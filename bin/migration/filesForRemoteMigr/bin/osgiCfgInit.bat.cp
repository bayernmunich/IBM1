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

@REM Launch osgiCfgInit
@REM   Clears the osgi caches contained in the osgi configuration directories 
@REM   as specified by the launch arguments.
@REM   Note: the locations of the osgi configuration are
@REM       <WAS_HOME>/configuration
@REM       <WAS_HOME>/profiles/*/configuration
@REM       <WAS_HOME>/profiles/*/servers/*/configuration

@REM Launch Arguments:
@REM   -all If from WAS_HOME, then performs osgi configuration init on 
@REM             WAS_HOME and all profiles and all servers
@REM   -washome Performs osgi configuration init only on WAS_HOME
@REM   -profile <profileName> Performs osgi configuration init on 
@REM                          <profileName>/configuration and 
@REM                          <profileName>/servers/<AllServers>/configuration
@REM   -profileConfig <profileName> Performs osgi configuration init on
@REM                          <profileName>/configuration
@REM   -servers <Server1, Server2...etc> Performs osgi configuration init on
@REM                          /servers/<AllSpecifiedServers>/configuration
@REM                          Under the profile this command is run in.
@REM   -help prints usage text
@REM
@REM If no arguments are specified, then the behavior is as follows:
@REM     if run from a profile/bin then clears the osgi server and profile caches for this profile
@REM     if run from <WAS_HOME>/bin then clears the osgi server and profile caches for the default profile
@REM     if run before a default profile exists, then the osgi cache for <WAS_HOME> is cleared.

@echo off

call "%~dp0setupCmdLine.bat" %*

if exist "%JAVA_HOME%\bin\java.exe" (
   set JAVA_EXE="%JAVA_HOME%\bin\java"
) else (
   set JAVA_EXE="%JAVA_HOME%\jre\bin\java"
)

setlocal ENABLEDELAYEDEXPANSION

set _SERVERARGS=
set _PROFILEARG=
set _PROFILECONFIGARG=
set _PROFILESCRIPT=
set _SERVER_CFG_AREA=
set RETCODE=0
set _NUMARGS=0
set _ARGCOUNT=0
set _DIFFCOUNT1=
set _SERVERSDIR=
set _IGNOREDARGS=

call:getNumberOfCmdLineArgs %*

if %_NUMARGS% equ 0 (
   @REM if the setupCmdLine.bat command is run from a profile, then
   @REM USER_INSTALL_PROP and USER_INSTALL_ROOT will be set.
   @REM If we find no default profile then let's cleanup WASHOME!
   if not defined USER_INSTALL_PROP (
      echo No default profile found.
      call:clearWASHomeCfg
   ) else (
	   if not exist "%USER_INSTALL_ROOT%" (
         echo No default profile found.
         call:clearWASHomeCfg 
      ) else (
         @REM We are running from a profile/bin or <WAS_HOME>/bin, clear the 
         @REM osgi caches from /servers/*/configuration and /configuration 
         @REM Note: in the case where this command is being run from the 
         @REM <WAS_HOME>/bin directory, the caches of the default profile 
         @REM are cleared.
         call:clearCfgForCurrentProfile
      )
   )
) else (
   for %%E in (%*) do (
      set /A _ARGCOUNT+=1
      if !_SERVERARGS! equ yes (
         call:clearCfgForServer %%E
      ) else (
         if !_PROFILEARG! equ yes (
           call:clearCfgForSpecifiedProfile %%E
           goto :EXITFORLOOP
         ) else (
           if !_PROFILECONFIGARG! equ yes (
              call:clearProfileCfgForSpecifiedProfile %%E
              goto :EXITFORLOOP
            ) else (
              if %%E equ -help (
                 call:HELP
                 goto :EXITFORLOOP
              ) else (
                 if %%E equ -washome (
                     call:clearWASHomeCfg
                     goto :EXITFORLOOP
                 ) else (
                     if %%E equ -servers (
                        if %_NUMARGS% lss 2 (
                           echo Error: No servers were specified
                           call:HELP
                           goto :EXITFORLOOP
                        )
                        @REM set a flag to indicate all further arguments are server 
                        @REM names
                        set _SERVERARGS=yes
                     ) else (
                        if %%E equ -all (
                           call:clearCfgForAllProfiles
                           call:clearWASHomeCfg
                           goto :EXITFORLOOP
                        ) else (
                           if %%E equ -profile (
                              @REM set a flag to indicate the next argument is a 
                              @REM profile name
                              set _PROFILEARG=yes
                           ) else (
                              if %%E equ -profileConfig (
                                 @REM set a flag to indicate the next argument is a 
                                 @REM profile name
                                 set _PROFILECONFIGARG=yes
                              ) else (
                                 echo input argument %%E not valid
                                 call:HELP
                                 goto :EXITFORLOOP
                              )
                           )
                        )
                     )
                  )
               )
            )
         )    
      )
   )
)
:EXITFORLOOP


