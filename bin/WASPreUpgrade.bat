@echo off
setlocal

CALL "%~dp0setupCmdLine.bat" %*

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

@REM win2k has a 2046 command line length (not counting the CRLF).  Max length for WAS_HOME is 60 chars.  Max profile path length is 80. 
@REM To conserve command line space you can:
@REM   1. Use the CLASSPATH ENV VAR instead of the -classpath parameter.
@REM   2. Write any Java Properties into a temporary properties file and specify  -Dcmd.properties.file="<your_prop_file>"  on the java command line.
@REM      Note these exceptions:  The user.install.root and was.install.root properties must be passed in on the command line.

set CMD_NAME=%~nx0
set CMD_NAME_ONLY=%~n0
goto loop

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
set CLASSPATH=%WAS_CLASSPATH%
set PERFJAVAOPTION=-Xms256m -Xmx512m -Xj9 -Xquickstart
@echo off

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
set TMPPROP=%WAS_HOME:\=\\%
>> %TMPJAVAPROPFILE% echo com.ibm.websphere.migration.serverRoot=%TMPPROP:"=%

"%JAVA_HOME%\bin\java" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -Dcmd.properties.file=%TMPJAVAPROPFILE% %PERFJAVAOPTION% %WAS_LOGGING% %javaoption% %CONSOLE_ENCODING% "-Dwas.install.root=%WAS_HOME%" "-Duser.install.root=%WAS_HOME%" com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -clean -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.migration.WASPreUpgrade  %*
set RC=%ERRORLEVEL%

@REM Cleanup the temporary java properties file and dir.
del %TMPJAVAPROPFILE%
rmdir %TMPWASDIR%

@REM Need to pass the RC through the endlocal
endlocal & exit /b %RC%

GOTO :EOF
