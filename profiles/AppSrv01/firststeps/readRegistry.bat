@echo off
REM Licensed Materials - Property of IBM
REM 5648-F10 (C) Copyright International Business Machines Corp. 2005 
REM All Rights Reserved
REM US Government Users Restricted Rights- Use, duplication or disclosure
REM restricted by GSA ADP Schedule Contract with IBM Corp.

SET %4=
IF not exist "%TEMP%\%3.regedit" regedit /E "%TEMP%\%3.regedit" %1
IF not exist "%TEMP%\%3.regedit" GOTO :eof
TYPE "%TEMP%\%3.regedit" >"%TEMP%\%3.reg"
DEL /F /Q "%TEMP%\%3.regedit" >nul 2>nul
FOR /f "tokens=1* delims=\=" %%A IN ('TYPE "%TEMP%\%3.reg"') DO IF "{%%~A}" == "{%2}" FOR /F "tokens=* delims=\" %%z in ("%%~B") DO (
    SET %4=%%~z
    GOTO :eof
)
