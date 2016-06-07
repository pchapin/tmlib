---------------------------------------------------------------------------
-- FILE    : tmlib-credentials-debug.ads
-- SUBJECT : Package that allows for display and manipulation of internal TMLib data.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- This package does not need to be SPARKable.
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------

package TMLib.Credentials.Debug is

   -- Displays the credential on the standard output device in a human readible format.
   procedure Dump_Credential(Credential: Credentials.Credential_Type);

end TMLib.Credentials.Debug;
