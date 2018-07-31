@rem Copyright IBM Corp. 2001, 2010

@echo off
setlocal
CALL "%~dp0setupCmdLine.bat" %*
  
if "%JAVA_HOME%"=="%JAVA_JRE%" (
   set "EXT"="%JAVA_HOME%\lib\ext"
) else (
   set "EXT"="%JAVA_HOME%\jre\lib\ext"
)
set CP="%EXT%\ibmjceprovider.jar;%EXT%\ibmjcefw.jar;%EXT%\US_export_policy.jar;%EXT%\local_policy.jar;%EXT%\ibmpkcs.jar;%WAS_HOME%\lib\gskikm.jar;%EXT%"
set PATH=%PATH%;%GIP%

if "%JAVA_HOME%"=="%JAVA_JRE%" (
   start "iKeyMan" "%JAVA_HOME%\bin\javaw" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -DADD_CMS_SERVICE_PROVIDER_ENABLED=true -classpath %CP% com.ibm.gsk.ikeyman.Ikeyman
) else (
   start "iKeyMan" "%JAVA_HOME%\jre\bin\javaw" -Djava.endorsed.dirs="%WAS_ENDORSED_DIRS%" -DADD_CMS_SERVICE_PROVIDER_ENABLED=true -classpath %CP% com.ibm.gsk.ikeyman.Ikeyman
)

endlocal

GOTO :EOF
