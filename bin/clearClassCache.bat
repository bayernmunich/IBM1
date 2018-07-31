@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997, 2012
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM Clear the shared class cache
@echo off
REM Usage: clearClassCache
setlocal
CALL "%~dp0setupCmdLine.bat" %* 

if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
   @REM echo using %JAVA_HOME%\bin\java to invoke JVMPathCalculator
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
   @REM echo using %JAVA_HOME%\jre\bin\java to invoke JVMPathCalculator
)

set CLASSPATH=%WAS_CLASSPATH%

@REM Default usage is quiet with log
set OUTSTREAM="NUL"
set LOGDIR="%WAS_HOME:"=%\logs\clearClassCache"
for /f %%x in ('wmic os get LocalDateTime ^| findstr ^[0-9]') do (set ts=%%x)
set TIMESTAMP=%ts:~0,14%
if not exist %LOGDIR% ( mkdir %LOGDIR% )
if exist %LOGDIR% ( 
   set OUTSTREAM="%LOGDIR:"=%\%TIMESTAMP: =%.log"
) else (
   echo The "%WAS_HOME:"=%\logs" directory must be writable to log results.
)

set TMPDIR="%WAS_HOME:"=%\temp\clearClassCache"
if exist %TMPDIR% goto GET_SDK_INFO
mkdir %TMPDIR%
if not exist %TMPDIR% ( echo The "%WAS_HOME:"=%\temp" directory must be writable to clear the class cache. ) & goto :EOF

:GET_SDK_INFO
set SDK_INFO_FILE=%TMPDIR%\SDK_INFO
cmd /c "%JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" %USER_INSTALL_PROP% -Dwas.install.root="%WAS_HOME%" "com.ibm.wsspi.bootstrap.WSPreLauncher" -nosplash -application "com.ibm.ws.bootstrap.WSLauncher" "com.ibm.ws.debug.osgi.JVMPathCalculator"" 2>&1 > %SDK_INFO_FILE%
set /p HI_JAVA=<%SDK_INFO_FILE%

if not exist "%HI_JAVA%" (
   @REM If HI_JAVA is not a directory, the value will either indicate a JvmPathCalculator 
   @REM launch error or contain the string JVMPATHCALCULATOR_ERROR
   @REM echo clearing shared class cache using non-calculated SDK path because the SDK path is undetermined: "%HI_JAVA%"
   %JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -Xshareclasses:destroyAll 2>%OUTSTREAM% 
) else (
   if exist "%HI_JAVA%\bin\java.exe" (
      @REM echo clearing shared class cache using calculated SDK path
      "%HI_JAVA%\bin\java" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -Xshareclasses:destroyAll 2>%OUTSTREAM% 
   ) else (
      if exist "%HI_JAVA%\jre\bin\java" (
         @REM echo clearing shared class cache using calculated SDK path
         "%HI_JAVA%\jre\bin\java" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -Xshareclasses:destroyAll 2>%OUTSTREAM% 
      ) else (
         @REM echo clearing shared class cache using non-calculated SDK path because the SDK path did not resolve to an expected location: "%HI_JAVA%"
         %JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -Xshareclasses:destroyAll 2>%OUTSTREAM% 
      )
   )
)

if exist %TMPDIR% rmdir /s /q %TMPDIR%

endlocal

set MYERRORLEVEL=%ERRORLEVEL%
@REM errorlevel of 1 is an OK return code.  Set it to 0;
if "%MYERRORLEVEL%"=="1" set MYERRORLEVEL=0

if defined PROFILE_CONFIG_ACTION exit %MYERRORLEVEL%
exit /b %MYERRORLEVEL%
GOTO :EOF
