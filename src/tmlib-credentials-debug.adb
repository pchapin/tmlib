---------------------------------------------------------------------------
-- FILE    : tmlib-credentials-debug.adb
-- SUBJECT : Package that allows for display and manipulation of internal TMLib data.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------
with Ada.Text_IO;
use  Ada.Text_IO;

package body TMLib.Credentials.Debug is

   package Credential_Form_IO is new Ada.Text_IO.Enumeration_IO(Credentials.Credential_Form);
   package Key_Index_IO is new Ada.Text_IO.Integer_IO(Key_Storage.Index_Type);
   package Role_IO is new Ada.Text_IO.Integer_IO(Credentials.Role_Type);

   use Credential_Form_IO;
   use Key_Index_IO;
   use Role_IO;

   procedure Dump_Credential(Credential: Credentials.Credential_Type) is
   begin
      -- Display invalid credentials in a (potentially) different way.
      if Credential.Form = Credentials.Invalid then
         Put("Form         => ");
         Put(Credential.Form);
         Put(")"); New_Line(2);
      else
         -- The credential is valid.
         Put("(Form         => ");
         Put(Credential.Form);
         Put(","); New_Line;
         Put(" Defining_Key => ");
         Put(Credential.Defining_Key, Width => 4);
         Put(","); New_Line;
         Put(" Target_Role  => ");
         Put(Credential.Target_Role);
         Put(","); New_Line;
         case Credential.Form is
            when Credentials.Role_Membership =>
               Put(" Source_Key1  => ");
               Put(Credential.Source_Key1, Width => 4);

            when Credentials.Role_Inclusion =>
               Put(" Source_Key1  => ");
               Put(Credential.Source_Key1, Width => 4);
               Put(","); New_Line;
               Put(" Source_Role1 => ");
               Put(Credential.Source_Role1);

            when Credentials.Role_Linked =>
               Put(" Source_Key1  => ");
               Put(Credential.Source_Key1, Width => 4);
               Put(","); New_Line;
               Put(" Source_Role1 => ");
               Put(Credential.Source_Role1);
               Put(","); New_Line;
               Put(" Source_Role2 => ");
               Put(Credential.Source_Role2);

            when Credentials.Role_Intersection =>
               Put(" Source_Key1  => ");
               Put(Credential.Source_Key1, Width => 4);
               Put(","); New_Line;
               Put(" Source_Key2  => ");
               Put(Credential.Source_Key2, Width => 4);
               Put(","); New_Line;
               Put(" Source_Role1 => ");
               Put(Credential.Source_Role1);
               Put(","); New_Line;
               Put(" Source_Role2 => ");
               Put(Credential.Source_Role2);

            -- Invalid credentials have been previously handled.
            when Credentials.Invalid =>
               null;
         end case;
         Put(")");
         New_Line(2);
      end if;
   end Dump_Credential;

end TMLib.Credentials.Debug;
