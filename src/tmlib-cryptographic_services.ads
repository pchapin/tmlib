---------------------------------------------------------------------------
-- FILE    : tmlib-cryptographic_services.ads
-- SUBJECT : Container package for low level cryptographic operations.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------

package TMLib.Cryptographic_Services is
   type Octet is mod 256;
   for Octet'Size use 8;

   -- Make sure Octet_Arrays will never use Natural'Last as their last index value. This makes
   -- processing such arrays a little easier since an index variable of type Natural can hold
   -- a "one off the end" value without exception.
   --
   subtype Raw_Index_Type is Natural range 0 .. Natural'Last - 1;
   type Octet_Array is array(Raw_Index_Type range <>) of Octet;

   type Session_Key_Type is private;
   type Public_Key_Type  is private;
   type Private_Key_Type is private;
   type Signature_Type   is private;
   type MAC_Type         is private;

   -- Create session key
   procedure Create_Session_Key(Key : out Session_Key_Type);
   --# derives Key from ;

   -- Create key pair
   procedure Create_Key_Pair
     (Public_Key : out Public_Key_Type; Private_Key : out Private_Key_Type);
   --# derives Public_Key  from &
   --#         Private_Key from ;

   -- Returns a place holder public key value to represent "no valid key."
   function Public_Key_Initializer return Public_Key_Type;

   -- Returns a place holder signature value to represent "no valid signature."
   function Signature_Initializer return Signature_Type;

   -- Converts a fragment of the given raw array to an abstract representation of a public key.
   -- The fragment begins at index 'Fst' and runs through index 'Lst.' Valid is True if the
   -- conversion was successful; otherwise the special invalid public key is returned.
   --
   procedure Raw_To_Public_Key
     (Raw_Data : in  Octet_Array;
      Fst      : in  Raw_Index_Type;
      Lst      : out Raw_Index_Type;
      Key      : out Public_Key_Type;
      Valid    : out Boolean);
   --# derives Lst   from Raw_Data, Fst &
   --#         Key   from Raw_Data, Fst &
   --#         Valid from Raw_Data, Fst;

   -- Converts a fragment of the given raw array to an abstract representation of a signature.
   -- The fragment begins at index 'Fst' and runs through index 'Lst.' Valid is True if the
   -- conversion was successful; otherwise the special invalid signature is returned.
   --
   procedure Raw_To_Signature
     (Raw_Data  : in  Octet_Array;
      Fst       : in  Raw_Index_Type;
      Lst       : out Raw_Index_Type;
      Signature : out Signature_Type;
      Valid     : out Boolean);
   --# derives Lst       from Raw_Data, Fst &
   --#         Signature from Raw_Data, Fst &
   --#         Valid     from Raw_Data, Fst;

   -- Compute MAC
   procedure Compute_MAC(Raw_Data : in Octet_Array; MAC : out MAC_Type);
   --# derives MAC from Raw_Data;

   -- Verify MAC
   function Verify_MAC(Raw_Data : Octet_Array; MAC : MAC_Type) return Boolean;

   -- Computes a signature of the fragment of the given raw array. Ths signature is computed
   -- only for the part of the array from index 'Fst' through index 'Lst.'
   --
   procedure Compute_Signature
     (Raw_Data  : in  Octet_Array;
      Fst       : in  Raw_Index_Type;
      Lst       : in  Raw_Index_Type;
      Signature : out Signature_Type;
      Key       : in  Private_Key_Type);
   --# derives Signature from Raw_Data, Fst, Lst, Key;

   -- Verifies a signature against a fragment of the given raw array. The signature is checked
   -- only for the part of the array from index 'Fst' through index 'Lst.'
   --
   function Verify_Signature
     (Raw_Data  : Octet_Array;
      Fst       : Raw_Index_Type;
      Lst       : Raw_Index_Type;
      Signature : Signature_Type;
      Key       : Public_Key_Type) return Boolean;

   -- Encrypt (public key operation)
   procedure Encrypt(Raw_Data : in out Octet_Array; Key : in Public_Key_Type);
   --# derives Raw_Data from Raw_Data, Key;

   -- Decrypt (private key operation)
   procedure Decrypt(Raw_Data : in out Octet_Array; Key : Private_Key_Type);
   --# derives Raw_Data from Raw_Data, Key;

private

   -- The following type definitions are temporary and used only for initial testing.

   type Session_Key_Type is mod 2**32;
   type Public_Key_Type  is mod 2**32;
   type Private_Key_Type is mod 2**32;
   type Signature_Type   is mod 2**32;
   type MAC_Type         is mod 2**32;

end TMLib.Cryptographic_Services;
