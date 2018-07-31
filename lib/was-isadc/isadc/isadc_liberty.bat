@echo off
setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION
setlocal
rem (C) COPYRIGHT International Business Machines Corp., 2004-2011. All Rights Reserved * Licensed Materials - Property of IBM
rem
rem Start Collector Application
rem
rem

rem set DEBUG_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8000

set SCRIPT=%0
set DQUOTE="
SET SYS32_HOME=%SystemRoot%\System32
SET FIND_CMD=%SYS32_HOME%\find.exe
SET FINDSTR_CMD=%SYS32_HOME%\findstr.exe

:: Detect how script was launched
@echo %SCRIPT:~0,1% | %FINDSTR_CMD% /l %DQUOTE% > NUL
if %ERRORLEVEL% EQU 0 set PAUSE_ON_CLOSE=1

rem Check to see if we are being invoked from a product script
rem If so, unset PAUSE_ON_CLOSE which was incorrectly set from above
if defined PRODUCT_INVOKE set PAUSE_ON_CLOSE=

cd /d "%~dps0"
rem Check to see if the cd command was successful
rem If not, the product most likely was installed into a directory that is not supported (eg., one with '.' chars, etc.)
if %ERRORLEVEL% NEQ 0 (
	echo.
	echo Unable to change directory.  Please see known issues in the README.txt for more
	echo information.
	echo.
	goto :EOF
	)

SET "AUTOPD_HOME=%cd%"

set "LOG_CONFIG=%AUTOPD_HOME%\properties\logger.properties"

set "TMP_DIR=%AUTOPD_HOME%\tmp"
set "DATA_HOME=%AUTOPD_HOME%"
set "LICENSES_HOME=%AUTOPD_HOME%\licenses"
set "LAPSTATUS_HOME=%AUTOPD_HOME%\lap_status"

for %%P in (%1 %2 %3 %4 %5 %6 %7 %8 %9) do if %%P. == -collectorBase. set NEED_INIT=true
for %%P in (%1 %2 %3 %4 %5 %6 %7 %8 %9) do if %%P. == -useHome. goto sethome

if defined NEED_INIT goto sethome
if not exist "%DATA_HOME%\log" md "%DATA_HOME%\log"

goto nohome
:sethome

set NEED_INIT=true

if "%HOMEPATH%." == "." goto nohome
if "%HOMEDRIVE%." == "." goto nohome
set "DATA_HOME=%HOMEDRIVE%%HOMEPATH%\.isadc"
if not exist "%DATA_HOME%" md "%DATA_HOME%" 

set "LOG_CONFIG=%AUTOPD_HOME%\properties\logger-home.properties"

set "LAPSTATUS_HOME=%DATA_HOME%\lap_status"
if not exist "%LAPSTATUS_HOME%" md "%LAPSTATUS_HOME%" 
if not exist "%LAPSTATUS_HOME%\license" md "%LAPSTATUS_HOME%\license" 
if exist "%AUTOPD_HOME%\lap_status\license\status.dat" copy "%AUTOPD_HOME%\lap_status\license\status.dat" "%LAPSTATUS_HOME%\license\status.dat" >nul

if "%TEMP%." == "." goto notemp
if not exist "%TEMP%\.isadc" md "%TEMP%\.isadc" 
set "TMP_DIR=%TEMP%\.isadc_%USERNAME%_%RANDOM%\%DATA_DIR%"
goto nohome

:notemp
if "%TMP%." == "." goto nohome
if not exist "%TMP%\.isadc" md "%TMP%\.isadc" 
set "TMP_DIR=%TMP%\.isadc_%USERNAME%_%RANDOM%\%DATA_DIR%"

:nohome
if not exist "%TMP_DIR%\properties" md "%TMP_DIR%\properties" 2>&1 >nul
set "JAVA_VER=%TMP_DIR%\properties\java_ver.txt"

if "%1"=="-help" goto displayHelp
goto :checkVersion

:displayHelp
rem Display the help info and then exit
:: Export International settings from registry to a temporary file
reg EXPORT "HKEY_CURRENT_USER\Control Panel\International" "%CD%\international.reg" > nul
:: Read several lines from the temporary files
:: and store these settings as environment variables

FOR /F "usebackq tokens=1* delims==" %%A IN (`TYPE "%CD%\international.reg" ^| "%FIND_CMD%" "sLanguage"`) DO SET sLanguage=%%B

SET sLanguage=%sLanguage:"=%

rem echo sLanguage is %sLanguage%

IF EXIST "%cd%"\util\help\userhelp_%sLanguage%.txt (
:: invoke the most specific case first if possible (language and country)
  type util\help\userhelp_%sLanguage%.txt  
) ELSE IF EXIST "%cd%"\util\help\userhelp_%sLanguage:~0,2%.txt (
:: now try matching just the first two characters (language)
  type util\help\userhelp_%sLanguage:~0,2%.txt 
) ELSE (
:: if all else fails, always invoke the default case (English)
  type util\help\userhelp_EN.txt 
)

