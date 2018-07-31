@echo off
REM
REM Licensed Materials - Property of IBM
REM (C) Copyright IBM Corp. 2004, 2010.  ALL RIGHTS RESERVED 
REM 5724-I63, 5724-H88, 5655-N02, 5733-W70
REM US Government Users Restricted Rights - Use, duplication, or disclosure
REM restricted by GSA ADP Schedule Contract with IBM Corp.rp.
REM
REM ----------------------------------------------------------------------------
REM
REM Upgrade the Event Service database from v5.x to v6.1
REM
REM Usage: eventUpgradeDB2.bat runUpgrade=true_or_false \
REM                  dbUser=db_user \
REM                  [dbName=db_name] \
REM                  [dbPassword=db_password] \ 
REM                  [dbNode=db_node_name]  \
REM                  [scriptDir=gen_scriptDir]
REM
REM Where:
REM   true_or_false  - Specify true to run the upgrade.
REM                    Specify false to generate ddl scripts only. 
REM   db_user        - Required db2 userid.
REM   db_name        - Required database name if runUpgrade is true.
REM   db_password    - Optional password. DB2 will prompt if not specified.
REM   db_node_name   - Optional database node name. This is required 
REM                    if the current machine is a db2 client.
REM   gen_script_dir - Optional directory to generate the DDL scripts.      
REM                    If not specified, the scripts will be generated in   
REM                    <current_dir>\eventDBUpgrade\db2 
REM  Example 1:                                                             
REM     eventUpgradeDB2 runUpgrade=false dbUser=db2inst1                  
REM
REM  Example 2:                                                             
REM     eventUpgradeDB2 runUpgrade=true dbName=event dbUser=db2inst1      
REM     
REM Return Codes:  0 for success, 1 for fail
REM --------------------------------------------------------------------------

setlocal

%~d0
cd %~p0

REM initialize
SET RC=0
SET SCRIPT_DIR=.
SET DB_NAME=
SET DB_USER=
SET DB_PASSWORD=
SET DB_NODE=
SET RUN_UPGRADE=
SET IS_ATTACHED=0
SET IS_CONNECTED=0

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

:VERIFY_INPUTS
IF "%DB_USER%"=="" set RC=1&echo dbUser is required.&GOTO PRINT_USAGE
IF "%RUN_UPGRADE%"=="" set RC=1&echo runUpgrade is required.&GOTO PRINT_USAGE
IF "%RUN_UPGRADE%"=="true" set RUN_UPGRADE=TRUE&goto GET_MORE_INPUTS
IF "%RUN_UPGRADE%"=="false" goto INITIALIZE
set RC=1&goto PRINT_USAGE

:GET_MORE_INPUTS
IF "%DB_NAME%"=="" set RC=1&echo dbName is required.&GOTO PRINT_USAGE

:INITIALIZE
REM initialize values
IF NOT EXIST "%SCRIPT_DIR%" goto DIR_NOT_FOUND
SET EVENT_UPGRADE_DIR=%SCRIPT_DIR%\eventDBUpgrade
IF NOT EXIST "%EVENT_UPGRADE_DIR%" MKDIR "%EVENT_UPGRADE_DIR%"
SET DB2_UPGRADE_DIR=%EVENT_UPGRADE_DIR%\DB2
IF NOT EXIST "%DB2_UPGRADE_DIR%" MKDIR "%DB2_UPGRADE_DIR%"
SET SCHEMA_VERSION_DB2=%DB2_UPGRADE_DIR%\schema_version.db2
SET SCHEMA_VERSION_TXT=%DB2_UPGRADE_DIR%\schema_version.txt
SET FINDSTR_OUTPUT_TXT=%DB2_UPGRADE_DIR%\findstr_output.txt
SET DDL_FILE=%DB2_UPGRADE_DIR%\upgrade_event_db.db2
SET METADATA_FILE=%DB2_UPGRADE_DIR%\ins_metadata.db2

IF "%RUN_UPGRADE%"=="false" goto GEN_UPGRADE_FILES

:BEGIN
ECHO Upgrading the Event Service DB2 database schema
SET USING=USING %DB_PASSWORD%
IF "%DB_PASSWORD%"=="" SET USING=
IF "%DB_NODE%"=="" goto CONNECT_DB

REM Attach to node
ECHO db2 ATTACH TO %DB_NODE% USER %DB_USER% USING xxxxx
db2 ATTACH TO %DB_NODE% USER %DB_USER% %USING%
SET RC=%ERRORLEVEL%
IF %RC% NEQ 0 goto END
SET IS_ATTACHED=1

:CONNECT_DB
ECHO db2 CONNECT TO %DB_NAME% USER %DB_USER% USING xxxxx
db2 connect to %DB_NAME% USER %DB_USER% %USING%
SET RC=%ERRORLEVEL%
IF %RC% NEQ 0 goto END
SET IS_CONNECTED=1

REM Generate schema_version.db2
IF EXIST "%SCHEMA_VERSION_DB2%" DEL /F /Q "%SCHEMA_VERSION_DB2%"
echo select substr(t1.property_value ^|^| '.' ^|^| t2.property_value ^|^| '.' ^|^| t3.property_value,1,80) from cei_t_properties t1, cei_t_properties t2, cei_t_properties t3 where t1.property_name = 'SchemaMajorVersion' and t2.property_name = 'SchemaMinorVersion' and t3.property_name = 'SchemaPtfLevel' >> %SCHEMA_VERSION_DB2% 

REM Check if upgrade is needed
IF EXIST "%SCHEMA_VERSION_TXT%" DEL /F /Q "%SCHEMA_VERSION_TXT%"
ECHO db2 +o -x -r "%SCHEMA_VERSION_TXT%" -f "%SCHEMA_VERSION_DB2%"
db2 +o -x -r "%SCHEMA_VERSION_TXT%" -f "%SCHEMA_VERSION_DB2%"

SET RC=%ERRORLEVEL%
IF %RC% NEQ 0 SET RC=1&echo Failed to check the Event Service database schema version.&GOTO DISCONNECT_DB

REM if version 5.1.0 found then upgrade to 6.1.0
IF EXIST "%FINDSTR_OUTPUT_TXT%" DEL /F /Q "%FINDSTR_OUTPUT_TXT%"
FINDSTR "5.1.0" "%SCHEMA_VERSION_TXT%" > "%FINDSTR_OUTPUT_TXT%"
SET RC=%ERRORLEVEL%
IF %RC% EQU 0 goto GEN_UPGRADE_FILES

