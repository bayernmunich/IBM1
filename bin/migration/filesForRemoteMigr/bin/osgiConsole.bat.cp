@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2006, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM OSGi cache Terminology:
@REM    ProfileCache - profiles/<A_Profile>/configuration
@REM                   This cache is used by only a few scripts (like stopServer)
@REM    ServerCache  - profiles/<A_Profile>/servers/<A_Specific_Server>/configuration
@REM                   This cache is used by a specific server instance 
@REM    WasHomeCache - <WAS_HOME>/configuration
@REM 
@REM Launch OSGi Console in order to debug, console connects to one of the 
@REM following osgi caches:
@REM   - if run from <WAS_INSTALL>/bin and no arguments provided, connected 
@REM     to the ProfileCache of the default profile.
@REM   - if run from a profile/bin with no args, connected to the 
@REM     ProfileCache of the profile the command is being run in.
@REM   - if run from a profile/bin with a server argument, connected to the 
@REM     server cache of the specified server.
@REM
@REM Launch Arguments:
@REM   -debug  <optional osgi debug file>, if none specified $WAS_HOME/bin/.options is used 
@REM   -washome
@REM   -server <a ServerName> 

@echo off
setlocal ENABLEDELAYEDEXPANSION
setlocal

call "%~dp0setupCmdLine.bat" %*

if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

set _DEBUG=
set _DEBUGERROR=
set _HELP=0
set _OSGICONFIG=
set _SERVEREXPECTED=no
set _WASHOMESPECIFIED=no
set _SERVERSPECIFIED=no
set _DEBUGSPECIFIED=no
set _DEBUGEXPECTED=no
set _ARGUMENTISDIRECTIVE=no

for %%E in (%*) do (
   if %%E equ -help goto :HELP
   
   if !_DEBUGEXPECTED! equ yes (
      call:ArgumentIsDirective %%E
      echo ArgumentIsDirective returned !_ARGUMENTISDIRECTIVE! for %%E
      if !_ARGUMENTISDIRECTIVE! equ yes (
         set _DEBUG=-debug "%WAS_HOME%\bin\.options"
         set _SERVEREXPECTED=yes
         set _SERVERSPECIFIED=yes
      ) else (
         if exist %%E (
				set _DEBUG=-debug %%E
			) else (
				echo %%E does not exist
				set _DEBUGERROR=error
			)
      )
      set _DEBUGEXPECTED=no
   ) else (
      if !_SERVEREXPECTED! equ yes (
         set _OSGI_CFG=-Dosgi.configuration.area="%USER_INSTALL_ROOT%\servers\%%E\configuration"
         echo Setting OSGi cfg area to: !_OSGI_CFG! 
         set _SERVEREXPECTED=no
      ) else (
	      if %%E equ -washome (
		      set OSGI_INSTALL=-Dosgi.install.area="!WAS_HOME:"=!"
		      set _OSGI_CFG=-Dosgi.configuration.area="!WAS_HOME:"=!\configuration"
		      set USER_INSTALL_PROP=-Duser.install.root="!WAS_HOME:"=!"
            echo Setting OSGi cfg area to: !_OSGI_CFG!
            set _WASHOMESPECIFIED=yes
	      ) else (
		      if %%E equ -debug ( 
			      set _DEBUG=-debug "%WAS_HOME%\bin\.options"
               set _DEBUGSPECIFIED=yes
               set _DEBUGEXPECTED=yes
		      ) else (
			      if %%E equ -server (
                  set _SERVEREXPECTED=yes
                  set _SERVERSPECIFIED=yes
			      ) else (
    	            echo %%E option not recognized.
		            goto :HELP
			      )
		      )
	      )
      )  
   )
)

if !_SERVERSPECIFIED! equ yes (
   if !_WASHOMESPECIFIED!==yes (
      echo -washome and -server are mutually exclusive directives
      goto :HELP
   ) 
)

if !_DEBUGERROR! equ error goto end
%JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" %OSGI_INSTALL% %_OSGI_CFG% %USER_INSTALL_PROP% -Dwas.install.root="%WAS_HOME:"=%" -classpath "%WAS_CLASSPATH%" com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash !_DEBUG! -console -consoleLog -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.debug.osgi.StartOsgiConsole

:end
endlocal
goto :EOF

:HELP
	echo "osgiConsole [-debug [osgi debug file]] [-washome] || [-server serverName]"
goto :EOF

:ArgumentIsDirective
if %1 equ -help (
   set _ARGUMENTISDIRECTIVE=yes
   goto :EOF
)

if %1 equ -debug (
   set _ARGUMENTISDIRECTIVE=yes
   goto :EOF
)


if %1 equ -washome (
   set _ARGUMENTISDIRECTIVE=yes
   goto :EOF
)


if %1 equ -server (
   set _ARGUMENTISDIRECTIVE=yes
   goto :EOF
)

set _ARGUMENTISDIRECTIVE=no

goto :EOF
