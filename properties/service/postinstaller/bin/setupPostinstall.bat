SET CUR_DIR=%cd%
cd /d "%~dp0..\..\..\..\"
SET WAS_HOME=%cd%
cd /d "%CUR_DIR%"

call "%WAS_HOME%\bin\sdk\_setupSdk.bat"  "%WAS_HOME%"
SET WAS_ENDORSED_DIRS=%WAS_HOME%\endorsed_apis;%JAVA_HOME%\jre\lib\endorsed