REM if version 5.1.1 found then upgrade to 6.1.0
IF EXIST "%FINDSTR_OUTPUT_TXT%" DEL /F /Q "%FINDSTR_OUTPUT_TXT%"
FINDSTR "5.1.1" "%SCHEMA_VERSION_TXT%" > "%FINDSTR_OUTPUT_TXT%"
SET RC=%ERRORLEVEL%
IF %RC% EQU 0 goto GEN_UPGRADE_FILES
goto NO_UPGRADE

:RUN_UPGRADE
IF "%RUN_UPGRADE%"=="false" SET RC=0&goto END
REM call upgrade script
ECHO db2 -td@ -f "%DDL_FILE% -s +c"
db2 -td@ -f "%DDL_FILE%" -s +c
SET RC=%ERRORLEVEL%

REM suppress warnings 
IF %RC% EQU 3 SET RC=0
IF %RC% NEQ 0 echo DB2 Command returned RC=%RC%&SET RC=1&GOTO DISCONNECT_DB

ECHO db2 -s -t -f "%METADATA_FILE%"
db2 -s -t -f "%METADATA_FILE%"
SET RC=%ERRORLEVEL%
REM suppress warnings
IF %RC% EQU 7 SET RC=0
IF %RC% EQU 3 SET RC=0

REM suppress warnings about empty rows
IF %RC% EQU 1 SET RC=0
goto DISCONNECT_DB

:NO_UPGRADE
SET RC=2
IF %IS_CONNECTED% EQU 1 goto DISCONNECT_DB
goto END

:DISCONNECT_DB
REM Disconnect DB
ECHO db connect reset
db2 connect reset
IF %IS_ATTACHED% EQU 1 goto DETACH_DB
goto CHECK_RESULT

:DETACH_DB
REM Detach DB node
ECHO db2 detach
db2 detach
SET IS_ATTACHED=0
goto CHECK_RESULT

:PRINT_USAGE
ECHO.
ECHO  Usage: eventUpgradeDB2.bat runUpgrade=true_or_false                   
ECHO          dbUser=db_user                                                 
ECHO          [dbName=db_name] [dbPassword=db_password]                     
ECHO          [dbNode=db_node_name] [scriptDir=gen_script_dir]
ECHO. 
ECHO  Where:                                                                 
ECHO    true_or_false - Specify true to run the upgrade.
ECHO                    Specify false to generate ddl scripts only.
ECHO    db_user       - Required db2 userid.
ECHO    db_name       - Required database name if runUpgrade is true.
ECHO    db_password   - Optional password. DB2 will prompt if not specified. 
ECHO    db_node_name  - Optional database node name. This is required
ECHO                    if the current machine is a db2 client.
ECHO    gen_script_dir- Optional directory to generate the DDL scripts.
ECHO                    If not specified, the scripts will be generated in
ECHO                    ^<current_dir^>\eventDBUpgrade\db2                    
ECHO.
ECHO  Example 1:
ECHO     eventUpgradeDB2 runUpgrade=false dbUser=db2inst1
ECHO.
ECHO  Example 2:
ECHO     eventUpgradeDB2 runUpgrade=true dbName=event dbUser=db2inst1
ECHO.
GOTO END

