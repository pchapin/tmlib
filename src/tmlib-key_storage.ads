---------------------------------------------------------------------------
-- FILE    : tmlib-key_storage.ads
-- SUBJECT : Package that manages a storage area holding public keys.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------
with TMLib.Cryptographic_Services; use type TMLib.Cryptographic_Services.Public_Key_Type;

--# inherit TMLib.Cryptographic_Services;
package TMLib.Key_Storage
  --# own Storage;
is
   Capacity : constant := 8;
   subtype Index_Type is Positive range 1 .. Capacity;
   subtype Size_Type is Natural range 0 .. Capacity;

   -- Initializes the key storage area.
   procedure Initialize;
   --# global out Storage;
   --# derives Storage from ;

   -- Add a new public key to the key storage area. Retuns the key's index value in the storage
   -- If Invalidate_Old is true any previous use of this index value is invalid. The caller is
   -- responsible for taking care of any issues that might cause.
   --
   procedure Add_Key
     (Key            : in Cryptographic_Services.Public_Key_Type;
      Key_Index      : out Index_Type;
      Invalidate_Old : out Boolean);
   --# global in out Storage;
   --# derives Storage        from Storage, Key &
   --#         Key_Index      from Storage, Key &
   --#         Invalidate_Old from Storage, Key;

   -- Returns the number of keys in the key storage area. This number is monotonically increasing.
   -- If the storage area fills and a new key is added, the key stored furthest in the past is
   -- removed causing the size to remain the same in that case.
   --
   function Size return Size_Type;
   --# global in Storage;

private
   -- The material in the private part of this package is for debugging purposes only. It is
   -- used by the child package TMLib.Key_Storage.Debug to display the state of the key storage
   -- area.

   type Storage_Array is array(Index_Type) of Cryptographic_Services.Public_Key_Type;

   function Get_Storage return Storage_Array;
   --# global in Storage;

end TMLib.Key_Storage;
