@echo off
REM
REM Licensed Materials - Property of IBM
REM (C) Copyright IBM Corp.  2013.  ALL RIGHTS RESERVED 
REM 5724-I63, 5724-H88, 5655-N02, 5733-W70
REM US Government Users Licensed Rights - Use, duplication, or disclosure
REM licensed by GSA ADP Schedule Contract with IBM Corp.
REM
REM ----------------------------------------------------------------------------
REM
REM Upgrade the SIBus DB  schema from lower version to v8.5 or higher
REM
REM Usage: sibDBUpgrade.bat runUpgrade=true or false \
REM                  dbUser=db_user \
REM 		     dbSchema=db_schema_name \
REM		     dbType=db_type \
REM                  [dbName=db_name] \
REM                  [dbPassword=db_password] \ 
REM           	     [dbServerName=db_server_name ]\
REM                  [dbNode=db_node_name]  \
REM		     [oracleHome=oracle_home] \
REM                  [scriptDir=gen_script_dir]
REM                  [permanent=number of permanent tables]
REM                  [temporary=number of temporary tables]
REM
REM Where:
REM   runUpgrade=true or false    		- Required, Specify true to run the upgrade.
REM                              	      		    Specify false to generate ddl scripts only. 
REM   dbUser=db_user              		- Required, UserID for Database.
REM   dbSchema=db_schema_name     		- Required, Schema name where particular ME associated with it, in the case of Oracle and Informix mention db_schema_user
REM   dbType=db_type              		- Required, Supported Database types are DB2, Derby, Oracle, SqlServer, Sybase OR Informix
REM   dbName=db_name              		- Optional, Database name if runUpgrade is true.
REM   dbPassword=db_password      		- Optional, Password. DB2 will prompt if not specified.
REM   dbNode=db_node_name         		- Optional, Database node name. This is required 
REM                    			      		    if the current machine has db2 client.
REM   dbServerName=db_server_name 		- Optional, Database server name. This is required if upgrade is for SYBASE database or SqlServer. 
REM   oracleHome=oracle_home      		- Optional, Path to Oracle Home if db_type=Oracle 
REM   scriptDir=gen_script_dir    		- Optional, Directory to generate the DDL scripts.      
REM                    			      		    If not specified, the scripts will be generated in   
REM                                           		    <current_dir>\SIBusDBUpgrade 
REM   permanent=number of permanent tables   	- Optional, Specify Number greater than 0
REM   temporary=number of temporary tables   	- Optional, Specify Number greater than 0 
REM  Example 1:                                                             
REM     sibDBUpgrade runUpgrade=false dbUser=db2inst1  dbSchema=SIBusMESchema dbType=DB2
REM
REM  Example 2:                                                             
REM     sibDBUpgrade runUpgrade=true dbName=SIBus dbUser=db2inst1 dbSchema=SIBusMESchema dbType=DB2
REM
REM  Example 3(for z/OS, Informix, Derby - -runUpgrade must false, no execution of scripts): 
REM     sibDBUpgrade runUpgrade=false dbName=SIBus dbUser=db2inst1 dbSchema=SIBusMESchema dbType=DB2
REM     
REM Return Codes:  0 for success, 1 for fail
REM --------------------------------------------------------------------------

setlocal

%~d0
cd %~p0

REM initialize
SET RC=0
SET SCRIPT_DIR=%CD%
SET DB_NAME=
SET DB_SCHEMA=
SET DB_TYPE=
SET DB_USER=
SET DB_PASSWORD=
SET DB_NODE=
SET RUN_UPGRADE=
SET IS_ATTACHED=0
SET IS_CONNECTED=0

SET ORACLE_ROLE=sysdba
SET SERVER_NAME=

REM for accepting number of temporary and permanent table  @run time
SET TEMP_TABLE=1
SET PERM_TABLE=1
SET STREAM_TABLE=1
IF "%1"=="" SET RC=1&goto PRINT_USAGE

