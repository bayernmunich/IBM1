@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J34 (C) COPYRIGHT International Business Machines Corp., 2005
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM Highly Available Deployment Manager Removal Utility

@REM Arguments:
@REM
@REM -hostname <primary_dmgr_host>
@REM [-port <primary_dmgr_port>]
@REM [-user <uid>] [-password <pwd>] 
@REM [-quiet] 
@REM [-logfile <filename>] [-replacelog]
@REM [-trace] [-help]

@setlocal
@echo off

@REM Bootstrap values ...
call "%~dp0setupCmdLine.bat" %*

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

SET PATH=%WAS_PATH%

@REM For debugging the utility itself
@REM set WAS_DEBUG=-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777

if "%JAASSOAP%"=="" set JAASSOAP=-Djaassoap=off

"%JAVA_HOME%\bin\java" %WAS_DEBUG% %WAS_TRACE% %CONSOLE_ENCODING% "%CLIENTSOAP%" "%JAASSOAP%" "%CLIENTSAS%" "%CLIENTSSL%" "-classpath" "%WAS_CLASSPATH%" "-Dws.ext.dirs=%WAS_EXT_DIRS%" "-Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager" "-Djava.util.logging.configureByServer=true" %USER_INSTALL_PROP% "-Dwas.install.root=%WAS_HOME%" "-DWAS_HOME=%WAS_HOME%" "com.ibm.ws.bootstrap.WSLauncher" "com.ibm.ws.xd.admin.hadmgr.config.HadmgrRemoveUtility" "%CONFIG_ROOT%" "%WAS_CELL%" "%WAS_NODE%" %*

@endlocal
set MYERRORLEVEL=%ERRORLEVEL%
if defined PROFILE_CONFIG_ACTION exit %MYERRORLEVEL% else exit /b %MYERRORLEVEL%