@REM Do a final check to verify all arguments passed to this script were 
@REM processed by the main argument do loop. If not, issue a warning 
@REM message and list the arguments that were ignored.

set /A _DIFFCOUNT1=_NUMARGS - _ARGCOUNT
if %_DIFFCOUNT1% GTR 0 (
   set _COUNT=0
   for %%E in (%*) do ( 
       set /A _COUNT+=1
       if !_COUNT! GTR !_ARGCOUNT! (
         set _IGNOREDARGS=!_IGNOREDARGS! %%E
       ) 
   )
   echo Warning - the following arguments were ignored: !_IGNOREDARGS!
)

@endlocal & set MYERRORLEVEL=%RC%
exit /b %MYERRORLEVEL%
goto :EOF

:HELP
	echo osgiCfgInit.bat [-all^|-washome^|-profile profileName^|-profileConfig profileName^|-servers serverName1 serverName2..etc].
goto :EOF

@REM Clears the osgi config of the server passed as an argument
:clearCfgForServer
   @REM echo clearCfgForServer %1
   set _ORIG_OSGI_CFG=%OSGI_CFG%
   set _SERVER_CFG_AREA="%USER_INSTALL_ROOT:"=%\servers\%1\configuration"
   if exist %_SERVER_CFG_AREA% (
      set OSGI_CFG=-Dosgi.configuration.area=%_SERVER_CFG_AREA%
      %JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" !OSGI_INSTALL! !OSGI_CFG! !USER_INSTALL_PROP! -Dwas.install.root="!WAS_HOME:"=!" -classpath "!WAS_CLASSPATH!" com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -clean -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.debug.osgi.OsgiCfgInit
	   if !ERRORLEVEL! NEQ 0 (
		   echo Clean up failed for server %1.
		   set RETCODE=!ERRORLEVEL!
	   ) else (
		   echo OSGi server cache successfully cleaned for %_SERVER_CFG_AREA%.
	   )
   )
   set OSGI_CFG=%_ORIG_OSGI_CFG%
goto :EOF

