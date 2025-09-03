@Echo off

set "inkscapePath=C:\Program Files\Inkscape\inkscape.exe"
set /a count=0

for %%i in (.\*.pdf) do (
	set /a count=count+1
	echo %%i to %%~ni.png
	"%inkscapePath%" --without-gui --file="%%i" --export-png="%%~ni.png" --export-dpi=300
)
   
echo %count% file(s) converted from pdf to png!
   
pause