:CHECK_RESULT
IF %RC% EQU 0 ECHO The Event Service DB2 database schema upgrade completed successfully.&goto END
IF %RC% EQU 2 ECHO The Event Service DB2 database schema is up to date. No upgrade is needed.&goto END
ECHO Errors occurred during the Event Service DB2 database schema upgrade.&goto END

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
echo "Generating the Event Service DB2 database schema upgrade scripts to directory %SCRIPT_DIR%"
IF EXIST "%DDL_FILE%" DEL /Q /F "%DDL_FILE%"
echo. > "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Licensed Materials - Property of IBM >> "%DDL_FILE%"
echo -- (C) Copyright IBM Corp. 2004, 2010.  ALL RIGHTS RESERVED >> "%DDL_FILE%"
echo -- 5724-I63, 5724-H88, 5655-N02, 5733-W70 >> "%DDL_FILE%"
echo -- US Government Users Restricted Rights - Use, duplication, or disclosure >> "%DDL_FILE%"
echo -- restricted by GSA ADP Schedule Contract with IBM Corp. >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- DB2 script that migrates a 5.1.0 or 5.1.1 CEI schema to >> "%DDL_FILE%"
echo -- a 6.0.0 schema. >> "%DDL_FILE%"
echo -- >> "%DDL_FILE%"
echo -- THIS SCRIPT MUST BE EXECUTED WITH THE FOLLOWING OPTIONS: >> "%DDL_FILE%"
echo -- -td@ -f path_to_this_script_file -s +c >> "%DDL_FILE%"
echo -- >> "%DDL_FILE%"
echo -- -td@ makes the '@' character the statement terminiator. This >> "%DDL_FILE%"
echo --      is needed since we are using a dynamic compound statement >> "%DDL_FILE%"
echo --      to perform the schema version checks. The dynamic >> "%DDL_FILE%"
echo --      compound statement needs to use the ';' as a terminiator >> "%DDL_FILE%"
echo -- -f tells the DB2 command processor to take input from a file >> "%DDL_FILE%"
echo -- -s tells the DB2 command processor to stop on the first error >> "%DDL_FILE%"
echo -- +c tells the DB2 command processor to not automatically commit >> "%DDL_FILE%"
echo --    after each statement >> "%DDL_FILE%"
echo -- >> "%DDL_FILE%"
echo -- A full database backup must be taken PRIOR to executing >> "%DDL_FILE%"
echo -- this script >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo set current schema = %DB_USER%@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Verify that we are upgrading from a 5.1.0 or >> "%DDL_FILE%"
echo -- 5.1.1 CEI schema! >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo begin atomic >> "%DDL_FILE%"
echo -- initialize to -1 in case we don't find the row >> "%DDL_FILE%"
echo DECLARE schemaMajor int default -1; >> "%DDL_FILE%"
echo DECLARE schemaMinor int default -1; >> "%DDL_FILE%"
echo DECLARE schemaPtf int default -1; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo FOR getmajor AS >> "%DDL_FILE%"
echo SELECT INTEGER(property_value) as major >> "%DDL_FILE%"
echo FROM cei_t_properties >> "%DDL_FILE%"
echo WHERE property_name = 'SchemaMajorVersion' >> "%DDL_FILE%"
echo DO >> "%DDL_FILE%"
echo set schemaMajor =  major; >> "%DDL_FILE%"
echo END FOR; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo if (schemaMajor ^<^> 5) THEN >> "%DDL_FILE%"
echo signal SQLSTATE VALUE 'CEI00' set MESSAGE_TEXT = 'Invalid schema major version'; >> "%DDL_FILE%"
echo end if; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo FOR getminor AS >> "%DDL_FILE%"
echo SELECT INTEGER(property_value) as minor >> "%DDL_FILE%"
echo FROM cei_t_properties >> "%DDL_FILE%"
echo WHERE property_name = 'SchemaMinorVersion' >> "%DDL_FILE%"
echo DO >> "%DDL_FILE%"
echo set schemaMinor = minor; >> "%DDL_FILE%"
echo END FOR; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo if (schemaMinor ^<^> 1) THEN >> "%DDL_FILE%"
echo signal SQLSTATE VALUE 'CEI01' set MESSAGE_TEXT = 'Invalid schema minor version'; >> "%DDL_FILE%"
echo end if; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo FOR getptf AS >> "%DDL_FILE%"
echo SELECT INTEGER(property_value) as ptf >> "%DDL_FILE%"
echo FROM cei_t_properties >> "%DDL_FILE%"
echo WHERE property_name = 'SchemaPtfLevel' >> "%DDL_FILE%"
echo DO >> "%DDL_FILE%"
echo set schemaPtf = ptf; >> "%DDL_FILE%"
echo END FOR; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo if (schemaPtf ^<^> 0 and schemaPtf ^<^> 1) THEN >> "%DDL_FILE%"
echo signal SQLSTATE VALUE 'CEI02' set MESSAGE_TEXT = 'Invalid schema ptf level'; >> "%DDL_FILE%"
echo end if; >> "%DDL_FILE%"
echo END@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- now we can safely begin the upgrade processing >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln DROP CONSTRAINT cei_fk_evt_engine@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_assoc_eng DROP CONSTRAINT cei_pk_assoc_eng@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Non event tables >> "%DDL_FILE%"
echo ALTER TABLE cei_t_properties DROP CONSTRAINT cei_pk_properties@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_cbe_map DROP CONSTRAINT cei_pk_cbe_map@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX properties_pk >> "%DDL_FILE%"
echo ON cei_t_properties >> "%DDL_FILE%"
echo (property_name) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_properties >> "%DDL_FILE%"
echo ADD CONSTRAINT properties_pk PRIMARY KEY >> "%DDL_FILE%"
echo (property_name)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX cbe_map_pk >> "%DDL_FILE%"
echo ON cei_t_cbe_map >> "%DDL_FILE%"
echo (cbe_version, table_name, column_name) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_cbe_map >> "%DDL_FILE%"
echo ADD CONSTRAINT cbe_map_pk PRIMARY KEY >> "%DDL_FILE%"
echo (cbe_version, table_name, column_name)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX assoc_eng_pk >> "%DDL_FILE%"
echo ON cei_t_assoc_eng (engine_id) >> "%DDL_FILE%"
echo PCTFREE 10 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_assoc_eng >> "%DDL_FILE%"
echo ADD CONSTRAINT assoc_eng_pk PRIMARY KEY >> "%DDL_FILE%"
echo (engine_id)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Create new event tables for the second bucket >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Event tables Bucket 1 >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo CREATE TABLE cei_t_event01 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo version VARCHAR ( 16 ), >> "%DDL_FILE%"
echo extension_name VARCHAR ( 192 ), >> "%DDL_FILE%"
echo local_id VARCHAR ( 384 ), >> "%DDL_FILE%"
echo creation_time VARCHAR ( 32 ) NOT NULL, >> "%DDL_FILE%"
echo creation_time_utc BIGINT NOT NULL, >> "%DDL_FILE%"
echo severity SMALLINT, >> "%DDL_FILE%"
echo priority SMALLINT, >> "%DDL_FILE%"
echo sequence_number BIGINT, >> "%DDL_FILE%"
echo repeat_count SMALLINT, >> "%DDL_FILE%"
echo elapsed_time BIGINT, >> "%DDL_FILE%"
echo msg VARCHAR ( 3072 ), >> "%DDL_FILE%"
echo msg_id VARCHAR ( 768 ), >> "%DDL_FILE%"
echo msg_id_type VARCHAR ( 96 ), >> "%DDL_FILE%"
echo msg_catalog_id VARCHAR ( 384 ), >> "%DDL_FILE%"
echo msg_catalog_type VARCHAR ( 96 ), >> "%DDL_FILE%"
echo msg_catalog VARCHAR ( 384 ), >> "%DDL_FILE%"
echo msg_locale VARCHAR ( 33 ), >> "%DDL_FILE%"
echo sit_category_name VARCHAR ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo reasoning_scope VARCHAR ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo sit_has_any_elem SMALLINT DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo success_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo situation_qual VARCHAR ( 192 ), >> "%DDL_FILE%"
echo situation_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo operation_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo availability_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo processing_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo report_category VARCHAR ( 192 ), >> "%DDL_FILE%"
echo feature_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo dependency_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo has_context SMALLINT DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_msg_tokens SMALLINT DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_extended_elem SMALLINT DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_any_element SMALLINT DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_event_assoc SMALLINT DEFAULT 0 NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_8k@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX event01_pk >> "%DDL_FILE%"
echo ON cei_t_event01 (global_id) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_event01 >> "%DDL_FILE%"
echo ADD CONSTRAINT event01_pk >> "%DDL_FILE%"
echo PRIMARY KEY (global_id)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_compid01 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo rel_type SMALLINT NOT NULL, >> "%DDL_FILE%"
echo component_type VARCHAR(1536) NOT NULL, >> "%DDL_FILE%"
echo component VARCHAR ( 768 ) NOT NULL, >> "%DDL_FILE%"
echo sub_component VARCHAR ( 1536 ) NOT NULL, >> "%DDL_FILE%"
echo comp_id_type VARCHAR ( 384 ), >> "%DDL_FILE%"
echo instance_id VARCHAR ( 384 ), >> "%DDL_FILE%"
echo application VARCHAR ( 768 ), >> "%DDL_FILE%"
echo exec_env VARCHAR ( 768 ), >> "%DDL_FILE%"
echo location VARCHAR ( 768 ) NOT NULL, >> "%DDL_FILE%"
echo location_type VARCHAR ( 96 ) NOT NULL, >> "%DDL_FILE%"
echo process_id VARCHAR ( 192 ), >> "%DDL_FILE%"
echo thread_id VARCHAR ( 192 ) >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_8k@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX compid01_pk >> "%DDL_FILE%"
echo ON cei_t_compid01 (global_id, rel_type) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_compid01 >> "%DDL_FILE%"
echo ADD CONSTRAINT compid01_pk >> "%DDL_FILE%"
echo PRIMARY KEY (global_id, rel_type)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_event_reln01 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo engine_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo array_index INTEGER NOT NULL, >> "%DDL_FILE%"
echo assoc_event_id VARCHAR ( 64 ) NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_base4K_path@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX event_reln01_pk >> "%DDL_FILE%"
echo ON cei_t_event_reln01 >> "%DDL_FILE%"
echo (global_id, engine_id, array_index) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln01 >> "%DDL_FILE%"
echo ADD CONSTRAINT event_reln01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, engine_id, array_index)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_context01 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo context_position INTEGER NOT NULL, >> "%DDL_FILE%"
echo context_id VARCHAR ( 765 ), >> "%DDL_FILE%"
echo context_name VARCHAR ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo context_type VARCHAR ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo context_value VARCHAR ( 3072 ) >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_8k@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX context01_pk >> "%DDL_FILE%"
echo ON cei_t_context01 >> "%DDL_FILE%"
echo (global_id, context_position) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_context01 >> "%DDL_FILE%"
echo ADD CONSTRAINT context01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, context_position)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_msg_token01 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo array_index INTEGER NOT NULL, >> "%DDL_FILE%"
echo token VARCHAR ( 768 ) NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_base4K_path@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX msg_token01_pk >> "%DDL_FILE%"
echo ON cei_t_msg_token01 >> "%DDL_FILE%"
echo (global_id, array_index) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_msg_token01 >> "%DDL_FILE%"
echo ADD CONSTRAINT msg_token01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, array_index)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_anyelmnt01 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_type SMALLINT NOT NULL, >> "%DDL_FILE%"
echo array_index INTEGER NOT NULL, >> "%DDL_FILE%"
echo chunk_number INTEGER DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo element_name VARCHAR ( 3072 ), >> "%DDL_FILE%"
echo namespace VARCHAR ( 3072 ), >> "%DDL_FILE%"
echo value CLOB ( 1G ) NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_8k@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX anyelmnt01_pk >> "%DDL_FILE%"
echo ON cei_t_anyelmnt01 >> "%DDL_FILE%"
echo (global_id, element_type, array_index, chunk_number) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_anyelmnt01 >> "%DDL_FILE%"
echo ADD CONSTRAINT anyelmnt01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_type, array_index, chunk_number)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_ext_elem01 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_key INTEGER NOT NULL, >> "%DDL_FILE%"
echo parent_element_key INTEGER, >> "%DDL_FILE%"
echo element_name VARCHAR ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo element_level INTEGER DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo element_position INTEGER DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo data_type SMALLINT NOT NULL, >> "%DDL_FILE%"
echo string_value VARCHAR(3072), >> "%DDL_FILE%"
echo long_value BIGINT, >> "%DDL_FILE%"
echo float_value DOUBLE >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_ext4K@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_elem01_pk >> "%DDL_FILE%"
echo ON cei_t_ext_elem01 >> "%DDL_FILE%"
echo (global_id, element_key) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_elem01 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_elem01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_ext_blob01 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_key INTEGER NOT NULL, >> "%DDL_FILE%"
echo chunk_number INTEGER DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo value BLOB ( 1G ) NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_ext4K@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_blob01_pk >> "%DDL_FILE%"
echo ON cei_t_ext_blob01 >> "%DDL_FILE%"
echo (global_id, element_key, chunk_number) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_blob01 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_blob01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, chunk_number)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_ext_float01 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_key INTEGER NOT NULL, >> "%DDL_FILE%"
echo array_index INTEGER NOT NULL, >> "%DDL_FILE%"
echo value DOUBLE NOT NULL, >> "%DDL_FILE%"
echo value_string VARCHAR(254) DEFAULT '0' NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_ext4K@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_float01_pk >> "%DDL_FILE%"
echo ON cei_t_ext_float01 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_float01 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_float01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_ext_string01 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_key INTEGER NOT NULL, >> "%DDL_FILE%"
echo array_index INTEGER NOT NULL, >> "%DDL_FILE%"
echo value VARCHAR ( 3072 ) NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_ext4K@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_string01_pk >> "%DDL_FILE%"
echo ON cei_t_ext_string01 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_string01 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_string01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_ext_int01 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_key INTEGER NOT NULL, >> "%DDL_FILE%"
echo array_index INTEGER NOT NULL, >> "%DDL_FILE%"
echo value BIGINT NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_ext4K@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_int01_pk >> "%DDL_FILE%"
echo ON cei_t_ext_int01 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_int01 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_int01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_ext_date01 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_key INTEGER NOT NULL, >> "%DDL_FILE%"
echo array_index INTEGER NOT NULL, >> "%DDL_FILE%"
echo value VARCHAR ( 32 ) NOT NULL, >> "%DDL_FILE%"
echo value_utc BIGINT NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_ext4K@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_date01_pk >> "%DDL_FILE%"
echo ON cei_t_ext_date01 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_date01 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_date01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE VIEW cei_v_reln_eng01 AS >> "%DDL_FILE%"
echo SELECT er.global_id,er.array_index,er.assoc_event_id,ae.engine_id,ae.engine_name,ae.engine_type >> "%DDL_FILE%"
echo FROM cei_t_event_reln01 er, cei_t_assoc_eng ae >> "%DDL_FILE%"
echo WHERE er.engine_id = ae.engine_id@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE INDEX event01_time_utc ON cei_t_event01 >> "%DDL_FILE%"
echo (creation_time_utc) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE INDEX ext_elem01_name ON cei_t_ext_elem01 >> "%DDL_FILE%"
echo (element_level, element_name) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_string01 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_string01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem01 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_blob01 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_blob01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem01(global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_context01 >> "%DDL_FILE%"
echo ADD CONSTRAINT context01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event01 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_int01 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_int01 >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem01 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_compid01 >> "%DDL_FILE%"
echo ADD CONSTRAINT compid01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event01 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_msg_token01 >> "%DDL_FILE%"
echo ADD CONSTRAINT msg_token01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event01 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln01 >> "%DDL_FILE%"
echo ADD CONSTRAINT event_reln01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event01 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln01 >> "%DDL_FILE%"
echo ADD CONSTRAINT reln01_engine_fk >> "%DDL_FILE%"
echo FOREIGN KEY (engine_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_assoc_eng (engine_id) >> "%DDL_FILE%"
echo ON DELETE RESTRICT ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_anyelmnt01 >> "%DDL_FILE%"
echo ADD CONSTRAINT anyelmnt01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event01 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_float01 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_float01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem01 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_date01 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_date01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem01 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_elem01 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_elem01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event01 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Create the new cei_t_event00 table. We need to create >> "%DDL_FILE%"
echo -- the table because the has_situation column is being >> "%DDL_FILE%"
echo -- dropped from the table. >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo CREATE TABLE cei_t_event00 ( >> "%DDL_FILE%"
echo global_id VARCHAR ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo version VARCHAR ( 16 ), >> "%DDL_FILE%"
echo extension_name VARCHAR ( 192 ), >> "%DDL_FILE%"
echo local_id VARCHAR ( 384 ), >> "%DDL_FILE%"
echo creation_time VARCHAR ( 32 ) NOT NULL, >> "%DDL_FILE%"
echo creation_time_utc BIGINT NOT NULL, >> "%DDL_FILE%"
echo severity SMALLINT, >> "%DDL_FILE%"
echo priority SMALLINT, >> "%DDL_FILE%"
echo sequence_number BIGINT, >> "%DDL_FILE%"
echo repeat_count SMALLINT, >> "%DDL_FILE%"
echo elapsed_time BIGINT, >> "%DDL_FILE%"
echo msg VARCHAR ( 3072 ), >> "%DDL_FILE%"
echo msg_id VARCHAR ( 768 ), >> "%DDL_FILE%"
echo msg_id_type VARCHAR ( 96 ), >> "%DDL_FILE%"
echo msg_catalog_id VARCHAR ( 384 ), >> "%DDL_FILE%"
echo msg_catalog_type VARCHAR ( 96 ), >> "%DDL_FILE%"
echo msg_catalog VARCHAR ( 384 ), >> "%DDL_FILE%"
echo msg_locale VARCHAR ( 33 ), >> "%DDL_FILE%"
echo sit_category_name VARCHAR ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo reasoning_scope VARCHAR ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo sit_has_any_elem SMALLINT DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo success_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo situation_qual VARCHAR ( 192 ), >> "%DDL_FILE%"
echo situation_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo operation_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo availability_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo processing_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo report_category VARCHAR ( 192 ), >> "%DDL_FILE%"
echo feature_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo dependency_disp VARCHAR ( 192 ), >> "%DDL_FILE%"
echo has_context SMALLINT DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_msg_tokens SMALLINT DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_extended_elem SMALLINT DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_any_element SMALLINT DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_event_assoc SMALLINT DEFAULT 0 NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo IN cei_ts_8k >> "%DDL_FILE%"
echo NOT LOGGED INITIALLY@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Populate the cei_t_event00 table with data from the >> "%DDL_FILE%"
echo -- cei_t_event and cei_t_situation tables. The indexes are >> "%DDL_FILE%"
echo -- created after the data is inserted to allow the inserts to >> "%DDL_FILE%"
echo -- execute faster. >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo INSERT INTO cei_t_event00 >> "%DDL_FILE%"
echo (global_id,version,extension_name,local_id,creation_time, >> "%DDL_FILE%"
echo creation_time_utc,severity,priority,sequence_number,repeat_count, >> "%DDL_FILE%"
echo elapsed_time,msg,msg_id,msg_id_type,msg_catalog_id, >> "%DDL_FILE%"
echo msg_catalog_type,msg_catalog,msg_locale,sit_category_name, >> "%DDL_FILE%"
echo reasoning_scope,sit_has_any_elem,success_disp,situation_qual, >> "%DDL_FILE%"
echo situation_disp,operation_disp,availability_disp,processing_disp, >> "%DDL_FILE%"
echo report_category,feature_disp,dependency_disp,has_context, >> "%DDL_FILE%"
echo has_msg_tokens,has_extended_elem,has_any_element,has_event_assoc) >> "%DDL_FILE%"
echo SELECT e.global_id,e.version,e.extension_name,e.local_id, >> "%DDL_FILE%"
echo e.creation_time,e.creation_time_utc,e.severity,e.priority, >> "%DDL_FILE%"
echo e.sequence_number,e.repeat_count,e.elapsed_time,e.msg,e.msg_id, >> "%DDL_FILE%"
echo e.msg_id_type,e.msg_catalog_id,e.msg_catalog_type,e.msg_catalog, >> "%DDL_FILE%"
echo e.msg_locale,s.sit_category_name,s.reasoning_scope, >> "%DDL_FILE%"
echo s.has_any_element,s.success_disp,s.situation_qual, >> "%DDL_FILE%"
echo s.situation_disp,s.operation_disp,s.availability_disp, >> "%DDL_FILE%"
echo s.processing_disp,s.report_category,s.feature_disp,s.dependency_disp, >> "%DDL_FILE%"
echo e.has_context,e.has_msg_tokens,e.has_extended_elem, >> "%DDL_FILE%"
echo e.has_any_element,e.has_event_assoc >> "%DDL_FILE%"
echo FROM cei_t_event e, cei_t_situation s >> "%DDL_FILE%"
echo WHERE e.global_id = s.global_id@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Create indexes on the cei_t_event00 table >> "%DDL_FILE%"
echo CREATE UNIQUE INDEX event00_pk >> "%DDL_FILE%"
echo ON cei_t_event00 (global_id) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_event00 >> "%DDL_FILE%"
echo ADD CONSTRAINT event00_pk PRIMARY KEY (global_id)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Create new index on event table >> "%DDL_FILE%"
echo CREATE INDEX event00_time_utc ON cei_t_event00 >> "%DDL_FILE%"
echo (creation_time_utc) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Drop foreign key constraints on old event tables >> "%DDL_FILE%"
echo -- extended data element tables >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_string DROP CONSTRAINT cei_fk_ext_string@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_blob DROP CONSTRAINT cei_fk_ext_blob@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_integer DROP CONSTRAINT cei_fk_ext_integer@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_float DROP CONSTRAINT cei_fk_ext_float@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_datetime DROP CONSTRAINT cei_fk_extdatetime@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_element DROP CONSTRAINT cei_fk_ext_eventid@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- other event tables >> "%DDL_FILE%"
echo ALTER TABLE cei_t_context DROP CONSTRAINT cei_fk_context@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_compid DROP CONSTRAINT cei_fk_compid@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_msg_token DROP CONSTRAINT cei_fk_msg_token@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln DROP CONSTRAINT cei_fk_event_reln@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_anyelmnt DROP CONSTRAINT cei_fk_anyelmnt@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Drop primary key constraints on old event tables >> "%DDL_FILE%"
echo -- extended data element tables >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_string DROP CONSTRAINT cei_pk_ext_string@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_blob DROP CONSTRAINT cei_pk_ext_blob@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_integer DROP CONSTRAINT cei_pk_ext_integer@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_float DROP CONSTRAINT cei_pk_ext_float@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_datetime DROP CONSTRAINT cei_pk_extdatetime@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_element DROP CONSTRAINT cei_pk_ext_element@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- other event tables >> "%DDL_FILE%"
echo ALTER TABLE cei_t_context DROP CONSTRAINT cei_pk_context@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_compid DROP CONSTRAINT cei_pk_compid@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_msg_token  DROP CONSTRAINT cei_pk_msg_token@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln DROP CONSTRAINT cei_pk_event_reln@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_anyelmnt DROP CONSTRAINT cei_pk_anyelmnt@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Drop indexes on old event tables >> "%DDL_FILE%"
echo DROP INDEX cei_i_create_time@ >> "%DDL_FILE%"
echo DROP INDEX cei_i_ext_name@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Drop the unneeded views >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo DROP VIEW cei_v_reln_engine@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Rename all remaining event tables. For example, cei_t_compid becomes cei_t_compid00 >> "%DDL_FILE%"
echo RENAME TABLE cei_t_ext_string TO cei_t_ext_string00@ >> "%DDL_FILE%"
echo RENAME TABLE cei_t_ext_blob TO cei_t_ext_blob00@ >> "%DDL_FILE%"
echo RENAME TABLE cei_t_ext_integer TO cei_t_ext_int00@ >> "%DDL_FILE%"
echo RENAME TABLE cei_t_ext_float TO cei_t_ext_float00@ >> "%DDL_FILE%"
echo RENAME TABLE cei_t_ext_datetime TO cei_t_ext_date00@ >> "%DDL_FILE%"
echo RENAME TABLE cei_t_ext_element TO cei_t_ext_elem00@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- other event tables >> "%DDL_FILE%"
echo RENAME TABLE cei_t_context TO cei_t_context00@ >> "%DDL_FILE%"
echo RENAME TABLE cei_t_compid TO cei_t_compid00@ >> "%DDL_FILE%"
echo RENAME TABLE cei_t_msg_token TO cei_t_msg_token00@ >> "%DDL_FILE%"
echo RENAME TABLE cei_t_event_reln TO cei_t_event_reln00@ >> "%DDL_FILE%"
echo RENAME TABLE cei_t_anyelmnt TO cei_t_anyelmnt00@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE INDEX ext_elem00_name ON cei_t_ext_elem00 >> "%DDL_FILE%"
echo (element_level, element_name) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Add indexes to each table using the new index names. Allow reverse scans. >> "%DDL_FILE%"
echo -- Add primary constraints to tables using the new primary key names >> "%DDL_FILE%"
echo CREATE UNIQUE INDEX compid00_pk >> "%DDL_FILE%"
echo ON cei_t_compid00 (global_id, rel_type) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_compid00 >> "%DDL_FILE%"
echo ADD CONSTRAINT compid00_pk PRIMARY KEY (global_id, rel_type)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX event_reln00_pk >> "%DDL_FILE%"
echo ON cei_t_event_reln00 >> "%DDL_FILE%"
echo (global_id, engine_id, array_index) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln00 >> "%DDL_FILE%"
echo ADD CONSTRAINT event_reln00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, engine_id, array_index)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX context00_pk >> "%DDL_FILE%"
echo ON cei_t_context00 >> "%DDL_FILE%"
echo (global_id, context_position) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_context00 >> "%DDL_FILE%"
echo ADD CONSTRAINT context00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, context_position)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX msg_token00_pk >> "%DDL_FILE%"
echo ON cei_t_msg_token00 >> "%DDL_FILE%"
echo (global_id, array_index) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_msg_token00 >> "%DDL_FILE%"
echo ADD CONSTRAINT msg_token00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, array_index)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX anyelmnt00_pk >> "%DDL_FILE%"
echo ON cei_t_anyelmnt00 >> "%DDL_FILE%"
echo (global_id, element_type, array_index, chunk_number) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_anyelmnt00 >> "%DDL_FILE%"
echo ADD CONSTRAINT anyelmnt00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_type, array_index, chunk_number)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_elem00_pk >> "%DDL_FILE%"
echo ON cei_t_ext_elem00 >> "%DDL_FILE%"
echo (global_id, element_key) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_elem00 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_elem00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_blob00_pk >> "%DDL_FILE%"
echo ON cei_t_ext_blob00 >> "%DDL_FILE%"
echo (global_id, element_key, chunk_number) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_blob00 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_blob00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, chunk_number)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_float00_pk >> "%DDL_FILE%"
echo ON cei_t_ext_float00 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_float00 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_float00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_string00_pk >> "%DDL_FILE%"
echo ON cei_t_ext_string00 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_string00 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_string00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_int00_pk >> "%DDL_FILE%"
echo ON cei_t_ext_int00 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_int00 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_int00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_date00_pk >> "%DDL_FILE%"
echo ON cei_t_ext_date00 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5 >> "%DDL_FILE%"
echo ALLOW REVERSE SCANS@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_date00 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_date00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Create views >> "%DDL_FILE%"
echo CREATE VIEW cei_v_reln_eng00 AS >> "%DDL_FILE%"
echo SELECT er.global_id,er.array_index,er.assoc_event_id, >> "%DDL_FILE%"
echo ae.engine_id,ae.engine_name,ae.engine_type >> "%DDL_FILE%"
echo FROM cei_t_event_reln00 er, cei_t_assoc_eng ae >> "%DDL_FILE%"
echo WHERE er.engine_id = ae.engine_id@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Add foreign key constraints to tables using the new foreign key names >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_string00 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_string00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem00 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_blob00 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_blob00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem00(global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_context00 >> "%DDL_FILE%"
echo ADD CONSTRAINT context00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event00 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_int00 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_int00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem00 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_compid00 >> "%DDL_FILE%"
echo ADD CONSTRAINT compid00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event00 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_msg_token00 >> "%DDL_FILE%"
echo ADD CONSTRAINT msg_token00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event00 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln00 >> "%DDL_FILE%"
echo ADD CONSTRAINT event_reln00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event00 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln00 >> "%DDL_FILE%"
echo ADD CONSTRAINT reln00_engine_fk >> "%DDL_FILE%"
echo FOREIGN KEY (engine_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_assoc_eng (engine_id) >> "%DDL_FILE%"
echo ON DELETE RESTRICT ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_anyelmnt00 >> "%DDL_FILE%"
echo ADD CONSTRAINT anyelmnt00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event00 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_float00 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_float00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem00 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_date00 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_date00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem00 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_elem00 >> "%DDL_FILE%"
echo ADD CONSTRAINT ext_elem00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event00 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE ON UPDATE RESTRICT@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Update the cei_t_ext_elem00 table. Set the float_value column to null if the extended >> "%DDL_FILE%"
echo -- data element is an integer type (Boolean, byte, short, int, long) >> "%DDL_FILE%"
echo UPDATE cei_t_ext_elem00 >> "%DDL_FILE%"
echo SET float_value = NULL >> "%DDL_FILE%"
echo WHERE data_type IN (9,1,2,3,4)@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Drop the old cei_t_event and cei_t_situation tables >> "%DDL_FILE%"
echo DROP TABLE cei_t_situation@ >> "%DDL_FILE%"
echo DROP TABLE cei_t_event@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Update the schema version information >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo UPDATE cei_t_properties >> "%DDL_FILE%"
echo SET property_value = '6' >> "%DDL_FILE%"
echo WHERE property_name = 'SchemaMajorVersion'@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo UPDATE cei_t_properties >> "%DDL_FILE%"
echo SET property_value = '0' >> "%DDL_FILE%"
echo WHERE property_name = 'SchemaMinorVersion'@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo UPDATE cei_t_properties >> "%DDL_FILE%"
echo SET property_value = '0' >> "%DDL_FILE%"
echo WHERE property_name = 'SchemaPtfLevel'@ >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT@ >> "%DDL_FILE%"
IF EXIST "%METADATA_FILE%" DEL /Q /F "%METADATA_FILE%"
echo. > "%METADATA_FILE%"
echo ----------------------------------------------------------------- >> "%METADATA_FILE%"

echo -- Licensed Materials - Property of IBM >> "%METADATA_FILE%"

echo -- (C) Copyright IBM Corp. 2004, 2011.  ALL RIGHTS RESERVED >> "%METADATA_FILE%"

echo -- 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70 >> "%METADATA_FILE%"

echo -- US Government Users Restricted Rights - Use, duplication, or disclosure >> "%METADATA_FILE%"

echo -- restricted by GSA ADP Schedule Contract with IBM Corp.p. >> "%METADATA_FILE%"

echo ----------------------------------------------------------------- >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo ----------------------------------------------------------------- >> "%METADATA_FILE%"

echo -- DB2 script that populates the cei_t_cbe_map table, which maps >> "%METADATA_FILE%"

echo -- CBE elements and attributes to tables and columns. It also >> "%METADATA_FILE%"

echo -- populates the cei_t_properties table, which contains runtime >> "%METADATA_FILE%"

echo -- properties. >> "%METADATA_FILE%"

echo ----------------------------------------------------------------- >> "%METADATA_FILE%"

echo set current schema = %DB_USER%; >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo DELETE FROM cei_t_cbe_map WHERE cbe_version = '1.0.1'; >> "%METADATA_FILE%"

echo COMMIT; >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo DELETE FROM cei_t_properties WHERE property_name IN >> "%METADATA_FILE%"

echo ('CbeMajorVersion', 'CbeMinorVersion', 'CbePtfLevel', 'SchemaMajorVersion', >> "%METADATA_FILE%"

echo 'SchemaMinorVersion', 'SchemaPtfLevel', >> "%METADATA_FILE%"

echo 'CurrentBucketNumber', 'NumberOfBuckets'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo COMMIT; >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --base event table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','version','CommonBaseEvent/@version'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','extension_name','CommonBaseEvent/@extensionName'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map(cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','local_id','CommonBaseEvent/@localInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES ('1.0.1','cei_t_event','creation_time','CommonBaseEvent/@creationTime'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES ('1.0.1','cei_t_event','creation_time_utc','dateTimeAsLong'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','severity','CommonBaseEvent/@severity'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','priority','CommonBaseEvent/@priority'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','sequence_number','CommonBaseEvent/@sequenceNumber'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES ('1.0.1','cei_t_event','repeat_count','CommonBaseEvent/@repeatCount'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','elapsed_time','CommonBaseEvent/@elapsedTime'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg','CommonBaseEvent/@msg'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg_id','CommonBaseEvent/msgDataElement/msgId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg_id_type','CommonBaseEvent/msgDataElement/msgIdType'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg_catalog_id','CommonBaseEvent/msgDataElement/msgCatalogId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg_catalog_type','CommonBaseEvent/msgDataElement/msgCatalogType'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg_catalog','CommonBaseEvent/msgDataElement/msgCatalog'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg_locale','CommonBaseEvent/msgDataElement/@msgLocale'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','has_context','boolean(CommonBaseEvent/contextDataElements)'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','has_msg_tokens','boolean(CommonBaseEvent/msgDataElement/msgCatalogTokens)'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','has_extended_elem','boolean(CommonBaseEvent/extendedDataElements)'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','has_any_element','hasAnyElement'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','has_situation','boolean(CommonBaseEvent/situation)'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','has_event_assoc','boolean(CommonBaseEvent/associatedEvents)'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --context table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_context','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_context','context_id','CommonBaseEvent/contextDataElements/contextId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_context','context_name','CommonBaseEvent/contextDataElements/@name'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_context','context_position','position'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_context','context_type','CommonBaseEvent/contextDataElements/@type'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_context','context_value','CommonBaseEvent/contextDataElements/contextValue'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Message catalog token table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_msg_token','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_msg_token','array_index','arrayIndex'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_msg_token','token','CommonBaseEvent/msgDataElement/msgCatalogTokens'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --base event table for Situation data >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','sit_category_name','CommonBaseEvent/situation/@categoryName'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','reasoning_scope','CommonBaseEvent/situation/situationType/@reasoningScope'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','sit_has_any_elem','sitHasAnyElement'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','success_disp','CommonBaseEvent/situation/situationType/@successDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','situation_qual','CommonBaseEvent/situation/situationType/@situationQualifier'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','situation_disp','CommonBaseEvent/situation/situationType/@situationDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','operation_disp','CommonBaseEvent/situation/situationType/@operationDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','availability_disp','CommonBaseEvent/situation/situationType/@availabilityDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','processing_disp','CommonBaseEvent/situation/situationType/@processingDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','report_category','CommonBaseEvent/situation/situationType/@reportCategory'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','feature_disp','CommonBaseEvent/situation/situationType/@featureDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','dependency_disp','CommonBaseEvent/situation/situationType/@dependencyDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Event association table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event_reln','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event_reln','assoc_event_id','CommonBaseEvent/associatedEvents/@resolvedEvents'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event_reln','engine_id','CommonBaseEvent/associatedEvents/associationEngine'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event_reln','array_index','arrayIndex'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Association engine table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_assoc_eng','engine_id','CommonBaseEvent/associatedEvents/associationEngineInfo/@id'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_assoc_eng','engine_type','CommonBaseEvent/associatedEvents/associationEngineInfo/@type'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_assoc_eng','engine_name','CommonBaseEvent/associatedEvents/associationEngineInfo/@name'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Event association view >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_v_reln_eng','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_v_reln_eng','assoc_event_id','CommonBaseEvent/associatedEvents/@resolvedEvents'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_v_reln_eng','engine_id','CommonBaseEvent/associatedEvents/associationEngineInfo/@id'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_v_reln_eng','array_index','arrayIndex'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_v_reln_eng','engine_type','CommonBaseEvent/associatedEvents/associationEngineInfo/@type'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_v_reln_eng','engine_name','CommonBaseEvent/associatedEvents/associationEngineInfo/@name'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Component table >> "%METADATA_FILE%"

echo --Both the reporter and source components map to the same table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','rel_type','relationType'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','component_type', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@componentType;CommonBaseEvent/sourceComponentId/@componentType'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','component', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@component;CommonBaseEvent/sourceComponentId/@component'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','sub_component', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@subComponent;CommonBaseEvent/sourceComponentId/@subComponent'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','comp_id_type', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@componentIdType;CommonBaseEvent/sourceComponentId/@componentIdType'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','instance_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@instanceId;CommonBaseEvent/sourceComponentId/@instanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','application', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@application;CommonBaseEvent/sourceComponentId/@application'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','exec_env', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@executionEnvironment;CommonBaseEvent/sourceComponentId/@executionEnvironment'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','location', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@location;CommonBaseEvent/sourceComponentId/@location'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','location_type', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@locationType;CommonBaseEvent/sourceComponentId/@locationType'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','process_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@processId;CommonBaseEvent/sourceComponentId/@processId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','thread_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@threadId;CommonBaseEvent/sourceComponentId/@threadId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Any element table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_anyelmnt','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_anyelmnt','element_type','elementType'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_anyelmnt','array_index','arrayIndex'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_anyelmnt','chunk_number','chunkNumber'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_anyelmnt','element_name','elementName'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_anyelmnt','namespace','nameSpace'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES ('1.0.1','cei_t_anyelmnt','value','value'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Extended data element table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','element_key','elementKey'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','parent_element_key','parentElementKey'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','element_name','CommonBaseEvent/extendedDataElements/@name'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','element_level','level'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','element_position','position'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','data_type','CommonBaseEvent/extendedDataElements/@type'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','string_value','CommonBaseEvent/extendedDataElements[@type=''string'']/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','long_value', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements[@type=''boolean'']/values;CommonBaseEvent/extendedDataElements[@type=''byte'']/values;CommonBaseEvent/extendedDataElements[@type=''short'']/values;CommonBaseEvent/extendedDataElements[@type=''int'']/values;CommonBaseEvent/extendedDataElements[@type=''long'']/values;CommonBaseEvent/extendedDataElements[@type=''dateTime'']/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','float_value', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements[@type=''float'']/values;CommonBaseEvent/extendedDataElements[@type=''double'']/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --String extended data element values >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_string','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_string','element_key','elementKey'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_string','array_index','arrayIndex'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_string','value','CommonBaseEvent/extendedDataElements/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Integer extended data element values >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_int','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_int','element_key','elementKey'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_int','array_index','arrayIndex'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_int','value','CommonBaseEvent/extendedDataElements/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Float extended data element values >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_float','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_float','element_key','elementKey'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_float','array_index','arrayIndex'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_float','value','CommonBaseEvent/extendedDataElements/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_float','value_string','floatAsString'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --DateTime extended data element values >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_date','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_date','element_key','elementKey'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_date','array_index','arrayIndex'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_date','value','CommonBaseEvent/extendedDataElements/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_date','value_utc','dateTimeAsLong'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Binary extended data element values >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_blob','global_id','CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_blob','element_key','elementKey'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_blob','chunk_number','chunkNumber'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_blob','value','CommonBaseEvent/extendedDataElements/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_properties >> "%METADATA_FILE%"

echo (property_name,property_value) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('CbeMajorVersion','1'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_properties >> "%METADATA_FILE%"

echo (property_name,property_value) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('CbeMinorVersion','0'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_properties >> "%METADATA_FILE%"

echo (property_name,property_value) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('CbePtfLevel','1'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_properties >> "%METADATA_FILE%"

echo (property_name,property_value) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('SchemaMajorVersion','6'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_properties >> "%METADATA_FILE%"

echo (property_name,property_value) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('SchemaMinorVersion','0'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_properties >> "%METADATA_FILE%"

echo (property_name,property_value) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('SchemaPtfLevel','0'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_properties >> "%METADATA_FILE%"

echo (property_name,property_value) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('NumberOfBuckets','2'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_properties >> "%METADATA_FILE%"

echo (property_name,property_value) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('CurrentBucketNumber','0'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo COMMIT; >> "%METADATA_FILE%"

goto RUN_UPGRADE
