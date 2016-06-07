(* 
   discovery.ml: issuer-driven certificate chain discovery for 
   the system RT^R.

   By c. skalka, August 2006
*)

(*
   RISK signature specifies a risk type, a partial order lt,
   monotonic risk and intersection aggregation operations plus 
   and times, and bottom and top elements bot and top.
*)
module type RISK =
  sig
    type risk
    val lt : risk -> risk -> bool
    val plus : risk -> risk -> risk
    val times : risk -> risk -> risk
    val bot : risk
    val top : risk
  end
  
(* example RISK: natural number ordering *)
module Risk =
  struct
    type risk = int
    let lt k1 k2 = k1 <= k2
    let plus k1 k2 = k1 + k2
    let times k1 k2 = k1 + k2
    let bot = 0
    let top = max_int
  end

open Risk

(* entities and role names are string identifiers *)    
type entity = string
type role_name =  string
type role = entity * role_name
(* the type of role expressions *)
type role_expr =     
    Ent of entity    (* entities *)
  | Role of role     (* roles *)
  | Link of entity * role_name * role_name  (* linking roles *)
  | Isect of role_expr list                 (* intersection roles *)
type cred = Cred of role * Risk.risk * role_expr (* credentials *)
type risk_assessment = (entity * risk) list 
type threshold = role_expr -> Risk.risk 
type search_risk = role * risk
type monitor = (entity * risk) -> unit 
type propagater = (role * risk) -> unit
(* The type of nodes, identified by a role expression *)
type node = { 
    id : role_expr;  
    mutable monitors : monitor list; 
    mutable propagaters : propagater list; 
    mutable search_risks : search_risk list;
    mutable solution : risk_assessment;
    mutable visited : bool
  }

exception BadNode
exception Solved of Risk.risk

(*
   A.r <-10- B
   A.r <-1- C.r1.r2
   C.r1 <-2- D
   D.r2 <-3- B
*)
let creds : cred list = 
  [Cred(("A","r"),10,(Ent "B"));
   Cred(("A","r"),1,(Link ("C","r1","r2")));
   Cred(("C","r1"),2,(Ent "D"));
   Cred(("D","r2"),3,(Ent "B"))]
    
let thresh1 = function _ -> max_int
let thresh2 = function (Role ("C","r1")) -> 1 | _ -> max_int

