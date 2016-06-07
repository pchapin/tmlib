---------------------------------------------------------------------------
-- FILE    : tmlib-credentials-credential_storage.adb
-- SUBJECT : Package that manages the RT_0 credential cache.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------

package body TMLib.Credentials.Credential_Storage
--# own Storage is Storage_Area,     Storage_Count,
--#                Credential_Added, Credential_Deleted &
--#     Model   is Model_Area, Model_Count;
is

   ---------------------
   -- Credential Storage
   ---------------------
   Storage_Area       : Storage_Array;
   Storage_Count      : Storage_Size_Type;
   Credential_Added   : Boolean;
   Credential_Deleted : Boolean;

   --------
   -- Model
   --------
   Model_Area  : Model_Array;
   Model_Count : Model_Size_Type;


   procedure Initialize
   --# global out Storage_Area,     Storage_Count;
   --#            Credential_Added, Credential_Deleted;
   --#            Model_Area,       Model_Count;
   --# derives Storage_Area,     Storage_Count      from &
   --#         Credential_Added, Credential_Deleted from &
   --#         Model_Area,       Model_Count        from ;
   is
      Dummy_Tuple : Model_Tuple;
   begin
      Dummy_Tuple := Model_Tuple'
        (Target_Key   => 1,
         Target_Role  => 0,
         Member_Key   => 1);

      -- Storage
      Storage_Area       := Storage_Array'(others => Credentials.Invalid_Credential);
      Storage_Count      := 0;
      Credential_Added   := False;
      Credential_Deleted := False;

      -- Model
      Model_Area         := Model_Array'(others => Dummy_Tuple);
      Model_Count        := 0;
   end Initialize;


   procedure Add_Credential(Credential : in Credentials.Credential_Type)
   --# global in out Storage_Area,     Storage_Count,
   --#               Credential_Deleted; out Credential_Added;
   --# derives Storage_Area       from Storage_Area, Storage_Count, Credential &
   --#         Storage_Count      from Storage_Count &
   --#         Credential_Added   from               &
   --#         Credential_Deleted from Storage_Count, Credential_Deleted;
   is
   begin
      -- If the storage is full, throw out the oldest credential.
      if Storage_Count = Storage_Capacity then
         for Index in Storage_Index_Type range 2 .. Storage_Count loop
            --# assert Index >= 2 and Storage_Count = Storage_Count%;
            Storage_Area(Index - 1) := Storage_Area(Index);
         end loop;
         Storage_Count      := Storage_Count - 1;
         Credential_Deleted := True;
      end if;

      -- Now add the new credential.
      Storage_Count               := Storage_Count + 1;
      Storage_Area(Storage_Count) := Credential;
      Credential_Added            := True;
   end Add_Credential;


   procedure Invalidate_Credentials_Using(Key_Index : Key_Storage.Index_Type)
   --# global in out Storage_Area, Storage_Count, Credential_Deleted;
   --# derives Storage_Area       from Storage_Area, Storage_Count, Key_Index &
   --#         Storage_Count      from Storage_Count, Key_Index &
   --#         Credential_Deleted from Storage_Area, Credential_Deleted, Key_Index;
   is
   begin
      null;
   end Invalidate_Credentials_Using;


   procedure Compute_Minimum_Model(Overflow : out Boolean)
   --# global in     Storage_Area, Storage_Count;
   --#        in out Credential_Added, Credential_Deleted;
   --#        in out Model_Area, Model_Count;
   --# derives Credential_Added   from &
   --#         Credential_Deleted from &
   --#         Model_Area  from Storage_Area, Storage_Count, Model_Area, Model_Count, Credential_Added, Credential_Deleted &
   --#         Model_Count from Storage_Area, Storage_Count, Model_Area, Model_Count, Credential_Added, Credential_Deleted &
   --#         Overflow    from Storage_Area, Storage_Count, Model_Area, Model_Count, Credential_Added, Credential_Deleted;
   is
      Tuple_Added : Boolean;

      -- Add the given tuple to the model. Set Tuple_Added to True if the add actually occurs.
      -- Set Overflow to True if an add was attempted and failed due to lack of space. In that
      -- case, there is no change to the model (Tuple_Added is unchanged as well).
      --
      procedure Add_Tuple
        (Target_Key  : in  Key_Storage.Index_Type;
         Target_Role : in  Credentials.Role_Type;
         Member_Key  : in  Key_Storage.Index_Type;
         Overflow    : out Boolean)
      --# global in out Model_Area, Model_Count, Tuple_Added;
      --# derives Model_Area  from Model_Area, Model_Count, Target_Key, Target_Role, Member_Key &
      --#         Model_Count from Model_Area, Model_Count, Target_Key, Target_Role, Member_Key &
      --#         Tuple_Added from Model_Area, Model_Count, Target_Key, Target_Role, Member_Key, Tuple_Added &
      --#         Overflow    from Model_Area, Model_Count, Target_Key, Target_Role, Member_Key;
      --# post (Overflow = True) -> (Model_Area  = Model_Area~  and
      --#                            Model_Count = Model_Count~ and
      --#                            Tuple_Added = Tuple_Added~);
      is
         New_Tuple : Model_Tuple;
         Found     : Boolean := False;
      begin
         Overflow  := False;
         New_Tuple := Model_Tuple'(Target_Key, Target_Role, Member_Key);
         for Index in Model_Index_Type range 1 .. Model_Count loop
            if Model_Area(Index) = New_Tuple then
               Found := True;
               exit;
            end if;
         end loop;
         if not Found then
            if Model_Count = Model_Capacity then
               Overflow := True;
            else
               Model_Count := Model_Count + 1;
               Model_Area(Model_Count) := Model_Tuple'(Target_Key, Target_Role, Member_Key);
               Tuple_Added := True;
            end if;
         end if;
      end Add_Tuple;


      procedure Process_Role_Membership(Credential_Index : in Storage_Index_Type; Overflow : out Boolean)
      --# global in Storage_Area; in out Model_Area, Model_Count, Tuple_Added;
      --# derives Model_Area  from Model_Area, Model_Count, Storage_Area, Credential_Index &
      --#         Model_Count from Model_Area, Model_Count, Storage_Area, Credential_Index &
      --#         Tuple_Added from Model_Area, Model_Count, Storage_Area, Credential_Index, Tuple_Added &
      --#         Overflow    from Model_Area, Model_Count, Storage_Area, Credential_Index;
      --# pre Storage_Area(Credential_Index).Form = Credentials.Role_Membership;
      is
      begin
         Add_Tuple
           (Target_Key  => Storage_Area(Credential_Index).Defining_Key,
            Target_Role => Storage_Area(Credential_Index).Target_Role,
            Member_Key  => Storage_Area(Credential_Index).Source_Key1,
            Overflow    => Overflow);
      end Process_Role_Membership;


      procedure Process_Role_Inclusion(Credential_Index : in Storage_Index_Type; Overflow : out Boolean)
      --# global in Storage_Area; in out Model_Area, Model_Count, Tuple_Added;
      --# derives Model_Area  from Model_Area, Model_Count, Storage_Area, Credential_Index &
      --#         Model_Count from Model_Area, Model_Count, Storage_Area, Credential_Index &
      --#         Tuple_Added from Model_Area, Model_Count, Storage_Area, Credential_Index, Tuple_Added &
      --#         Overflow    from Model_Area, Model_Count, Storage_Area, Credential_Index;
      --# pre Storage_Area(Credential_Index).Form = Credentials.Role_Inclusion;
      is
         New_Member : Key_Storage.Index_Type;
      begin
         Overflow := False;
         for Model_Index in Model_Index_Type range 1 .. Model_Count loop
            if Model_Area(Model_Index).Target_Key  = Storage_Area(Credential_Index).Source_Key1 and
               Model_Area(Model_Index).Target_Role = Storage_Area(Credential_Index).Source_Role1 then

               New_Member := Model_Area(Model_Index).Member_Key;
               Add_Tuple
                 (Target_Key  => Storage_Area(Credential_Index).Defining_Key,
                  Target_Role => Storage_Area(Credential_Index).Target_Role,
                  Member_Key  => New_Member,
                  Overflow    => Overflow);
            end if;
            exit when Overflow;
         end loop;
      end Process_Role_Inclusion;


      procedure Process_Role_Linked(Credential_Index : in Storage_Index_Type; Overflow : out Boolean)
      --# global in Storage_Area; in out Model_Area, Model_Count, Tuple_Added;
      --# derives Model_Area  from Model_Area, Model_Count, Storage_Area, Credential_Index &
      --#         Model_Count from Model_Area, Model_Count, Storage_Area, Credential_Index &
      --#         Tuple_Added from Model_Area, Model_Count, Storage_Area, Credential_Index, Tuple_Added &
      --#         Overflow    from Model_Area, Model_Count, Storage_Area, Credential_Index;
      --# pre Storage_Area(Credential_Index).Form = Credentials.Role_Linked;
      is
         Delegated_Member : Key_Storage.Index_Type;
         New_Member       : Key_Storage.Index_Type;
      begin
         Overflow := False;
         for Outer_Model_Index in Model_Index_Type range 1 .. Model_Count loop
            if Model_Area(Outer_Model_Index).Target_Key  = Storage_Area(Credential_Index).Source_Key1 and
               Model_Area(Outer_Model_Index).Target_Role = Storage_Area(Credential_Index).Source_Role1 then

               Delegated_Member := Model_Area(Outer_Model_Index).Member_Key;

               for Inner_Model_Index in Model_Index_Type range 1 .. Model_Count loop
                  if Model_Area(Inner_Model_Index).Target_Key  = Delegated_Member and
                     Model_Area(Inner_Model_Index).Target_Role = Storage_Area(Credential_Index).Source_Role2 then

                  New_Member := Model_Area(Inner_Model_Index).Member_Key;
                  Add_Tuple
                    (Target_Key  => Storage_Area(Credential_Index).Defining_Key,
                     Target_Role => Storage_Area(Credential_Index).Target_Role,
                     Member_Key  => New_Member,
                     Overflow    => Overflow);
                  end if;
                  exit when Overflow;
               end loop;
            end if;
            exit when Overflow;
         end loop;
      end Process_Role_Linked;


      procedure Process_Role_Intersection(Credential_Index : in Storage_Index_Type; Overflow : out Boolean)
      --# global in Storage_Area; in out Model_Area, Model_Count, Tuple_Added;
      --# derives Model_Area  from Model_Area, Model_Count, Storage_Area, Credential_Index &
      --#         Model_Count from Model_Area, Model_Count, Storage_Area, Credential_Index &
      --#         Tuple_Added from Model_Area, Model_Count, Storage_Area, Credential_Index, Tuple_Added &
      --#         Overflow    from Model_Area, Model_Count, Storage_Area, Credential_Index;
      --# pre Storage_Area(Credential_Index).Form = Credentials.Role_Intersection;
      is
         New_Member : Key_Storage.Index_Type;
      begin
         Overflow := False;
         for Outer_Model_Index in Model_Index_Type range 1 .. Model_Count loop
            if Model_Area(Outer_Model_Index).Target_Key  = Storage_Area(Credential_Index).Source_Key1 and
               Model_Area(Outer_Model_Index).Target_Role = Storage_Area(Credential_Index).Source_Role1 then

               New_Member := Model_Area(Outer_Model_Index).Member_Key;

               for Inner_Model_Index in Model_Index_Type range 1 .. Model_Count loop
                  if Model_Area(Inner_Model_Index).Target_Key  = Storage_Area(Credential_Index).Source_Key2  and
                     Model_Area(Inner_Model_Index).Target_Role = Storage_Area(Credential_Index).Source_Role2 and
                     Model_Area(Inner_Model_Index).Member_Key  = New_Member then

                  Add_Tuple
                    (Target_Key  => Storage_Area(Credential_Index).Defining_Key,
                     Target_Role => Storage_Area(Credential_Index).Target_Role,
                     Member_Key  => New_Member,
                     Overflow    => Overflow);
                  end if;
                  exit when Overflow;
               end loop;
            end if;
            exit when Overflow;
         end loop;
      end Process_Role_Intersection;


   begin  -- Compute_Minimum_Model
      Overflow := False;
      if Credential_Added or Credential_Deleted then

         -- Throw away the old model if a credential has been removed. We must rebuild from scratch.
         if Credential_Deleted then
            Model_Count := 0;
         end if;

         -- Keep looping until either a fixed point is reached or the model overflows allocated space.
         Tuple_Added := True;
         while Tuple_Added and not Overflow loop
            Tuple_Added := False;

            -- Scan over all credentials...
            for Credential_Index in Storage_Index_Type range 1 .. Storage_Count loop
               case Storage_Area(Credential_Index).Form is
                  when Credentials.Invalid           => null;
                  when Credentials.Role_Membership   => Process_Role_Membership(Credential_Index, Overflow);
                  when Credentials.Role_Inclusion    => Process_Role_Inclusion(Credential_Index, Overflow);
                  when Credentials.Role_Linked       => Process_Role_Linked(Credential_Index, Overflow);
                  when Credentials.Role_Intersection => Process_Role_Intersection(Credential_Index, Overflow);
               end case;
               exit when Overflow;
            end loop;
         end loop;
      end if;
      Credential_Added   := False;
      Credential_Deleted := False;
   end Compute_Minimum_Model;


   function Storage_Size return Natural
   --# global in Storage_Count;
   is
   begin
      return Storage_Count;
   end Storage_Size;


   function Current_Model_Size return Natural
   --# global in Model_Count;
   is
   begin
      return Model_Count;
   end Current_Model_Size;


   function Authorize
     (Governing_Key  : Key_Storage.Index_Type;
      Governing_Role : Credentials.Role_Type;
      Query_Key      : Key_Storage.Index_Type) return Boolean
   --# global in Model_Area, Model_Count;
   is
      Result : Boolean := False;
   begin
      for Index in Model_Index_Type range 1 .. Model_Count loop
         if Model_Area(Index).Target_Key  = Governing_Key  and
            Model_Area(Index).Target_Role = Governing_Role and
            Model_Area(Index).Member_Key  = Query_Key      then

            Result := True;
            exit;
         end if;
      end loop;
      return Result;
   end Authorize;


   function Get_Storage return Storage_Array
   --# global in Storage_Area;
   is
   begin
      return Storage_Area;
   end Get_Storage;


   function Get_Model return Model_Array
   --# global in Model_Area;
   is
   begin
      return Model_Area;
   end Get_Model;


end TMLib.Credentials.Credential_Storage;
