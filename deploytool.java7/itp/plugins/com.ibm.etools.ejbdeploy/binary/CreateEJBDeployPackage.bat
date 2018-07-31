@echo off

if .%1==. goto bad
if not .%2==. goto bad

setlocal

set buildEclipseDir=%~f1

set destination=%buildEclipseDir%\..\itp
set plugins_dir=%buildEclipseDir%\plugins
set pluginlist_file=%temp%\pluginlist.txt

set base=%plugins_dir%\com.ibm.etools.ejbdeploy
if not exist %base% set base=%plugins_dir%\com.ibm.etools.ejbdeploy_*
for /d %%i in (%base%) do set ejbdeploy_dir=%%i
echo Using plugin dir: %ejbdeploy_dir%

set base=%plugins_dir%\com.ibm.etools.ejbdeploy.nl1
if not exist %base% set base=%plugins_dir%\com.ibm.etools.ejbdeploy.nl1_*
for /d %%i in (%base%) do set ejbdeploynl_dir=%%i
echo Using NL plugin dir: %ejbdeploynl_dir%

if not exist %plugins_dir% goto not_exist
set itp_loc=%buildEclipseDir%
set was_home=%buildEclipseDir%\..\runtimes\base_v5
set java_home=%was_home%\java

if exist %pluginlist_file% erase /f %pluginlist_file%
if not exist tmp_ md tmp_
copy /b %ejbdeploy_dir%\runtime\batch.jar %itp_loc%
copy /b %ejbdeploynl_dir%\batch_nl1.jar %itp_loc%

call %ejbdeploy_dir%\binary\ejbdeploy %ejbdeploy_dir%\runtime\ejbdeploy.jar tmp_ \fake.jar -pluginlist %pluginlist_file% -keep
erase %itp_loc%\batch.jar

if not exist %pluginlist_file% goto list_failed
rd tmp_ /s/q

if not exist %destination% md %destination%
for /f %%i in (%pluginlist_file%) do echo a | xcopy "%%i\*" "%destination%\plugins\%%~nxi\*" /s

set base=%destination%\plugins\com.ibm.etools.ejbdeploy
if not exist %base% set base=%destination%\plugins\com.ibm.etools.ejbdeploy_*
for /d %%i in (%base%) do set ejbdeploy_dest_dir=%%i

echo a | xcopy "%buildEclipseDir%\install\*" "%destination%\install\*" /s
erase /f %destination%\install\*.cfg
%ejbdeploy_dest_dir%\binary\unctrlm %ejbdeploy_dest_dir%\binary\ejbdeploy.sh
erase %ejbdeploy_dest_dir%\binary\create*
erase %ejbdeploy_dest_dir%\binary\unctrlm*
echo a | xcopy %ejbdeploy_dest_dir%\binary\* %destination%\* 
echo a | xcopy %ejbdeploy_dest_dir%\runtime\batch.jar %destination%\* 
for /d %%i in (%destination%\plugins\com.ibm.etools.logging.util*) do rd %%i\bin /s/q
erase %destination%\plugins\*.zip /s/f/q
erase %destination%\plugins\*.gif /s/f/q
erase %destination%\plugins\*.old /s/f/q
erase %destination%\plugins\*.cat /s/f/q

goto done

rem *****************************
:list_failed
echo ***Error: Attempt to list required plugins failed
type tmp_\fake._\.metadata\.log
goto done

rem *****************************
:not_exist
echo ***Error: Plugins dir (%plugins_dir% ) does not exist
goto done

rem *****************************
:bad
echo Format: CreateEJBDeployPackage existingEclipseDir 
echo (Note: existingEclipseDir\plugins must exist)

rem *****************************
:done

endlocal