@REM Clears the osgi config from just the profile/<arg>/configuration 
:clearProfileCfgForSpecifiedProfile
   @REM echo clearProfileCfgForSpecifiedProfile %1
   set _PROFILESCRIPT="%WAS_HOME:"=%\properties\fsdb\%1.bat"
   if exist %_PROFILESCRIPT% (
      @REM Note: there is one .bat per profile in the fsdb directory.
      @REM Each script is named to match the profile name.
      @REM 
      @REM Running the fsdb/*.bat file sets up the WAS_USER_SCRIPT
      @REM environment variable to point to the setupCmdLine.bat in 
      @REM the profile directory specified by the argument passed
      @REM to this function.      
      call "%_PROFILESCRIPT%"
      if exist "!WAS_USER_SCRIPT!" (
         call "%~dp0setupCmdLine.bat"
	      %JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" !OSGI_INSTALL! !OSGI_CFG! !USER_INSTALL_PROP! -Dwas.install.root="!WAS_HOME:"=!" -classpath "!WAS_CLASSPATH!" com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -clean -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.debug.osgi.OsgiCfgInit
	      if !ERRORLEVEL! NEQ 0 (
		      echo Clean up failed for profile !USER_INSTALL_ROOT!.
		      set RETCODE=!ERRORLEVEL!
            goto :EOF
	      ) else (
		      echo OSGi profile cache successfully cleaned for !USER_INSTALL_ROOT!.
	      )
      ) else (
         echo !WAS_USER_SCRIPT! file was not found
      )
   ) else (
      echo !_PROFILESCRIPT! file was bit found
   )
goto :EOF


@REM Clears the osgi profile and server caches in the profile you are 
@REM executing the command from. 
:clearCfgForCurrentProfile
   @REM echo clearCfgForCurrentProfile
	%JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" !OSGI_INSTALL! !OSGI_CFG! !USER_INSTALL_PROP! -Dwas.install.root="!WAS_HOME:"=!" -classpath "!WAS_CLASSPATH!" com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -clean -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.debug.osgi.OsgiCfgInit
	if !ERRORLEVEL! NEQ 0 (
		echo Clean up failed for profile !USER_INSTALL_ROOT!.
		set RETCODE=!ERRORLEVEL!
      goto :EOF
	) else (
		echo OSGi profile cache successfully cleaned for !USER_INSTALL_ROOT!\configuration.
	)
   
   
   @REM Now clear the profile/servers/<ServerName>/configuration cache for
   @REM each server under this profile
   set _SERVERSDIR="%USER_INSTALL_ROOT:"=%\servers\*"
   for /D %%J in (!_SERVERSDIR!) do (
      set _SERVER_CFG_AREA=%%J\configuration
      if exist !_SERVER_CFG_AREA! (
         set OSGI_CFG=-Dosgi.configuration.area="!_SERVER_CFG_AREA!"
         %JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" !OSGI_INSTALL! !OSGI_CFG! !USER_INSTALL_PROP! -Dwas.install.root="!WAS_HOME:"=!" -classpath "!WAS_CLASSPATH!" com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -clean -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.debug.osgi.OsgiCfgInit
	      if !ERRORLEVEL! NEQ 0 (
            echo Clean up failed for server !_SERVER_CFG_AREA!.
		      set RETCODE=!ERRORLEVEL!
	      ) else (
            echo OSGi server cache successfully cleaned for !_SERVER_CFG_AREA!.
	      )
      )
   )
goto :EOF

@REM Clears the osgi config from just the profile/<arg>/configuration 
:clearCfgForSpecifiedProfile
   @REM echo clearCfgForSpecifiedProfile %1
   set _PROFILESCRIPT="%WAS_HOME:"=%\properties\fsdb\%1.bat"
   if exist %_PROFILESCRIPT% (
      @REM Note: there is one .bat per profile in the fsdb directory.
      @REM Each script is named to match the profile name.
      @REM 
      @REM Running the fsdb/*.bat file sets up the WAS_USER_SCRIPT
      @REM environment variable to point to the setupCmdLine.bat in 
      @REM the profile directory specified by the argument passed
      @REM to this function.      
      call "%_PROFILESCRIPT%"
      if exist "!WAS_USER_SCRIPT!" (
         call "%~dp0setupCmdLine.bat"
         call:clearCfgForCurrentProfile
      ) else (
         echo !WAS_USER_SCRIPT! file was not found
      )
   )
goto :EOF

@REM Clear osgi profile and server caches in all profiles
:clearCfgForAllProfiles
   @REM echo clearCfgForAllProfiles
	for %%E in ("%WAS_HOME:"=%\properties\fsdb\*.bat") do (
      if exist %%E (
   		call "%%E"
	   	if exist "!WAS_USER_SCRIPT!" (
	   		call "%~dp0setupCmdLine.bat"
            call:clearCfgForCurrentProfile
         )
      )
		set WAS_USER_SCRIPT=
	)
goto :EOF

@REM Clear osgi cache locatated in <WAS_HOME>/configuration
:clearWASHomeCfg
   @REM echo clearWASHomeCfg
   set OSGI_INSTALL=-Dosgi.install.area="!WAS_HOME:"=!"
	set OSGI_CFG=-Dosgi.configuration.area="!WAS_HOME:"=!"\configuration

	%JAVA_EXE% -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" !OSGI_INSTALL! !OSGI_CFG! -Duser.install.root="!WAS_HOME:"=!" -Dwas.install.root="!WAS_HOME:"=!" -classpath "!WAS_CLASSPATH!" com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash -clean -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.debug.osgi.OsgiCfgInit
	if !ERRORLEVEL! NEQ 0 (
		echo Clean up failed for !WAS_HOME!\configuration.
		set RETCODE=!ERRORLEVEL!
	) else (
		echo OSGi cache successfully cleaned for !WAS_HOME!\configuration.
	)
goto :EOF

:getNumberOfCmdLineArgs
   set _NUMARGS=0
   for %%x in (%*) do Set /A _NUMARGS+=1
goto :EOF
