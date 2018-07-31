@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5724-i63, 5724-H88 (C) COPYRIGHT International Business Machines Corp., 1997,2004, 2010
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@echo off
@setlocal

set CURDIR_=%CD%
set BINDIR_=%~dp0

cd /d %BINDIR_%\..
call .\setupCmdLine.bat

@REM If COMMAND_SDK doesn't contain 32 then run from eclipse64, otherwise run from eclipse32
@REM %COMMAND_SDK:32=% replaces 32 with nothing
if %COMMAND_SDK:32=%==%COMMAND_SDK% (
set PMT_ECLIPSE_DIR=eclipse64) else (
set PMT_ECLIPSE_DIR=eclipse32)
cd /d %BINDIR_%
call .\%PMT_ECLIPSE_DIR%\pmt.bat %*

cd %CURDIR_%

GOTO :EOF
