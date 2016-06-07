---------------------------------------------------------------------------
-- FILE    : tmlib-credentials-transfer_format.ads
-- SUBJECT : Package that handles RT_0 credential transfer formats.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------
with TMLIb.Credentials;
with TMLib.Credentials.Credential_Storage;
with TMLib.Cryptographic_Services;
with TMLib.Key_Storage;

--# inherit TMLib.Credentials, TMLib.Credentials.Credential_Storage, TMLib.Cryptographic_Services, TMLib.Key_Storage;
package TMLib.Credentials.Transfer_Format is

   -- Converts the raw bytes of a credential transfer format to a credential.
   procedure Raw_To_Credential
     (Raw_Data   : in  Cryptographic_Services.Octet_Array;
      Credential : out Credentials.Credential_Type;
      Valid      : out Boolean);
   --# global in out Key_Storage.Storage, Credential_Storage.Storage;
   --# derives Credential          from Raw_Data, Key_Storage.Storage &
   --#         Valid               from Raw_Data &
   --#         Key_Storage.Storage from Raw_Data, Key_Storage.Storage &
   --#         Credential_Storage.Storage from
   --#                                Raw_Data, Key_Storage.Storage, Credential_Storage.Storage;

--   -- Converts a credential to the raw bytes of a credential transfer format.
--   procedure Credential_To_Raw
--     (Credential : in  Credentials.Credential_Type;
--      Raw_Data   : out Cryptographic_Services.Octet_Array;
--      Success    : out Boolean);
--   --# derives Raw_Data from Credential &
--   --#         Success  from Credential;

end TMLib.Credentials.Transfer_Format;
