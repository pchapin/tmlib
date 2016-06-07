---------------------------------------------------------------------------
-- FILE    : tmlib-credentials-certificate_storage.ads
-- SUBJECT : Package that handles certificates.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- It's unclear to me right now just how certificates should be integrated into this library.
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------
with TMLib.Cryptographic_Services;
with TMLib.Credentials;

--# inherit TMLib.Cryptographic_Services, TMLib.Credentials;
package TMLib.Credentials.Certificate_Storage is
   type Certificate_Type is private;

   -- Converts the raw bytes of a certificate transfer format to a certificate.
   procedure Raw_To_Certificate
     (Raw_Data    : in  Cryptographic_Services.Octet_Array;
      Certificate : out Certificate_Type;
      Valid       : out Boolean);
   --# derives Certificate from Raw_Data &
   --#         Valid       from Raw_Data;

   -- Converts a certificate to the raw bytes of a certificate transfer format.
   procedure Certificate_To_Raw
     (Certificate : in  Certificate_Type;
      Raw_Data    : out Cryptographic_Services.Octet_Array;
      Success     : out Boolean);
   --# derives Raw_Data from Certificate &
   --#         Success  from Certificate;

private
   type Certificate_Type is
      record
         Credential : Credentials.Credential_Type;
         Signature  : Cryptographic_Services.Signature_Type;
      end record;

end TMLib.Credentials.Certificate_Storage;
