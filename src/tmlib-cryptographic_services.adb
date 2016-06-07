---------------------------------------------------------------------------
-- FILE    : tmlib-cryptographic_services.adb
-- SUBJECT : Container package for low level cryptographic operations.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- Ths subprograms in this package are currently stubs used for initial testing.
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------

package body TMLib.Cryptographic_Services is

   -- The key generating procedures just return integer values in sequence. This means different
   -- "keys" will be unique (until they wrap around); an important characteristic for some tests.
   --
   Next_Session_Key : Session_Key_Type := 0;
   Next_Public_Key  : Public_Key_Type  := 0;
   Next_Private_Key : Private_Key_Type := 0;


   procedure Create_Session_Key(Key : out Session_Key_Type) is
   begin
      Key := Next_Session_Key;
      Next_Session_Key := Next_Session_Key + 1;
   end Create_Session_Key;


   procedure Create_Key_Pair
     (Public_Key : out Public_Key_Type; Private_Key : out Private_Key_Type) is
   begin
      Public_Key  := Next_Public_Key;
      Private_Key := Next_Private_Key;
      Next_Public_Key  := Next_Public_Key + 1;
      Next_Private_Key := Next_Private_Key + 1;
   end Create_Key_Pair;


   function Public_Key_Initializer return Public_Key_Type is
   begin
      return 16#FFFFFFFF#;
   end Public_Key_Initializer;


   function Signature_Initializer return Signature_Type is
   begin
      return 16#FFFFFFFF#;
   end Signature_Initializer;


   procedure Raw_To_Public_Key
     (Raw_Data : in  Octet_Array;
      Fst      : in  Raw_Index_Type;
      Lst      : out Raw_Index_Type;
      Key      : out Public_Key_Type;
      Valid    : out Boolean) is
   begin
      Key := 0;
      if Fst < Raw_Data'First or Fst + 4 > Raw_Data'Last + 1 then
         Lst   := Fst;
         Valid := False;
      else
         for I in Natural range Fst .. Fst + 4 - 1 loop
            Key := Key * 256;
            Key := Key + Public_Key_Type(Raw_Data(I));
         end loop;
         Lst   := Fst + 4 - 1;
         Valid := True;
      end if;
   end Raw_To_Public_Key;


   procedure Raw_To_Signature
     (Raw_Data : in  Octet_Array;
      Fst      : in  Raw_Index_Type;
      Lst      : out Raw_Index_Type;
      Signature: out Signature_Type;
      Valid    : out Boolean) is
   begin
      Signature := 0;
      if Fst < Raw_Data'First or Fst + 4 > Raw_Data'Last + 1 then
         Lst   := Fst;
         Valid := False;
      else
         for I in Natural range Fst .. Fst + 4 - 1 loop
            Signature := Signature * 256;
            Signature := Signature + Signature_Type(Raw_Data(I));
         end loop;
         Lst   := Fst + 4 - 1;
         Valid := True;
      end if;
   end Raw_To_Signature;


   procedure Compute_MAC(Raw_Data : in Octet_Array; MAC : out MAC_Type) is
   begin
      MAC := 0;
   end Compute_MAC;


   function Verify_MAC(Raw_Data : Octet_Array; MAC : MAC_Type) return Boolean is
   begin
      return True;
   end Verify_MAC;


   procedure Compute_Signature
     (Raw_Data  : in  Octet_Array;
      Fst       : in  Raw_Index_Type;
      Lst       : in  Raw_Index_Type;
      Signature : out Signature_Type;
      Key       : in  Private_Key_Type) is
   begin
      Signature := 0;
   end Compute_Signature;


   function Verify_Signature
     (Raw_Data  : Octet_Array;
      Fst       : Raw_Index_Type;
      Lst       : Raw_Index_Type;
      Signature : Signature_Type;
      Key       : Public_Key_Type) return Boolean is
   begin
      return True;
   end Verify_Signature;


   procedure Encrypt(Raw_Data : in out Octet_Array; Key : in Public_Key_Type) is
   begin
      null;
   end Encrypt;


   procedure Decrypt(Raw_Data : in out Octet_Array; Key : Private_Key_Type) is
   begin
      null;
   end Decrypt;

end TMLib.Cryptographic_Services;