(* black-box method of retrieving credentials based on issuer *)
let issuer_retrieve r = List.filter (fun (Cred(r',_,_)) -> r' = r) creds  

(* queue used by processing *)
let q : node Queue.t = Queue.create()

(* nodes created during processing *)
let nodes : node list ref = ref [] 

let dummy = "DUMMY"
(* authorization target *)
let target = ref (dummy, (Role(dummy,dummy)))

let make_target a r = target := (a, (Role r))

let add_monitor m nd = nd.monitors <- m :: nd.monitors
let add_propagater p nd = nd.propagaters <- p :: nd.propagaters
let add_search_risks risks nd = nd.search_risks <- risks @ nd.search_risks
let add_new_solution (b,k) nd =
  nd.solution <- 
    (b,k) :: (List.filter 
		(fun (b',k') -> b' <> b || not (Risk.lt k k'))
		nd.solution)

let apply_all fs x = List.iter (fun f -> f x) fs
let apply_to_all f l = List.iter f l
      
let aggregate_all rs k = 
  List.map (fun (x,k') -> (x,Risk.plus k k')) rs

(* 
   subsumed : (entry * risk) -> risk_assessment -> bool
   in : new solution element (r,k), risk assessment R
   out : true iff the canonical union of {(r,k)} and R equals R
*)
let rec subsumed (x,k) rs = 
  List.exists (fun (x',k') -> x = x' && Risk.lt k' k) rs
	
(*
   produce_node : role_expr -> node
   in : role expression f
   out : the node nd identified by f taken from nodes, or a fresh 
   node identified by f (with empty fields) if none exists
   mutates : nodes, adds fresh node identified by f if none exists
   previously
*)
let produce_node f = 
  let rec pn = function
      [] -> 
	let nd = 
	  { id = f; monitors = []; propagaters = [];
	    solution = []; search_risks = []; visited = false }
	in (nodes := nd :: !nodes; nd)
    | nd::nds -> if nd.id = f then nd else pn nds
  in pn !nodes

(*
   enqueue_unvisited : node -> unit
   in : a node nd
   out : ()
   mutates : q, adds nd to q if not nd.visited
*)
let enqueue_unvisited nd =
  if (not nd.visited) then (Queue.add nd q; nd.visited <- true)

(* 
   risk_notify : node -> (role * risk) -> unit
   in : node nd, search risk (r,k)
   out : ()
   mutates : notifies nd to add (r,k) to its solutions, and 
   also invokes all of nd's propagaters on (r,k)
*)
let risk_notify nd (r,k) = 
  if not (subsumed (r,k) nd.search_risks) 
  then 
    begin
      add_search_risks [(r,k)] nd;
      apply_all nd.propagaters (r,k)
    end
      
(* make_propagater : node -> risk -> propagater *)
let make_propagater nd k' = 
  (fun (r,k) -> risk_notify nd (r, Risk.plus k k')) 
    
(* soln_notify : node -> (entity * risk) -> threshold -> unit *)
let soln_notify nd (b,k) thresh = 
  if (Risk.lt k (thresh nd.id)) && not (subsumed (b,k) nd.solution)
  then
    if nd.id = (snd !target) && b = (fst !target) then raise (Solved k)
    else
      begin
	add_new_solution (b,k) nd;
	apply_all nd.monitors (b,k)
      end
      
(* make_nmonitor : node -> risk -> threshold -> monitor *)
let make_nmonitor nd k thresh = 
  (fun (b,k') -> soln_notify nd (b, Risk.plus k k') thresh)

(* make_lmonitor : node -> threshold -> monitor *)
let make_lmonitor nd thresh =
  match nd.id with
    Link(a,r1,r2) -> 
      (fun (b,k) -> 
	let m = make_nmonitor nd k thresh in
  	let nd' = produce_node (Role(b,r2)) in
        begin
	  apply_to_all m nd'.solution;
	  add_monitor m nd';
	  add_search_risks (aggregate_all nd.search_risks k) nd';
	  add_propagater (make_propagater nd' k) nd;
	  enqueue_unvisited nd';
	end
      )	   
  | _ -> raise BadNode
	
(* at : risk_assessment -> risk_assessment -> risk_assessment *)
let rec at rs1 rs2 = 
  match rs1 with
    [] -> []
  | (b,k)::rs -> 
      List.fold_right 
	(fun (b',k') rs' -> 
	  if b = b' then (b, Risk.plus k k') :: rs' else rs') 
	rs
	[]
      @ at rs rs2 

(* assessment_times : risk_assessment list -> risk_assessment *)
let rec assessment_times = function
    [] -> []
  | [rs] -> rs
  | rs1::rs2::rs -> assessment_times ((at rs1 rs2) :: rs) 

(* make_imonitor : node -> threshold -> monitor *)	
let make_imonitor nd thresh = 
  match nd.id with
    Isect(fs) -> 
      (fun (b,k) ->
	let m = make_nmonitor nd Risk.bot thresh in
	let rs = 
	  assessment_times 
	    (List.map (fun f -> (produce_node f).solution) fs) 
	in
	apply_to_all m rs
      )
  | _ -> raise BadNode

(* below_thresh : threshold -> search_risk list -> bool *)
let rec below_thresh thresh = function
    [] -> true
  | (r,k)::risks -> 
      let (l1,l2) = List.partition (fun (r',_) -> r' = r) risks in
      List.exists (fun (_,k) -> Risk.lt k (thresh (Role r))) ((r,k)::l1) 
	&&
      below_thresh thresh l2  

(* searchable : threshold -> node Queue.t -> bool *)
let searchable thresh q = 
  Queue.fold 
    (fun tl nd -> (below_thresh thresh nd.search_risks) || tl) 
    false 
    q

(* getnext : threshold -> node Queue.t -> node *)
let getnext thresh q = 
  let ql = Queue.fold (fun ql x -> x::ql) [] q in
  let rec gn = function
      [] -> raise Queue.Empty
    | nd::nds -> 
	if (below_thresh thresh nd.search_risks) then (nd, nds) 
	else
	  let (nd',nds') = gn nds in (nd', nd::nds')
  in
  let (nd,ql') = gn ql in 
  begin
    Queue.clear q;
    List.iter (fun x -> Queue.add x q) ql';
    nd
  end

let process_cred nd thresh (Cred(_,k,f)) = 
  let m = make_nmonitor nd k thresh in 
  let nd' = produce_node f in 
  begin
    apply_to_all m nd'.solution;
    add_monitor m nd';
    apply_to_all (risk_notify nd') 
      (aggregate_all nd.search_risks k);
    add_propagater (make_propagater nd' k) nd;
    enqueue_unvisited nd'
  end

let process_isect nd m nd' = 
  begin
    add_monitor m nd';
    add_search_risks nd.search_risks nd';
    add_propagater (make_propagater nd' Risk.bot) nd;
    enqueue_unvisited nd'
  end
    
(* checkmem : entity -> role -> threshold -> unit *)
let rec checkmem b r thresh = 
  begin
    Queue.clear q;
    nodes := [];
    make_target b r;
    enqueue_unvisited (produce_node (Role r));
    while (searchable thresh q) do
      let nd = getnext thresh q in 
      match nd.id with 
	Ent(a) -> soln_notify nd (a, Risk.bot) thresh
      | Role(r) -> 
	  begin
	    add_search_risks [(r,Risk.bot)] nd;
	    apply_to_all (process_cred nd thresh) (issuer_retrieve r)
	  end
      | Link(a,r1,r2) -> 
	  let nd' = produce_node (Role(a,r1)) in 
	  let m = make_lmonitor nd thresh in
	  begin
	    apply_to_all m nd'.solution;
	    add_monitor m nd';
	    add_search_risks nd.search_risks nd';
	    add_propagater (make_propagater nd' Risk.bot) nd;
	    enqueue_unvisited nd'
	  end	      
      | Isect(fs) -> 
	  let m = make_imonitor nd thresh in
	  let nds = List.map produce_node fs in
	  apply_to_all (process_isect nd m) nds
    done
  end
  
