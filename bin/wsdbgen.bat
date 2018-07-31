@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2008, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@echo off
setlocal

@rem WsJpaDBGen launcher

SET CLASS_NAME=com.ibm.websphere.persistence.pdq.WsJpaDBGen

CALL "%~dp0setupCmdLine.bat" %*

REM echo %WAS_HOME%

SET PROVIDER_CLASSPATH=%WAS_HOME%\dev\JavaEE\j2ee.jar;%WAS_HOME%\plugins\com.ibm.ws.jpa.jar;%WAS_HOME%\plugins\com.ibm.ws.prereq.commons-collections.jar
SET PROVIDER_CLASSPATH=%PROVIDER_CLASSPATH%;%WAS_HOME%\plugins\com.ibm.ws.prereq.asm.jar

SET TOOL_CLASSPATH=%PROVIDER_CLASSPATH%;%CLASSPATH%

IF "%1" == "-help" goto :NO_ENHANCE

SET VM_ARGS1=%VM_ARGS% -javaagent:"%WAS_HOME%"\plugins\com.ibm.ws.jpa.jar
GOTO :GEN

:NO_ENHANCE
SET VM_ARGS1=%VM_ARGS%

:GEN
"%JAVA_HOME%\bin\java" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" %VM_ARGS1% -classpath "%TOOL_CLASSPATH%" "%CLASS_NAME%" %*

endlocal
