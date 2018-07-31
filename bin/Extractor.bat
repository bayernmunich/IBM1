@echo off
if "%WAS_HOME%x" == "x" goto error
call "%~dp0xdaSetupCmdLine.bat"
goto one


:error
echo.
echo Detected that WAS_HOME is not currently set.
echo.
echo Please set the WAS_HOME Environment Variable to your WAS51 Dmgr's Home Path.
echo.
goto end

:one
"%AGENT_JAVA_HOME%"\bin\java -cp "%AGENT_HOME%"\lib\legacycell.jar com.ibm.ws.legacycell.xmlutils.ContextRootExtractor "%WAS_HOME%"\config

:end
