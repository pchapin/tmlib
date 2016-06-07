---------------------------------------------------------------------------
-- FILE    : tmlib-key_storage-debug.adb
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
with Ada.Integer_Text_IO;
with TMLib.Cryptographic_Services.Debug;

use  Ada.Text_IO;
use  Ada.Integer_Text_IO;

package body TMLib.Key_Storage.Debug is

   procedure Dump_Storage is
      Storage      : Key_Storage.Storage_Array := Key_Storage.Get_Storage;
      Storage_Size : Key_Storage.Size_Type := Key_Storage.Size;
   begin
      Put_Line("Key Storage");
      Put_Line("-----------");
      for I in Storage'First .. Storage'First + Storage_Size - 1 loop
         Put(I);
         Put(" => ");
         Cryptographic_Services.Debug.Dump_Public_Key(Storage(I));
         New_Line;
      end loop;
      New_Line;
   end Dump_Storage;

end TMLib.Key_Storage.Debug;
