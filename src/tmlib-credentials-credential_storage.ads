---------------------------------------------------------------------------
-- FILE    : tmlib-credentials-credential_storage.ads
-- SUBJECT : Package that manages the RT_0 credential cache.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- In addition to managing a storage area for credentials, this package is also responsible for
-- the authorization computation. This is done because a set of crentials is closely related
-- to the minimum model they imply. Both forms (storage and model) are basically alternate
-- representations of a database. By packaging them together, various optimizations are
-- possible in the implementation. This structure also emphasizes the close relationship
-- between a set of credentials and their model.
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------
with TMLib.Credentials;
with TMLib.Cryptographic_Services; use type TMLib.Cryptographic_Services.Public_Key_Type;
with TMLib.Key_Storage;

--# inherit TMLib.Credentials, TMLib.Cryptographic_Services, TMLib.Key_Storage;
package TMLib.Credentials.Credential_Storage
  --# own Storage, Model;
is
   -- Erases the contents of the storage.
   procedure Initialize;
   --# global out Storage, Model;
   --# derives Storage from &
   --#         Model   from ;

   -- Adds the given credential to the storage. If the given credential is invalid no change is
   -- made to the storage. If the credential storage is full an existing credential is removed.
   -- If the key storage is full, and new keys need to be added to support the addition of this
   -- credential, existing keys, along with all related credentials, are removed.
   --
   procedure Add_Credential(Credential : in Credentials.Credential_Type);
   --# global in out Storage;
   --# derives Storage  from Storage, Credential;

   -- Removes any credentials that are using the indicated key index. This must be called after
   -- any new key is added to the key storage area to ensure that any credentials use a removed
   -- key is also removed.
   --
   procedure Invalidate_Credentials_Using(Key_Index : Key_Storage.Index_Type);
   --# global in out Storage;
   --# derives Storage from Storage, Key_Index;

   -- Computes the minimum model defined by the credentials currently in the storage. If there
   -- is insufficent space to hold all tuples in the minimum model, Overflow is set to True. If
   -- this procedure returns with Overflow True, the the model computed is not complete but it
   -- is still sound.
   --
   procedure Compute_Minimum_Model(Overflow : out Boolean);
   --# global in out Storage, Model;
   --# derives Storage  from Storage        &
   --#         Model    from Storage, Model &
   --#         Overflow from Storage, Model;

   -- Returns the number of credentials in the storage.
   function Storage_Size return Natural;
   --# global in Storage;

   -- Returns the number of tuples in the current model. Note that this only reflects the model
   -- implied by the stored credentials if Compute_Minimum_Model has been called more recently
   -- than Add_Raw_Credential. The model in only updated when Compute_Minimum_Model is called.
   --
   function Current_Model_Size return Natural;
   --# global in Model;

   -- Returns True of Query_Key is in role Governing_Key.Governing_Role; False otherwise.
   function Authorize
     (Governing_Key  : Key_Storage.Index_Type;
      Governing_Role : Credentials.Role_Type;
      Query_Key      : Key_Storage.Index_Type) return Boolean;
   --# global in Model;

private

   -- The material in the private part of this package is for debugging purposes only. It is
   -- used by the child package TMLib.Credentials.Credential_Storage.Debug to display the state
   -- of the credential storage area.

   ---------------------
   -- Credential Storage
   ---------------------
   Storage_Capacity : constant :=  8;
   subtype Storage_Index_Type is Positive range 1 .. Storage_Capacity;
   subtype Storage_Size_Type is Natural range 0 .. Storage_Capacity;
   type Storage_Array is array(Storage_Index_Type) of Credentials.Credential_Type;

   function Get_Storage return Storage_Array;
   --# global in Storage;

   --------
   -- Model
   --------
   Model_Capacity : constant := 16;
   subtype Model_Index_Type is Positive range 1 .. Model_Capacity;
   subtype Model_Size_Type is Natural range 0 .. Model_Capacity;
   type Model_Tuple is
      record
         Target_Key  : Key_Storage.Index_Type;
         Target_Role : Credentials.Role_Type;
         Member_Key  : Key_Storage.Index_Type;
      end record;
   type Model_Array is array(Model_Index_Type) of Model_Tuple;

   function Get_Model return Model_Array;
   --# global in Model;

end TMLib.Credentials.Credential_Storage;
