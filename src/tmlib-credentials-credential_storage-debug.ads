---------------------------------------------------------------------------
-- FILE    : tmlib-credentials-credential_storage-debug.ads
-- SUBJECT : Package that allows for the display and manipulation of internal TMLib data.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- This package does not need to be SPARKable.
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------

package TMLib.Credentials.Credential_Storage.Debug is

   -- Displays the current storage on the standard output device.
   procedure Dump_Storage;

   -- Displays the current model on the standard output device.
   procedure Dump_Model;

end TMLib.Credentials.Credential_Storage.Debug;
