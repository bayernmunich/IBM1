@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5630-A36 (C) COPYRIGHT International Business Machines Corp., 2014
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM PMI-SNMP util to encrypt securityAttributes
@REM Usage: SNMP_EncryptSecurityAttributes.bat <Dmgr's agentConfig.xml absolute path>

@echo off
setlocal

call "%~dp0setupCmdLine.bat"


if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

set MYCLASSPATH="%WAS_HOME%"\optionalLibraries\IBM\SNMPAgent\com.ibm.ws.pmi.snmpagent.jar;"%WAS_HOME%"\plugins\com.ibm.ws.prereq.snmp.jar

if '%1'=='' (
  echo Usage: SNMP_EncryptSecurityAttributes.bat ^<Dmgr's agentConfig.xml absolute path^>
  exit /b
)

"%JAVA_EXE%" -cp %MYCLASSPATH% com.ibm.ws.pmi.snmp.util.EncyptionAtDmgrUtil %1

endlocal

