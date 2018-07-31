@REM  THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM  5724-I63, 5724-H88, 5655-N01, 5733-W61 (C) COPYRIGHT International Business Machines Corp., 1997,2006
@REM  All Rights Reserved * Licensed Materials - Property of IBM
@REM  US Government Users Restricted Rights - Use, duplication or disclosure
@REM  restricted by GSA ADP Schedule Contract with IBM Corp.
@REM 
@REM  DESCRIPTION: PROFILE_COMMAND_SDK is set via the managesdk.bat command
@REM  ###########################################################################
@echo off
SET PROFILE_COMMAND_SDK=sdkname
SET COMMAND_SDK=%PROFILE_COMMAND_SDK%

@REM  ###########################################################################
@REM  Call the script that sets the HIGHEST_AVAILABLE_SDK variable
@REM  if the calling script has set USE_HIGHEST_AVAILABLE_SDK to a 
@REM  value of "true"
@REM  ###########################################################################
if  "%USE_HIGHEST_AVAILABLE_SDK%"=="true" (
  if exist "%WAS_HOME%\bin\sdk\_highest_available_sdk.bat" (
     CALL "%WAS_HOME%\bin\sdk\_highest_available_sdk.bat" %*
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

@REM call the _setupsdk<sdkname> script to set the corrent JAVA_HOME path
CALL "%WAS_HOME%\bin\sdk\_setupsdk%COMMAND_SDK%.bat"  %*
