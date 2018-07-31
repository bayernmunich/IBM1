@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp. 2012
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.
                               
@echo off
setlocal

CALL "%~dp0setupCmdLine.bat" %* 

if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

set CMD_NAME=%~nx0
set CMD_NAME_ONLY=%~n0
set PRODUCT_INVOKE=TRUE

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

@REM For debugging the launcher itself
@REM set DEBUG=-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777

@REM win2k has a 2046 command line length (not counting the CRLF).  Max length for WAS_HOME is 60 chars.  Max profile path length is 80. 
@REM To conserve command line space you can:
@REM   1. Use the CLASSPATH ENV VAR instead of the -classpath parameter.
@REM   2. Write any Java Properties into a temporary properties file and specify  -Dcmd.properties.file="<your_prop_file>"  on the java command line.
@REM      Note these exceptions:  The user.install.root and was.install.root properties must be passed in on the command line.

for %%I in ("%WAS_HOME%") do set TEMP_WAS_HOME=%%~sI
set WAS_HOME=%TEMP_WAS_HOME%
for %%I in ("%USER_INSTALL_ROOT%") do set TEMP_USER_INSTALL_ROOT=%%~sI
set USER_INSTALL_ROOT=%TEMP_USER_INSTALL_ROOT%


call "%WAS_HOME%\lib\was-isadc\isadc\isadc.bat" -outputzip "%TEMP%\%WAS_CELL%-%WAS_NODE%-WAS-ISADC.zip" -collectorBase "%WAS_HOME%\lib\was-isadc\was" %*


set RC=%ERRORLEVEL%


@REM Need to pass the RC through the endlocal
endlocal & exit /b %RC%
GOTO :EOF