:: unset the sLanguage variable
SET sLanguage=

:: Remove temporary file
DEL "%CD%\international.reg"
goto end

:checkVersion
if "%1"=="-version" goto displayVersion
goto :DO_COLLECTION

:displayVersion
rem Display the version info and then exit
for /f "tokens=1,2 delims==" %%a in (properties\version\version.properties) do (
  set id=%%a
  set version=%%b
  rem Check to see if an '=' delimeter was found, if not then ignore that line
  if NOT "%%b" == "" (
	  set id=!id:_= !
	  echo.!id!: !version!
  )
)
goto end

:DO_COLLECTION

set CISA_HOME=%AUTOPD_HOME%\cisa
set CISA_CP=%CISA_HOME%
for /R "%CISA_HOME%\lib" %%i in (*.jar) do set CISA_CP=!CISA_CP!;%%i

set "AUTOPD_LIB=%AUTOPD_HOME%\lib"

REM set "RASUtils_LIB=%AUTOPD_HOME%\lib\rasutils"

set "LV_HOME=%AUTOPD_HOME%\levelreport"

set "AUTOPD_PROPERTIES=%AUTOPD_HOME%\properties"

REM set "AUTOPD_XML_CP=%AUTOPD_LIB%\xercesImpl.jar;%AUTOPD_LIB%\xmlParserAPIs.jar;%AUTOPD_LIB%\resolver.jar"

REM set "AUTOPD_ANT_CP=%AUTOPD_LIB%\ant.jar;%AUTOPD_LIB%\ant-launcher.jar;%AUTOPD_LIB%\jakarta-oro-2.0.7.jar;%AUTOPD_LIB%\ant-jsch.jar;%AUTOPD_LIB%\jsch-0.1.40.jar"

set AUTOPD_JARS=%AUTOPD_LIB%
for /R "%AUTOPD_LIB%" %%i in (*.jar) do set AUTOPD_JARS=!AUTOPD_JARS!;%%i

REM Set up a directory for the front of the classpath for patches
if EXIST "%AUTOPD_HOME%\patch" (
	set AUTOPD_PATCH=%AUTOPD_HOME%\patch
	for /R "%AUTOPD_HOME%\patch" %%j in (*.jar) do set AUTOPD_PATCH=!AUTOPD_PATCH!;%%j
)


set "AUTOPD_LV_CP=%LV_HOME%\lib\invtool.jar;%LV_HOME%\lib\xsdbeans.jar;%LV_HOME%\lib\depcheck.jar;%LV_HOME%\lib\itj157minimal.jar;%LV_HOME%\lib\xalan.jar"

REM SET "AUTOPD_CP=%AUTOPD_HOME%;%AUTOPD_LIB%\autopd.jar;%AUTOPD_LIB%\autopdswing.jar;%RASUtils_LIB%\RASUtils.jar;%AUTOPD_PROPERTIES%;%AUTOPD_ANT_CP%;%AUTOPD_XML_CP%;%CISA_CP%;%AUTOPD_LIB%\collector.jar;%AUTOPD_LIB%\com.ibm.icu.jar;%AUTOPD_LIB%\esa.jar;%AUTOPD_LIB%\commons-net-1.4.1.jar;%AUTOPD_LV_CP%"
REM SET "AUTOPD_CP=%AUTOPD_HOME%;%AUTOPD_LIB%\autopd.jar;%AUTOPD_LIB%\autopdswing.jar;%AUTOPD_LIB%\RASUtils.jar;%AUTOPD_PROPERTIES%;%AUTOPD_ANT_CP%;%AUTOPD_XML_CP%;%CISA_CP%;%AUTOPD_LIB%\collector.jar;%AUTOPD_LIB%\com.ibm.icu.jar;%AUTOPD_LIB%\esa.jar;%AUTOPD_LIB%\commons-net-1.4.1.jar;%AUTOPD_LV_CP%"
SET "AUTOPD_CP=%AUTOPD_HOME%;%AUTOPD_JARS%;%AUTOPD_PROPERTIES%;%CISA_CP%;%AUTOPD_LV_CP%"
SET AUTOPD_CP=%AUTOPD_CP%;"%WAS_CLASSPATH%"
if DEFINED AUTOPD_PATCH set AUTOPD_CP=%AUTOPD_PATCH%;%AUTOPD_CP%

set "PATH_TMP=%PATH%"

set "PATH=%CISA_HOME%\bin;%LV_HOME%;%LV_HOME%\lib;%PATH%"

rem assume we dont have a valid java
set IS_VALID_JAVA=false

