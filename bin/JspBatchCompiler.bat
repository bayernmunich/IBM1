@REM Copyright IBM Corp. 2001, 2010
@REM Configuration Based Server Launcher

@REM Launch Arguments:
@REM
@REM cellName
@REM nodeName
@REM serverName

@setlocal
@echo off

@REM Bootstrap values ...

CALL "%~dp0setupCmdLine.bat" %*

@REM The following is added through defect 236497.1
if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

set CMD_NAME=%~nx0
set CMD_NAME_ONLY=%~n0

set PROFILE_ERROR=0
call :CHECK_INVALID_PROFILE_SPECIFIED
if "%PROFILE_ERROR%"=="1" goto :END

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

@REM Debugging defaults ...

SET DEFAULT_OLT_HOST=localhost
SET DEFAULT_OLT_PORT=2102
SET DEFAULT_JDWP_PORT=7777

@REM Setup the initial java invocation;

SET PATH=%WAS_PATH%
chdir "%WAS_HOME%\bin"
rem set DEBUG=-Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,address=7777

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
>> %TMPJAVAPROPFILE% echo java.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager
>> %TMPJAVAPROPFILE% echo java.util.logging.configureByServer=true

set CLASSPATH=%WAS_CLASSPATH%

@REM PM00031
set NOZIPFILECACHE=-Dcom.ibm.ws.classloader.zipFileCacheSize=0


call:getNumberOfCmdLineArgs %*

setlocal ENABLEDELAYEDEXPANSION

set _ARGCOUNT=0
set _SERVERNAMEFOUND=false
set _SERVERNAMEVALUE=
if %_NUMARGS% gtr 0 (
    for %%E in (%*) do (
        set /A _ARGCOUNT+=1
        if !_SERVERNAMEFOUND! equ yes (
            set _SERVERNAMEVALUE=%%E
            goto :EXITFORLOOP
        ) else (
            if %%E equ -server.name (
                set _SERVERNAMEFOUND=yes
            )
        )
    )
)
:EXITFORLOOP

if "%_SERVERNAMEVALUE%"=="" (
    set OSGI_CFG=
) else (
    set _SERVER_CFG_AREA="%USER_INSTALL_ROOT:"=%\servers\%_SERVERNAMEVALUE%\configuration"
    set OSGI_CFG=-Dosgi.configuration.area=!_SERVER_CFG_AREA!
)

"%JAVA_HOME%\bin\java" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -Dcmd.properties.file=%TMPJAVAPROPFILE% %WAS_TRACE% %NOZIPFILECACHE% %WAS_DEBUG% %CONSOLE_ENCODING% "%CLIENTSAS%" %USER_INSTALL_PROP%  %OSGI_CFG% "-Dwas.install.root=%WAS_HOME%" -Xms64m -Xmx256m com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash  -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.runtime.LaunchBatchCompiler "-config.root.hidden" "%CONFIG_ROOT%" "-cell.name.hidden" "%WAS_CELL%" "-node.name.hidden" "%WAS_NODE%" %*
set RC=%ERRORLEVEL%

@REM Cleanup the temporary java properties file and dir.
del %TMPJAVAPROPFILE%
rmdir %TMPWASDIR%

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
@REM Need to pass the RC through the endlocal
@endlocal & exit /b %RC%


GOTO :EOF
:getNumberOfCmdLineArgs
   set _NUMARGS=0
   for %%x in (%*) do Set /A _NUMARGS+=1
goto :EOF
