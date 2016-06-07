---------------------------------------------------------------------------
-- FILE    : tmlib-credentials.ads
-- SUBJECT : Package that handles RT_0 credential forms.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------
with TMLib.Key_Storage;

--# inherit TMLib.Key_Storage;
package TMLib.Credentials is
   -- Represents RT_0 credentials.
   type Credential_Type is private;
   type Role_Type is range 0 .. 255;

   -- Returns a special credential that is different from any valid credential.
   function Invalid_Credential return Credential_Type;

   -- Returns True if the given credential is not the invalid credential.
   function Is_Valid(Credential : Credential_Type) return Boolean;

private
   type Credential_Form is (Invalid, Role_Membership, Role_Inclusion, Role_Linked, Role_Intersection);
   type Credential_Type is
      record
         Form         : Credential_Form;          -- Really should be a discriminant.
         Defining_Key : Key_Storage.Index_Type;
         Target_Role  : Role_Type;
         Source_Key1  : Key_Storage.Index_Type;
         Source_Key2  : Key_Storage.Index_Type;
         Source_Role1 : Role_Type;
         Source_Role2 : Role_Type;
      end record;
end TMLib.Credentials;