:PARAM_LOOP
REM No more parameters to process
IF "%1"=="" GOTO VERIFY_INPUTS
IF "%1"=="runUpgrade" set RUN_UPGRADE=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="dbName" set DB_NAME=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="dbUser" set DB_USER=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="dbNode" set DB_NODE=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="dbPassword" set DB_PASSWORD=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="scriptDir" set SCRIPT_DIR=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="dbSchema" set DB_SCHEMA=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="dbType" set DB_TYPE=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="oracleHome" set ORACLE_HOME=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="dbServerName" set SERVER_NAME=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="permanent" set PERM_TABLE=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="temporary" set TEMP_TABLE=%2%&shift&shift&goto PARAM_LOOP


:VERIFY_INPUTS
IF "%DB_USER%"=="" set RC=1&echo dbUser is required.&GOTO PRINT_USAGE
IF "%RUN_UPGRADE%"=="" set RC=1&echo runUpgrade is required.&GOTO PRINT_USAGE
IF "%DB_SCHEMA%"=="" set RC=1&echo Schema name is required(in Oracle, username owning schema).&GOTO PRINT_USAGE
IF "%DB_TYPE%"=="" set RC=1&echo Database Type(such as  DB2/Oracle/..) is required.&GOTO PRINT_USAGE
IF "%DB_TYPE%" == "Oracle" IF "%ORACLE_HOME%"=="" set RC=1&echo PATH to Oracle Home is required.&GOTO PRINT_USAGE
IF "%PERM_TABLE%" LSS "1" set RC=1&echo Invalid value %PERM_TABLE% for parameter -permanent.&GOTO PRINT_USAGE
IF "%TEMP_TABLE%" LSS "1" set RC=1&echo Invalid value %TEMP_TABLE% for parameter -temporary.&GOTO PRINT_USAGE
	
IF "%RUN_UPGRADE%"=="true" set RUN_UPGRADE=TRUE&goto GET_MORE_INPUTS


IF "%RUN_UPGRADE%"=="false" goto INITIALIZE
set RC=1&goto PRINT_USAGE

:GET_MORE_INPUTS
IF "%DB_NAME%"=="" set RC=1&echo dbName is required.&GOTO PRINT_USAGE
IF "%DB_TYPE%"=="SqlServer" IF "%SERVER_NAME%"=="" set RC=1&echo DB Server name is required.&GOTO PRINT_USAGE
IF "%DB_TYPE%"=="Sybase" IF "%SERVER_NAME%"=="" set RC=1&echo DB Server name is required.&GOTO PRINT_USAGE

:INITIALIZE
REM initialize values
IF NOT EXIST "%SCRIPT_DIR%" goto DIR_NOT_FOUND

SET DB2_UPGRADE_DIR=%SCRIPT_DIR%\SIBusDBUpgrade
IF NOT EXIST "%DB2_UPGRADE_DIR%" MKDIR "%DB2_UPGRADE_DIR%"

SET FINDSTR_OUTPUT_TXT=%DB2_UPGRADE_DIR%\findstr_output.txt
SET DDL_FILE=%DB2_UPGRADE_DIR%\upgrade_SIBus_db.db

IF EXIST "%DDL_FILE%" DEL /F /Q "%DDL_FILE%"

IF EXIST "%FINDSTR_OUTPUT_TXT%" DEL /F /Q "%FINDSTR_OUTPUT_TXT%"
goto GEN_UPGRADE_FILES



:BEGIN_DB2
ECHO Upgrading the SIBus database schema
SET USING=USING %DB_PASSWORD%
IF "%DB_PASSWORD%"=="" SET USING=
IF "%DB_NODE%"=="" goto CONNECT_DB2

REM Attach to node
ECHO db2 ATTACH TO %DB_NODE% USER %DB_USER% USING xxxxx
db2 ATTACH TO %DB_NODE% USER %DB_USER% %USING%
SET RC=%ERRORLEVEL%
IF %RC% NEQ 0 goto END
SET IS_ATTACHED=1

