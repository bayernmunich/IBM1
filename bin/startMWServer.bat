@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5655-V64 (C) COPYRIGHT International Business Machines Corp., 2009,2011
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@setlocal
@echo off

call "%~dp0mwSetupCmdLine.bat"

"%AGENT_JAVA_HOME%\bin\java" %XDA_LOGGING% "%XDA_EXT_DIRS%" "-Dagent.home=%AGENT_HOME%" com.ibm.ws.xd.agent.process.ManageServerProcess %* -action start

@endlocal
