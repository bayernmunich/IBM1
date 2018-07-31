@echo off
REM @(#)78 1.9 src/pdwas/com/tivoli/pdwas/migrate/migrateEAR.bat, amemb.jacc.was, amemb610, 090612a 09/06/11 21:59:32 @(#)
REM
REM Licensed Materials - Property of IBM
REM 5724-C0814
REM (c) Copyright International Business Machines Corp. 2001
REM All Rights Reserved
REM US Government Users Restricted Rights - Use, duplication or disclosure
REM restricted by GSA ADP Schedule Contract with IBM Corp.

call "%~dp0setupCmdLine.bat"

REM set PDWAS_HOME=%WAS_HOME%
REM set J2EE_JAR=%WAS_HOME%\lib\j2ee.jar
REM set XML_PARSER_JAR=%WAS_HOME%\lib\xerces.jar
REM set PDWAS_JAR=%WAS_HOME%\lib\migrate.jar
REM set DDPARSER_JAR=%WAS_HOME%\lib\DDParser5.jar
REM set RBPF_JAR=%WAS_HOME%\lib\rbpf.jar
REM set ADMIN_JAR=%WAS_HOME%\lib\admin.jar
REM set WSEXC_JAR=%WAS_HOME%\lib\wsexception.jar
REM set CLASSPATH="%XML_PARSER_JAR%;%PDWAS_JAR%;%J2EE_JAR%;%RBPF_JAR%;%DDPARSER_JAR%;%ADMIN_JAR%;%WSEXC_JAR%"
set CLASSPATH="%WAS_HOME%\plugins\com.ibm.ws.runtime.jar;%WAS_HOME%\plugins\com.ibm.ws.admin.core.jar;%WAS_HOME%\plugins\com.tivoli.pd.amwas.core_6.1.0.jar"

set JAVA_CMD=%JAVA_HOME%\jre\bin\java

set CMD="%JAVA_CMD%" -Dpdwas.home="%WAS_HOME%" -Dwas.home="%WAS_HOME%" -cp %CLASSPATH% com.tivoli.pdwas.migrate.Migrate 

:LOOP
if '%1'=='' goto COMMAND
set CMD=%CMD% %1
shift
goto LOOP


REM
REM Process Java Command
REM
:COMMAND

%CMD%


REM we could check the errorlevel states here if required.

goto END

:END
