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

package body TMLib.Credentials.Certificate_Storage is

   -- Converts the raw bytes of a certificate transfer format to a certificate.
   procedure Raw_To_Certificate
     (Raw_Data    : in  Cryptographic_Services.Octet_Array;
      Certificate : out Certificate_Type;
      Valid       : out Boolean) is
   begin
      null;
   end Raw_To_Certificate;

   -- Converts a certificate to the raw bytes of a certificate transfer format.
   procedure Certificate_To_Raw
     (Certificate : in  Certificate_Type;
      Raw_Data    : out Cryptographic_Services.Octet_Array;
      Success     : out Boolean) is
   begin
      null;
   end Certificate_To_Raw;

end TMLib.Credentials.Certificate_Storage;
