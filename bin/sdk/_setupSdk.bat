@REM  THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM  5724-I63, 5724-H88, 5655-N01, 5733-W61 (C) COPYRIGHT International Business Machines Corp., 1997,2006
@REM  All Rights Reserved * Licensed Materials - Property of IBM
@REM  US Government Users Restricted Rights - Use, duplication or disclosure
@REM  restricted by GSA ADP Schedule Contract with IBM Corp.
@REM 
@REM  DESCRIPTION: This script is called from setupCmdLine.bat and setupClient.bat
@REM  ###########################################################################
@echo off

@REM  ###########################################################################
@REM  pushd "%~dp0" - temp set the drive/path for this script.  Then relative 
@REM  paths can be used.  popd "%~dp0" will restore to the previous setting
@REM  ###########################################################################
pushd "%~dp0"

@REM  ###########################################################################
@REM  Read the cmdDefaultSDK.properties file to get the current value of 
@REM  COMMAND_DEFAULT_SDK ( ..\..\properties\sdk\cmdDefaultSDK.properties )
@REM  ###########################################################################
SETLOCAL ENABLEDELAYEDEXPANSION 
FOR /F "tokens=1-2 delims== " %%a IN ( ..\..\properties\sdk\cmdDefaultSDK.properties ) DO (
  SET command_default_sdk=%%a
  SET value=%%b
  IF "!command_default_sdk!" EQU "COMMAND_DEFAULT_SDK" (
     break
  )   
)
ENDLOCAL & SET COMMAND_DEFAULT_SDK=%value%


SET COMMAND_SDK=%COMMAND_DEFAULT_SDK%

@REM  ###########################################################################
@REM  Call the script that sets the HIGHEST_AVAILABLE_SDK variable
@REM  if the calling script has set USE_HIGHEST_AVAILABLE_SDK to a 
@REM  value of "true"
@REM  ###########################################################################
if  "%USE_HIGHEST_AVAILABLE_SDK%"=="true" (
  if exist "%~dp0_highest_available_sdk.bat" (
     CALL "%~dp0_highest_available_sdk.bat" %*
  ) 
)
@REM  ###########################################################################
@REM  Set the COMMAND_SDK from the output of calling the 
@REM  _highest_available_sdk.bat file above if the calling script has set
@REM  USE_HIGHEST_AVAILABLE_SDK to a value of "true"
@REM  This could not be done in the same if statement ... requires two   
@REM  ###########################################################################
if  "%USE_HIGHEST_AVAILABLE_SDK%"=="true" (   
   if DEFINED HIGHEST_AVAILABLE_SDK (
      SET COMMAND_SDK=%HIGHEST_AVAILABLE_SDK%
   ) 
)
@REM  ###########################################################################                                                                                 
@REM  COMMAND_OVERRIDE_SDK variable exists, its value will be used!
@REM  If variable value is not a valid sdkName this script will fail!
@REM  Valid sdkNames will have the format 1.6_32 (sdk version_bitness)
@REM  ###########################################################################
if  "%USE_COMMAND_OVERRIDE_SDK%"=="true" ( 
  if DEFINED COMMAND_OVERRIDE_SDK (
     SET COMMAND_SDK=%COMMAND_OVERRIDE_SDK%
  )    
)
@REM  ###########################################################################                                                                                 
@REM  Trim trailing blanks 
@REM  ###########################################################################
SET COMMAND_SDK=%COMMAND_SDK: =%

@REM  ###########################################################################
@REM  Call the _setup<sdkname> script to set the corrent JAVA_HOME path
@REM  ###########################################################################
CALL "%~dp0_setupsdk%COMMAND_SDK%.bat"  %*
popd "%~dp0"
