@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5630-A36 (C) COPYRIGHT International Business Machines Corp., 1997,2003
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM XD core group bridge cross cell config

@echo off
REM Usage: crossCellCGBCfg arguments
setlocal

call "%~dp0setupCmdLine.bat"

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

@REM For debugging the utility itself
@REM set DEBUG=-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777

if NOT %USER_INSTALL_ROOT%.==. goto loop
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
"%JAVA_HOME%\bin\java" %javaoption% %CONSOLE_ENCODING% %DEBUG% "%CLIENTSOAP%" "%CLIENTSSL%" "%CLIENTSAS%" "-Dcom.ibm.ws.scripting.wsadminprops=%WSADMIN_PROPERTIES%" -Dcom.ibm.ws.management.standalone=true "-Duser.install.root=%USER_INSTALL_ROOT%" "-Dwas.install.root=%WAS_HOME%" "-Dwas.repository.root=%CONFIG_ROOT%" "-Dserver.root=%WAS_HOME%" "-Dlocal.cell=%WAS_CELL%" "-Dlocal.node=%WAS_NODE%" "-Dcom.ibm.itp.location=%WAS_HOME%\bin" "-classpath" "%WAS_CLASSPATH%;%WAS_HOME%\lib\jython.jar"  "-Dws.ext.dirs=%WAS_EXT_DIRS%" com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.xd.config.ha.coregroupbridge.monitor.CGBCrossCellCfg %*

endlocal


