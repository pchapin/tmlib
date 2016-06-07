
This folder contains test cases for the credential chain discovery
algorithm. Each file is a single test case and is designed to be run in
isolation. Comments in each file describe what is being tested and the
expected outputs.

The batch file doJava.bat makes it easier to run the Java tests by
executing the Java virtual machine with appropriate options. In theory
it would be nice to create an automated test harness.

test0?.txt
==========

These files test type 1 and 2 credentials (simple credentials without
linked roles or intersections.

test1?.txt
==========

These files test linked roles.

test2?.txt
==========

These files test intersections.
