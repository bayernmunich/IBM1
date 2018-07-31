@echo off
setlocal

if defined WAS_HOME goto :RUN

if not exist "%~dp0setupCmdLine.bat" goto :NOWAS

call "%~dp0setupCmdLine.bat"
goto :RUN
 
:NOWAS
	echo Please set your WAS_HOME variable
	goto :END
	
:RUN
	echo %WAS_HOME%
	%WAS_HOME%\java\bin\java -Xms128M -Xmx512M -cp %WAS_HOME%\lib\odcnd.jar com.ibm.ws.odc.nd.util.PluginMergeTool %*

:END
	endlocal