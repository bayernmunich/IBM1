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
call "C:\Program Files (x86)\IBM\WebSphere\AppServer\bin\setupCmdLine.bat"

call "C:\Program Files (x86)\IBM\WebSphere\AppServer\firststeps\fbrowser.bat"
"C:\Program Files (x86)\IBM\WebSphere\AppServer\java\jre\bin\javaw" -classpath "C:\Program Files (x86)\IBM\WebSphere\AppServer\lib\htmlshell.jar";"C:\Program Files (x86)\IBM\WebSphere\AppServer\plugins\com.ibm.ws.runtime.jar" com.ibm.ws.install.htmlshell.Launcher --file "C:\Program Files (x86)\IBM\WebSphere\AppServer\firststeps\firststeps"  --width 651  --height 600  --resizable false --icon "C:\Program Files (x86)\IBM\WebSphere\AppServer\firststeps\ws16x16.gif" --profilepath "C:\Program Files (x86)\IBM\WebSphere\AppServer" --cellname ${WS_CMT_CELL_NAME} --wasroot C:\Program Files (x86)\IBM\WebSphere\AppServer --FirstStepsDefaultBrowserPath %FirstStepsDefaultBrowserPath% --FirstStepsDefaultBrowser %FirstStepsDefaultBrowser%
cd /d "%CUR_DIR%"
ENDLOCAL
GOTO :EOF
