@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5655-V64 (C) COPYRIGHT International Business Machines Corp., 2009,2011
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.


@REM bat.full

SET CUR_DIR=%cd%
cd /d "%~dp0.."
SET AGENT_HOME=%cd%
cd /d "%CUR_DIR%"

SET AGENT_HOME_LIB=%AGENT_HOME%\lib
SET AGENT_JAVA_HOME=%AGENT_HOME%\java\jre
SET AGENT_SYSTEM_JAVA_HOME=%JAVA_HOME%
SET AGENT_SYSTEM_PATH=%path%
SET AGENT_SYSTEM_CLASSPATH=%classpath%
SET AGENT_PATH=%AGENT_HOME%\bin;%PATH%
SET PATH=%AGENT_PATH%

SET XDA_LOGGING=-Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager -Djava.util.logging.configureByServer=true
SET XDA_EXT_DIRS=-Djava.ext.dirs=%AGENT_JAVA_HOME%\lib\ext;%AGENT_HOME%\plugins;%AGENT_HOME%\lib;%AGENT_HOME%\runtimes

