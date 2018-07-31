@setlocal
@echo off

REM "USAGE : runConfigActions.sh"
REM "USAGE : This script runs any config actions that are required in the profile. "

call "%~dp0\setupCmdLine.bat" %*

REM If runConfigActions.disableAlways file exists, just exit RC=0
IF EXIST "%USER_INSTALL_ROOT%"/properties/service/runConfigActions.disableAlways (
	set MYERRORLEVEL=0
	GOTO END
)
REM If runConfigActions.disableAtServerStartup exists AND this script was called by startServer, exit RC=0
REM  This allows the script to be skipped at server startup but run manually. 
IF NOT EXIST "%USER_INSTALL_ROOT%"/properties/service/runConfigActions.disableAtServerStartup (
	GOTO CONTINUE
)

:CHECKSS
IF  "%1" == "-startServer"  (
 		set MYERRORLEVEL=0
		GOTO END
)


:CONTINUE

if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

set CP="%WAS_HOME%"\properties\service\postinstaller\lib\postinstaller_mp.jar;"%WAS_HOME%"\properties\service\postinstaller\lib\com.ibm.ws.runtime.postinstaller.jar

%JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -DWAS_HOME="%WAS_HOME%" -DUSER_INSTALL_ROOT="%USER_INSTALL_ROOT%" -classpath %CP% com.ibm.ws.postinstall.runConfigActions.RunConfigActions  %* 


set MYERRORLEVEL=%ERRORLEVEL%

:END
@endlocal & exit /b %MYERRORLEVEL%
