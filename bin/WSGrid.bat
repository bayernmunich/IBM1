@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J34 (C) COPYRIGHT International Business Machines Corp., 2007
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@echo off
REM Usage: WSGrid <job properties file>
setlocal

call "%~dp0/../bin/setupCmdLine.bat" %*

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

setlocal enabledelayedexpansion
set /a i=0
set /a jvmIndex=0
set /a iiopIndex=0
set javaoption=
set iiopoption=

@REM Copy input parameters into an array and set the location of the 
@REM -JVMOptions or -IIOP parameters if they exist
for %%j in (%*) do (
  if '%%j'=='-JVMOptions' (
    set jvmIndex=!i!
    set /a jvmIndex=jvmIndex+1
  )
  if '%%j'=='-IIOP' (
    set iiopIndex=!i!
    set /a iiopIndex=iiopIndex+1
  )
  set element[!i!]=%%j
  set /a i=i+1
)

@REM Set the -JVMOption and -IIOP parameter's values (ie, the value following 
@REM the parameter)
if '%jvmIndex%' neq '0' (
  set javaoption=!element[%jvmIndex%]!
)
if '%iiopIndex%' neq '0' (
  set iiopoption=!element[%iiopIndex%]!
)

@REM Calculate the parameters for WSGrid.java (last 2 input parameters max)
@REM No optional parameters scenario
if '%jvmIndex%' equ '%iiopIndex%' ( 
  :noparamloop
  if %i% gtr 2 (
    shift
    set /a i=i-1
    goto noparamloop
  )
  set params=%1 %2
  goto runcmd
)

@REM Check if the JVMOption parameter is the last parameter in the input
@REM Shift the parameters so that we send the proper values to WSGrid.java

@REM JVMOptions is the last parameter scenario
if '%jvmIndex%' gtr '%iiopIndex%' (
  set /a jvmIndex+=1
  set /a x=0
  :jvmloop
    if '%x%' lss '%jvmIndex%' (
      shift
      set /a x+=1
      goto :jvmloop
    )
) 

@REM IIOP is the last parameter scenario
if '%jvmIndex%' lss '%iiopIndex%' (
  set /a iiopIndex+=1
  set /a x=0
  :iioploop
    if '%x%' lss '%iiopIndex%' (
      shift
      set /a x+=1
      goto :iioploop
    )
)
  
@REM Set the WSGrid parameters
set params=%1 %2
goto runcmd

:runcmd
set PATH=%WAS_HOME%\bin;%PATH%
set JMS_PATH=%WAS_HOME%\lib\WMQ\java\lib\com.ibm.mq.jar;%WAS_HOME%\lib\WMQ\java\lib\com.ibm.mqjms.jar;%WAS_HOME%\lib\WMQ\java\lib\dhbcore.jar

@if defined DEFAULTSERVERNAME (set WAS_DEFAULTSERVERNAME=-Dcom.ibm.CORBA.BootstrapHost=%DEFAULTSERVERNAME%) else (set set WAS_DEFAULTSERVERNAME=)
@if defined SERVERPORTNUMBER (set WAS_SERVERPORTNUMBER=-Dcom.ibm.CORBA.BootstrapPort=%SERVERPORTNUMBER%) else (set set WAS_SERVERPORTNUMBER=)

"%JAVA_HOME%\bin\java" %javaoption% "%CLIENTSSL%" %CONSOLE_ENCODING% -Djava.naming.provider.url=corbaloc:iiop:%iiopoption% -Dwas.install.root="%WAS_HOME%" -Dws.ext.dirs="%WAS_EXT_DIRS%" %WAS_DEFAULTSERVERNAME% %WAS_SERVERPORTNUMBER% %USER_INSTALL_PROP% -classpath "%WAS_CLASSPATH%;%JMS_PATH%" "com.ibm.ws.bootstrap.WSLauncher" "com.ibm.ws.grid.comm.WSGrid" %params%

endlocal

