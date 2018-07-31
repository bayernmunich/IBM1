@echo off
setlocal

CALL "%~dp0setupCmdLine.bat" %* 

if NOT exist "%ITP_LOC%\ejbdeploy.bat" goto failedFeature

if "%ITP_LOC%"=="" goto darn



:checkCommandLine


if /i ?%1?==?? goto checkEnvironmentVariable

if /i ?%1?==?-workspace? goto processworkspace
set PARAMS=%PARAMS% %1 
shift
goto checkCommandLine                                            

:processworkspace
shift
set WORKSPACE="%1"

shift 
goto checkCommandLine

:checkEnvironmentVariable

if "%WORKSPACE%" == "" echo Set WORKSPACE to the rapid deployment workspace directory& goto End

:launchWRD




set wrd_cp="%ITP_LOC%\startup.jar"
set application=com.ibm.ws.rapiddeploy.core.WRDExec

Echo Launching WebSphere Rapid Deployment configuration.  Please wait...
Echo Starting Workbench...
Echo.

              
"%JAVA_HOME%\bin\java" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -Xms256m -Xmx512m -classpath %wrd_cp% org.eclipse.core.launcher.Main -noupdate -data %WORKSPACE% -application %application% -config %PARAMS%
goto end

:darn
echo need to set ITP_LOC

:end

endlocal

GOTO :EOF

:workspaceMessage 
echo "Set WORKSPACE to the rapid deployment workspace directory"
  echo Windows: "set WORKSPACE=<workspace root>"
GOTO :EOF


:failedFeature
if exist "%JAVA_HOME%\bin\java.exe" (
  set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
  set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)
%JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -cp "%WAS_HOME%\lib\commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -ejbdeployfeaturenotinstalled
GOTO :EOF

:workspaceMessage 
echo "Set WORKSPACE to the rapid deployment workspace directory"
  echo Windows: "set WORKSPACE=<workspace root>"
GOTO :EOF


