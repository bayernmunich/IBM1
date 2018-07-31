@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 2004, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@setlocal
@echo off

call "%~dp0setupCmdLine.bat" %*

"%JAVA_HOME%\bin\java" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" %WAS_LOGGING% "-classpath" "%WAS_CLASSPATH%" "-Dws.ext.dirs=%WAS_EXT_DIRS%" "-Dwas.install.root=%WAS_HOME%" "com.ibm.ws.bootstrap.WSLauncher" "com.ibm.ws.sib.msgstore.persistence.DDLGenerator" %*

@endlocal
