@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2007, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@setlocal
@echo off

@REM Bootstrap values ...
CALL "%~dp0setupCmdLine.bat" %* 

if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

set PROFILE_CLASSPATH="%WAS_HOME%\plugins\com.ibm.ws.runtime.jar"

echo.
%JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -classpath %PROFILE_CLASSPATH% com.ibm.ws.profile.DeprecatedCommandRetriever wasprofile.bat manageprofiles.bat %*
echo.

call "%~dp0manageprofiles.bat" %*

set RC=%ERRORLEVEL%

@REM Need to pass the RC through the endlocal
@endlocal & exit /b %RC%

GOTO :EOF