rem call product specific script to set JAVA_HOME
if exist "%AUTOPD_HOME%\util\setupJava.bat" call "%AUTOPD_HOME%\util\setupJava.bat"

if not defined JAVA_HOME goto tryjava

rem Strip any quotes on JAVA_HOME using substitution 
set JAVA_HOME=%JAVA_HOME:"=%

rem Shorten JAVA_HOME to the 8.3 version
for %%I in ("%JAVA_HOME%") do set JAVA_HOME=%%~sI

rem run AutoPD if JAVA_HOME is defined
if "" NEQ "%JAVA_HOME%" goto run 


rem if JAVA_HOME is not defined, try running java

:tryjava
rem echo Try to run with java on PATH
REM call "%AUTOPD_HOME%\util\runCollector.bat" %*
rem echo error level is %ERRORLEVEL%

set JAVA_CMD=java
%FINDSTR_CMD% /? >NUL 2>&1
IF ERRORLEVEL 0 goto checkjavaversion
goto runCheckLAPStatus
if %ERRORLEVEL% NEQ 0 goto error

goto end

:run
if "" EQU "%JAVA_CMD%" (
	if exist "%JAVA_HOME%\bin\java.exe" (
		set JAVA_CMD=%JAVA_HOME%\bin\java.exe
	) else (
		set JAVA_CMD=%JAVA_HOME%\jre\bin\java.exe
	)
)

%FINDSTR_CMD% /? >NUL 2>&1
IF ERRORLEVEL 0 goto checkjavaversion
goto runISALite

:checkjavaversion
rem get the java version - pipes to standard err
"%JAVA_CMD%" -version 2>%JAVA_VER%
if %ERRORLEVEL% NEQ 0 goto getValidJava

rem check that JRE is not on excluded list
for /F "tokens=*" %%I in (util\jre_exclude_list.txt) do (
	%FINDSTR_CMD% /r /c:"%%I" %JAVA_VER%
    If errorlevel 1 (
	   echo. 
	) else (
	   goto errorjavaprovider )
    )
)
rem verify Java version is 1.5 or higher
%FINDSTR_CMD% /r /c:"java version \"1\.[234]" %JAVA_VER%
If %ERRORLEVEL% EQU 0 goto errorjava

:runCheckLAPStatus
REM check for existence of status.dat file
IF EXIST "%LAPSTATUS_HOME%\license\status.dat" goto runISALite

REM check GUI versus Console mode
"%JAVA_CMD%" -cp %AUTOPD_CP% com.ibm.autopd.lap.ConsoleGUI %*
IF %ERRORLEVEL% EQU 1 goto setConsoleMode
SET CONSOLE_MODE=
goto runLAP

:setConsoleMode
SET CONSOLE_MODE=-text_only

:runLAP
echo "Running License Acceptance Process Tool"
"%JAVA_CMD%" -cp %LICENSES_HOME%\LAPApp.jar  com.ibm.lex.lapapp.LAP -l "%LICENSES_HOME%" -s "%LAPSTATUS_HOME%"  %CONSOLE_MODE%

REM check if license was accepted
IF NOT EXIST "%LAPSTATUS_HOME%\license\status.dat" goto nolicense_accepted

REM Run ISALite
:runISALite
rem echo Java command used: %JAVA_CMD%

if defined NEED_INIT (
	if exist "%DATA_HOME%\tmp\collectorInit.bat" del "%DATA_HOME%\tmp\collectorInit.bat"


	"%JAVA_CMD%" %DEBUG_OPTS% -Xms64M -Xmx128M -cp %AUTOPD_CP% -Dautopd.home=%AUTOPD_HOME% -Djava.util.logging.config.file=%LOG_CONFIG% %CONSOLE_ENCODING% -Dwas.root=%WAS_HOME% -Dwas.install.root=%WAS_HOME% -Duser.install.root=%USER_INSTALL_ROOT% com.ibm.autopd.internal.console.ISACollectorConsole %* -init
	if exist "%DATA_HOME%\tmp\collectorInit.bat" (
		call "%DATA_HOME%\tmp\collectorInit.bat"
		"%JAVA_CMD%" %DEBUG_OPTS% -Xms64M -Xmx128M -cp %AUTOPD_CP%;!COLLECTOR_CLASSPATH! -Dautopd.home=%AUTOPD_HOME% -Djava.util.logging.config.file=%LOG_CONFIG% %CONSOLE_ENCODING% -Dwas.root=%WAS_HOME% -Dwas.install.root=%WAS_HOME% -Duser.install.root=%USER_INSTALL_ROOT% com.ibm.autopd.internal.console.ISACollectorConsole %*
	)
) else (
	"%JAVA_CMD%" %DEBUG_OPTS% -Xms64M -Xmx128M -cp %AUTOPD_CP% -Dautopd.home=%AUTOPD_HOME% -Djava.util.logging.config.file=%LOG_CONFIG% %CONSOLE_ENCODING% -Dwas.root=%WAS_HOME% -Dwas.install.root=%WAS_HOME% -Duser.install.root=%USER_INSTALL_ROOT% com.ibm.autopd.internal.console.ISACollectorConsole %*
)

