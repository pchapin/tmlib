---------------------------------------------------------------------------
-- FILE    : tests.adb
-- SUBJECT : Main procedure of the TMLib test program.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- This subprogram does not need to be SPARKable.
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------
with Ada.Text_IO;
with Assertions;
with TMLib.Credentials;
with TMLib.Credentials.Credential_Storage;
with TMLib.Credentials.Credential_Storage.Debug;
with TMLib.Credentials.Transfer_Format;
with TMLib.Cryptographic_Services;
with TMLib.Credentials.Debug;
with TMLib.Key_Storage;
with TMLib.Key_Storage.Debug;

use Ada.Text_IO;
use TMLib;

procedure Tests is

   procedure Test_Cryptographic_Services is
   begin
      Put_Line("*** TMLib.Cryptographic_Services");
      -- No tests defined at this time.
   end Test_Cryptographic_Services;


   procedure Test_Key_Storage is
      Assigned_Keys  : array(Key_Storage.Index_Type) of Boolean := (others => False);
      Key_Index      : Key_Storage.Index_Type;
      Public_Key     : Cryptographic_Services.Public_Key_Type;
      Private_Key    : Cryptographic_Services.Private_Key_Type;
      Invalidate_Old : Boolean;
   begin
      Put_Line("*** TMLib.Key_Storage");
      Key_Storage.Initialize;
      Assertions.Assert(Key_Storage.Size = 0, "Invalid initial size");
      for I in 1 .. Key_Storage.Capacity loop
         Cryptographic_Services.Create_Key_Pair(Public_Key, Private_Key);
         Key_Storage.Add_Key(Public_Key, Key_Index, Invalidate_Old);
         Assertions.Assert(Invalidate_Old, "No request to invalidate keys");
         Assertions.Assert(not Assigned_Keys(Key_Index), "Key index reused prematurely");
         Assigned_Keys(Key_Index) := True;
         Assertions.Assert(Key_Storage.Size = I, "Invalid size while populating key storage");
      end loop;

      for I in 1 .. Key_Storage.Capacity loop
         Cryptographic_Services.Create_Key_Pair(Public_Key, Private_Key);
         Key_Storage.Add_Key(Public_Key, Key_Index, Invalidate_Old);
         Assertions.Assert(Invalidate_Old, "No request to invalidate keys during reuse");
         Assertions.Assert(Key_Storage.Size = Key_Storage.Capacity, "Invalid size during storage reuse");
      end loop;

      -- I should include some tests to make sure the addition of an existing key is okay.
      -- Such tests should explore both the case when the key storage is being populated
      -- and when existing storage slots are being reused.

      Key_Storage.Initialize;
      Assertions.Assert(Key_Storage.Size = 0, "Invalid size after reinitialization");
   end Test_Key_Storage;


   procedure Test_Credential_Transfer_Format is
      -- These raw key values assume knowledge of the private type in TMLib.Cryptographic_Services.
      -- A's key = #16#01010101#
      -- B's key = #16#02020202#
      -- C's key = #16#03030303#
      -- D's key = #16#04040404#
      -- E's key = #16#05050505#

      -- Role assignments.
      -- r = 1
      -- s = 2
      -- t = 3
      -- u = 4

      Raw_Credential_1 : Cryptographic_Services.Octet_Array :=
        (0, 0, 0, 0,   1, 1, 1, 1,   0,   1,   5, 5, 5, 5);                          -- A.r <- E
      Raw_Credential_2 : Cryptographic_Services.Octet_Array :=
        (0, 0, 0, 0,   2, 2, 2, 2,   1,   2,   1, 1, 1, 1,   1);                     -- B.s <- A.r
      Raw_Credential_3 : Cryptographic_Services.Octet_Array :=
        (0, 0, 0, 0,   3, 3, 3, 3,   2,   3,   2, 2, 2, 2,   2,   1);                -- C.t <- B.s.r
      Raw_Credential_4 : Cryptographic_Services.Octet_Array :=
        (0, 0, 0, 0,   4, 4, 4, 4,   3,   4,   3, 3, 3, 3,   1, 1, 1, 1,   3,   1);  -- D.u <- C.t ^ A.r;

      -- This credential causes E to be a member of D.u.
      Raw_Credential_5 : Cryptographic_Services.Octet_Array :=
        (0, 0, 0, 0,   5, 5, 5, 5,   0,   1,   5, 5, 5, 5);                          -- E.r <- E

      Credential_1 : Credentials.Credential_Type;
      Credential_2 : Credentials.Credential_Type;
      Credential_3 : Credentials.Credential_Type;
      Credential_4 : Credentials.Credential_Type;
      Credential_5 : Credentials.Credential_Type;

      Valid    : Boolean;
      Overflow : Boolean;
   begin
      Put_Line("*** TMLib.Credentials.Transfer_Format");
      Key_Storage.Initialize;
      Credentials.Credential_Storage.Initialize;

      Credentials.Transfer_Format.Raw_To_Credential(Raw_Credential_1, Credential_1, Valid);
      Assertions.Assert(Valid, "Unable to convert raw ROLE MEMBERSHIP credential");
      Credentials.Credential_Storage.Add_Credential(Credential_1);

      Credentials.Transfer_Format.Raw_To_Credential(Raw_Credential_2, Credential_2, Valid);
      Assertions.Assert(Valid, "Unable to convert raw ROLE INCLUSION credential");
      Credentials.Credential_Storage.Add_Credential(Credential_2);

      Credentials.Transfer_Format.Raw_To_Credential(Raw_Credential_3, Credential_3, Valid);
      Assertions.Assert(Valid, "Unable to convert raw ROLE LINKED credential");
      Credentials.Credential_Storage.Add_Credential(Credential_3);

      Credentials.Transfer_Format.Raw_To_Credential(Raw_Credential_4, Credential_4, Valid);
      Assertions.Assert(Valid, "Unable to convert raw ROLE INTERSECTION credential");
      Credentials.Credential_Storage.Add_Credential(Credential_4);

      Credentials.Transfer_Format.Raw_To_Credential(Raw_Credential_5, Credential_5, Valid);
      Assertions.Assert(Valid, "Unable to convert raw self referential ROLE MEMBERSHIP credential");
      Credentials.Credential_Storage.Add_Credential(Credential_5);

      -- Display the keys in the key storage area.
      Key_Storage.Debug.Dump_Storage;

      -- Display the credentials in the storage area.
      Credentials.Credential_Storage.Debug.Dump_Storage;

      -- We might as well compute and display the minimum model for good measure.
      Credentials.Credential_Storage.Compute_Minimum_Model(Overflow);
      Assertions.Assert(not Overflow, "Unexpected overflow of model space");
      Credentials.Credential_Storage.Debug.Dump_Model;

      -- We might as well compute and display an authorization result for good measure.
      Assertions.Assert
        (Credentials.Credential_Storage.Authorize(Governing_Key => 5, Governing_Role => 4, Query_Key => 2),
         "Authorization failed unexpectedly");
   end Test_Credential_Transfer_Format;


begin -- Tests
   Test_Cryptographic_Services;
   Test_Key_Storage;
   Test_Credential_Transfer_Format;
end Tests;