:CONNECT_DB2
ECHO db2 CONNECT TO %DB_NAME% USER %DB_USER% USING xxxxx
db2 connect to %DB_NAME% USER %DB_USER% %USING%
SET RC=%ERRORLEVEL%
IF %RC% NEQ 0 ECHO For runUpgrade=true, Check whether appropriate database client libraries available in PATH and for other errors (see findstr_output.txt).&goto END
SET IS_CONNECTED=1
goto RUN_UPGRADE_DB2





:RUN_UPGRADE
REM call upgrade script

IF "%RUN_UPGRADE%" ==  "false" SET RC=0&GOTO  END

	
	

IF "%DB_TYPE%" == "DB2" goto BEGIN_DB2
		
if "%DB_TYPE%" == "Oracle" goto RUN_UPGRADE_Oracle
		
if "%DB_TYPE%" == "SqlServer" goto RUN_UPGRADE_SQLServer

if "%DB_TYPE%" == "Sybase" goto RUN_UPGRADE_Sybase
	
if "%DB_TYPE%" == "Derby" goto RUN_UPGRADE_Derby
	
	goto END
	

:RUN_UPGRADE_Oracle
ECHO Upgrading SIbus oracle schema
IF "%RUN_UPGRADE%" == "false" SET RC=0&GOTO END
REM call upgrade script
ECHO "sqlplus xxxxxx @%DDL_FILE%"
sqlplus -S %CONNECT_STRING% @%DDL_FILE% /NOLOG
SET RC=%ERRORLEVEL%
IF %RC% EQU 0 ECHO The SIBus database schema upgrade completed successfully(see findstr_output.txt for any error).
IF %RC% NEQ 0 ECHO For runUpgrade=true, Check whether appropriate database client libraries available in PATH and for other errors (see findstr_output.txt).
GOTO END

:RUN_UPGRADE_SQLServer
ECHO Upgrading SIbus SQLServer schema
IF "%RUN_UPGRADE%"=="false" SET RC=0&GOTO END
REM call upgrade script
ECHO "Sqlcmd -S %SERVER_NAME% -d %DB_NAME%  -U %DB_USER% -P XXXXXX -i %DDL_FILE% -o %FINDSTR_OUTPUT_TXT%"
Sqlcmd -S %SERVER_NAME% -d %DB_NAME%  -U %DB_USER% -P %DB_PASSWORD% -i %DDL_FILE% -o %FINDSTR_OUTPUT_TXT%
SET RC=%ERRORLEVEL%
IF %RC% EQU 0 ECHO The SIBus database schema upgrade completed successfully(see findstr_output.txt for any error).
IF %RC% NEQ 0 ECHO For runUpgrade=true, Check whether appropriate database client libraries available in PATH and for other errors (see findstr_output.txt).
GOTO END

:RUN_UPGRADE_Sybase
ECHO Upgrading SIbus Sybase schema
IF "%RUN_UPGRADE%"=="false" SET RC=0&GOTO END
REM call upgrade script
ECHO "isql -S %SERVER_NAME% -D %DB_NAME%  -U %DB_USER% -P XXXXXXX -i %DDL_FILE% -o %FINDSTR_OUTPUT_TXT%"
isql -S %SERVER_NAME% -D %DB_NAME%  -U %DB_USER% -P %DB_PASSWORD% -i %DDL_FILE% -o %FINDSTR_OUTPUT_TXT%
SET RC=%ERRORLEVEL%
IF %RC% EQU 0 ECHO The SIBus database schema upgrade completed successfully(see findstr_output.txt for any error).
IF %RC% NEQ 0 ECHO For runUpgrade=true, Check whether appropriate database client libraries available in PATH and for other errors (see findstr_output.txt).
GOTO END

