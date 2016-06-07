---------------------------------------------------------------------------
-- FILE    : tmlib-credentials.adb
-- SUBJECT : Package that manages RT_0 credentials.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------

package body TMLib.Credentials is

   function Invalid_Credential return Credential_Type is
   begin
      return Credential_Type'
        (Form => Invalid,
         Defining_Key => Key_Storage.Index_Type'Last,
         Target_Role  => 0,
         Source_Key1  => Key_Storage.Index_Type'Last,
         Source_Key2  => Key_Storage.Index_Type'Last,
         Source_Role1 => 0,
         Source_Role2 => 0);
   end Invalid_Credential;


   function Is_Valid(Credential : Credential_Type) return Boolean is
   begin
      -- Should any other sanity checking also be done?
      return Credential.Form /= Invalid;
   end Is_Valid;

end TMLib.Credentials;
