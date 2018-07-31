@rem Copyright IBM Corp. 2001
@echo off
setlocal
if "%ITP_LOC%"=="" call setupCmdLine.bat
if "%ITP_LOC%"=="" goto darn

@REM For debugging the utility itself
@REM set WAS_DEBUG=-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777
@REM For debugging using jdb
@REM Look for Listening for transport dt_shmem at address: javadebug
@REM and run <java>/bin/jdb -attach javadebug
@REM set JDB_DEBUG=-Xdebug -Xrunjdwp:transport=dt_shmem,server=y,suspend=n

if "%EJBDEPLOY_JAVA_HOME%"=="" ( set EJBDEPLOY_JAVA_HOME="%JAVA_HOME%"
) else ( echo "using JRE in %EJBDEPLOY_JAVA_HOME%" )

if "%EJBDEPLOY_JVM_HEAP%"=="" ( set EJBDEPLOY_JVM_HEAP=-Xms256m -Xmx256m
) else ( echo "using JVM heap %EJBDEPLOY_JVM_HEAP%" )

set EJBDEPLOY_JAVA_HOME=%EJBDEPLOY_JAVA_HOME:"=%
set bootpath=%ITP_LOC%\batchboot.jar;%EJBDEPLOY_JAVA_HOME%\jre\lib\ext\iwsorbutil.jar
set ejbd_cp=%ITP_LOC%\batch2.jar;%ITP_LOC%\batch2_nl1.jar;%ITP_LOC%\batch2_nl2.jar
set WAS_EXT_DIRS=%WAS_HOME%\plugins;%WAS_EXT_DIRS%

"%EJBDEPLOY_JAVA_HOME%\bin\java" -Ditp.loc="%ITP_LOC%" %EJBDEPLOY_JVM_ARGS% -Dorg.osgi.framework.bootdelegation=* -Dwas.install.root="%WAS_HOME%" -Dwebsphere.lib.dir="%WAS_HOME%\lib" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -Dws.ext.dirs="%WAS_HOME%\eclipse\plugins\j2ee.javax_1.4.0";"%WAS_HOME%\eclipse\plugins\com.ibm.ws.runtime.eclipse_1.0.0";"%WAS_EXT_DIRS%" -Dcom.ibm.sse.model.structuredbuilder="off" -cp "%ejbd_cp%" -Xbootclasspath/a:"%bootpath%" -Xj9 -Xquickstart -Xverify:none %EJBDEPLOY_JVM_HEAP% %WAS_DEBUG% %JDB_DEBUG% com.ibm.etools.ejbdeploy.EJBDeploy %*
goto end

:darn
echo need to set ITP_LOC

:end

endlocal