:RUN_UPGRADE_Derby
ECHO Upgrading happens by running Manually
IF "%RUN_UPGRADE%"=="false" SET RC=0&GOTO END
REM call upgrade script
ECHO " %DDL_FILE% 
REM %DDL_FILE%
SET RC=%ERRORLEVEL%
IF %RC% EQU 0 ECHO 
GOTO END

:RUN_UPGRADE_DB2
ECHO Upgrading SIbus DB2 schema
ECHO db2 -t -f "%DDL_FILE% -s +c"
db2 -t -f "%DDL_FILE%" -s +c
SET RC=%ERRORLEVEL%

REM suppress warnings 
IF %RC% EQU 3 SET RC=0
IF %RC% NEQ 0 echo DB2 Command returned RC=%RC%&SET RC=1&GOTO END



:NO_UPGRADE
SET RC=2
IF %IS_CONNECTED% EQU 1 goto DISCONNECT_DB2
goto END

:DISCONNECT_DB2
REM Disconnect DB
ECHO db connect reset
db2 connect reset
IF %IS_ATTACHED% EQU 1 goto DETACH_DB2
goto CHECK_RESULT

:DETACH_DB2
REM Detach DB node
ECHO db2 detach
db2 detach
SET IS_ATTACHED=0
goto CHECK_RESULT

:PRINT_USAGE
ECHO.
ECHO  Usage: sibDBUpgrade.bat runUpgrade=true or false                   
ECHO          dbUser=db_user    
ECHO          dbSchema=db_schema_name dbType=db_type
ECHO          [dbServerName=db_server_name] [oracleHome=oracle_home]
ECHO          [dbName=db_name] [dbPassword=db_password]                     
ECHO          [dbNode=db_node_name] [scriptDir=gen_script_dir]
ECHO          [permanent=number of permanent tables]
ECHO          [temporary=number of temporary tables]
ECHO. 
ECHO  Where:                                                                 
ECHO    runUpgrade=true or false    			- Required, Specify true to run the upgrade.
ECHO                    		        		    Specify false to generate ddl scripts only.
ECHO    dbUser=db_user              			- Required, UserID for Database.
ECHO    dbSchema=db_schema_name     			- Required, Schema name where particular ME associated with it, in the case of Oracle and Informix mention db_schema_user
ECHO    dbType=db_type              			- Required, Supported Database types are
ECHO			 		        		    DB2, Derby, Oracle, SqlServer, Sybase OR Informix 
ECHO    dbName=db_name              			- Optional, Database name if runUpgrade is true.
ECHO    dbPassword=db_password      			- Optional, Password. DB2 will prompt if not specified. 
ECHO    dbNode=db_node_name         			- Optional, Database node name. This is required
ECHO                                            		    if the current machine has db2 client.
ECHO    dbServerName=db_server_name 			- Optional, Database server name. This is required if the upgrade is for SqlServer or Sybase Database.   
ECHO                                            
ECHO    oracleHome=oracle_home      			- Optional, Path to Oracle Home if db_type=Oracle        
ECHO    scriptDir=gen_script_dir    			- Optional, Directory to generate the DDL scripts.
ECHO                                            		    If not specified, the scripts will be generated in
ECHO                                            		    ^<current_dir^>\SIBusDBUpgrade                    
ECHO    permanent=number of permanent tables	   	- Optional, Specify Number greater than 0        
ECHO    temporary=number of temporary tables   		- Optional, Specify Number greater than 0       
ECHO.
ECHO  Example 1:
ECHO     sibDBUpgrade runUpgrade=false dbUser=db2inst1  dbSchema=SIBusMESchema dbType=DB2
ECHO.
ECHO  Example 2:
ECHO     sibDBUpgrade runUpgrade=true dbName=SIBus dbUser=db2inst1 dbSchema=SIBusMESchema dbType=DB2
ECHO.
ECHO  Example 3(for z/OS, Informix, Derby  - -runUpgrade must false, no execution of scripts):
ECHO     sibDBUpgrade runUpgrade=false dbName=SIBus dbUser=db2inst1 dbSchema=SIBusMESchema dbType=DB2
GOTO END

