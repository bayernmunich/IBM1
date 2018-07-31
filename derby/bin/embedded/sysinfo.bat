@REM ---------------------------------------------------------
@REM -- This batch file is an example of how to use sysinfo to get
@REM -- important system information
@REM --
@REM -- This file for use on Windows systems
@REM ---------------------------------------------------------

@REM ---------------------------------------------------------
@REM -- start sysinfo
@REM ---------------------------------------------------------
@echo off
@call "%~dp0\..\..\..\bin\setupCmdLine.bat"

@REM -- list of jars used to localize Derby
@set __DERBY_LOCALE_JARS_PATH__=%DERBY_HOME%\lib\locales\derbyLocale_cs.jar;%DERBY_HOME%\lib\locales\derbyLocale_de_DE.jar;%DERBY_HOME%\lib\locales\derbyLocale_es.jar;%DERBY_HOME%\lib\locales\derbyLocale_fr.jar;%DERBY_HOME%\lib\locales\derbyLocale_hu.jar;%DERBY_HOME%\lib\locales\derbyLocale_it.jar;%DERBY_HOME%\lib\locales\derbyLocale_ja_JP.jar;%DERBY_HOME%\lib\locales\derbyLocale_ko_KR.jar;%DERBY_HOME%\lib\locales\derbyLocale_pl.jar;%DERBY_HOME%\lib\locales\derbyLocale_pt_BR.jar;%DERBY_HOME%\lib\locales\derbyLocale_ru.jar;%DERBY_HOME%\lib\locales\derbyLocale_zh_CN.jar;%DERBY_HOME%\lib\locales\derbyLocale_zh_TW.jar

"%JAVA_HOME%/bin/java" %DERBY_OPTS% -classpath "%DERBY_HOME%\lib\derby.jar;%DERBY_HOME%\lib\derbytools.jar;%DERBY_HOME%\lib\jh.jar;%__DERBY_LOCALE_JARS_PATH__%" -Dderby.system.home="%DERBY_HOME%" org.apache.derby.tools.sysinfo %*
