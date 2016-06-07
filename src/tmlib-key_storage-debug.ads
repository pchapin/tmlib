---------------------------------------------------------------------------
-- FILE    : tmlib-key_storage-debug.ads
-- SUBJECT : Package that allows for the display and manipulation of internal TMLib data.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- This package does not need to be SPARKable.
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------

package TMLib.Key_Storage.Debug is

   -- Displays the current key storage on the standard output device.
   procedure Dump_Storage;

end TMLib.Key_Storage.Debug;
