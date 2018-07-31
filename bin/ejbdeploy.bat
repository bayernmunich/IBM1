@rem Copyright IBM Corp. 2001

@echo off
setlocal
set USE_HIGHEST_AVAILABLE_SDK=true
call "%~dp0setupCmdLine.bat" %*

if exist "%JAVA_HOME%\bin\java.exe" (
  set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
  set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

set WAS_EXT_DIRS=%WAS_HOME%\dev\javaee5.jar;%WAS_HOME%\plugins;%WAS_EXT_DIRS%
if exist "%ITP_LOC%\ejbdeploy.bat" (
  call "%ITP_LOC%\ejbdeploy.bat" %*
) else (
  %JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -cp "%WAS_HOME%\lib\commandlineutils.jar" com.ibm.ws.install.commandline.utils.CommandLineUtils -ejbdeployfeaturenotinstalled
)


endlocal

