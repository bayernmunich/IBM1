@echo off
@rem IBM Confidential OCO Source Material
@rem 5630-A36 (C) COPYRIGHT International Business Machines Corp. 2016
@rem The source code for this program is not published or otherwise divested
@rem of its trade secrets, irrespective of what has been deposited with the
@rem U.S. Copyright Office.

@setlocal

set INSTALLSRC=%~dp0
CALL "%INSTALLSRC:\bin\migration\bin\=%"\bin\setupCmdLine.bat

if exist "%JAVA_HOME%\bin\java.exe" (
    set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
    set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

SET PATH=%WAS_PATH%
set WAS_ANT_EXTRA_CLASSPATH=%WAS_HOME%\lib\bootstrap.jar
set WAS_ANT_CLASSPATH=%WAS_ANT_CLASSPATH%;%WAS_HOME%\plugins
set INCLUDEJAVA=true
set ALLPLUGINS=true

set CLASSPATH=%WAS_CLASSPATH%

if defined USER_INSTALL_ROOT goto parseParams
SET USER_INSTALL_ROOT=%WAS_HOME%

:parseParams
if "%1" == "" goto checkVars
if /I "%1" == "-usage" goto usage
if /I "%1" == "-help" goto usage
@rem  Optional - Specify if you want the jre provided by this WebSphere install included.
if /I "%1" == "-skipJava" set INCLUDEJAVA="false"& shift& goto parseParams
@rem Optional - Specify if you want to have all bundles in the plugins dir included.
@rem If "osgiConsole>ss" fails to resolve all the wiring - use the following option.
if /I "%1" == "-reducePlugins" set ALLPLUGINS="false"& shift& goto parseParams
if "%2" == "" goto usageBadParam
if /I "%2" == "-usage" goto usage
if /I "%2" == "-help" goto usage
if /I "%1" == "-targetDir" set TARGETDIR=%2& shift& shift& goto parseParams
goto usageBadParam

:checkVars
if not defined TARGETDIR goto usage
 
:checkInstallRoot
if not exist "%TARGETDIR:"=%" mkdir "%TARGETDIR:"=%"
if not exist "%TARGETDIR:"=%" goto usageNoTargetDir
for /f "delims=\/" %%a in ('echo "%TARGETDIR:"=%"') do (
    set DRIVE=%%a
)
set DRIVE=%DRIVE:"=%
if not exist "%DRIVE%" goto usageNoTargetDir

:setEnvVars
set ANT_ARGS=-DWAS_INSTALL_ROOT="%WAS_HOME:"=%" -DTARGETDIR="%TARGETDIR:"=%" -DINCLUDEJAVA="%INCLUDEJAVA:"=%" -DALLPLUGINS="%ALLPLUGINS:"=%" -DWAS_HOME="%WAS_HOME:"=%"

:createRemoteMigrJarFile
echo Creating the remote Migration Jar File ...

%JAVA_EXE% -classpath "%WAS_CLASSPATH%" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" %WAS_LOGGING% %CONSOLE_ENCODING% -DWAS_USER_SCRIPT="%WAS_USER_SCRIPT%" %USER_INSTALL_PROP% -Dws.ext.dirs="%WAS_HOME:\=\\%"\\plugins;"%WAS_EXT_DIRS:\=\\%";"%WAS_ANT_CLASSPATH:\=\\%" -Dwas.ant.extra.classpath="%WAS_ANT_EXTRA_CLASSPATH:\=\\%" -Dwas.install.root="%WAS_HOME%" -Dwas.root="%WAS_HOME%" com.ibm.ws.bootstrap.WSLauncher org.apache.tools.ant.Main -quiet -f "%INSTALLSRC:"=%\createRemoteMigrJar.ant" %ANT_ARGS%
set RC=%ERRORLEVEL%

if not %RC% == 0 echo Possible error, %errorlevel%, running create Remote Migration Ant Script, check system stderr/stdout & goto done

if /I "%INCLUDEJAVA%"=="false" goto useSystemJavaInstructions
echo The WebSphere Remote Migration support jarfile has been created, it includes java from this WebSphere installation.
echo This jar is valid only on systems which support running the same level of java as what was collected.
echo 1) Send the jarfile to the system where your source profile resides.
echo 2) Unjar the file to a temp location.
echo 3) cd to the bin directory in the temp location.
echo 4) Run the WASPreUpgrade command against the source profile to be migrated using the -machineChange true parameter.
echo    See the WASPreUpgrade command details in the infoCenter.
echo.
goto done

:useSystemJavaInstructions
echo The WebSphere Remote Migration Support jarfile has been created, it does NOT include a java installation.
echo Your remote system must have version 7 or greater installed.
echo 1) Send the jarfile to the system where your source profile resides.
echo 2) Unjar the file to a temp location.
echo 3) set JAVA_HOME=location_of_the_java_installation
echo 4) cd to the bin directory in the temp location.
echo 5) Run the WASPreUpgrade command against the source profile to be migrated using the -machineChange true parameter.
echo    See the WASPreUpgrade command details in the infoCenter.
echo.
goto done

:usageBadParam
echo ERROR: The command line parameter, %1, is invalid or no value provided with param.
goto usage

:usageNoTargetDir
echo The install location, (%TARGETDIR%), does not exist.
echo Please specify the fully qualified path location where the Remote Migration Support Jar should be created.
echo.
goto usage

:usage
set ERRORLEVEL=1
echo.
echo Usage:
echo   "createRemoteMigrJar -targetDir targetdir [-skipJava]
goto explainParams

:explainParams
echo.
echo  -targetDir - The directory where the jar file will be created.
echo  -skipJava - if specified then WebSphere's java directory is not collected into the jar.
goto done

:done
@endlocal
