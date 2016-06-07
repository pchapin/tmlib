---------------------------------------------------------------------------
-- FILE    : tmlib-credentials-transfer_format.adb
-- SUBJECT : Package that handles RT_0 credential transfer formats.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------

package body TMLib.Credentials.Transfer_Format is

   -- Raw credential formats:
   --
   -- Defining_Key (20 bytes)
   -- Form         ( 1 byte )
   -- Target_Role  ( 1 byte )
   -- Source_Key1  (20 bytes)
   -- Source_Key2  (20 bytes)
   -- Source_Role1 ( 1 byte )
   -- Source_Role2 ( 1 byte )
   --
   -- Unnecessary fields are deleted.

   procedure Raw_To_Credential
     (Raw_Data   : in  Cryptographic_Services.Octet_Array;
      Credential : out Credentials.Credential_Type;
      Valid      : out Boolean) is

      -- Used by the state machine that parses a raw credential.
      type State_Type is (Get_Defining_Key,
                          Get_Form,
                          Get_Target_Role,
                          Get_Source_Key1,
                          Get_Source_Key2,
                          Get_Source_Role1,
                          Get_Source_Role2,
                          Done);

      Current_Index : Cryptographic_Services.Raw_Index_Type;
      Key_Ok        : Boolean;
      State         : State_Type := Get_Defining_Key;


      -- Checks the signature on the raw credential. Returns in Lst the index of the defining key.
      --
      -- BUG: If the conversion works but there is insufficient additional material, this
      -- procedure will return with Valid = True even though it should not.
      --
      procedure Check_Credential_Validity
        (Raw_Data         : in  Cryptographic_Services.Octet_Array;
         End_Of_Signature : out Cryptographic_Services.Raw_Index_Type;
         Valid            : out Boolean)
      --# derives End_Of_Signature from Raw_Data &
      --#         Valid            from Raw_Data;
      is
         Signature  : Cryptographic_Services.Signature_Type;
         Key        : Cryptographic_Services.Public_Key_Type;
         End_Of_Key : Cryptographic_Services.Raw_Index_Type;
      begin
         Cryptographic_Services.Raw_To_Signature(Raw_Data, Raw_Data'First, End_Of_Signature, Signature, Valid);
         if Valid and End_Of_Signature < Raw_Data'Last then
            Cryptographic_Services.Raw_To_Public_Key(Raw_Data, End_Of_Signature + 1, End_Of_Key, Key, Valid);
            if Valid and End_Of_Key < Raw_Data'Last then
               Valid := Cryptographic_Services.Verify_Signature
                 (Raw_Data, End_Of_Signature + 1, Raw_Data'Last, Signature, Key);
            end if;
         end if;
      end Check_Credential_Validity;


      -- Extracts a key from the specified part of the raw credential.
      procedure Get_Key(Key : out Key_Storage.Index_Type; Key_Ok : out Boolean)
      --# global in Raw_Data; in out Current_Index, Key_Storage.Storage, Credential_Storage.Storage;
      --# derives Key                 from Raw_Data, Current_Index, Key_Storage.Storage &
      --#         Current_Index       from Raw_Data, Current_Index &
      --#         Key_Ok              from Raw_Data, Current_index &
      --#         Key_Storage.Storage from Raw_Data, Current_Index, Key_Storage.Storage &
      --#         Credential_Storage.Storage from
      --#                                Raw_Data, Current_Index, Key_Storage.Storage, Credential_Storage.Storage;
      is
         Last_Index     : Cryptographic_Services.Raw_Index_Type;
         Public_Key     : Cryptographic_Services.Public_Key_Type;
         Key_Index      : Key_Storage.Index_Type;
         Invalidate_Old : Boolean;
      begin
         Cryptographic_Services.Raw_To_Public_Key
           (Raw_Data, Current_Index, Last_Index, Public_Key, Key_Ok);
         if not Key_Ok then
            Key := Key_Storage.Index_Type'First;
         else
            Key_Storage.Add_Key(Public_Key, Key_Index, Invalidate_Old);
            Key := Key_Index;
            if Invalidate_Old then
               Credential_Storage.Invalidate_Credentials_Using(Key_Index);
            end if;
         end if;
         Current_Index := Last_Index;
      end Get_Key;


      -- Extracts the role from the specified part of the raw credential.
      procedure Get_Role(Role : out Credentials.Role_Type)
      --# global in Raw_Data, Current_Index;
      --# derives Role from Raw_Data, Current_Index;
      --# pre Current_Index >= Raw_Data'First and Current_Index <= Raw_Data'Last;
      is
      begin
         Role := Credentials.Role_Type(Raw_Data(Current_Index));
      end Get_Role;


   begin  -- Raw_To_Credential
      Credential := Credentials.Invalid_Credential;

      Check_Credential_Validity(Raw_Data, Current_Index, Valid);
      if Valid then
         Current_Index := Current_Index + 1;
         while State /= Done and Current_Index <= Raw_Data'Last loop
            case State is
               when Get_Defining_Key =>
                  Get_Key(Credential.Defining_Key, Key_Ok);
                  if not Key_Ok then
                     Valid := False;
                     State := Done;
                  else
                     Current_Index := Current_Index + 1;
                     State := Get_Form;
                  end if;

               when Get_Form =>
                  case Raw_Data(Current_Index) is
                     when 0 =>
                        Credential.Form := Credentials.Role_Membership;
                        Current_Index := Current_Index + 1;
                        State := Get_Target_Role;
                     when 1 =>
                        Credential.Form := Credentials.Role_Inclusion;
                        Current_Index := Current_Index + 1;
                        State := Get_Target_Role;
                     when 2 =>
                        Credential.Form := Credentials.Role_Linked;
                        Current_Index := Current_Index + 1;
                        State := Get_Target_Role;
                     when 3 =>
                        Credential.Form := Credentials.Role_Intersection;
                        Current_Index := Current_Index + 1;
                        State := Get_Target_Role;
                     when others =>
                        Credential.Form := Credentials.Invalid;
                        Valid := False;
                        State := Done;
                  end case;

               when Get_Target_Role =>
                  Get_Role(Credential.Target_Role);
                  Current_Index := Current_Index + 1;
                  State := Get_Source_Key1;

               when Get_Source_Key1 =>
                  Get_Key(Credential.Source_Key1, Key_Ok);
                  if not Key_Ok then
                     Valid := False;
                     State := Done;
                  else
                     Current_Index := Current_Index + 1;
                     case Credential.Form is
                        when Credentials.Role_Membership =>
                           State := Done;
                        when Credentials.Role_Inclusion | Credentials.Role_Linked =>
                           State := Get_Source_Role1;
                        when Credentials.Role_Intersection =>
                           State := Get_Source_Key2;
                        when others =>
                           Valid := False;
                           State := Done;
                     end case;
                  end if;

               when Get_Source_Key2 =>
                  Get_Key(Credential.Source_Key2, Key_Ok);
                  if not Key_Ok then
                     Valid := False;
                     State := Done;
                  else
                     Current_Index := Current_Index + 1;
                     case Credential.Form is
                        when Credentials.Role_Intersection =>
                           State := Get_Source_Role1;
                        when others =>
                           Valid := False;
                           State := Done;
                     end case;
                  end if;

               when Get_Source_Role1 =>
                  Get_Role(Credential.Source_Role1);
                  Current_Index := Current_Index + 1;
                  case Credential.Form is
                     when Credentials.Role_Inclusion =>
                        State := Done;
                     when Credentials.Role_Linked | Credentials.Role_Intersection =>
                        State := Get_Source_Role2;
                     when others =>
                        Valid := False;
                        State := Done;
                  end case;

               when Get_Source_Role2 =>
                  Get_Role(Credential.Source_Role2);
                  Current_Index := Current_Index + 1;
                  case Credential.Form is
                     when Credentials.Role_Linked | Credentials.Role_Intersection =>
                        State := Done;
                     when others =>
                        Valid := False;
                        State := Done;
                  end case;

               -- Should never occur. When State = Done, the enclosing loop terminates.
               when Done =>
                  null;

            end case;
         end loop;
      end if;

   end Raw_To_Credential;


--   procedure Credential_To_Raw
--     (Credential : in  Credentials.Credential_Type;
--      Raw_Data   : out Cryptographic_Services.Octet_Array;
--      Success    : out Boolean) is
--   begin
--      -- FIX ME!
--      for I in Natural range Raw_Data'Range loop
--         Raw_Data(I) := 0;
--      end loop;
--      Success := False;
--   end Credential_To_Raw;

end TMLib.Credentials.Transfer_Format;

