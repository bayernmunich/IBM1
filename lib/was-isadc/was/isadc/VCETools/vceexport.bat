@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5630-A36 (C) COPYRIGHT International Business Machines Corp., 2008
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM vceexport launcher 

@REM !!!!!!!! THIS SCRIPT IS PART OF VCE AUTOMATION FRAMEWORK AND NOT INTENDED 
@REM !!!!!!!! TO BE EXECUTED STANDALONE. PLEASE REFER TO README OR HELP DOCUMENTATION.

@echo off
REM Usage: vceexport WAS_HOME TEMP_DIR OUTPUT_DIR OUTFILE_BASENAME VCE_LIB_DIR (PROFILE_NAME)
REM Note: Script must be called from WAS_ROOT

@REM to enable class loading debugging specify the following parms -Dws.ext.debug=true -verbose:class 
@REM The VCE_OUT variable controls where the exported configurations are saved.
@REM The VCE_TEMP variable controls where temp files are created. If you experience problems, try setting this value to a directory near the drive root.
set ERRORLEVEL=
setlocal

set WAS_HOME=%~1
set VCE_TEMP=%~2
set VCE_OUT=%~3
set VCE_FILE=%~4
set VCE_LIB=%~5
echo parameters: %*
if "%6"=="" goto no_profile
if not "%6"=="" goto profile
:no_profile
echo profile not specified
call setupCmdLine.bat
goto end_profile
:profile
echo profile %~6 specified
call setupCmdLine.bat -profileName %6 
:end_profile

@REM The following is added through defect 238059.1 
if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

SET USER_INSTALL_ROOT=%WAS_HOME%

:runcmd
set CLASSPATH=%WAS_CLASSPATH%;%WAS_HOME%\optionalLibraries\jython\jython.jar;%WAS_HOME%\optionalLibraries\jython\lib;%ITP_LOC%\batchboot.jar;%ITP_LOC%\batch2.jar
set PERFJAVAOPTION=-Xms64m -Xmx256m -Xj9 -Xquickstart
@echo off

@echo on
"%JAVA_HOME%\bin\java" %PERFJAVAOPTION% "-Dwas.repository.temp=%VCE_TEMP%" "-Djava.io.tmpdir=%VCE_TEMP%" "-Dperf.java.options=%PERFJAVAOPTION%" "-Duser.install.root=%USER_INSTALL_ROOT%" "-Dws.ext.dirs=%WAS_EXT_DIRS%;%VCE_LIB%" "-Dvce.lib=%VCE_LIB%" "-Dwas.install.root=%WAS_HOME%" "-Dwas.repository.root=%CONFIG_ROOT%" -Dlocal.cell=%WAS_CELL% -Dlocal.node=%WAS_NODE% "-Dexport.workdir=%VCE_OUT%" -Dexport.fileprefix=%VCE_FILE% -Dexport.hidePasswords=true com.ibm.ws.bootstrap.WSLauncher com.ibm.topology.websphere.provider.VCEExportLauncher
@echo off
set RC=%ERRORLEVEL%
if not '%RC%'=='0' goto cleanup
call "%VCE_OUT%\export-temp.bat"
set RC=%ERRORLEVEL%
:cleanup
if exist "%VCE_OUT%\export-temp.bat" del "%VCE_OUT%\export-temp.bat"
goto END

:END
@REM Need to pass the RC through the endlocal
@endlocal & set MYERRORLEVEL=%RC%

if defined PROFILE_CONFIG_ACTION ( exit %MYERRORLEVEL% ) else exit /b %MYERRORLEVEL%