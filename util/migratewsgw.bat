@REM @start_restricted_prolog@
@REM Version: @(#) 1.4 SIB/ws/code/sib.webservices.wsgw/windows/all/util/migratewsgw.bat, SIB.webservices.wsgw, WAS855.SIB, cf131750.05 06/03/03 02:37:55 [12/17/17 20:15:38]
@REM 
@REM Licensed Materials - Property of IBM
@REM 
@REM "Restricted Materials of IBM"
@REM 
@REM 5724-I63, 5724-H88, 5655-N02, 5733-W70
@REM 
@REM (C) Copyright IBM Corp. 2004, 2006 All Rights Reserved.
@REM 
@REM US Government Users Restricted Rights - Use, duplication or
@REM disclosure restricted by GSA ADP Schedule Contract with
@REM IBM Corp.
@REM @end_restricted_prolog@

@echo off
setlocal

call "%~dp0..\bin\setupCmdLine.bat"

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

@REM For debugging the utility itself
@REM set DEBUG=-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777

if NOT "%USER_INSTALL_ROOT%".==. goto loop
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
"%JAVA_HOME%\bin\java" %javaoption% %CONSOLE_ENCODING% %DEBUG% "%CLIENTSOAP%" "%CLIENTSAS%" %WAS_LOGGING% "-Dcom.ibm.ws.scripting.wsadminprops=%WSADMIN_PROPERTIES%" -Dcom.ibm.ws.management.standalone=true "-Duser.install.root=%USER_INSTALL_ROOT%" "-Dwas.install.root=%WAS_HOME%" "-Dwas.repository.root=%CONFIG_ROOT%" "-Dserver.root=%WAS_HOME%" "-Dlocal.cell=%WAS_CELL%" "-Dlocal.node=%WAS_NODE%" "-Dcom.ibm.SSL.ConfigURL=file:%USER_INSTALL_ROOT%\properties\ssl.client.props" "-Dcom.ibm.itp.location=%WAS_HOME%\bin" "-classpath" "%WAS_CLASSPATH%;%WAS_HOME%\optionalLibraries\jython.jar"  "-Dws.ext.dirs=%WAS_EXT_DIRS%" com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.sib.webservices.wsgw.Migrate %*

endlocal
