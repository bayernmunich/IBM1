@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-J34 (C) COPYRIGHT International Business Machines Corp., 2007
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@echo off 
REM Usage: jobRecovery server_name [options] 
REM        options:
REM        -profileName <profile>
REM        -username <authentication username>
REM        -password <authentication password>
setlocal
        
if %1a==a goto parm_error 
set WAS_SERVER=%1   

shift
shift

set WAS_PROFILE_NAME=
set WAS_USER_NAME=
set WAS_PASSWORD=
  
:next
if #%0 == # goto end_loop
  goto GET_OPTIONS
:return
  shift
  goto next
:end_loop

set BINDIR=%~dp0

cd ..
set INSTALL_DIR=%CD%

if "%WAS_PROFILE_NAME%"=="" (set LOCATION=%INSTALL_DIR%) else (set LOCATION=%INSTALL_DIR%\profiles\%WAS_PROFILE_NAME%)

if not exist %LOCATION% (
  echo Directory, %LOCATION%, does not exist.
  echo Do not specify the -profileName option on the jobRecovery command if you are executing it from the profile bin directory.
  goto end
)

cd "%LOCATION%"
if not exist "%LOCATION%\xdtemp" mkdir "%LOCATION%\xdtemp"
if %ERRORLEVEL% NEQ 0 (
  echo Could not create directory, "%LOCATION%\xdtemp".
  goto end
)

cd xdtemp
if not exist xd.job.scheduler.dr.site.takeover echo temp > xd.job.scheduler.dr.site.takeover

cd ../bin

 
REM Start the nodeagent running the scheduler to perform the disaster recovery
echo Starting nodeagent...
call "%~dp0startNode.bat"

REM If the nodeagent didn't start, exit  
 
if %ERRORLEVEL% NEQ 0 (
  echo.
  echo The nodeagent could not be started.  Job recovery failed.  Check the server log for details.
  goto end
)

REM Start the server running the scheduler to perform the disaster recovery
echo Starting server %WAS_SERVER%...
call "%~dp0startServer.bat" %WAS_SERVER%

REM If the server didn't start, exit.

if %ERRORLEVEL% NEQ 0 (  
   echo. 
   echo The specified server %WAS_SERVER% could not be started. Job recovery failed. Check the server log for details. 
   goto end
)

REM Stop the server 
echo Stopping server %WAS_SERVER%...

if "%WAS_USER_NAME%"=="" (call "%~dp0stopServer.bat" %WAS_SERVER%) else (call "%~dp0stopServer.bat" %WAS_SERVER% -username %WAS_USER_NAME% -password %WAS_PASSWORD% )

if %ERRORLEVEL% NEQ 0 echo The specified server %WAS_SERVER% could not be stopped. Check the server log for details.
 
REM Stop the nodeagent 
echo Stopping nodeagent... 
if "%WAS_USER_NAME%"=="" (call "%~dp0stopNode.bat") else (call "%~dp0stopNode.bat" -username %WAS_USER_NAME% -password %WAS_PASSWORD% )
 
if %ERRORLEVEL% NEQ 0 echo The nodeagent could not be stopped. Check the server log for details.

echo Job recovery has been completed.  Check the server logs for any error messages
goto end

REM ---------------------------------------------------------                       
REM Print the usage message
:parm_error
echo.
echo Usage: %0 ^<server^> [options]
echo        options:
echo        -profileName ^<profile^>
echo        -username ^<authenticatin username^>
echo        -password ^<authentication password^>
echo.                  
echo Example: %0 server1 -profileName AppSrv01 -username wsadmin -password wspassword
echo.
goto end


REM subroutine for getting the command options
:GET_OPTIONS
if %0==-profileName set WAS_PROFILE_NAME=%1
if %0==-username set WAS_USER_NAME=%1
if %0==-password set WAS_PASSWORD=%1 
goto :return
     
     
REM ---------------------------------------------------------                       
:end
endlocal
