@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5630-A36, 5630-A37, 5724-D18 (C) COPYRIGHT International Business Machines Corp., 2004,2005
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM Utility to remove the proxy server templates from an existing proxy server profile.
@REM
@REM Usage: unaugmentProxyServer.bat <ProfileName>
@REM 

@echo off
@setlocal

goto deprecated

REM call "%~dp0setupCmdLine.bat"
REM set PROFILE_NAME=%1
REM if not defined PROFILE_NAME (
REM	goto usage
REM )
REM call "%WAS_HOME%\bin\wasprofile.bat" "-unaugment" "-profileName" "%PROFILE_NAME%"
REM goto end

:usage
	echo Usage: %0 ProfileName
	goto end
	
: deprecated
   echo The %0 command is deprecated and no longer required.
   goto end
   	
:end
