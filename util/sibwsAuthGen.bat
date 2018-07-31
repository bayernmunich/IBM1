@REM @start_restricted_prolog@
@REM Version: @(#) 1.2 SIB/ws/code/sib.webservices/windows/all/util/sibwsAuthGen.bat, SIB.webservices.runtime, WAS855.SIB, cf131750.05 05/01/26 07:23:47 [12/17/17 20:15:38]
@REM 
@REM Licensed Materials - Property of IBM
@REM 
@REM "Restricted Materials of IBM"
@REM 
@REM 5724-I63, 5724-H88, 5655-N01, 5733-W60         
@REM 
@REM (C) Copyright IBM Corp. 2004 All Rights Reserved.
@REM 
@REM US Government Users Restricted Rights - Use, duplication or
@REM disclosure restricted by GSA ADP Schedule Contract with
@REM IBM Corp.
@REM @end_restricted_prolog@

@echo off

setlocal

call "%~dp0..\bin\setupCmdLine.bat"

if defined WAS_HOME goto was_home_set
echo WAS_HOME environment variable not set.
echo This is needed to obtain the J2ee.jar file.
goto end

:was_home_set

"%JAVA_HOME%\bin\java" %WAS_TRACE% %DEBUG% %CONSOLE_ENCODING% "-classpath" "%WAS_CLASSPATH%" "-Dws.ext.dirs=%WAS_EXT_DIRS%" %USER_INSTALL_PROP% "-Dwas.install.root=%WAS_HOME%" "-Dibm.websphere.preload.classes=true" "-DWAS_HOME=%WAS_HOME%" "com.ibm.ws.bootstrap.WSLauncher" "com.ibm.ws.sib.webservices.tools.GenAuth" %1 %2
:end
endlocal
