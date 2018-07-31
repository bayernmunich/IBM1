@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@echo off
setlocal ENABLEDELAYEDEXPANSION

set CUR_DIR=%~dp0
set PROFILE_NAME_CHECK=%1

set _AUTHALL=no
set _AUTHUSER=no
set _AUTHEVERYONE=no
set _USEREXPECTED=no
set _REALMEXPECTED=no
set _USERNAME=
set _REALMNAME=
set PROFILE_NAME=

set argC=0
for %%x in (%*) do Set /A argC+=1
set NUMARGS=%argC%

CALL "%~dp0setupCmdLine.bat" %*
cd /d "%WAS_HOME%\bin"
set BIN_DIR=%cd%

set str=%PROFILE_NAME_CHECK:~0,1%

if "%str%" == "~0,1" (
	set PROFILE_NAME=
) else (
	if "%str%" == "-" (
		set PROFILE_NAME=
	) else (
		set PROFILE_NAME=%1
	)
)

for %%E in (%*) do (
	if !_USEREXPECTED! equ YES (
		set _USERNAME=%%E
		set _USEREXPECTED=NO
		set _REALMEXPECTED=YES
	) else (
		if !_REALMEXPECTED! equ YES (
			set _REALMNAME=%%E
			set _REALMEXPECTED=NO
		) else (
			if %%E equ -authorizeAllAuthenticated (
				if !_AUTHUSER! equ YES (
					echo -authorizeAll, -authorizeEveryone and -authorizeUser are mutually exclusive arguments
					goto :HELP
				)
				if !_AUTHEVERYONE! equ YES (
					echo -authorizeAll, -authorizeEveryone and -authorizeUser are mutually exclusive arguments
					goto :HELP
				)
				set _AUTHALL=YES
			) else (
				if %%E equ -authorizeEveryone (
					if !_AUTHUSER! equ YES (
						echo -authorizeAll, -authorizeEveryone and -authorizeUser are mutually exclusive arguments
						goto :HELP
					)
					if !_AUTHALL! equ YES (
						echo -authorizeAll, -authorizeEveryone and -authorizeUser are mutually exclusive arguments
						goto :HELP
					)
					set _AUTHEVERYONE=YES
				) else (
					if %%E equ -authorizeUser (
						if !_AUTHEVERYONE! equ YES (
							echo -authorizeAll, -authorizeEveryone and -authorizeUser are mutually exclusive arguments
							goto :HELP
						)
						if !_AUTHALL! equ YES (
							echo -authorizeAll, -authorizeEveryone and -authorizeUser are mutually exclusive arguments
							goto :HELP
						)
						set _AUTHUSER=YES
						set _USEREXPECTED=YES
					) else (
						set THISARG=%%E
						set THISCHECK=!THISARG:~0,1!

						if "!THISCHECK!" == "-" (
							echo Unknown argument detected: !THISARG!
							echo.
							goto :HELP
						)
					)
				)
			) 
		)
	)
)

if "!_REALMNAME!" equ "" (
	echo Error: Both a user and realm must be specified
	echo.
	echo. Example: uteConfig AppSrv01 -authorizeUser wasadmin defaultWIMFileBasedRealm
	echo.
)
		
@REM Determine if the target WebSphere installation contains a profile at all
SET CMD="%BIN_DIR%\manageprofiles.bat" -listProfiles

CALL %CMD% > "%HOMEDRIVE%%HOMEPATH%\utetmp"

findstr /C:"[]" "%HOMEDRIVE%%HOMEPATH%\utetmp" > NUL 2>&1

SET RC=%ERRORLEVEL%
del "%HOMEDRIVE%%HOMEPATH%\utetmp"


if (%RC%) == (0) (
	echo Error: Target WebSphere installation "%WAS_HOME%" does not contain a profile
	cd /d "%CUR_DIR%"
	@endlocal & exit /b 8
)

@REM Determine if the specified profile exists (if one was specified)
if (%PROFILE_NAME%) == () (
	GOTO skipcheck
)

SET CMD="%BIN_DIR%\manageprofiles.bat" -getPath -profileName %PROFILE_NAME%
CALL %CMD% > "%HOMEDRIVE%%HOMEPATH%\utetmp"
findstr /C:"Cannot retrieve" "%HOMEDRIVE%%HOMEPATH%\utetmp" > NUL 2>&1
SET RC=%ERRORLEVEL%

if (%RC%) == (0) (
	echo Profile %PROFILE_NAME% does not exist
	del "%HOMEDRIVE%%HOMEPATH%\utetmp"
	cd /d "%CUR_DIR%"
	@endlocal & exit /b 8
)

set /p PROFILE_PATH= < "%HOMEDRIVE%%HOMEPATH%\utetmp"
set PROFILE_PATH="%PROFILE_PATH%"
del "%HOMEDRIVE%%HOMEPATH%\utetmp"

:skipcheck

if (%PROFILE_NAME%) == () (
	set PROFILE_PATH="%USER_INSTALL_ROOT%"
)
cd /d "%PROFILE_PATH%"

set PROFILE_SETUPCMDLINE=%PROFILE_PATH%\bin\setupCmdLine.bat

set WSADMIN=%PROFILE_PATH%\bin\wsadmin.bat

