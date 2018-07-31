@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997,2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM wsadmin launcher

@echo off
REM Usage: wsadmin arguments
setlocal

if defined SI_PATH goto sipathdefined
echo Environment variable SI_PATH is not defined.  You need to run %%ACU_COMMON%%\setenv.cmd first where %%ACU_COMMON%% is the Solution Install common directory, for example C:\Program Files\IBM\common\acu.
goto :EOF
:sipathdefined

CALL "%~dp0setupCmdLine.bat" %*

@REM The following is added through defect 236497.1
if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

set CMD_NAME=%~nx0
set PROFILE_ERROR=0
call :CHECK_INVALID_PROFILE_SPECIFIED
if "%PROFILE_ERROR%"=="1" goto :END

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

@REM For debugging the utility itself
@REM set DEBUG=-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777

if defined USER_INSTALL_ROOT goto loop
SET USER_INSTALL_ROOT=%WAS_HOME%

:loop
if '%1'=='-javaoption' goto javaoption
if '%1'=='' goto runcmd
goto nonjavaoption

:javaoption
shift 
set javaoption=%javaoption% %1
goto again

:nonjavaoption
set nonjavaoption=%nonjavaoption% %1

:again
shift
goto loop

:runcmd
"%JAVA_HOME%\bin\java" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" %WAS_LOGGING% %javaoption% %CONSOLE_ENCODING% %DEBUG% "%CLIENTSOAP%" "%CLIENTSAS%" "%CLIENTSSL%" "-Dcom.ibm.ws.scripting.wsadminprops=%WSADMIN_PROPERTIES%" -Dcom.ibm.ws.management.standalone=true "-Duser.install.root=%USER_INSTALL_ROOT%" "-Dwas.install.root=%WAS_HOME%" "-Dwas.repository.root=%CONFIG_ROOT%" "-Dserver.root=%WAS_HOME%" "-Dlocal.cell=%WAS_CELL%" "-Dlocal.node=%WAS_NODE%" "-Dcom.ibm.itp.location=%WAS_HOME%\bin" "-Dsipath=%SI_PATH%" "-classpath" "%SI_PATH%\lib\si.jar;%SI_PATH%\lib\jlog.jar;%SI_PATH%\lib\db2j.jar;%SI_PATH%\lib\db2jcc.jar;%SI_PATH%\lib\db2jnet.jar;%SI_PATH%\lib\db2jcc_license_c.jar;%SI_PATH%\lib\db2jtools.jar"  "-Dws.ext.dirs=%WAS_EXT_DIRS%" com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.management.touchpoint.tpru.RegisterTouchpoints %*
                                     
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
endlocal

GOTO :EOF
