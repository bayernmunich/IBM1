@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2003, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@echo off
setlocal

set USE_HIGHEST_AVAILABLE_SDK=true
call "%~dp0setupCmdLine.bat"
@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

REM the -jardir directories contain webservices.jar and j2ee.jar. These are
REM used to run wsdl2java and compile the generated files.

SET WAS_CLASSPATH=%WAS_HOME%\plugins\com.ibm.ws.prereq.asm.jar;%WAS_CLASSPATH%
"%JAVA_HOME%\bin\java" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" %OSGI_INSTALL% %OSGI_CFG% %WAS_LOGGING% %CONSOLE_ENCODING% -Dwas.install.root="%WAS_HOME%" -Dws.ext.dirs="%WAS_EXT_DIRS%" %USER_INSTALL_PROP% -Xbootclasspath/p:"%WAS_BOOTCLASSPATH%" -classpath "%WAS_CLASSPATH%;%WAS_HOME%/plugins/com.ibm.ws.prereq.ow.asm.jar" com.ibm.ws.bootstrap.WSLauncher com.ibm.etools.webservice.deploy.core.DeployWebService %* -jardir "%WAS_HOME%\lib" -jardir "%WAS_HOME%\plugins"

endlocal

