@rem Copyright IBM Corp. 2006, 2011
@setlocal
@echo off

CALL "%~dp0setupCmdLine.bat" %* 

if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

SET WAS_CLASSPATH=%WAS_HOME%\properties;%WAS_HOME%\plugins\com.ibm.ws.runtime.jar;%WAS_HOME%\plugins\com.ibm.ws.runtime.client.jar;%WAS_HOME%\plugins\nls\eclipse\plugins\*;%WAS_HOME%\lib\wasproduct.jar

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

if "%WAS_ENDORSED_DIRS%"=="" (
  %JAVA_EXE% %CONSOLE_ENCODING% -Dwas.install.root="%WAS_HOME%" -classpath "%WAS_CLASSPATH%" com.ibm.websphere.product.history.HistoryInfo %*
) else (  
  %JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" %CONSOLE_ENCODING% -Dwas.install.root="%WAS_HOME%" -classpath "%WAS_CLASSPATH%" com.ibm.websphere.product.history.HistoryInfo %*
)

@endlocal

GOTO :EOF