:CHECK_RESULT
IF %RC% EQU 0 ECHO The SIBus DB2 database schema upgrade completed successfully.
goto END
IF %RC% EQU 2 ECHO The SIBus DB2 database schema is up to date. No upgrade is needed.
goto END
ECHO Errors occurred during the Event Service DB2 database schema upgrade.
goto END

:DIR_NOT_FOUND
echo Directory %SCRIPT_DIR% not found
SET RC=1
goto END


:END
echo RC=%RC%
exit /B %RC%
endlocal

REM ==========================================================================

:GEN_UPGRADE_FILES
echo "Generating the SIBus database schema upgrade scripts to directory %SCRIPT_DIR%"
IF EXIST "%DDL_FILE%" DEL /Q /F "%DDL_FILE%"
echo. > "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Licensed Materials - Property of IBM >> "%DDL_FILE%"
echo -- (C) Copyright IBM Corp.  2012.  ALL RIGHTS RESERVED >> "%DDL_FILE%"
echo -- 5724-I63, 5724-H88, 5655-N02, 5733-W70 >> "%DDL_FILE%"
echo -- US Government Users Licensed Rights - Use, duplication, or disclosure >> "%DDL_FILE%"
echo -- licensed by GSA ADP Schedule Contract with IBM Corp. >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- DB script that migrates a  lower version of  SIBus schema to >> "%DDL_FILE%"
echo -- a 8.5.0 or higher schema . >> "%DDL_FILE%"
echo -- >> "%DDL_FILE%"
echo -- >> "%DDL_FILE%"
echo -- A full database backup must be taken PRIOR to executing >> "%DDL_FILE%"
echo -- this script >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- set current schema = %DB_USER%@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- now we can safely begin the upgrade processing >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"

echo -- Altering SIBOWNER table >> "%DDL_FILE%"

  if "%DB_TYPE%" == "Derby" goto DDL_CONNECT_DERBY
	
  if  "%DB_TYPE%" == "DB2" 	goto DDL_SIBOWNER_DB2_DERBY
	
  if "%DB_TYPE%" == "Oracle"  goto DDL_SIBOWNER_Oracle
	
	
  if "%DB_TYPE%" == "Informix" goto DDL_SIBOWNER_Informix
	
	
  if  "%DB_TYPE%" == "SqlServer"  goto DDL_SIBOWNER_SqlServer
	
	
  if  "%DB_TYPE%" == "Sybase" goto DDL_SIBOWNER_Sybase
	
	
  
  
:DDL_SIB00X
  echo.>> "%DDL_FILE%"

  echo -- Altering SIB00X tables >> "%DDL_FILE%"

  if "%DB_TYPE%" == "DB2" goto DDL_SIB00X_DB2_DERBY_ORACLE
  	
	
  if "%DB_TYPE%" == "Derby" goto DDL_SIB00X_DB2_DERBY_ORACLE
  	
	
   if "%DB_TYPE%" == "Oracle" goto DDL_SIB00X_DB2_DERBY_ORACLE
   
   if "%DB_TYPE%" == "SqlServer" goto DDL_SIB00X_OTHERS
   
   if "%DB_TYPE%" == "Informix" goto DDL_SIB00X_OTHERS
   
   if "%DB_TYPE%" == "Sybase" goto DDL_SIB00X_OTHERS
  	
	
  
	
  
	
  
:DDL_CONNECT_DERBY
echo -- Process This script in the ij command line processor. >> "%DDL_FILE%"
echo -- Example:  >> "%DDL_FILE%"
echo -- java -Djava.ext.dirs=C:/WebSPhere/AppServer/derby/lib -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij upgrade_SIBus_db.db >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CONNECT 'jdbc:derby:%DB_NAME%;create=false'; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE %DB_SCHEMA%.SIBOWNER ADD ME_LUTS TIMESTAMP; >>  "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE %DB_SCHEMA%.SIBOWNER ADD ME_INFO VARCHAR(254); >>  "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE %DB_SCHEMA%.SIBOWNER ADD ME_STATUS VARCHAR(16); >>  "%DDL_FILE%"
echo.>> "%DDL_FILE%"
goto DDL_SIB00X

