@echo off

SET CUR_DIR=%cd%
cd /d "%~dp0.."
SET WAS_HOME=%cd%
cd /d "%CUR_DIR%"


CALL "%WAS_HOME%\bin\sdk\_setupSdk.bat"

if "%FFDCLOG%"=="" SET FFDCLOG=%WAS_HOME%/logs/ffdc/
SET DEFAULT_PROFILE_REGISTRY_LOC=%WAS_HOME%\properties\profileRegistry.xml
SET FSDB_PATH=%WAS_HOME%\properties\fsdb
if exist "%DEFAULT_PROFILE_REGISTRY_LOC%" goto NO_JAVA_EXEC
  FOR /F "tokens=*" %%i in ('""%JAVA_HOME:)=^)%\jre\bin\java" -classpath "%WAS_HOME:)=^)%\lib\setup.jar" com.ibm.ws.setup.SetupFsdbPath "%WAS_HOME:)=^)%""') do set FSDB_PATH=%%i
:NO_JAVA_EXEC

SET DEFAULT_PROFILE_SCRIPT=%FSDB_PATH%\_was_profile_default\default.bat
SET ITP_LOC=%WAS_HOME%\deploytool\itp
SET PROFILE_REGISTRY_LOC=%FSDB_PATH%
SET CONFIG_ROOT=%WAS_HOME%\config
REM SET WAS_BOOTCLASSPATH=
SET CLIENT_CONNECTOR_INSTALL_ROOT=%WAS_HOME%\installedConnectors
SET WAS_LOGGING=-Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager -Djava.util.logging.configureByServer=true


SET QUALIFYNAMES=
SET DERBY_HOME=%WAS_HOME%\derby
SET OSGI_INSTALL=-Dosgi.install.area="%WAS_HOME%"
SET OSGI_CFG=-Dosgi.configuration.area="%WAS_HOME%"\configuration

REM To override the values above, create your own batch file to override the values and then 
REM    set the WAS_USER_SCRIPT environment variable to point to your batch file
set WAS_PROFILE_NAME=
set WAS_PROFILE_FSDB_SCRIPT=
set NEXT_IS_PROFILE=

REM This line is replaced by the following subroutine. for %%P in ( %* ) do call :GET_PROFILE_NAME_PARM %%P
:next
if #%0 == # goto end
   call :GET_PROFILE_NAME_PARM %0
   shift
   goto next
:end

REM Init INV_PRF_SPECIFIED, NO_DFT_PRF_EXISTS and WAS_USER_SCRIPT_FILE_NOT_EXISTS variables
SET NO_DFT_PRF_EXISTS=false
SET INV_PRF_SPECIFIED=false
SET WAS_USER_SCRIPT_FILE_NOT_EXISTS=false

if "%WAS_PROFILE_NAME%"=="" goto SET_DEFAULT_WAS_PROFILE_SCRIPT
set WAS_PROFILE_FSDB_SCRIPT=%PROFILE_REGISTRY_LOC%\%WAS_PROFILE_NAME%.bat
if not exist "%WAS_PROFILE_FSDB_SCRIPT%" SET INV_PRF_SPECIFIED=true
goto CALL_WAS_PROFILE_SCRIPT

:SET_DEFAULT_WAS_PROFILE_SCRIPT
if defined WAS_USER_SCRIPT goto CALL_WAS_PROFILE_SCRIPT
set WAS_PROFILE_FSDB_SCRIPT=%DEFAULT_PROFILE_SCRIPT%
if not exist "%WAS_PROFILE_FSDB_SCRIPT%" SET NO_DFT_PRF_EXISTS=true

:CALL_WAS_PROFILE_SCRIPT
if exist "%WAS_PROFILE_FSDB_SCRIPT%" call "%WAS_PROFILE_FSDB_SCRIPT%"

if defined WAS_USER_SCRIPT goto SOURCE_WAS_USER_SCRIPT 
goto NO_SOURCE_WAS_USER_SCRIPT
:SOURCE_WAS_USER_SCRIPT
    if exist "%WAS_USER_SCRIPT%" (
        call "%WAS_USER_SCRIPT%"
    ) else if "%INV_PRF_SPECIFIED%"=="false" (
        SET WAS_USER_SCRIPT_FILE_NOT_EXISTS=true
    )
:NO_SOURCE_WAS_USER_SCRIPT

REM The following declarations are moved here because the value of JAVA_HOME and JAVA_NATIVE_LIB_DIR 
REM are only in their final form after the WAS_USER_SCRIPT is sourced (if it exists)
SET WAS_EXT_DIRS=%JAVA_HOME%\lib;%WAS_HOME%\classes;%WAS_HOME%\lib;%WAS_HOME%\installedChannels;%WAS_HOME%\lib\ext;%WAS_HOME%\web\help;%ITP_LOC%\plugins\com.ibm.etools.ejbdeploy\runtime
SET WAS_CLASSPATH=%WAS_HOME%\properties;%WAS_HOME%\lib\startup.jar;%WAS_HOME%\lib\bootstrap.jar;%JAVA_HOME%\lib\tools.jar;%WAS_HOME%/lib/lmproxy.jar;%WAS_HOME%/lib/urlprotocols.jar
SET WAS_PATH=%JAVA_NATIVE_LIB_DIR%;%WAS_HOME%\bin;%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin;%PATH%
SET WAS_ENDORSED_DIRS=%WAS_HOME%\endorsed_apis;%JAVA_HOME%\jre\lib\endorsed

:DONE

if defined USER_INSTALL_ROOT goto SET_USER_INSTALL_ROOT_IF_IT_EXISTS 
goto NO_SET_USER_INSTALL_ROOT
:SET_USER_INSTALL_ROOT_IF_IT_EXISTS
    if exist "%USER_INSTALL_ROOT%" goto SET_USER_INSTALL_ROOT 
    goto NO_SET_USER_INSTALL_ROOT
    :SET_USER_INSTALL_ROOT
        SET USER_INSTALL_PROP="-Duser.install.root=%USER_INSTALL_ROOT%"
        SET WAS_CLASSPATH=%USER_INSTALL_ROOT%\properties;%WAS_CLASSPATH%
	     SET OSGI_CFG=-Dosgi.configuration.area="%USER_INSTALL_ROOT%"\configuration
:NO_SET_USER_INSTALL_ROOT
goto :EOF

REM subroutine for getting the -profileName parameter
:GET_PROFILE_NAME_PARM
if not "%NEXT_IS_PROFILE%"=="" set WAS_PROFILE_NAME=%1
set NEXT_IS_PROFILE=
if -profileName==%1 set NEXT_IS_PROFILE=true
