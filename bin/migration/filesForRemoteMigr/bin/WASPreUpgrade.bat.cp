@echo off
@setlocal ENABLEDELAYEDEXPANSION

call "%~dp0setupCmdLine.bat" %*

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

if exist "%JAVA_HOME%\bin\java.exe" (
    set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
    if exist "%JAVA_HOME%\jre\bin\java.exe" (
        set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
    ) else (
        echo Cannot locate the java command. Verify that the directory specified by the JAVA_HOME variable is a valid java installation.  
        set RC=5
        goto done
    )
)

:checkJavaArchAgainstSystemArch
if not exist "%~dp0..\properties\sdk\cmdDefaultSDK.properties" (
    echo Cannot locate the cmdDefaultSDK.properties
    set RC=99
    goto done
)

set /p jdkInfo=<"%~dp0..\properties\sdk\cmdDefaultSDK.properties"
for /f "tokens=5,6 delims=._ " %%a in ('echo %jdkInfo%') do (
    set JAVA_OS_ARCH=%%b
    set JAVA_LOCATION=java_1.%%a_%%b
)

if not exist "%~dp0..\%JAVA_LOCATION%" goto checkThisSystemsJDKLevel
@REM If a JDK was provided by the remote migration jar, check if the provided java's arch is compatible with this system's arch.
if not "%JAVA_OS_ARCH%"=="64" goto loop

@REM OK, the java is 64 bit - so the system must also be 64 bit, let's ask regedit....
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OSBIT=32BIT || set OSBIT=64BIT

@REM IF we are 64 bit - we're good to go, otherwise print a message and exit.
if "%OSBIT%"=="64BIT" goto loop
echo This system does not support running the 64 bit JDK provided by this createRemoteMigrJar file.
echo You can rerun the createRemoteMigrJar script with -includeJava false option.   
echo WASPreUpgrade aborted....
set RC=10
goto done

:checkThisSystemsJDKLevel
@REM A JDK was not provided with the createRemoteMigrJar file.  So we just need to be sure the JDK is 7.0 or higher.
set TMPFILE="WASPre.Java.Ver.%RANDOM%"
if exist %TMPFILE% goto checkThisSystemsJDKLevel
"%JAVA_EXE%" -version 2>%TMPFILE%
set /p jvline=<%TMPFILE%
for /f "tokens=1-7 delims=." %%j in ('echo %jvline%') do (
    set jver=%%k
)
del %TMPFILE%
if %jver% geq 6 goto loop
echo The WASPreUpgrade command requires a java version of 1.6.0 or greater.
set RC=20
goto done

:loop
if '%1'=='-javaoption' goto javaoption
if '%1'=='' goto runcmd
goto nonjavaoption

:javaoption
shift
set javaoption=%javaoption% %1
goto again

:nonjavaoption
set nonjavaoption=%nonjavaoption% %1

:again
shift
goto loop

:runcmd
set CLASSPATH=%WAS_CLASSPATH%
SET PERFJAVAOPTION=-Xms256m -Xmx512m -Xj9 -Xquickstart

@REM set WAS_MIGR_DEBUG_RMT_PRE=-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8888

@REM Any WebSphere processes spawned by WASPreUpgrade will use the incorrect SDK if this env variable is true.
set USE_COMMAND_OVERRIDE_SDK=false

"%JAVA_EXE%" ^
    %WAS_MIGR_DEBUG_RMT_PRE% ^
    %OSGI_INSTALL% ^
    -Dosgi.configuration.area="@user.home/WebSphereRemoteMigr" ^
    %PERFJAVAOPTION% ^
    %WAS_LOGGING% ^
    %javaoption% ^
    %CONSOLE_ENCODING% ^
    -Dcom.ibm.websphere.migration.serverRoot="%WAS_HOME%" ^
    -Dws.ext.dirs="%WAS_EXT_DIRS%" ^
    -Dws.migration.pre.remote.xos="true" ^
    -classpath "%CLASSPATH%" ^
    com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash ^
    -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.migration.WASPreUpgrade %*
  
set RC=%ERRORLEVEL%

:done
@REM Need to pass the RC through the endlocal
endlocal & exit /b %RC%
