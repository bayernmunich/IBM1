@rem Copyright IBM Corp. 2002

@setlocal
@echo off

call "%~dp0versionInfo.bat" -format html -file versionReport.html -maintenancePackages -componentDetail

@endlocal

GOTO :EOF
