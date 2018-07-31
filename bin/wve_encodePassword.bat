@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5630-A36 (C) COPYRIGHT International Business Machines Corp., 1997,2012
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM WVE util to encode passwords

@echo off
REM Usage: PasswordEncoder pwdtoEncode
setlocal

call "%~dp0setupCmdLine.bat"

set MYCLASSPATH="%WAS_HOME%"\plugins\com.ibm.ws.runtime.jar;"%WAS_HOME%"\lib\bootstrap.jar;"%WAS_HOME%"\plugins\com.ibm.ws.emf.jar;"%WAS_HOME%"\lib\ffdc.jar;"%WAS_HOME%"\plugins\org.eclipse.emf.ecore.jar;"%WAS_HOME%"\plugins\org.eclipse.emf.common.jar

"%JAVA_HOME%\bin\java" -cp %MYCLASSPATH% com.ibm.ws.security.util.PasswordEncoder %1

endlocal

