@echo off
set SDK=10.0.26100.0
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\VsDevCmd.bat" -arch=x64
if not exist bin mkdir bin
if not exist data mkdir data
cl /nologo /EHsc /I"C:\Program Files (x86)\Windows Kits\10\Include\%SDK%\um\winsqlite" main.cpp /link /LIBPATH:"C:\Program Files (x86)\Windows Kits\10\Lib\%SDK%\um\x64" winsqlite3.lib /OUT:bin\itc_conectores.exe
