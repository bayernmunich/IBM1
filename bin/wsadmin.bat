@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM wsadmin launcher

@echo off
REM Usage: wsadmin arguments
set ERRORLEVEL=
setlocal

CALL "%~dp0setupCmdLine.bat" %*

@REM The following is added through defect 238059.1 
if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

set CMD_NAME=%~nx0
set CMD_NAME_ONLY=%~n0

set PROFILE_ERROR=0
call :CHECK_INVALID_PROFILE_SPECIFIED
if "%PROFILE_ERROR%"=="1" goto END

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

@REM For debugging the utility itself
@REM set WAS_DEBUG=-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777

if defined USER_INSTALL_ROOT goto prop
SET USER_INSTALL_ROOT=%WAS_HOME%

:prop
set WSADMIN_PROPERTIES_PROP=
if not defined WSADMIN_PROPERTIES goto workspace
set WSADMIN_PROPERTIES_PROP="-Dcom.ibm.ws.scripting.wsadminprops=%WSADMIN_PROPERTIES%"

:workspace
set WORKSPACE_PROPERTIES=
if not defined CONFIG_CONSISTENCY_CHECK goto loop
set WORKSPACE_PROPERTIES="-Dconfig_consistency_check=%CONFIG_CONSISTENCY_CHECK%"

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
SET PATH=%WAS_PATH%
set CLASSPATH=%WAS_CLASSPATH%;%ITP_LOC%\batchboot.jar;%ITP_LOC%\batch2.jar
set PERFJAVAOPTION=-Xms256m -Xmx256m -Xquickstart
@echo off

if "%JAASSOAP%"=="" set JAASSOAP=-Djaassoap=off

@REM win2k has a 2046 command line length (not counting the CRLF).  Max length for WAS_HOME is 60 chars.  Max profile path length is 80. 
@REM To conserve command line space you can:
@REM   1. Use the CLASSPATH ENV VAR instead of the -classpath parameter.
@REM   2. Write any Java Properties into a temporary properties file and specify  -Dcmd.properties.file="<your_prop_file>"  on the java command line.
@REM      Note these exceptions:  The user.install.root and was.install.root properties must be passed in on the command line.

@REM Generate a temporary path name for the properties file.  Be sure the dir exists and is writable.
@REM Try using the profile's temp space first before using the system's temp space.
if not defined USER_INSTALL_ROOT goto GEN_SYS_TMP_DIR
:GEN_TMP_DIR
set TMPWASDIR="%USER_INSTALL_ROOT:"=%\temp\%CMD_NAME_ONLY%.%RANDOM%"
if exist %TMPWASDIR% goto GEN_TMP_DIR
mkdir %TMPWASDIR%
if exist %TMPWASDIR% goto WRITE_PROPERTIES_FILE

:GEN_SYS_TMP_DIR
set TMPWASDIR="%TEMP:"=%\%CMD_NAME_ONLY%.%RANDOM%"
if exist %TMPWASDIR% goto GEN_SYS_TMP_DIR
mkdir %TMPWASDIR%
if not exist %TMPWASDIR% ( echo The TEMP environment variable must be set to a writable directory. ) & goto :EOF

:WRITE_PROPERTIES_FILE
set TMPJAVAPROPFILE="%TMPWASDIR:"=%\%CMD_NAME_ONLY%.properties"
@REM write one property per line into the temp file. - Format is propname=value   
@REM Remember to handle the "\" char in paths, as it must become two "\\" in order for java to handle properly.
>  %TMPJAVAPROPFILE% echo # Temporary Java Properties File for the %CMD_NAME% WAS command.
set TMPPROP=%WAS_EXT_DIRS:\=\\%
>> %TMPJAVAPROPFILE% echo ws.ext.dirs=%TMPPROP:"=%
set TMPPROP=%CONFIG_ROOT:\=\\%
>> %TMPJAVAPROPFILE% echo was.repository.root=%TMPPROP:"=%
set TMPPROP=%WAS_HOME:\=\\%\\bin
>> %TMPJAVAPROPFILE% echo com.ibm.itp.location=%TMPPROP:"=%
>> %TMPJAVAPROPFILE% echo local.cell=%WAS_CELL%
>> %TMPJAVAPROPFILE% echo local.node=%WAS_NODE%
>> %TMPJAVAPROPFILE% echo com.ibm.ws.management.standalone=true
>> %TMPJAVAPROPFILE% echo com.ibm.ws.ffdc.log=%USER_INSTALL_ROOT%/logs/ffdc/
 
@REM Note: %OSGI_INSTALL% %OSGI_CFG% properties are now implicitly set in the
@REM bootstrap's pre-launcher (D309270)
%JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -Dcmd.properties.file=%TMPJAVAPROPFILE% %PERFJAVAOPTION% %WAS_LOGGING% %CONSOLE_ENCODING% %WAS_DEBUG% "%CLIENTSOAP%" "%JAASSOAP%" "%CLIENTSAS%" "%CLIENTSSL%" %WSADMIN_PROPERTIES_PROP% %WORKSPACE_PROPERTIES% "-Duser.install.root=%USER_INSTALL_ROOT%" "-Dwas.install.root=%WAS_HOME%" %javaoption% com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.admin.services.WsAdmin %*
set RC=%ERRORLEVEL%

@REM Cleanup the temporary java properties file and dir.
del %TMPJAVAPROPFILE%
rmdir %TMPWASDIR%

goto END

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
@REM Need to pass the RC through the endlocal
@endlocal & set MYERRORLEVEL=%RC%

if defined PROFILE_CONFIG_ACTION ( exit %MYERRORLEVEL% ) else exit /b %MYERRORLEVEL%

GOTO :EOF
