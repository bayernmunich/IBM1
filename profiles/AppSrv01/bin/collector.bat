@echo off
SETLOCAL
call "%~dp0setupCmdLine.bat"
call "%WAS_HOME%\bin\collector.bat" %*
ENDLOCAL
