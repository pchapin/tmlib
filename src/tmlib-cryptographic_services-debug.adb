---------------------------------------------------------------------------
-- FILE    : tmlib-cryptographic_services-debug.adb
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

package body TMLib.Cryptographic_Services.Debug is

   package Public_Key_IO is new Ada.Text_IO.Modular_IO(Public_Key_Type);
   use Public_Key_IO;

   procedure Dump_Public_Key(Key : Cryptographic_Services.Public_Key_Type) is
   begin
      Put(Key, Base => 16);
   end Dump_Public_Key;

end TMLib.Cryptographic_Services.Debug;
