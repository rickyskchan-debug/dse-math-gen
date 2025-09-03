@echo off
fpc main_fpc.pas 
if errorlevel 1 goto :lastline

del /S *.o
del /S *.out

cls

main_fpc <input.in >nul

echo success
timeout 5

del /S *.exe

exit

:lastline
pause