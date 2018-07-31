@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-I63, 5724-H88, 5655-N01, 5733-W61 (C) COPYRIGHT International Business Machines Corp., 1997,2006
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.
@REM
@REM  DESCRIPTION:
@REM  Script file used to change the SDK used by this product, specific profiles and application servers.
@REM  ##########################################################################
@setlocal
@echo off

@REM Bootstrap values ...
CALL "%~dp0setupCmdLine.bat" %* 

if exist "%JAVA_HOME%\bin\java.exe" (
  set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
  set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

set PATH=%WAS_PATH%


if "%CLIENTIPC%" == "" (
@REM No profiles exist
  %JAVA_EXE% -Xms128M -Xmx128M -Xquickstart "-Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager" "-Djava.util.logging.configureByServer=true" "-DtraceSettingsFile=%WAS_HOME%\properties\sdk\SdkTraceSettings.properties" "-DWAS_HOME=%WAS_HOME%" "-Duser.install.root=%USER_INSTALL_ROOT%" "-Dwas.install.root=%WAS_HOME%" "-DKeepProfileName=true" "-Dcom.ibm.ws.sdk.whoCalledMe=managesdk.bat" -classpath "%WAS_CLASSPATH%" com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application  com.ibm.ws.bootstrap.WSLauncher  com.ibm.ws.runtime.ManageSDK %*
) else (
@REM At least one profile exists
  %JAVA_EXE% -Xms128M -Xmx128M -Xquickstart "%CLIENTIPC%" "%CLIENTSOAP%" "%JAASSOAP%" "%CLIENTSAS%" "%CLIENTSSL%" "-Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager" "-Djava.util.logging.configureByServer=true" "-DtraceSettingsFile=%WAS_HOME%\properties\sdk\SdkTraceSettings.properties" "-DWAS_HOME=%WAS_HOME%" "-Duser.install.root=%USER_INSTALL_ROOT%" "-Dwas.install.root=%WAS_HOME%" "-DKeepProfileName=true" "-Dcom.ibm.ws.sdk.whoCalledMe=managesdk.bat" -classpath "%WAS_CLASSPATH%" com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -application  com.ibm.ws.bootstrap.WSLauncher  com.ibm.ws.runtime.ManageSDK %*
)

set PATH=%PATH_ORIG%

set RC=%ERRORLEVEL%                   

@REM Need to pass the RC through the endlocal
@endlocal & exit /b %RC%

GOTO :EOF