:DDL_SIBOWNER_DB2_DERBY
echo ALTER TABLE %DB_SCHEMA%.SIBOWNER ADD ME_LUTS TIMESTAMP; >>  "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE %DB_SCHEMA%.SIBOWNER ADD ME_INFO VARCHAR(254); >>  "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE %DB_SCHEMA%.SIBOWNER ADD ME_STATUS VARCHAR(16); >>  "%DDL_FILE%"
echo.>> "%DDL_FILE%"
goto DDL_SIB00X

:DDL_SIBOWNER_Oracle
echo ALTER TABLE %DB_SCHEMA%.SIBOWNER ADD (ME_LUTS TIMESTAMP, ME_INFO VARCHAR(254), ME_STATUS VARCHAR(16)); >>  "%DDL_FILE%"
echo.>> "%DDL_FILE%"
goto DDL_SIB00X

:DDL_SIBOWNER_Informix
echo ALTER TABLE %DB_SCHEMA%.SIBOWNER ADD ME_LUTS DATETIME YEAR TO FRACTION(5), ME_INFO VARCHAR(254), ME_STATUS VARCHAR(16) >>  "%DDL_FILE%"
echo go >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
goto DDL_SIB00X

:DDL_SIBOWNER_SqlServer
echo ALTER TABLE %DB_SCHEMA%.SIBOWNER ADD ME_LUTS DATETIME, ME_INFO VARCHAR(254), ME_STATUS VARCHAR(16) >>  "%DDL_FILE%"
echo go >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
goto DDL_SIB00X

:DDL_SIBOWNER_Sybase
echo ALTER TABLE %DB_SCHEMA%.SIBOWNER ADD ME_LUTS DATETIME, ME_INFO VARCHAR(254), ME_STATUS VARCHAR(16) >>  "%DDL_FILE%"
echo go >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
goto DDL_SIB00X

:DDL_SIB00X_DB2_DERBY_ORACLE
SET COUNT=0
SET /A TOTAL_COUNT = %TEMP_TABLE% + %PERM_TABLE% + %STREAM_TABLE% 

:NEXT_SIB_TABLE

IF %COUNT% LEQ 9 echo ALTER TABLE %DB_SCHEMA%.SIB00%COUNT% ADD REDELIVERED_COUNT  INTEGER;  >>  "%DDL_FILE%"
IF %COUNT% GTR 9 echo ALTER TABLE %DB_SCHEMA%.SIB0%COUNT% ADD REDELIVERED_COUNT  INTEGER;  >>  "%DDL_FILE%"
echo.>> "%DDL_FILE%"
set /A COUNT = %COUNT% + 1
IF %COUNT% LSS %TOTAL_COUNT% goto NEXT_SIB_TABLE
echo COMMIT; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
goto RUN_UPGRADE

:DDL_SIB00X_OTHERS
SET COUNT=0
SET /A TOTAL_COUNT = %TEMP_TABLE% + %PERM_TABLE% + %STREAM_TABLE% 

:NEXT_SIB_TABLE_O

IF %COUNT% LEQ 9 echo ALTER TABLE %DB_SCHEMA%.SIB00%COUNT% ADD REDELIVERED_COUNT  INT >>  "%DDL_FILE%"
IF %COUNT% GTR 9 echo ALTER TABLE %DB_SCHEMA%.SIB0%COUNT% ADD REDELIVERED_COUNT  INT  >>  "%DDL_FILE%"
echo go >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
set /A COUNT = %COUNT% + 1
IF %COUNT% LSS %TOTAL_COUNT% goto NEXT_SIB_TABLE_O

echo COMMIT >> "%DDL_FILE%"
echo go >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"




goto RUN_UPGRADE
