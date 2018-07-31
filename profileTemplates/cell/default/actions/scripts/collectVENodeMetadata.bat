@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2005, 2006
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM launches collection of metadata
@REM data is stored in the node config node-metadata.properties file; cell config is updated when available.

@REM echo off

@REM The Ant calling environment is sensitive to the ERRORLEVEL value.  If ERRORVALUE is
@REM already set when this script is invoked, it will not get updated by the JVM.  Therefore
@REM it should be cleared up front so that the calling environment will not interfere with
@REM the ERRORLEVEL value returned by the Java program invocation.  Additionally, this
@REM script should not be bracketed in a setlocal/endlocal block, because the ERRORLEVEL
@REM value will not get returned to the caller.

set ERRORLEVEL=

echo %0 entry
echo WAS_USER_SCRIPT: %WAS_USER_SCRIPT%
echo PARAM 1: %1
echo PARAM 2: %2

REM Set up env:
call "%WAS_USER_SCRIPT%"

set NODE=%WAS_NODE%
if NOT ("%2") == ("") set NODE=%2


@REM win2k has a 2046 command line length (not counting the CRLF).  Max length for WAS_HOME is 60 chars.  Max profile path length is 80.
@REM To conserve command line space you can:
@REM   1. Use the CLASSPATH ENV VAR instead of the -classpath parameter.
@REM   2. Write any Java Properties into a temporary properties file and specify  -Dcmd.properties.file="<your_prop_file>"  on the java command line.
@REM      Note these exceptions:  The user.install.root and was.install.root properties must be passed in on the command line.

@REM Generate a temporary name for the properties file.
:GENFILENAME
set TMPJAVAPROPFILE=%TEMP%\%~n0%RANDOM%.properties
if exist %TMPJAVAPROPFILE% goto GENFILENAME

@REM write one property per line into the temp file. - Format is propname=value
@REM Remember to handle the "\" char in paths, as it must become two "\\" in order for java to handle properly.
>  %TMPJAVAPROPFILE% echo # Temporary Java Properties File for the WAS %~n0 command.
set TMPPROP=%WAS_EXT_DIRS:\=\\%
>> %TMPJAVAPROPFILE% echo ws.ext.dirs=%TMPPROP:"=%
set TMPPROP=%CONFIG_ROOT:\=\\%
>> %TMPJAVAPROPFILE% echo was.repository.root=%TMPPROP:"=%
>> %TMPJAVAPROPFILE% echo com.ibm.ws.management.standalone=true
>> %TMPJAVAPROPFILE% echo local.cell=%WAS_CELL%
>> %TMPJAVAPROPFILE% echo local.node=%NODE%
>> %TMPJAVAPROPFILE% echo com.ibm.CORBA.BootstrapHost=%COMPUTERNAME%

>> %TMPJAVAPROPFILE% echo ConfigService.TestMode=True

set CLASSPATH=%WAS_CLASSPATH%

"%JAVA_HOME%\bin\java" %JAVA_DEBUG% -Dcmd.properties.file="%TMPJAVAPROPFILE%" %CONSOLE_ENCODING% "%CLIENTSOAP%" "%CLIENTSAS%" "-Dtrace=%TRACE%" "-DtraceFile=%TMPPROP%" "-Dserver.root=%WAS_HOME%" "-Dwas.install.root=%WAS_HOME%" "-Duser.install.root=%USER_INSTALL_ROOT%" com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -debug -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.runtime.CollectManagedObjectMetadata

@REM Cleanup the temporary java properties file.
del %TMPJAVAPROPFILE%

if defined PROFILE_CONFIG_ACTION exit %ERRORLEVEL% else exit /b %ERRORLEVEL%
