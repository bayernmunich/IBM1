@echo off
SETLOCAL
call "%~dp0\setupCmdLine.bat"
call "%WAS_HOME%\bin\SNMP_EncryptSecurityAttributes.bat" %*
ENDLOCAL & set MYERRORLEVEL=%ERRORLEVEL%
if defined PROFILE_CONFIG_ACTION (exit %MYERRORLEVEL%) else exit /b %MYERRORLEVEL%
