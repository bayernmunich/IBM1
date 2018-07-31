@echo off
@setlocal

call "%~dp0setupCmdLine.bat"

IF EXIST "%WAS_HOME%\lib\ifixtool.jar" (
	SET IFIXLIB="%WAS_HOME%\lib\ifixtool.jar"
) ELSE (
	SET IFIXLIB="%WAS_HOME%\plugins\com.ibm.ws.ve.runtime.common.jar"
)

"%JAVA_HOME%"\bin\java -Dserver.root="%WAS_HOME%" -Dwas.repository.root="%CONFIG_ROOT%" -classpath "%IFIXLIB%" com.ibm.ws.ifixtool.Cell %*

@endlocal
