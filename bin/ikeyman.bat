@rem Copyright IBM Corp. 2004

@echo off
CALL "%~dp0setupCmdLine.bat" %* 
"%SystemRoot%\system32\cscript" //NoLogo "%WAS_HOME%\bin\GetGSKITInstallPath.vbs"
GOTO :EOF