set "PATH=%PATH_TMP%"
goto end

:errorjavaprovider
echo ERROR: The following Java Runtime Environment (JRE) is not supported.
echo.
"%JAVA_CMD%" -version
echo.
echo Please set JAVA_HOME to select another JRE or download one from 
echo IBM (https://www.ibm.com/developerworks/java/jdk/)
echo or
echo Oracle (http://java.com/en/download/manual.jsp)
set IS_VALID_JAVA=false
goto getValidJava

:errorjava
echo ERROR: This tool requires JRE 1.5 or greater to run.
echo.
echo Please set JAVA_HOME to select another JRE or download one from 
echo IBM (https://www.ibm.com/developerworks/java/jdk/)
echo or
echo Oracle (http://java.com/en/download/manual.jsp)
set IS_VALID_JAVA=false
goto getValidJava

:nolicense_accepted
echo "You must accept the license before running the ISA Data Collector"
goto end

:error

:: ==============================================================
:: :getValidJava
:: Routine to loop until we get a valid Java directory in the ISA_JAVA_HOME variable
:: Note that this routine uses delayed variable expansion with the '!' delimiters so that
:: we can check variable values that may have been set in any called routines
:: ==============================================================
:getValidJava
if "%IS_VALID_JAVA%" == "false" (
	call :promptForJava
	
	rem check the RESPONSE variable from the prompting.
	if /I X!RESPONSE! == Xq (
		rem Quit the program if the user typed in a 'q'
		echo Quitting ISA Data Collector
		goto :EOF
	) else (
		rem Try setting ISA_JAVA_HOME and validate what they provided
		call :validateJava
		goto :getValidJava
	)
) else (
	rem we have a valid Java location.
	set JAVA_HOME=!ISA_JAVA_HOME!
	goto :run
)

:: ==============================================================
:: :promptForJava
:: Routine to prompt the user for a Java install directory.  The assumption
:: coming into this routine is that Java cannot be found and the user will see a message
:: indicating that ISA Data Collector cannot detect a usable Java
:: 
:: returns
::     ISA_JAVA_HOME is set to an input value specified by the user.  It has not been
::               validated, but is guaranteed to not have quotation marks.
::				This only works as long as every use of JAVA_CMD is enclosed in ",
::				as the value of it may contain spaces.
:: 
:: This routine should be used in CALL statements since it exits by going to EOF
:: ==============================================================
:promptForJava
echo.
if "x!RESPONSE!" EQU "x" (
	echo ISA Data Collector cannot automatically detect a usable Java executable.
) else (
	echo ISA Data Collector cannot automatically detect a usable Java executable at 
	echo !ISA_JAVA_HOME!
)
echo If Java 1.5 is not available, and you are running on IBM hardware, 
echo you can download one from 
echo https://www.ibm.com/developerworks/java/jdk/
echo.
echo Please enter the path to a Java installation (i.e.: C:\IBM\Java50) 
echo or 'q' to quit:
set /P RESPONSE=
set ISA_JAVA_HOME=%RESPONSE:"=%

rem Now shorten to the 8.3 representation
for %%I in ("%ISA_JAVA_HOME%") do set ISA_JAVA_HOME=%%~sI
goto :EOF

:: ==============================================================
:: :validateJava
:: Routine to validate that a java.exe can be found in the global variable ISA_JAVA_HOME
::	 'bin' or 'jre\bin' subdirectory
:: An assumption is made that the existence of a java.exe file in one of these subdirectories
:: indicates that this directory is a valid Java installation.
::
:: returns IS_VALID_JAVA set to 'true' (w/o quotes) if a java.exe was found
:: 	JAVA_CMD set to the path where java.exe was found
::
:: This routine should be used in CALL statements since it exits by going to EOF
:: ==============================================================
:validateJava
rem First check to see if there's a bin directory with java.exe.  This is usually the case for a Java SDK install
if EXIST "%ISA_JAVA_HOME%\bin\java.exe" (
	set IS_VALID_JAVA=true
	set JAVA_CMD=%ISA_JAVA_HOME%\bin\java.exe
)
rem if the check above fails, then check for a jre\bin directory with java.exe
if EXIST "%ISA_JAVA_HOME%\jre\bin\java.exe" (
	set IS_VALID_JAVA=true
	set JAVA_CMD=%ISA_JAVA_HOME%\jre\bin\java.exe
)

goto :EOF

:end
if defined PAUSE_ON_CLOSE pause
endlocal
