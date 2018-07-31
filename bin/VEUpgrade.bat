
@rem THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@rem 5724-J34 COPYRIGHT International Business Machines Corp. 2006,2007
@rem All Rights Reserved * Licensed Materials - Property of IBM
@rem US Government Users Restricted Rights - Use, duplication or disclosure
@rem restricted by GSA ADP Schedule Contract with IBM Corp.

@echo off
setlocal

echo parms %*

call "%~dp0setupCmdLine.bat" %*

@REM CONSOLE_ENCODING controls the output encoding used for stdout/stderr
@REM    console - encoding is correct for a console window
@REM    file    - encoding is the default file encoding for the system
@REM    <other> - the specified encoding is used.  e.g. Cp1252, Cp850, SJIS
@REM SET CONSOLE_ENCODING=-Dws.output.encoding=console

@SET WAS_XD_V5_INSTALL_ROOT=%1
@SET WAS_INSTALL_ROOT=%WAS_HOME%

@SET %WAS_EXT_DIRS%=%WAS_EXT_DIRS%;%WAS_INSTALL_ROOT%/properties/version/update/config/xd.migration/lib

rem "%JAVA_HOME%\bin\java" %WAS_LOGGING% %CONSOLE_ENCODING% -Xbootclasspath/p:"%WAS_BOOTCLASSPATH%" -DKeepProfileName=true -Dws.ext.dirs="%WAS_EXT_DIRS%" -classpath "%WAS_CLASSPATH%" com.ibm.ws.bootstrap.WSLauncher com.ibm.websphere.migration.XDUpgrade %1 "%WAS_INSTALL_ROOT%" "%USER_INSTALL_ROOT%" %2 %3 %4 %5 %6 %7
rem "%JAVA_HOME%\bin\java" %WAS_LOGGING% %CONSOLE_ENCODING% -Xbootclasspath/p:"%WAS_BOOTCLASSPATH%" -DKeepProfileName=true -Dws.ext.dirs="%WAS_EXT_DIRS%" -classpath "%WAS_CLASSPATH%" com.ibm.ws.bootstrap.WSLauncher com.ibm.websphere.migration.XDUpgrade "-targetwashome" "%WAS_INSTALL_ROOT%" %1 %2 %3 %4 %5 %6 %7 %8 %9
"%JAVA_HOME%\bin\java" %WAS_LOGGING% %CONSOLE_ENCODING% -Xbootclasspath/p:"%WAS_BOOTCLASSPATH%" -DKeepProfileName=true -Dws.ext.dirs="%WAS_EXT_DIRS%" -classpath "%WAS_CLASSPATH%" com.ibm.ws.bootstrap.WSLauncher com.ibm.websphere.migration.XDUpgrade "-targetwashome" "%WAS_INSTALL_ROOT%" %*

endlocal


