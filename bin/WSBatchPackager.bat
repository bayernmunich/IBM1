@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5630-A36 (C) COPYRIGHT International Business Machines Corp., 1997,2003
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM launcher

@echo off

setlocal

call "%~dp0/../bin/setupCmdLine.bat" %*

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

@REM For debugging the utility itself
@REM set WAS_DEBUG=-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777

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
set CLASSPATH=%WAS_CLASSPATH%;%WAS_HOME%\plugins\com.ibm.ws.batch.runtime.jar

set PERFJAVAOPTION=-Xms256m -Xmx256m -Xj9 -Xquickstart
@echo off

"%JAVA_HOME%\bin\java" %PERFJAVAOPTION% %WAS_LOGGING% %javaoption% %CONSOLE_ENCODING% %WAS_DEBUG% "%CLIENTSOAP%" "%CLIENTSAS%" "%CLIENTSSL%" -Dcom.ibm.ws.management.standalone=true "-Duser.install.root=%USER_INSTALL_ROOT%" "-Dwas.install.root=%WAS_HOME%" "-Dcom.ibm.itp.location=%WAS_HOME%\bin" "-Dws.ext.dirs=%WAS_EXT_DIRS%" "-classpath" "%CLASSPATH%" com.ibm.ws.batch.packager.WSBatchPackager %*

endlocal


