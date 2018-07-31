@echo off
SETLOCAL
call "%~dp0setupCmdLine.bat"
call "%WAS_HOME%\bin\ProfileManagement\wct.bat" %* -perspective com.ibm.ws.mmt.perspective
ENDLOCAL & set MYERRORLEVEL=%ERRORLEVEL%
if defined PROFILE_CONFIG_ACTION (exit %MYERRORLEVEL%) else exit /b %MYERRORLEVEL%
