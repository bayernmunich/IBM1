@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM Configuration Instance Creation Tool Launcher

@setlocal
@echo off

IF NOT "%~1%" == "" GOTO CHECK_WAS_HOME
GOTO USAGE


:CHECK_WAS_HOME
if not exist %1 ( echo Invalid installation root.... ) & goto :USAGE
set WAS_HOME=%1%
SET WAS_HOME_TMP=%WAS_HOME%
for /f "useback tokens=*" %%a in ('%WAS_HOME_TMP%') do set WAS_HOME_TMP=%%~a
call "%WAS_HOME_TMP%\bin\setupCmdLine.bat" %*
GOTO CHECK_LOG_HOME_EXISTS


:CHECK_LOG_HOME_EXISTS
IF NOT "%~2%" == "" GOTO CHECK_LOG_HOME
GOTO USAGE


:CHECK_LOG_HOME
if not exist %2 ( echo Invalid log file home ) & goto :USAGE
set LOG_HOME=%2%
:: remove quotes if they exist
for /f "useback tokens=*" %%a in ('%LOG_HOME%') do set LOG_HOME=%%~a
:: remove trailing slash if it exists
if "%LOG_HOME:~-1%"=="\" set LOG_HOME=%LOG_HOME:~0,-1%
GOTO CHECK_LOG_NAME_EXISTS


:CHECK_LOG_NAME_EXISTS
IF NOT "%~3" == "" GOTO SET_LOG_NAME
GOTO USAGE

	
:SET_LOG_NAME
set LOG_NAME=%3%
for /f "useback tokens=*" %%a in ('%LOG_NAME%') do set LOG_NAME=%%~a
GOTO CHECK_ACTION_REPOSITORY


:CHECK_ACTION_REPOSITORY
IF NOT "%~4%" == "-WS_CMT_CONF_DIR" GOTO USAGE
IF "%~5%" == ""  GOTO USAGE
IF NOT EXIST %5 ( echo Warning: Configure action directory does not exist on the file system. ) & exit /b 0
IF NOT "%~f5" == "%~dpn5" ( echo Warning: Configure action directory does not exist on the file system. ) & exit /b 0
GOTO SET_ACTION_REPOSITORY


:SET_ACTION_REPOSITORY
set REPOSITORYNAME=%5%
for /f "useback tokens=*" %%a in ('%REPOSITORYNAME%') do set REPOSITORYNAME=%%~a
if "%REPOSITORYNAME:~-1%"=="\" set REPOSITORYNAME=%REPOSITORYNAME:~0,-1%
set ACTION_REPOSITORY=%REPOSITORYNAME%

::Elimnate any trailing slashes from the extra parameters
set EXTRA_PARAMS=%*
set EXTRA_PARAMS=%EXTRA_PARAMS:\"="%
GOTO EXECUTE_CFGMGR_NO_REGISTRY


:USAGE
echo.
echo USAGE:
echo configManager.bat ^<appServerRoot^> ^<logFileLocation^> ^<logFileName^> -WS_CMT_CONF_DIR ^<actionRepository^> [-WS_CMT_ACTION_REGISTRY ^<actionRegistry^>]
echo.
echo eg. configManagerLauncher.bat ^\opt^\IBM^\WebSphere^\AppServer ^\mydir^\logs mylog.log -WS_CMT_CONF_DIR ^\opt^\IBM^\WebSphere^\myActionRepository
echo.
GOTO :EOF


:EXECUTE_CFGMGR_NO_REGISTRY

@REM Bootstrap values ...

set PATH=%WAS_PATH%
set CONFIG_MANAGER_CLASSPATH="%WAS_HOME%\plugins\com.ibm.ws.runtime.jar;%WAS_HOME%\plugins\com.ibm.ws.runtime.dist.jar"
"%JAVA_HOME%\bin\java" "-DWAS_HOME=%WAS_HOME%" "-Dwas.install.root=%WAS_HOME%" "-DWS_CMT_LOG_HOME=%LOG_HOME%" "-DWS_CMT_LOG_NAME=%LOG_NAME%" "-DWS_CMT_CONF_DIR=%ACTION_REPOSITORY%" -classpath %CONFIG_MANAGER_CLASSPATH% com.ibm.ws.install.configmanager.launcher.Launcher %EXTRA_PARAMS%
set PATH=%PATH_ORIG%
set RC=%ERRORLEVEL%
@endlocal & exit /b %RC%
