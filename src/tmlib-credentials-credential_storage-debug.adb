---------------------------------------------------------------------------
-- FILE    : tmlib-credentials-credential_storage-debug.adb
-- SUBJECT : Package that allows for the display and manipulation of internal TMLib data.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- This package does not need to be SPARKable.
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------
with Ada.Text_IO;
use  Ada.Text_IO;

with TMLib.Credentials.Debug;

package body TMLib.Credentials.Credential_Storage.Debug is

   package Key_Index_IO is new Ada.Text_IO.Integer_IO(Key_Storage.Index_Type);
   package Role_IO is new Ada.Text_IO.Integer_IO(Credentials.Role_Type);

   use Key_Index_IO;
   use Role_IO;


   procedure Dump_Storage is
      Storage      : Credentials.Credential_Storage.Storage_Array := Credentials.Credential_Storage.Get_Storage;
      Storage_Size : Natural := Credentials.Credential_Storage.Storage_Size;
   begin
      Put_Line("Credential Storage");
      Put_Line("------------------");
      for I in Storage'First .. Storage'First + Storage_Size - 1 loop
         Credentials.Debug.Dump_Credential(Storage(I));
      end loop;
   end Dump_Storage;


   procedure Dump_Model is
      Model      : Credentials.Credential_Storage.Model_Array := Credentials.Credential_Storage.Get_Model;
      Model_Size : Natural := Credentials.Credential_Storage.Current_Model_Size;
   begin
      Put_Line("Minimum Model");
      Put_Line("-------------");
      for I in Model'First .. Model'First + Model_Size - 1 loop
         Put("(");
         Put("Target_Key => ");
         Put(Model(I).Target_Key);
         Put(", ");
         Put("Target_Role => ");
         Put(Model(I).Target_Role);
         Put(", ");
         Put("Member_Key => ");
         Put(Model(I).Member_Key);
         Put(")");
         New_Line;
      end loop;
      New_Line;
   end Dump_Model;

end TMLib.Credentials.Credential_Storage.Debug;
