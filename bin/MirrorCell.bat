@echo off
SET mode=ALL
SET os=WINDOWS
SET security=true
SET save=true
SET version=51

:Loop
IF "%1" == "" goto Verify
IF "%1" == "-mode" SET mode=%2
IF "%1" == "-nosec" SET security=false
IF "%1" == "-nosave" SET save=false
IF "%1" == "-version" SET version=%2
shift
goto Loop

:Verify

IF EXIST "%WAS_HOME%\lib\legacycell.jar" (
	SET LEGACYJAR="%WAS_HOME%\lib\legacycell.jar"
) ELSE (
	SET LEGACYJAR="%WAS_HOME%\plugins\com.ibm.ws.ve.runtime.common.jar"
)

call "%~dp0setupCmdLine.bat" %*
call java -cp "%LEGACYJAR%" com.ibm.ws.legacycell.launcher.MirrorCell "%WAS_HOME%" %mode% %os% %security% %save% %version%

goto end


:error

echo.
echo Error: missing required arguments
echo.
echo USAGE:
echo    MirrorCell [-mode MODE] [-nosec] [-nosave]
echo.
echo Required
echo.
echo Options
echo    -nosec      Turns Off Encryption of User and Pass
echo    -nosave		Changes Will Not Be Saved (Trial Mode)
echo    -version    Enables read mode for a version other than WebSphere 5.1.x
echo                 i.e. acceptable values could be 6.1, or 61
echo.
echo Where
echo    MODE        PROPSGEN, DIFF, READ, WRITE, or ALL
echo                 ALL if unspecified or invalid MODE
echo.
echo Make sure you surround paths that contain a space (' ') in them (i.e: Program Files) with "" to treat them literally
echo.
echo.

:end






