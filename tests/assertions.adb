---------------------------------------------------------------------------
-- FILE    : assertions.adb
-- SUBJECT : Package for managing assertions during testing.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- This package does not need to be SPARKable.
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------
with Ada.Text_IO;

package body Assertions is

   procedure Assert(Condition : in Boolean; Message : in String) is
   begin
      if not Condition then
         Ada.Text_IO.Put_Line(Message);
         raise Assertion_Failure with Message;
      end if;
   end Assert;

end Assertions;
