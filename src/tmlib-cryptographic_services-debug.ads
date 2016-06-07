---------------------------------------------------------------------------
-- FILE    : tmlib-cryptographic_services-debug.ads
-- SUBJECT : Package that allows for the display and manipulation of internal TMLib data.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- This package does not need to be SPARKable.
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------

package TMLib.Cryptographic_Services.Debug is

   -- Displays the given public key on the standard output device.
   procedure Dump_Public_Key(Key : Cryptographic_Services.Public_Key_Type);

end TMLib.Cryptographic_Services.Debug;
