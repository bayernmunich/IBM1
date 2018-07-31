@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM Configuration Instance Creation Tool Launcher

@setlocal
@echo off

@REM Bootstrap values ...
CALL "%~dp0setupCmdLine.bat" %* 

if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

set PATH_ORIG=%PATH%
set PATH=%WAS_PATH%
set USER_HOME=%HOMEDRIVE%%HOMEPATH%
set WORKSPACE=%USER_HOME%\manageprofiles\workspace

%JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -Xms256M -Xmx512M -Xquickstart -Xshareclasses "-DWAS_HOME=%WAS_HOME%" "-Dwas.install.root=%WAS_HOME%" "-DJAVA_NATIVE_LIB_DIR=%JAVA_NATIVE_LIB_DIR% " -classpath "%WAS_CLASSPATH%" "-Dws.ext.dirs=%WAS_EXT_DIRS%"  com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash  -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.runtime.WsProfile %* 
set PATH=%PATH_ORIG%

set RC=%ERRORLEVEL%

CALL "%~dp0clearClassCache.bat"
@REM Need to pass the RC through the endlocal
@endlocal & exit /b %RC%

GOTO :EOF

