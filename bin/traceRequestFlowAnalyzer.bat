@REM Copyright IBM Corp. 2010,2011

@echo off
setlocal

@REM
@REM Look for WAS, JAVA, and the JAR file.
@REM
@REM First, look for WAS.  We need it to try to find the jar file, and maybe java.
@REM
@REM Second, look for JAVA.  Look in:
@REM    WAS, 
@REM    JAVA_HOME - do not specify the bin, that will be concatenated on the end of JAVA_HOME
@REM    PATH
@REM
@REM Third, look for the jar file.  Look in:
@REM    the current directory, 
@REM    the script's directory, 
@REM    WAS_HOME/classes
@REM    WAS_HOME/util/ve
@REM

set SCRIPT_DIR=%~dp0
set CUR_DIR=%cd%
set LOGMGR=logmgr.jar
if defined WAS_HOME GOTO GET_JAVA
cd "%SCRIPT_DIR%\.."
set WAS_HOME=%cd%
   
@REM Try to find java. If failure, then try a local java.
:GET_JAVA
if exist "%WAS_HOME%\java\bin\" (
   set JAVA_EXE=%WAS_HOME%\java\bin\java
) else (
   if exist "%WAS_HOME%\java\jre\bin\" (
      set JAVA_EXE=%WAS_HOME%\java\jre\bin\java
   ) else (
      if exist "%JAVA_HOME%\bin\" (
         set JAVA_EXE=%JAVA_HOME%\bin\java
      ) else (
         set JAVA_EXE="java"
  	      echo "WARNING: Could not find java path.  Try setting JAVA_HOME. Will try using PATH variable."
      )
   )
)

@REM Try to find the trace analyzer jar.
if exist "%CUR_DIR%\%LOGMGR%" (
   set LOGJAR=%CUR_DIR%\%LOGMGR%
) else (
   if exist "%SCRIPT_DIR%\%LOGMGR%" (
      set LOGJAR=%SCRIPT_DIR%\%LOGMGR%
   ) else (
      if exist "%WAS_HOME%\classes\%LOGMGR%" (
         set LOGJAR=%WAS_HOME%\classes\%LOGMGR%
      ) else (
         if exist "%WAS_HOME%\util\ve\%LOGMGR%" (
            set LOGJAR=%WAS_HOME%\util\ve\%LOGMGR%
         ) else (
            if exist "%CLASSPATH%" (
     	         echo "WARNING: Could not find %LOGMGR% jar file.  Will try using your CLASSPATH variable."
            ) else (
               echo "ERROR: Could not find %LOGMGR% jar file."
            )
         )
      )
   )
)

@REM
@REM Display the env settings, so if there's a problem, we can know
@REM what files were being used.
@REM
set WAS_INSTALL_ROOT=%WAS_HOME%\
set WAS_CLASSPATH=%LOGJAR%

@REM
@REM Execute the analysis program.
@REM

"%JAVA_EXE%" -Dwas.install.root=%WAS_INSTALL_ROOT% -classpath "%LOGJAR%" com.ibm.ws.logmgr.analysis.trace.RequestFlowAnalyzer %*
