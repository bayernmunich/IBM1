@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp., 1997,2004
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@echo off
SETLOCAL
SET CUR_DIR=%cd%
SET DIR_CUR=%cd%
cd /d "%~dp0.."
call "${PROFILEROOT}\bin\setupCmdLine.bat"

call "${PROFILEROOT}\firststeps\fbrowser.bat"
${JAVAWROOT} -classpath ${HTMLSHELLJAR};"${WASROOT}\plugins\com.ibm.ws.runtime.jar" com.ibm.ws.install.htmlshell.Launcher --file "${PROFILEROOT}\firststeps\firststeps"  --width 651  --height 600  --resizable false --icon "${PROFILEROOT}\firststeps\ws16x16.gif" --profilepath "${PROFILEROOT}" --cellname ${CELLNAME} --wasroot ${WASROOT} --FirstStepsDefaultBrowserPath %FirstStepsDefaultBrowserPath% --FirstStepsDefaultBrowser %FirstStepsDefaultBrowser%
cd /d "%CUR_DIR%"
ENDLOCAL
GOTO :EOF
