---------------------------------------------------------------------------
-- FILE    : tmlib-key_storage.adb
-- SUBJECT : Package that manages a storage area holding public keys.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------

package body TMLib.Key_Storage
  --# own Storage is Key_Storage_Area, Key_Storage_Size, Key_Storage_Next;
is

   Key_Storage_Area : Storage_Array;
   Key_Storage_Size : Size_Type;
   Key_Storage_Next : Index_Type;


   procedure Initialize
   --# global out Key_Storage_Area, Key_Storage_Size, Key_Storage_Next;
   --# derives Key_Storage_Area from &
   --#         Key_Storage_Size from &
   --#         Key_Storage_Next from ;
   is
   begin
      Key_Storage_Area := Storage_Array'(others => Cryptographic_Services.Public_Key_Initializer);
      Key_Storage_Size := 0;
      Key_Storage_Next := Index_Type'First;
   end Initialize;


   procedure Add_Key
     (Key            : in Cryptographic_Services.Public_Key_Type;
      Key_Index      : out Index_Type;
      Invalidate_Old : out Boolean)
   --# global in out Key_Storage_Area, Key_Storage_Size, Key_Storage_Next;
   --# derives Key_Storage_Area from Key_Storage_Area, Key_Storage_Size, Key_Storage_Next, Key &
   --#         Key_Storage_Size from Key_Storage_Area, Key_Storage_Size, Key &
   --#         Key_Storage_Next from Key_Storage_Area, Key_Storage_Size, Key_Storage_Next, Key &
   --#         Key_Index        from Key_Storage_Area, Key_Storage_Size, Key_Storage_Next, Key &
   --#         Invalidate_Old   from Key_Storage_Area, Key_Storage_Size, Key;
   is
      Found : Boolean;
   begin
      Invalidate_Old := True;

      -- Is the key already present in the key storage area?
      Found := False;
      for I in Index_Type range 1 .. Key_Storage_Size loop
         if Key_Storage_Area(I) = Key then
            Key_Index      := I;
            Invalidate_Old := False;  -- Don't invalidate if the key is already present.
            Found          := True;
            exit;
         end if;
      end loop;

      -- If the key is not in the storage area, add it.
      if not Found then
         Key_Storage_Area(Key_Storage_Next) := Key;
         Key_Index := Key_Storage_Next;
         if Key_Storage_Size < Capacity then
            Key_Storage_Size := Key_Storage_Size + 1;
         end if;

         if Key_Storage_Next = Index_Type'Last then
            Key_Storage_Next := Index_Type'First;
         else
            Key_Storage_Next := Key_Storage_Next + 1;
         end if;
      end if;
   end Add_Key;


   function Size return Size_Type
   --# global in Key_Storage_Size;
   is
   begin
      return Key_Storage_Size;
   end Size;


   function Get_Storage return Storage_Array
   --# global in Key_Storage_Area;
   is
   begin
      return Key_Storage_Area;
   end Get_Storage;


end TMLib.Key_Storage;
