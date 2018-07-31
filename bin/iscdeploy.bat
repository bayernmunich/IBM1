@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@setlocal
@echo off

@REM Bootstrap values ...

CALL "%~dp0setupCmdLine.bat" %* 

set CMD_NAME=%~nx0
set CMD_NAME_ONLY=%~n0

if ("%USER_INSTALL_ROOT%") == ("") set USER_INSTALL_ROOT=%WAS_HOME%

if ("%WAS_PLPR_ROOT%") == ("") set WAS_PLPR_ROOT=%WAS_HOME%\systemApps

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
set TMPPROP=%WAS_PLPR_ROOT:\=\\%
>> %TMPJAVAPROPFILE% echo pluginprocessor.root=%TMPPROP:"=%
>> %TMPJAVAPROPFILE% echo local.cell=%WAS_CELL%
>> %TMPJAVAPROPFILE% echo local.node=%WAS_NODE%
>> %TMPJAVAPROPFILE% echo com.ibm.ws.management.standalone=true

SET WAS_CLASSPATH=%WAS_HOME%\plugins\com.ibm.ws.prereq.asm.jar;%WAS_CLASSPATH%
set CLASSPATH=%WAS_CLASSPATH%

"%JAVA_HOME%\bin\java" -Xquickstart -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" "-Djavax.xml.transform.TransformerFactory=org.apache.xalan.processor.TransformerFactoryImpl" -Dcmd.properties.file=%TMPJAVAPROPFILE% %WAS_LOGGING%  "-Duser.install.root=%USER_INSTALL_ROOT%" "-Dwas.install.root=%WAS_HOME%" %ISC_DEBUG% "-Xbootclasspath/p:%WAS_BOOTCLASSPATH%" "com.ibm.ws.bootstrap.WSLauncher" "com.ibm.ws.console.plugin.PluginProcessor" %*
set RC=%ERRORLEVEL%

@REM Cleanup the temporary java properties file and dir.
del %TMPJAVAPROPFILE%
rmdir %TMPWASDIR%

@REM Need to pass the RC through the endlocal
if defined INSTALL_CONFIG_ACTION ( exit %RC% ) else exit /b %RC%
GOTO :EOF

