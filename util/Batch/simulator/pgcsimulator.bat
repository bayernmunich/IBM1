@echo off
set CUR_DIR=%~dp0
set XJCL=%1
set OPTARG=%2

if NOT exist %XJCL% (
	echo Specified xJCL file [%XJCL%] does not exist
	exit /b 8
)

set application.classpath=
set simulator.home=

for /f "delims=" %%A in (%CUR_DIR%\\pgcsimulator.properties) do set %%A

set APP_CLASSPATH=%application.classpath%
set SIMULATOR_HOME=%simulator.home%

set SIMULATOR_CLASSPATH=%CUR_DIR%\\pgcruntime.jar;%CUR_DIR%\\pgccommon.jar;%CUR_DIR%\\pgcstandalone.jar;..\\..\\lib\\batfepapi.jar

java -cp %SIMULATOR_CLASSPATH%;%APP_CLASSPATH% -Dsimulator.home=%SIMULATOR_HOME% com.ibm.ws.gridcontainer.standalone.PGCSimulator %XJCL% %OPTARG%