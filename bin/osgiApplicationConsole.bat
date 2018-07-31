@echo off
rem ****************************************************************************
rem Licensed Materials - Property of IBM
rem
rem 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 Copyright IBM Corp. 2010
rem
rem US Government Users Restricted Rights - Use, duplication or disclosure
rem restricted by GSA ADP Schedule Contract with IBM Corp.
rem ****************************************************************************
rem Launch the OSGI Application Console which allow interrogation of the Application Bundles/Services and packages.
rem
rem called by osgiApplicationConsole.bat <-h hostname> <-o port> <-u userid> <-p password>
rem
rem ****************************************************************************
setlocal

set host=
set port=
set user=
set pwd=

rem call the setupCmdLine to generate the WAS path variables.
call "%~dp0setupCmdLine.bat"
rem Define out aries directory location.

rem iterate through the arguments and call the relevant function
:argloop

if "%1%" == "" goto endargloop
if "%1%" == "-h" goto sethost
if "%1%" == "-o" goto setport
if "%1%" == "-u" goto setuser
if "%1%" == "-p" goto setpwd

rem this is called when we need to move onto the next parameters
:skipargs

shift
shift
goto argloop

rem If we have a host variable then set the host value for wsadmin
:sethost
set host=-host %2%
goto skipargs

rem If we have a port variable then set the port value for wsadmin
:setport
set port=-port %2%
goto skipargs

rem If we have a user variable then set the user value for wsadmin
:setuser
set user=-user %2%
goto skipargs

rem If we have a password variable then set the password value for wsadmin
:setpwd
set pwd=-pwd %2%
goto skipargs

rem This is the main function. It is called when all of the parameters have been processed
:endargloop


rem Point the ariesDir to the feature pack directory (with wildcard to cater for different releases). Then check to see if this exists. If it doesn't, 
rem set it to the plugins.
set ariesDir=%WAS_HOME%\feature_packs\aries
if not exist "%ariesDir%" set ariesDir=%WAS_HOME%\plugins
rem set the ariesOSGIAppDir variable to point to the correct location. This location can be appended to either the plugins or featurepack prefixes.
set ariesOSGIAppDir=%ariesDir%\osgiappbundles\com.ibm.ws.osgi.applications
rem pushd the current directory and switch to the aries dir to allow us to find the jar we want to add to our classpath.
pushd "%ariesOSGIAppDir%\aries"

rem Find the OSGI jar that matches the pattern and put this into another variable
for %%f in (org.eclipse.osgi*.jar) do (set osgijar=%%f)

rem Before invoking the command, switch back to the original working dir rather than the dir that we
rem switched to, to get the osgi jar name.
popd

rem If the OSGi jar was not available in osgiappbundles look in WAS plugins and then return to the original working dir
if not defined osgijar (
pushd "%WAS_HOME%"\plugins
for %%f in (org.eclipse.osgi*.jar) do (set osgijar=%%~ff)
popd
)

set ebaAdminJar=%ariesOSGIAppDir%\com.ibm.ws.eba.admin.jar

rem Finally invoke the osgiApplicationConsole python script adding the osgi jar to the wsadmin classpath
"%WAS_HOME%\bin\wsadmin.bat" -lang jython -profile "%WAS_HOME%\scriptLibraries\osgi\osgiApplicationConsole.py" -wsadmin_classpath "%ariesOSGIAppDir%\aries\%osgiJar%;%ebaAdminJar%" %host% %port% %user% %pwd%

:exitscript
endlocal
