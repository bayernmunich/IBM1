@REM ---------------------------------------------------------
@REM -- This batch file is an example of how to run the Cloudscape
@REM -- migration tool
@REM --
@REM -- 
@REM -- This file for use on Windows systems
@REM ---------------------------------------------------------
@REM -- usage: db2jMigrate.bat  [old dbname] [new dbname]

@REM --      command below can be modify with the following options:
@REM -- 
@REM --         -Ddb2j.migrate.ddlOnly=true Do not perform migration. Only
@REM --                 generate the old DDL file, <sourceDBname>.sql, and
@REM --                 the new DDL file (see dbj2.migrate.ddlFile option).
@REM --                 The default is false.
@REM -- 
@REM --         -Ddb2j.migrate.appendLogs=true Do not overwrite output logs.
@REM --                 The default is false.
@REM -- 
@REM --         -Ddb2j.migrate.ddlFile=<name> Write new DDL to file <name>
@REM --                 to create the v 10 DB.
@REM --                 The default is <sourceDBName>_newDDL.sql
@REM --        
@REM --         -Ddb2j.migrate.disableNationalCharMigrate=true
@REM --              disables National Char Migrate.  Default in WAS is true 
@REM --
@REM --



@echo off
@call "%~dp0\..\..\..\bin\setupCmdLine.bat"


@if .%1 == . goto ERROR
set OLD_DB_URL=jdbc:db2j:%1

@if .%2 == . goto ERROR
set NEW_DB=%2

set LOGFILE="%DERBY_HOME%\%~n1_migrationLog.log"
set DEBUGFILE="%DERBY_HOME%\%~n1_migrationDebug.log"


         
"%JAVA_HOME%/bin/java" -classpath "%DERBY_HOME%\migration\migratetoderby.jar;%DERBY_HOME%\lib\derby.jar" -Ddb2j.migrate.disableNationalCharMigrate=true -Ddbj.migrate.verbose=true -Ddb2j.system.home="%DERBY_HOME%" -Dderby.system.home="%DERBY_HOME%" -Ddb2j.migrate.newDBURL=jdbc:derby:%2 -Ddb2j.migrate.migrateLog="%LOGFILE%" -Ddb2j.migrate.debugLog="%DEBUGFILE%" com.ibm.db2j.tools.MigrateFrom51 %OLD_DB_URL%
goto DONE
     
:ERROR
@echo    USAGE: db2jMigrate.bat  [old dbname] [new dbname]

:DONE
 
@REM now delete the variables              
set OLD_DB_URL=
set NEW_DB=



