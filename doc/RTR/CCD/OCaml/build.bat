@echo off
rem
rem Batch file to control the build of the CCD executable and docs.
rem

if %1x == docsx goto DoDocs
ocamlc -o CCD.exe CCD.ml
goto Finished

:DoDocs
if exist docs goto DocsExist
md docs

:DocsExist
ocamldoc -html -d docs CCD.ml

:Finished

