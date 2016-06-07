---------------------------------------------------------------------------
-- FILE    : assertions.ads
-- SUBJECT : Package for managing assertions during testing.
-- AUTHOR  : (C) Copyright 2010 by Peter C. Chapin
--
-- This package does not need to be SPARKable.
--
-- Please send comments or bug reports to
--
--      Peter C. Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------

package Assertions is
   Assertion_Failure : exception;

   -- If the condition is false, print the string and raise Assertion_Failure.
   procedure Assert(Condition : in Boolean; Message : in String);
end Assertions;
