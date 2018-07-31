@REM ---------------------------------------------------------
@REM -- This batch file is an example of how to start ij in 
@REM -- an embedded environment.
@REM --
@REM --
@REM -- This file for use on Windows systems
@REM ---------------------------------------------------------

    
    
@REM -- You may need to modify the values below for a different
@REM -- host, port, user, or password
@REM --
@REM -- This file for use on Windows systems
@REM ---------------------------------------------------------

@echo off

set IJ_HOST=localhost
set IJ_PORT=1527

@REM ---------------------------------------------------------
@REM -- start ij
@REM -- host, port may need to be changed
@REM ---------------------------------------------------------

@call "%~dp0\..\..\..\bin\setupCmdLine.bat"

@REM -- list of jars used to localize Derby
@set __DERBY_LOCALE_JARS_PATH__=%DERBY_HOME%\lib\locales\derbyLocale_cs.jar;%DERBY_HOME%\lib\locales\derbyLocale_de_DE.jar;%DERBY_HOME%\lib\locales\derbyLocale_es.jar;%DERBY_HOME%\lib\locales\derbyLocale_fr.jar;%DERBY_HOME%\lib\locales\derbyLocale_hu.jar;%DERBY_HOME%\lib\locales\derbyLocale_it.jar;%DERBY_HOME%\lib\locales\derbyLocale_ja_JP.jar;%DERBY_HOME%\lib\locales\derbyLocale_ko_KR.jar;%DERBY_HOME%\lib\locales\derbyLocale_pl.jar;%DERBY_HOME%\lib\locales\derbyLocale_pt_BR.jar;%DERBY_HOME%\lib\locales\derbyLocale_ru.jar;%DERBY_HOME%\lib\locales\derbyLocale_zh_CN.jar;%DERBY_HOME%\lib\locales\derbyLocale_zh_TW.jar

"%JAVA_HOME%/bin/java" %DERBY_OPTS% -classpath "%DERBY_HOME%\lib\derbyclient.jar;%DERBY_HOME%\lib\derby.jar;%DERBY_HOME%\lib\derbytools.jar;%DERBY_HOME%\lib\jh.jar;%DERBY_HOME%\lib\derbynet.jar;%__DERBY_LOCALE_JARS_PATH__%" -Dderby.system.home="%DERBY_HOME%" -Dij.driver=org.apache.derby.jdbc.ClientDriver -Dij.protocol=jdbc:derby://%IJ_HOST%:%IJ_PORT%/ org.apache.derby.tools.ij %*
