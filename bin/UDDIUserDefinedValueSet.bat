@REM @start_source_copyright@
@REM Licensed Materials - Property of IBM                              
@REM                                                                   
@REM 55724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70                                                           
@REM                                                                   
@REM (C) COPYRIGHT IBM Corp., 2004, 2010 All Rights Reserved     
@REM                                                                   
@REM US Government Users Restricted Rights - Use, duplication or       
@REM disclosure restricted by GSA ADP Schedule Contract with IBM Corp. 
@REM @end_source_copyright@

@REM UDDI User Defined Value Set Utility

@setlocal
@echo off

@REM Bootstrap values ...
call "%~dp0setupCmdLine.bat" %*

set CMD_NAME=%~nx0
set CMD_NAME_ONLY=%~n0

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

SET PATH=%WAS_PATH%

@REM For debugging the utility itself
@REM set WAS_DEBUG=-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777

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
>> %TMPJAVAPROPFILE% echo java.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager
>> %TMPJAVAPROPFILE% echo java.util.logging.configureByServer=true

set CLASSPATH=%WAS_CLASSPATH%

"%JAVA_HOME%\bin\java" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -Dcmd.properties.file=%TMPJAVAPROPFILE% %WAS_DEBUG% %WAS_TRACE% %CONSOLE_ENCODING% "%CLIENTSOAP%" "%CLIENTSAS%" "%CLIENTSSL%" %USER_INSTALL_PROP% "-Dwas.install.root=%WAS_HOME%" com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash  -application com.ibm.ws.bootstrap.WSLauncher com.ibm.uddi.UDDIValueSet %*
set RC=%ERRORLEVEL%

@REM Cleanup the temporary java properties file and dir.
del %TMPJAVAPROPFILE%
rmdir %TMPWASDIR%

@REM Need to pass the RC through the endlocal
@endlocal & exit /b %RC%
