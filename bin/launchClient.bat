@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 COPYRIGHT International Business Machines Corp., 1997, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@echo off
REM Usage: launchClient [-profileName name | -JVMOptions options | -help | -?] <userapp> [-CC<name>=<value>] [app args] 
setlocal

CALL "%~dp0setupCmdLine.bat" %*

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

:loop
  if '%1'=='' goto exitloop
  if '%1'=='-JVMOptions' (
    set isJavaOption=true
  ) else (    
    if '%isJavaOption%'=='true' (
      set javaoption=%javaoption% %~1
      set isJavaOption=false
    )   
  )    
  shift
  goto loop 
:exitloop

:runcmd
set PATH=%WAS_HOME%\bin;%PATH%

@if defined DEFAULTSERVERNAME (set WAS_DEFAULTSERVERNAME=-Dcom.ibm.CORBA.BootstrapHost=%DEFAULTSERVERNAME%) else (set set WAS_DEFAULTSERVERNAME=)
@if defined SERVERPORTNUMBER (set WAS_SERVERPORTNUMBER=-Dcom.ibm.CORBA.BootstrapPort=%SERVERPORTNUMBER%) else (set set WAS_SERVERPORTNUMBER=)
                                                                                                                       
"%JAVA_HOME%\bin\java" -DMQ_USE_BUNDLE_REFERENCE_INSTALL=true -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" %javaoption% %CONSOLE_ENCODING% -Dwas.install.root="%WAS_HOME%" -Dws.ext.dirs="%WAS_EXT_DIRS%" %WAS_DEFAULTSERVERNAME% %WAS_SERVERPORTNUMBER% %USER_INSTALL_PROP% -Dorg.osgi.framework.bootdelegation=* -Dcom.ibm.ffdc.log="%FFDCLOG%" -classpath "%WAS_HOME%\lib\launchclient.jar;%WAS_CLASSPATH%" com.ibm.websphere.client.applicationclient.launchClient %*

endlocal

