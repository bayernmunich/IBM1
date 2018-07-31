@REM THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
@REM 5630-A36, 5630-A37, 5724-D18 (C) COPYRIGHT International Business Machines Corp., 1997,2007
@REM All Rights Reserved * Licensed Materials - Property of IBM
@REM US Government Users Restricted Rights - Use, duplication or disclosure
@REM restricted by GSA ADP Schedule Contract with IBM Corp.

@REM Configuration Instance Creation Tool Launcher

@setlocal
@echo off

@REM Bootstrap values ...
call "..\..\..\bin\setupCmdLine.bat"

if exist "%USER_INSTALL_ROOT%\ejbdeploy\configuration"  (
	rmdir /s /q "%USER_INSTALL_ROOT%\ejbdeploy\configuration"
)

if exist "%ITP_LOC%\configuration"  (
	rmdir /s /q "%ITP_LOC%\configuration\org.eclipse.core.runtime"
	rmdir /s /q "%ITP_LOC%\configuration\org.eclipse.osgi"
	rmdir /s /q "%ITP_LOC%\configuration\org.eclipse.update"
	rmdir /s /q "%ITP_LOC%\configuration\org.eclipse.equinox.app"
)

@endlocal
