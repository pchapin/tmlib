@echo off
rem
rem Batch file to simplify running tests.
rem

if not %1x == x goto Continue1
echo Specify the name of a test file on the command line.
goto Done

:Continue1
if exist %1 goto Continue2
echo File %1 not found.
goto Done

:Continue2
java -cp ..\Java\build CCD %1

:Done