call %PROFILE_SETUPCMDLINE%

@REM Determine if the scheduler is already configured on the target profile
findstr /C:"LongRunningScheduler" %PROFILE_PATH%\config\cells\%WAS_CELL%\nodes\%WAS_NODE%\serverindex.xml > NUL 2>&1

SET RC=%ERRORLEVEL%

if (%RC%) == (0) (
  echo UTE already configured on profile
  cd /d "%CUR_DIR%"
  @endlocal & exit /b 8
)

@REM Determine if the target profile is the correct type (appserver)
findstr /C:"com.ibm.ws.profile.type=BASE" %PROFILE_PATH%\properties\profileKey.metadata > NUL 2>&1

SET RC=%ERRORLEVEL%

if not (%RC%) == (0) (
	echo Error: Target profile must be an Application Server profile.
	cd /d "%CUR_DIR%"
	@endlocal & exit /b 8
)


if not exist gridDatabase (
	mkdir gridDatabase
)

cd /d "%PROFILE_PATH%\gridDatabase"

"%JAVA_HOME%\bin\java" %JAVA_DEBUG%  -Djava.ext.dirs="%WAS_HOME%/derby/lib" -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij "%WAS_HOME%/util/Batch/CreateLRSCHEDTablesDerby.ddl"
SET RC=%ERRORLEVEL%

if not (%RC%) == (0) (
  echo Error occurred while running CreateLRSCHEDTablesDerby.ddl
  @endlocal & exit /b 8
)

set UTECONFIG_SCRIPT="%WAS_HOME%/util/Batch/deployGridSchedulerAndEndpoint.py"

call %WSADMIN% -conntype NONE -f %UTECONFIG_SCRIPT%

SET RC=%ERRORLEVEL%


if not (%RC%) == (0) (
  echo Error occurred while running deployGridSchedulerAndEndpoint.py
  cd /d "%CUR_DIR%"
  @endlocal & exit /b 8
)

set UTECONFIG_SCRIPT="%WAS_HOME%/util/Batch/setGridSchedulerTarget.py"
call %WSADMIN% -conntype NONE -f %UTECONFIG_SCRIPT%
SET RC=%ERRORLEVEL%

if not (%RC%) == (0) (
  echo Error occurred while running setGridSchedulerTarget.py
  cd /d "%CUR_DIR%"
  @endlocal & exit /b 8
)

set UTECONFIG_SCRIPT="%WAS_HOME%/util/Batch/createBatchWorkManager.py"
call %WSADMIN% -conntype NONE -f %UTECONFIG_SCRIPT%
SET RC=%ERRORLEVEL%

if not (%RC%) == (0) (
  echo Error occurred while running createBatchWorkManager.py
  cd /d "%CUR_DIR%"
  @endlocal & exit /b 8
)

set UTECONFIG_SCRIPT="%WAS_HOME%/util/Batch/enableStartupService.py"
call %WSADMIN% -conntype NONE -f %UTECONFIG_SCRIPT%
SET RC=%ERRORLEVEL%

if not (%RC%) == (0) (
  echo Error occurred while running enableStartupService.py
  cd /d "%CUR_DIR%"
  @endlocal & exit /b 8
)

if %_AUTHALL% equ YES (
goto :AUTHORIZE_ALL
)

if %_AUTHEVERYONE% equ YES (
goto :AUTHORIZE_EVERYONE
)

if %_AUTHUSER% equ YES (
goto :AUTHORIZE_USER
)

@endlocal
goto :SUCCESS

:AUTHORIZE_ALL
set AUTHUSERS_SCRIPT="%WAS_HOME%/util/Batch/setUserRoles.py"
call %WSADMIN% -conntype NONE -f %AUTHUSERS_SCRIPT% -authorizeAllAuthenticated
SET RC=%ERRORLEVEL%

if not (%RC%) == (0) (
  echo Error occurred while running setUserRoles.py
  cd /d "%CUR_DIR%"
  @endlocal & exit /b 8
)
goto :SUCCESS

:AUTHORIZE_EVERYONE
set AUTHUSERS_SCRIPT="%WAS_HOME%/util/Batch/setUserRoles.py"
call %WSADMIN% -conntype NONE -f %AUTHUSERS_SCRIPT% -authorizeEveryone
SET RC=%ERRORLEVEL%

if not (%RC%) == (0) (
  echo Error occurred while running setUserRoles.py
  cd /d "%CUR_DIR%"
  @endlocal & exit /b 8
)
goto :SUCCESS

:AUTHORIZE_USER
set AUTHUSERS_SCRIPT="%WAS_HOME%/util/Batch/setUserRoles.py"
call %WSADMIN% -conntype NONE -f %AUTHUSERS_SCRIPT% -authorizeUser %_USERNAME% %_REALMNAME%
SET RC=%ERRORLEVEL%

if not (%RC%) == (0) (
  echo Error occurred while running setUserRoles.py
  cd /d "%CUR_DIR%"
  @endlocal & exit /b 8
)
goto :SUCCESS

:HELP
	echo Usage: uteConfig [profileName] [-authorizeAllAuthenticated] || [-authorizeEveryone] || [-authorizeUser [username] [realm name]]
goto :EOF

:SUCCESS
echo UTE configured successfully