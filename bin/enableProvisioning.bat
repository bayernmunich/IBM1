@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2008, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM Enable provisioning for the specified node and server

@REM Arguments
@REM
@REM -nodeName <node name> - required
@REM -serverName <server name> - optional; defaults to server1
@REM -help - optional; help for this command

@setlocal
@echo off

@REM Bootstrap values ...
CALL "%~dp0setupCmdLine.bat" %*

if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

set CMD_NAME=%~nx0
set PROFILE_ERROR=0
call :CHECK_INVALID_PROFILE_SPECIFIED
if "%PROFILE_ERROR%"=="1" goto :END

"%WAS_HOME%\bin\wsadmin" -conntype none -lang jython -c "AdminTask.enableProvisioning('%*')"

goto :END

REM subroutine for checking if invalid profile specified.
:CHECK_INVALID_PROFILE_SPECIFIED
if defined INV_PRF_SPECIFIED (
   if "%INV_PRF_SPECIFIED%"=="true" (
       %JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -classpath "%WAS_HOME%\lib\commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -specifiedProfileNotExists -profileName "%WAS_PROFILE_NAME:"=%"
       SET PROFILE_ERROR=1
   ) else ( call :CHECK_WAS_USER_SCRIPT_FILE_NOT_EXISTS
   )
) else ( call :CHECK_WAS_USER_SCRIPT_FILE_NOT_EXISTS
)
goto :EOF

REM subroutine for checking if WAS User Script file not exists.
:CHECK_WAS_USER_SCRIPT_FILE_NOT_EXISTS
if defined WAS_USER_SCRIPT_FILE_NOT_EXISTS (
   if "%WAS_USER_SCRIPT_FILE_NOT_EXISTS%"=="true" (
       %JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -classpath "%WAS_HOME%\lib\commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -wasUserScriptFileNotExists -wasUserScript "%WAS_USER_SCRIPT:"=%"
       SET PROFILE_ERROR=1
   ) else ( call :CHECK_NO_DFT_PRF_EXISTS
   )
) else ( call :CHECK_NO_DFT_PRF_EXISTS
)
goto :EOF

REM subroutine for checking if no default profile exists.
:CHECK_NO_DFT_PRF_EXISTS
if defined NO_DFT_PRF_EXISTS (
   if "%NO_DFT_PRF_EXISTS%"=="true" (
       %JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -classpath "%WAS_HOME%\lib\commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -noDefaultProfile -commandName "%CMD_NAME:"=%"
       SET PROFILE_ERROR=1
   )
)
goto :EOF

:END
@endlocal
