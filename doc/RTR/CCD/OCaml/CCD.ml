(** This is the OCaml version of the RT^R credential chain discovery
    algorithm. This program currently only handles type 1 and type 2
    credentials. Proper handling of linked roles and intersections is
    tricky and hasn't yet been fully worked out (using the functional
    style presented here).

    @author Peter C. Chapin
    @version 0.1
*)

(** Type to represent an edge in the credential graph. We are only
    interested in the weight on the edge and the node that is the source of
    the edge.
*)
type credential = {
  risk   : int;    (** Use some-of-risks model. Weights are just integers *)
  source : string  (** Name of the source node *)
}

(** The edge (credential) database *)
let edge_data : (string, credential list) Hashtbl.t = Hashtbl.create 31

(** Compute an aggregation over a risk assessment

    @param k The risk
    @param ra The risk assessment
    @return A new risk assessment where each risk association has had
    its cost updated
*)
let ra_oplus k ra = List.map (fun (e, x) -> (e, x + k)) ra

(** Check to see if a node is an entity node. In the current version of
    this program, this is used to locate the base case of the recursion. In
    a more full featured version of the program, it might be better to
    introduce type constructors for the different credential forms.

    @param node The node to consider.
    @return true iff the node is the name of a plain entity
*)
let is_entity node = not (String.contains node '.')

(** Convert a risk assessment to canonical form. In this version of the
    program, risk associations that contain excessive risk are purged from
    the risk assessment here. In the current version this function does not.
    It is a placeholder for real code later.

    @param max_risk The maximum risk allowed.
    @param ra The risk assessment to canonicalize.
    @return The canonical form of ra with every risk association (e, k)
    such that k <= max_risk
*)
let make_canonical max_risk ra = ra

(** This is the main function. It computes the risk assessment for a
    given node.It recursively invokes itself on all nodes defining the
    given node. This function should return a canonical form of the risk
    assessment, but in the current version of the program it doesn't do
    so.

    @param node The name of the node to analyze
    @param max_risk To control the depth of the search
    @param acc_risk The risk accumulated so far. Initialize to zero.
    @param nodeList A list of nodes seen in the path. Initialize to [].
    @return A risk assessment for node where all risk associations (e,
    k) in that assessment are such that k <= max_risk
*)
let rec get_risks node max_risk acc_risk nodeList =
  (* Abort if we've accumulated too much risk *)
  if not (acc_risk <= max_risk) then []
  else
    (* Abort if we've been to this node before. *)
    if List.mem node nodeList then []
    else
      (* An entity node is the base case. *)
      if is_entity node then [(node, 0)]
      else
        let defining_list = try Hashtbl.find edge_data node
        with Not_found -> [] in
        let merge_risks ra cred =
          let new_acc_risk = acc_risk + cred.risk in
          let incoming =
            get_risks cred.source max_risk new_acc_risk (node::nodeList) in
            ra @ (ra_oplus cred.risk incoming) in
        make_canonical max_risk (List.fold_left merge_risks [] defining_list);;

(* No I/O facilities implemented yet. Hard code each example. *)
begin
  Hashtbl.add edge_data "A.r"
    [{risk = 5; source = "B.s"}];

  Hashtbl.add edge_data "B.s"
    [{risk = 5; source = "C.t"}; {risk = 5; source = "E"}];

  Hashtbl.add edge_data "C.t"
    [{risk = 5; source = "A.r"}; {risk = 5; source = "E"}];

  get_risks "A.r" 50 0 []
end

