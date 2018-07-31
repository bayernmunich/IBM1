@setlocal
@echo off

SET CUR_DIR=%cd%
cd /d "%~dp0.."
SET WAS_HOME=%cd%
cd /d "%CUR_DIR%"

if [%1] == [] (
  GOTO USAGE
  )

REM If %2 is -SUN_JRE_HOME then use that JRE and don't call setupPostinstall.bat 
if %2 == -SUN_JRE_HOME  (
	GOTO SETJAVAEXE
) ELSE (
	GOTO SETUPPOSTINSTALL
)

:SETJAVAEXE
SET JAVA_EXE_TMP=%3
for /f "useback tokens=*" %%a in ('%JAVA_EXE_TMP%') do set JAVA_EXE_TMP=%%~a
IF %JAVA_EXE_TMP:~-1%==\ SET JAVA_EXE_TMP=%JAVA_EXE_TMP:~0,-1%
SET JAVA_EXE="%JAVA_EXE_TMP%\bin\java"

GOTO SETCP


:SETUPPOSTINSTALL
call "%WAS_HOME%\properties\service\postinstaller\bin\setupPostinstall.bat"  "%WAS_HOME%"

if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

:SETCP
set CP="%WAS_HOME%"\properties\service\postinstaller\lib\postinstaller_mp.jar;"%WAS_HOME%"\properties\service\postinstaller\lib\com.ibm.ws.runtime.postinstaller.jar

 %JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -DWAS_HOME="%WAS_HOME%" -DUSER_INSTALL_ROOT="%USER_INSTALL_ROOT%" -classpath %CP% com.ibm.ws.postinstall.LaunchUnifiedPostInstaller  %* 
set RC=%ERRORLEVEL%

if %RC% GTR 2 GOTO LOGERROR
if %RC% LSS 0 GOTO LOGERROR
if %RC% EQU 1 GOTO USAGE
GOTO END

:LOGERROR


SET POSTINSTALL_LOG=%WAS_HOME%\logs\postinstall\postinstalldefault.log

:loop1

if [%1] == [] GOTO ECHOERROR
SET CURRENT_VAR1=%1
for /f "useback tokens=*" %%a in ('%CURRENT_VAR1%') do set CURRENT_VAR1=%%~a
if ["%CURRENT_VAR1%"] == ["-POSTINSTALL_LOG_FILE"] GOTO SET1 
shift
goto loop1
:endLoop1

:SET1
 SET POSTINSTALL_LOG=%2
 for /f "useback tokens=*" %%a in ('%POSTINSTALL_LOG%') do set POSTINSTALL_LOG=%%~a

:ECHOERROR
 echo.  >> "%POSTINSTALL_LOG%" 
 echo ^<log^> >> "%POSTINSTALL_LOG%"
 echo ^<record^> >> "%POSTINSTALL_LOG%"
 echo.   ^<date^>%DATE% %TIME%^</date^> >> "%POSTINSTALL_LOG%"
 echo.   ^<level^>SEVERE^</level^> >> "%POSTINSTALL_LOG%"
 echo.   ^<message^>postinstall.bat return code is %RC%. See the most current Installation Manager application data log in ^<IM appdata^>/logs/native for more information.^</message^> >> "%POSTINSTALL_LOG%"
 echo ^</record^> >> "%POSTINSTALL_LOG%"
 echo ^</log^> >> "%POSTINSTALL_LOG%"
 goto end

:USAGE
 echo postinstall.bat return code is 1.
 echo Check the usage and the ^<POSTINSTALL_LOG_FILE^> specified in the parameters for more information.
 echo Usage: postinstall.bat ^<WAS_HOME^> -WS_CMT_CONF_DIR ^<WS_CMT_CONF_DIR^> -MASTER_ACTION_REGISTRY ^<MASTER_ACTION_REGISTRY^> -SUB_ACTION_REGISTRY ^<CACHE_ACTION_REGISTRY^> -WS_PI_ACTION_REGISTRY_EXTENSION ^<REGISTRY_EXTENSION^> -WS_CMT_LOG_HOME ^<WS_CMT_LOG_HOME^> -POSTINSTALL_LOG_FILE ^<POSTINSTALL_LOG_FILE^>


:END 
@endlocal & exit /b %RC%

