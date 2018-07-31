@echo off
setlocal

@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 1997,2011
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM WebSphere Intelligent Management scripts to link two cells together for OVERLAY communication

call "%~dp0setupCmdLine.bat"

if [%2]==[] (
	goto :HELP
) else (
	if not [%3]==[] (
		goto :HELP
	)
)
goto :RUN

:HELP
	echo "Usage: linkCells.sh <cell1Info> <cell2Info>"
	echo "   where both <cell1Info> and <cell2Info> are of one of the following two forms:"
	echo "     <dmgrHost>:<dmgrSoapPort>"
	echo "        if WebSphere security is NOT enabled in the cell"
	echo "     <dmgrHost>:<dmgrSoapPort>:<userName>:<password>[:<trustStoreName>]"
	echo "        if WebSphere security is enabled in the cell"
	echo "This script links two cells together for communication over the OVERLAY ports."
	goto :END

:RUN
	for /f "tokens=1,2,3,4,5 delims=:" %%a in ("%1") do set HOST1=%%a&set PORT1=%%b&set UID1=%%c&set PWD1=%%d&set TS1=%%e
	if not defined TS1 set TS1=CellDefaultTrustStore
	for /f "tokens=1,2,3,4,5 delims=:" %%a in ("%2") do set HOST2=%%a&set PORT2=%%b&set UID2=%%c&set PWD2=%%d&set TS2=%%e
	if not defined TS2 set TS2=CellDefaultTrustStore
	
	set PY=-f %WAS_HOME%\bin\linkCells.py

	set INVOKE1=%WAS_HOME%\bin\wsadmin.bat -conntype SOAP -host %HOST1% -port %PORT1% -user %UID1% -password %PWD1% %PY%
	set INVOKE2=%WAS_HOME%\bin\wsadmin.bat -conntype SOAP -host %HOST2% -port %PORT2% -user %UID2% -password %PWD2% %PY%

	set OVERLAY_FILE1=%TEMP%\_overlay1_$$
	set OVERLAY_FILE1_PY=%OVERLAY_FILE1:\=\\%
	set OVERLAY_FILE2=%TEMP%\_overlay2_$$
	set OVERLAY_FILE2_PY=%OVERLAY_FILE2:\=\\%

	echo "Begin linking cells ..."

	@REM Get the overlay config from cell1 and store in OVERLAY_FILE1
	call %INVOKE1% -getOverlay::%OVERLAY_FILE1_PY%

	@REM Get the overlay config from cell2 and store it in OVERLAY_FILE2
	@REM Add the overlay config from cell1 to cell2
	@REM If a password was provided for cell1, import cell1's signer certificate into cell2
	if not %PWD1%.==. (
		call %INVOKE2% -getOverlay::%OVERLAY_FILE2_PY% -addOverlay::%OVERLAY_FILE1_PY% -importSigner:%HOST1%:%PORT1%:%TS1%
	) else (
		call %INVOKE2% -getOverlay::%OVERLAY_FILE2_PY% -addOverlay::%OVERLAY_FILE1_PY%
	)

	@REM Add the overlay config from cell2 to cell1
	@REM If a password was provided for cell2, import cell2's signer certificate into cell1
	if not %PWD2%.==. (
		call %INVOKE1% -addOverlay::%OVERLAY_FILE2_PY% -importSigner:%HOST2%:%PORT2%:%TS2%
	) else (
		call %INVOKE1% -addOverlay::%OVERLAY_FILE2_PY%
	)

	@REM Clean up temporary files
	DEL /F %OVERLAY_FILE1%
	DEL /F %OVERLAY_FILE2%

	echo "Done linking cells."

:END
	endlocal
