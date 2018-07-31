@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp., 1997,2004, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@echo off

setlocal

set CURDIR=%CD%
set BINDIR=%~dp0

cd /d %BINDIR%\..\..
call .\setupCmdLine.bat

cd /d %BINDIR%
start "WCT" ".\eclipse.exe" -perspective com.ibm.ws.pmt.views.standalone.perspectives.standAlonePerspective -vm "%WAS_HOME%\java\jre\bin\javaw.exe" %* -vmargs -Xbootclasspath/a:"%WAS_HOME%\lib\bootstrap.jar" -Djava.endorsed.dirs="%WAS_HOME%\endorsed_apis":"%WAS_HOME%\jre\lib\endorsed" -Declipse.refreshBundles=true -DJAVA_NATIVE_LIB_DIR="%JAVA_NATIVE_LIB_DIR%" -DWAS_HOME="%WAS_HOME%"

cd %CURDIR%
endlocal

GOTO :EOF

