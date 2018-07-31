@echo off
REM
REM
REM Licensed Materials - Property of IBM
REM (C) Copyright IBM Corp. 2004, 2010.  ALL RIGHTS RESERVED 
REM 5724-I63, 5724-H88, 5655-N02, 5733-W70
REM US Government Users Restricted Rights - Use, duplication, or disclosure
REM restricted by GSA ADP Schedule Contract with IBM Corp.
REM  
REM --------------------------------------------------------------------------
REM Upgrade the Event Service Oracle database schema from v5.x to v7.0
REM
REM Usage: eventUpgradeOracle.bat runUpgrade=true_or_false \
REM                  schemaUser=schema_user
REM                  [oracleHome=oracle_home_dir] \
REM                  [dbName=db_name] \
REM                  [dbUser=sys_user] \
REM                  [dbPassword=sys_password] \ 
REM                  [scriptDir=gen_scriptDir] \
REM                  [tsBaseName=table_space_base_name] \
REM                  [tsExtName=table_space_extended_name] \
REM
REM Where:
REM   true_or_false  - Specify true to run the upgrade.
REM                    Specify false to generate ddl scripts only. 
REM   schema_user    - Specify the user id that owns the Event Service tables.
REM   oracle_home    - Path to the Oracle home. Required if runUpgrade is true.
REM   db_name        - Database name. Required if runUpgrade is true.
REM   sys_user       - Oracle sys userid. Required if runUpgrade is true.
REM   sys_password   - Optional sys password. 
REM                    Do not specify this parameter if no password. 
REM   gen_script_dir - Optional directory to generate the DDL scripts.      
REM                    If not specified, the scripts will be generated in   
REM                    <current_dir>\eventDBUpgrade\oracle 
REM   tsBaseName     - Optional table space base name. 
REM                    Default to cei_ts_base
REM   tsExtName      - Optional table space extended name. 
REM                    Default to cei_ts_extended
REM     
REM   Example 1:                                                             
REM     eventUpgradeOracle runUpgrade=false schemaUser=cei 
REM
REM   Example 2:                                                             
REM     eventUpgradeOracle runUpgrade=true schemaUser=cei 
REM             dbName=event dbUser=sys dbPassword=secret 
REM
REM Return Codes:  0 for success, 1 for fail
REM --------------------------------------------------------------------------

setlocal

%~d0
cd %~p0

REM initialize
SET RC=0
SET SCRIPT_DIR=.
SET ORACLE_HOME=
SET SCHEMA_USER=
SET DB_NAME=
SET DB_USER=
SET DB_PASSWORD=
SET ORACLE_ROLE=sysdba
SET TS_BASE_NAME=cei_ts_base
SET TS_EXTENDED_NAME=cei_ts_extended
SET RUN_UPGRADE=

IF "%1"=="" SET RC=1&GOTO PRINT_USAGE

:PARAM_LOOP
REM No more parameters to process
IF "%1"=="" GOTO VERIFY_INPUTS
IF "%1"=="runUpgrade" SET RUN_UPGRADE=%2%&shift&shift&GOTO PARAM_LOOP
IF "%1"=="schemaUser" SET SCHEMA_USER=%2%&shift&shift&GOTO PARAM_LOOP
IF "%1"=="oracleHome" SET ORACLE_HOME=%2%&shift&shift&GOTO PARAM_LOOP
IF "%1"=="dbName" SET DB_NAME=%2%&shift&shift&GOTO PARAM_LOOP
IF "%1"=="dbUser" SET DB_USER=%2%&shift&shift&GOTO PARAM_LOOP
IF "%1"=="dbPassword" SET DB_PASSWORD=%2%&shift&shift&GOTO PARAM_LOOP
IF "%1"=="scriptDir" SET SCRIPT_DIR=%2%&shift&shift&GOTO PARAM_LOOP
IF "%1"=="tsBaseName" SET TS_BASE_NAME=%2%&shift&shift&GOTO PARAM_LOOP
IF "%1"=="tsExtName" SET TS_EXTENDED_NAME=%2%&shift&shift&GOTO PARAM_LOOP

:VERIFY_INPUTS
IF "%SCHEMA_USER%"=="" SET RC=1&GOTO PRINT_USAGE
IF "%RUN_UPGRADE%"=="true" SET RUN_UPGRADE=TRUE&GOTO GET_MORE_INPUTS
IF "%RUN_UPGRADE%"=="false" GOTO INITIALIZE
SET RC=1&GOTO PRINT_USAGE

:GET_MORE_INPUTS
IF "%ORACLE_HOME%"=="" SET RC=1&echo oracleHome is required.&GOTO PRINT_USAGE
IF NOT EXIST "%ORACLE_HOME%" GOTO ORACLE_HOME_NOT_FOUND
IF "%DB_NAME%"=="" SET RC=1&echo dbName is required.&GOTO PRINT_USAGE
IF "%DB_USER%"=="" SET RC=1&echo dbUser is required.&GOTO PRINT_USAGE

:INITIALIZE
REM initialize values
IF NOT EXIST "%SCRIPT_DIR%" GOTO DIR_NOT_FOUND
SET EVENT_UPGRADE_DIR=%SCRIPT_DIR%\eventDBUpgrade
IF NOT EXIST "%EVENT_UPGRADE_DIR%" MKDIR "%EVENT_UPGRADE_DIR%"
SET DB_UPGRADE_DIR=%EVENT_UPGRADE_DIR%\oracle
IF NOT EXIST "%DB_UPGRADE_DIR%" MKDIR "%DB_UPGRADE_DIR%"
SET FINDSTR_OUTPUT_TXT=%DB_UPGRADE_DIR%\findstr_output.txt
SET DDL_FILE=%DB_UPGRADE_DIR%\upgrade_event_db.ora
SET METADATA_FILE=%DB_UPGRADE_DIR%\ins_metadata.ora
SET TEST_CONNECTION_LOG=%DB_UPGRADE_DIR%\testconnection.log
SET PATH=%ORACLE_HOME%\bin;%PATH%

IF "%RUN_UPGRADE%"=="false" GOTO GEN_UPGRADE_FILES

:BEGIN
ECHO Upgrading the Event Service Oracle database schema
IF "%DB_PASSWORD%"=="" GOTO NO_PASSWORD
SET CONNECT_STRING="%DB_USER%/%DB_PASSWORD%@%DB_NAME% as %ORACLE_ROLE%"
GOTO TEST_CONNECT_DB

:NO_PASSWORD
SET CONNECT_STRING="/@%DB_NAME% as %ORACLE_ROLE%"

:TEST_CONNECT_DB
IF EXIST %TEST_CONNECTION_LOG% DEL /F /Q %TEST_CONNECTION_LOG% 
ECHO quit;|sqlplus -S %CONNECT_STRING% > %TEST_CONNECTION_LOG%
FINDSTR "ORA-" %TEST_CONNECTION_LOG%
SET RC=%ERRORLEVEL%
IF %RC% EQU 0 GOTO CONNECTION_FAILED

FINDSTR "SP2-0306" %TEST_CONNECTION_LOG%
SET RC=%ERRORLEVEL%
IF %RC% EQU 0 GOTO CONNECTION_FAILED
IF EXIST %TEST_CONNECTION_LOG% DEL /F /Q %TEST_CONNECTION_LOG% 

REM successful connection, generate scripts
GOTO  GEN_UPGRADE_FILES

:RUN_UPGRADE
IF "%RUN_UPGRADE%"=="false" SET RC=0&GOTO END
REM call upgrade script
ECHO "sqlplus xxxxxx @%DLL_FILE%"
sqlplus -S %CONNECT_STRING% @%DDL_FILE% /NOLOG
SET RC=%ERRORLEVEL%
IF %RC% NEQ 0 ECHO sqlplus returned RC=%RC%&SET RC=1&GOTO CHECK_RESULT

ECHO "sqlplus xxxxxx @%METADATA_FILE%"
sqlplus -S %CONNECT_STRING% @%METADATA_FILE% /NOLOG
SET RC=%ERRORLEVEL%
IF %RC% NEQ 0 ECHO sqlplus returned RC=%RC%&SET RC=1&GOTO CHECK_RESULT

GOTO CHECK_RESULT

:CONNECTION_FAILED
SET RC=1
ECHO "Failed to connect to the Oracle database %DB_NAME%"
GOTO END

:PRINT_USAGE
ECHO.
ECHO Usage: upgrade_event_oracle.bat runUpgrade=true_or_false
ECHO                  schemaUser=schema_user
ECHO                  [oracleHome=oracle_home_dir]
ECHO                  [dbName=db_name]
ECHO                  [dbUser=sys_user]
ECHO                  [dbPassword=sys_password]
ECHO                  [scriptDir=gen_scriptDir]
ECHO                  [tsBaseName=table_space_base_name]
ECHO                  [tsExtName=table_space_extended_name]
ECHO. 
ECHO  Where:
ECHO   true_or_false  - Specify true to run the upgrade.
ECHO                    Specify false to generate ddl scripts only.
ECHO   schema_user    - Specify the user id that owns the Event Service tables.
ECHO   oracle_home    - Path to the Oracle home. Required if runUpgrade is true.
ECHO   db_name        - Database name. Required if runUpgrade is true.
ECHO   sys_user       - Oracle sys userid. Required if runUpgrade is true.
ECHO   sys_password   - Optional sys password.
ECHO                    Do not specify this parameter if no password. 
ECHO   gen_script_dir - Optional directory to generate the DDL scripts. 
ECHO                    If not specified, the scripts will be generated in 
ECHO                    ^<current_dir^>\eventDBUpgrade\oracle
ECHO   tsBaseName     - Optional table space base name.
ECHO                    Default to cei_ts_base.
ECHO   tsExtName      - Optional table space extended name.
ECHO                    Default to cei_ts_extended.
ECHO.
ECHO  Example 1:
ECHO     upgrade_event_oracle runUpgrade=false schemaUser=cei
ECHO.
ECHO  Example 2:
ECHO     upgrade_event_oracle runUpgrade=true schemaUser=cei dbName=event
ECHO               dbUser=sys dbPassword=secret
ECHO.
GOTO END

:CHECK_RESULT
IF %RC% EQU 0 ECHO The Event Service Oracle database schema upgrade completed successfully.&GOTO END
IF %RC% EQU 2 ECHO The Event Service Oracle database schema is up to date. No upgrade is needed.&GOTO END
ECHO Errors occurred during the Event Service Oracle database schema upgrade.&GOTO END

:DIR_NOT_FOUND
echo Directory %SCRIPT_DIR% not found
SET RC=1
GOTO END

:ORACLE_HOME_NOT_FOUND
echo Oracle home %ORACLE_HOME% not found
SET RC=1
GOTO END


:END
echo RC=%RC%
exit /B %RC%
endlocal

REM ==========================================================================

:GEN_UPGRADE_FILES
echo Generating the Event Service Oracle database schema upgrade scripts to directory %SCRIPT_DIR%
IF EXIST "%DDL_FILE%" DEL /Q /F "%DDL_FILE%"
echo. > "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Licensed Materials - Property of IBM >> "%DDL_FILE%"
echo -- (C) Copyright IBM Corp. 2004, 2010.  ALL RIGHTS RESERVED >> "%DDL_FILE%"
echo -- 5724-I63, 5724-H88, 5655-N02, 5733-W70 >> "%DDL_FILE%"
echo -- US Government Users Restricted Rights - Use, duplication, or disclosure >> "%DDL_FILE%"
echo -- restricted by GSA ADP Schedule Contract with IBM Corp. >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo WHENEVER SQLERROR EXIT FAILURE; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER SESSION set current_schema=%SCHEMA_USER%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Oracle script that migrates a 5.1.0 or 5.1.1 CEI schema to >> "%DDL_FILE%"
echo -- a 6.0.0 schema. >> "%DDL_FILE%"
echo -- >> "%DDL_FILE%"
echo -- A full database backup must be taken PRIOR to executing >> "%DDL_FILE%"
echo -- this script >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Verify that we are upgrading from a 5.1.0 or >> "%DDL_FILE%"
echo -- 5.1.1 CEI schema! >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo DECLARE >> "%DDL_FILE%"
echo v_schemaMajor INTEGER NOT NULL DEFAULT -1; >> "%DDL_FILE%"
echo v_schemaMinor INTEGER NOT NULL DEFAULT -1; >> "%DDL_FILE%"
echo v_schemaPtf INTEGER NOT NULL DEFAULT -1; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo BEGIN >> "%DDL_FILE%"
echo -- NO_DATA_FOUND exception will be thrown if the property values >> "%DDL_FILE%"
echo -- do not exist in the table >> "%DDL_FILE%"
echo SELECT TO_NUMBER(property_value) >> "%DDL_FILE%"
echo INTO v_schemaMajor >> "%DDL_FILE%"
echo FROM cei_t_properties >> "%DDL_FILE%"
echo WHERE property_name = 'SchemaMajorVersion'; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo IF (v_schemaMajor != 5) THEN >> "%DDL_FILE%"
echo RAISE_APPLICATION_ERROR(-20000, 'Invalid schema major version: ' ^|^| v_schemaMajor); >> "%DDL_FILE%"
echo END IF; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo SELECT TO_NUMBER(property_value) >> "%DDL_FILE%"
echo INTO v_schemaMinor >> "%DDL_FILE%"
echo FROM cei_t_properties >> "%DDL_FILE%"
echo WHERE property_name = 'SchemaMinorVersion'; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo IF (v_schemaMinor != 1) THEN >> "%DDL_FILE%"
echo RAISE_APPLICATION_ERROR(-20001, 'Invalid schema minor version: ' ^|^| v_schemaMinor); >> "%DDL_FILE%"
echo END IF; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo SELECT TO_NUMBER(property_value) >> "%DDL_FILE%"
echo INTO v_schemaPtf >> "%DDL_FILE%"
echo FROM cei_t_properties >> "%DDL_FILE%"
echo WHERE property_name = 'SchemaPtfLevel'; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo IF (v_schemaPtf != 0 AND v_schemaPtf != 1) THEN >> "%DDL_FILE%"
echo RAISE_APPLICATION_ERROR(-20002, 'Invalid schema PTF level: ' ^|^| v_schemaPtf); >> "%DDL_FILE%"
echo END IF; >> "%DDL_FILE%"
echo END; >> "%DDL_FILE%"
echo / >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- now we can safely begin the upgrade processing >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- When we drop the constraints, the associated indexes are also >> "%DDL_FILE%"
echo -- dropped >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln DROP CONSTRAINT cei_fk_evt_engine; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_assoc_eng DROP CONSTRAINT cei_pk_assoc_eng >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Non event tables >> "%DDL_FILE%"
echo ALTER TABLE cei_t_properties DROP CONSTRAINT cei_pk_properties >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_cbe_map DROP CONSTRAINT cei_pk_cbe_map >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX properties_pk >> "%DDL_FILE%"
echo ON cei_t_properties >> "%DDL_FILE%"
echo (property_name) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_properties >> "%DDL_FILE%"
echo ADD (CONSTRAINT properties_pk PRIMARY KEY >> "%DDL_FILE%"
echo (property_name)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX cbe_map_pk >> "%DDL_FILE%"
echo ON cei_t_cbe_map >> "%DDL_FILE%"
echo (cbe_version, table_name, column_name) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_cbe_map >> "%DDL_FILE%"
echo ADD (CONSTRAINT cbe_map_pk PRIMARY KEY >> "%DDL_FILE%"
echo (cbe_version, table_name, column_name)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX assoc_eng_pk >> "%DDL_FILE%"
echo ON cei_t_assoc_eng (engine_id) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_assoc_eng >> "%DDL_FILE%"
echo ADD (CONSTRAINT assoc_eng_pk PRIMARY KEY >> "%DDL_FILE%"
echo (engine_id)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Create new event tables for the second bucket >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Event tables Bucket 1 >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo CREATE TABLE cei_t_event01 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo version VARCHAR2 ( 16 ), >> "%DDL_FILE%"
echo extension_name VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo local_id VARCHAR2 ( 384 ), >> "%DDL_FILE%"
echo creation_time VARCHAR2 ( 32 ) NOT NULL, >> "%DDL_FILE%"
echo creation_time_utc NUMBER(20) NOT NULL, >> "%DDL_FILE%"
echo severity NUMBER(5), >> "%DDL_FILE%"
echo priority NUMBER(5), >> "%DDL_FILE%"
echo sequence_number NUMBER(20), >> "%DDL_FILE%"
echo repeat_count NUMBER(5), >> "%DDL_FILE%"
echo elapsed_time NUMBER(20), >> "%DDL_FILE%"
echo msg VARCHAR2 ( 3072 ), >> "%DDL_FILE%"
echo msg_id VARCHAR2 ( 768 ), >> "%DDL_FILE%"
echo msg_id_type VARCHAR2 ( 96 ), >> "%DDL_FILE%"
echo msg_catalog_id VARCHAR2 ( 384 ), >> "%DDL_FILE%"
echo msg_catalog_type VARCHAR2 ( 96 ), >> "%DDL_FILE%"
echo msg_catalog VARCHAR2 ( 384 ), >> "%DDL_FILE%"
echo msg_locale VARCHAR2 ( 33 ), >> "%DDL_FILE%"
echo sit_category_name VARCHAR2 ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo reasoning_scope VARCHAR2 ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo sit_has_any_elem NUMBER(1) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo success_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo situation_qual VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo situation_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo operation_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo availability_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo processing_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo report_category VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo feature_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo dependency_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo has_context NUMBER(1) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_msg_tokens NUMBER(1) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_extended_elem NUMBER(1) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_any_element NUMBER(1) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_event_assoc NUMBER(1) DEFAULT 0 NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_BASE_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX event01_pk >> "%DDL_FILE%"
echo ON cei_t_event01 (global_id) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_event01 >> "%DDL_FILE%"
echo ADD (CONSTRAINT event01_pk >> "%DDL_FILE%"
echo PRIMARY KEY (global_id)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_ext_elem01 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_key NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo parent_element_key NUMBER ( 10 ), >> "%DDL_FILE%"
echo element_name VARCHAR2 ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo element_level NUMBER ( 10 ) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo element_position NUMBER ( 10 ) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo data_type NUMBER ( 5 ) NOT NULL, >> "%DDL_FILE%"
echo string_value VARCHAR2(3072), >> "%DDL_FILE%"
echo long_value NUMBER(20), >> "%DDL_FILE%"
echo float_value FLOAT(126) >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_EXTENDED_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_elem01_pk >> "%DDL_FILE%"
echo ON cei_t_ext_elem01 >> "%DDL_FILE%"
echo (global_id, element_key) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_elem01 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_elem01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_ext_string01 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_key NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo array_index NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo value VARCHAR2 ( 3072 ) NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_EXTENDED_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_string01_pk >> "%DDL_FILE%"
echo ON cei_t_ext_string01 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_string01 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_string01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_ext_blob01 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_key NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo chunk_number NUMBER(10) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo value BLOB NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_EXTENDED_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_blob01_pk >> "%DDL_FILE%"
echo ON cei_t_ext_blob01 >> "%DDL_FILE%"
echo (global_id, element_key, chunk_number) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_blob01 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_blob01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, chunk_number)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_context01 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo context_position NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo context_id VARCHAR2 ( 765 ), >> "%DDL_FILE%"
echo context_name VARCHAR2 ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo context_type VARCHAR2 ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo context_value VARCHAR2 ( 3072 ) >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_BASE_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX context01_pk >> "%DDL_FILE%"
echo ON cei_t_context01 >> "%DDL_FILE%"
echo (global_id, context_position) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_context01 >> "%DDL_FILE%"
echo ADD (CONSTRAINT context01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, context_position)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_ext_int01 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_key NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo array_index NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo value NUMBER ( 20 ) NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_EXTENDED_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_int01_pk >> "%DDL_FILE%"
echo ON cei_t_ext_int01 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_int01 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_int01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_compid01 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo rel_type NUMBER ( 5 ) NOT NULL, >> "%DDL_FILE%"
echo component_type VARCHAR2(1536) NOT NULL, >> "%DDL_FILE%"
echo component VARCHAR2 ( 768 ) NOT NULL, >> "%DDL_FILE%"
echo sub_component VARCHAR2 ( 1536 ) NOT NULL, >> "%DDL_FILE%"
echo comp_id_type VARCHAR2 ( 384 ), >> "%DDL_FILE%"
echo instance_id VARCHAR2 ( 384 ), >> "%DDL_FILE%"
echo application VARCHAR2 ( 768 ), >> "%DDL_FILE%"
echo exec_env VARCHAR2 ( 768 ), >> "%DDL_FILE%"
echo location VARCHAR2 ( 768 ) NOT NULL, >> "%DDL_FILE%"
echo location_type VARCHAR2 ( 96 ) NOT NULL, >> "%DDL_FILE%"
echo process_id VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo thread_id VARCHAR2 ( 192 ) >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_BASE_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX compid01_pk >> "%DDL_FILE%"
echo ON cei_t_compid01 (global_id, rel_type) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_compid01 >> "%DDL_FILE%"
echo ADD (CONSTRAINT compid01_pk >> "%DDL_FILE%"
echo PRIMARY KEY (global_id, rel_type)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_msg_token01 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo array_index NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo token VARCHAR2 ( 768 ) NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_BASE_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX msg_token01_pk >> "%DDL_FILE%"
echo ON cei_t_msg_token01 >> "%DDL_FILE%"
echo (global_id, array_index) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_msg_token01 >> "%DDL_FILE%"
echo ADD (CONSTRAINT msg_token01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, array_index)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_event_reln01 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo engine_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo array_index NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo assoc_event_id VARCHAR2 ( 64 ) NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_BASE_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX event_reln01_pk >> "%DDL_FILE%"
echo ON cei_t_event_reln01 >> "%DDL_FILE%"
echo (global_id, engine_id, array_index) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln01 >> "%DDL_FILE%"
echo ADD (CONSTRAINT event_reln01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, engine_id, array_index)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_anyelmnt01 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_type NUMBER ( 5 ) NOT NULL, >> "%DDL_FILE%"
echo array_index NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo chunk_number NUMBER(10) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo element_name VARCHAR2 ( 3072 ), >> "%DDL_FILE%"
echo namespace VARCHAR2 ( 3072 ), >> "%DDL_FILE%"
echo value CLOB >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_BASE_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX anyelmnt01_pk >> "%DDL_FILE%"
echo ON cei_t_anyelmnt01 >> "%DDL_FILE%"
echo (global_id, element_type, array_index, chunk_number) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_anyelmnt01 >> "%DDL_FILE%"
echo ADD (CONSTRAINT anyelmnt01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_type, array_index, chunk_number)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_ext_float01 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_key NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo array_index NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo value FLOAT ( 126 ) NOT NULL, >> "%DDL_FILE%"
echo value_string VARCHAR2(254) DEFAULT '0' NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_EXTENDED_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_float01_pk >> "%DDL_FILE%"
echo ON cei_t_ext_float01 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_float01 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_float01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE TABLE cei_t_ext_date01 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo element_key NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo array_index NUMBER ( 10 ) NOT NULL, >> "%DDL_FILE%"
echo value VARCHAR2 ( 32 ) NOT NULL, >> "%DDL_FILE%"
echo value_utc NUMBER ( 20 ) NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_EXTENDED_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_date01_pk >> "%DDL_FILE%"
echo ON cei_t_ext_date01 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_date01 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_date01_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE INDEX event01_time_utc >> "%DDL_FILE%"
echo ON cei_t_event01 >> "%DDL_FILE%"
echo (creation_time_utc) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo CREATE INDEX ext_elem01_name >> "%DDL_FILE%"
echo ON cei_t_ext_elem01 >> "%DDL_FILE%"
echo (element_level, element_name) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE VIEW cei_v_reln_eng01 AS >> "%DDL_FILE%"
echo SELECT er.global_id,er.array_index,er.assoc_event_id,ae.engine_id,ae.engine_name,ae.engine_type >> "%DDL_FILE%"
echo FROM cei_t_event_reln01 er, cei_t_assoc_eng ae >> "%DDL_FILE%"
echo WHERE er.engine_id = ae.engine_id; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_string01 ADD ( >> "%DDL_FILE%"
echo CONSTRAINT ext_string01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem01 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_blob01 ADD ( >> "%DDL_FILE%"
echo CONSTRAINT ext_blob01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem01 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_context01 ADD ( >> "%DDL_FILE%"
echo CONSTRAINT context01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event01 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_int01 ADD ( >> "%DDL_FILE%"
echo CONSTRAINT ext_int01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem01 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_compid01 ADD ( >> "%DDL_FILE%"
echo CONSTRAINT compid01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event01 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_msg_token01 ADD ( >> "%DDL_FILE%"
echo CONSTRAINT msg_token01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event01 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln01 ADD ( >> "%DDL_FILE%"
echo CONSTRAINT event_reln01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event01 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln01 ADD ( >> "%DDL_FILE%"
echo CONSTRAINT reln01_engine_fk >> "%DDL_FILE%"
echo FOREIGN KEY (engine_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_assoc_eng (engine_id)); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_anyelmnt01 ADD ( >> "%DDL_FILE%"
echo CONSTRAINT anyelmnt01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event01 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_float01 ADD ( >> "%DDL_FILE%"
echo CONSTRAINT ext_float01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem01 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_date01 ADD ( >> "%DDL_FILE%"
echo CONSTRAINT ext_date01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem01 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_elem01 ADD ( >> "%DDL_FILE%"
echo CONSTRAINT ext_elem01_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event01 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Create the new cei_t_event00 table. We need to create >> "%DDL_FILE%"
echo -- the table because the has_situation column is being >> "%DDL_FILE%"
echo -- dropped from the table. >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo CREATE TABLE cei_t_event00 ( >> "%DDL_FILE%"
echo global_id VARCHAR2 ( 64 ) NOT NULL, >> "%DDL_FILE%"
echo version VARCHAR2 ( 16 ), >> "%DDL_FILE%"
echo extension_name VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo local_id VARCHAR2 ( 384 ), >> "%DDL_FILE%"
echo creation_time VARCHAR2 ( 32 ) NOT NULL, >> "%DDL_FILE%"
echo creation_time_utc NUMBER(20) NOT NULL, >> "%DDL_FILE%"
echo severity NUMBER(5), >> "%DDL_FILE%"
echo priority NUMBER(5), >> "%DDL_FILE%"
echo sequence_number NUMBER(20), >> "%DDL_FILE%"
echo repeat_count NUMBER(5), >> "%DDL_FILE%"
echo elapsed_time NUMBER(20), >> "%DDL_FILE%"
echo msg VARCHAR2 ( 3072 ), >> "%DDL_FILE%"
echo msg_id VARCHAR2 ( 768 ), >> "%DDL_FILE%"
echo msg_id_type VARCHAR2 ( 96 ), >> "%DDL_FILE%"
echo msg_catalog_id VARCHAR2 ( 384 ), >> "%DDL_FILE%"
echo msg_catalog_type VARCHAR2 ( 96 ), >> "%DDL_FILE%"
echo msg_catalog VARCHAR2 ( 384 ), >> "%DDL_FILE%"
echo msg_locale VARCHAR2 ( 33 ), >> "%DDL_FILE%"
echo sit_category_name VARCHAR2 ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo reasoning_scope VARCHAR2 ( 192 ) NOT NULL, >> "%DDL_FILE%"
echo sit_has_any_elem NUMBER(1) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo success_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo situation_qual VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo situation_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo operation_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo availability_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo processing_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo report_category VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo feature_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo dependency_disp VARCHAR2 ( 192 ), >> "%DDL_FILE%"
echo has_context NUMBER(1) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_msg_tokens NUMBER(1) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_extended_elem NUMBER(1) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_any_element NUMBER(1) DEFAULT 0 NOT NULL, >> "%DDL_FILE%"
echo has_event_assoc NUMBER(1) DEFAULT 0 NOT NULL >> "%DDL_FILE%"
echo ) >> "%DDL_FILE%"
echo TABLESPACE %TS_BASE_NAME%; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT; >> "%DDL_FILE%"
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
echo WHERE e.global_id = s.global_id; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Create indexes on the cei_t_event00 table >> "%DDL_FILE%"
echo CREATE UNIQUE INDEX event00_pk >> "%DDL_FILE%"
echo ON cei_t_event00 (global_id) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_event00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT event00_pk PRIMARY KEY (global_id)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Drop foreign key constraints on old event tables >> "%DDL_FILE%"
echo -- extended data element tables >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_string DROP CONSTRAINT cei_fk_ext_string; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_blob DROP CONSTRAINT cei_fk_ect_blob; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_integer DROP CONSTRAINT cei_fk_ext_integer; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_float DROP CONSTRAINT cei_fk_ext_float; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_datetime DROP CONSTRAINT cei_fk_extdatetime; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_element DROP CONSTRAINT cei_fk_ext_eventid; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- other event tables >> "%DDL_FILE%"
echo ALTER TABLE cei_t_context DROP CONSTRAINT cei_fk_context; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_compid DROP CONSTRAINT cei_fk_compid; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_msg_token DROP CONSTRAINT cei_fk_msg_token; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln DROP CONSTRAINT cei_fk_event_reln; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_anyelmnt DROP CONSTRAINT cei_fk_anyelmnt; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Drop primary key constraints on old event tables >> "%DDL_FILE%"
echo -- extended data element tables >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_string DROP CONSTRAINT cei_pk_ext_string >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_blob DROP CONSTRAINT cei_pk_ext_blob >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_integer DROP CONSTRAINT cei_pk_ext_integer >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_float DROP CONSTRAINT cei_pk_ext_float >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_datetime DROP CONSTRAINT cei_pk_extdatetime >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_element DROP CONSTRAINT cei_pk_ext_element >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- other event tables >> "%DDL_FILE%"
echo ALTER TABLE cei_t_context DROP CONSTRAINT cei_pk_context >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_compid DROP CONSTRAINT cei_pk_compid >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_msg_token  DROP CONSTRAINT cei_pk_msg_token >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln DROP CONSTRAINT cei_pk_event_reln >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo ALTER TABLE cei_t_anyelmnt DROP CONSTRAINT cei_pk_anyelmnt >> "%DDL_FILE%"
echo DROP INDEX; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Drop indexes on old event tables >> "%DDL_FILE%"
echo DROP INDEX cei_i_create_time; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Create new index on event table >> "%DDL_FILE%"
echo CREATE INDEX event00_time_utc ON cei_t_event00 >> "%DDL_FILE%"
echo (creation_time_utc) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Drop the unneeded views >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo DROP VIEW cei_v_reln_engine; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Rename all remaining event tables. For example, cei_t_compid becomes cei_t_compid00 >> "%DDL_FILE%"
echo ALTER TABLE %SCHEMA_USER%.cei_t_ext_string RENAME TO cei_t_ext_string00; >> "%DDL_FILE%"
echo ALTER TABLE %SCHEMA_USER%.cei_t_ext_blob RENAME TO cei_t_ext_blob00; >> "%DDL_FILE%"
echo ALTER TABLE %SCHEMA_USER%.cei_t_ext_integer RENAME TO cei_t_ext_int00; >> "%DDL_FILE%"
echo ALTER TABLE %SCHEMA_USER%.cei_t_ext_float RENAME TO cei_t_ext_float00; >> "%DDL_FILE%"
echo ALTER TABLE %SCHEMA_USER%.cei_t_ext_datetime RENAME TO cei_t_ext_date00; >> "%DDL_FILE%"
echo ALTER TABLE %SCHEMA_USER%.cei_t_ext_element RENAME TO cei_t_ext_elem00; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- other event tables >> "%DDL_FILE%"
echo ALTER TABLE %SCHEMA_USER%.cei_t_context RENAME TO cei_t_context00; >> "%DDL_FILE%"
echo ALTER TABLE %SCHEMA_USER%.cei_t_compid RENAME TO cei_t_compid00; >> "%DDL_FILE%"
echo ALTER TABLE %SCHEMA_USER%.cei_t_msg_token RENAME TO cei_t_msg_token00; >> "%DDL_FILE%"
echo ALTER TABLE %SCHEMA_USER%.cei_t_event_reln RENAME TO cei_t_event_reln00; >> "%DDL_FILE%"
echo ALTER TABLE %SCHEMA_USER%.cei_t_anyelmnt RENAME TO cei_t_anyelmnt00; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Add indexes to each table using the new index names. >> "%DDL_FILE%"
echo -- Add primary constraints to tables using the new primary key names >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX compid00_pk >> "%DDL_FILE%"
echo ON cei_t_compid00 >> "%DDL_FILE%"
echo (global_id, rel_type) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_compid00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT compid00_pk PRIMARY KEY (global_id, rel_type)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX event_reln00_pk >> "%DDL_FILE%"
echo ON cei_t_event_reln00 >> "%DDL_FILE%"
echo (global_id, engine_id, array_index) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT event_reln00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, engine_id, array_index)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX context00_pk >> "%DDL_FILE%"
echo ON cei_t_context00 >> "%DDL_FILE%"
echo (global_id, context_position) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_context00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT context00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, context_position)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX msg_token00_pk >> "%DDL_FILE%"
echo ON cei_t_msg_token00 >> "%DDL_FILE%"
echo (global_id, array_index) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_msg_token00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT msg_token00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, array_index)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX anyelmnt00_pk >> "%DDL_FILE%"
echo ON cei_t_anyelmnt00 >> "%DDL_FILE%"
echo (global_id, element_type, array_index, chunk_number) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_anyelmnt00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT anyelmnt00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_type, array_index, chunk_number)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo DROP INDEX CEI_I_EXT_NAME; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE INDEX ext_elem00_name ON cei_t_ext_elem00 >> "%DDL_FILE%"
echo (element_level, element_name) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_elem00_pk >> "%DDL_FILE%"
echo ON cei_t_ext_elem00 >> "%DDL_FILE%"
echo (global_id, element_key) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_elem00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_elem00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_blob00_pk >> "%DDL_FILE%"
echo ON cei_t_ext_blob00 >> "%DDL_FILE%"
echo (global_id, element_key, chunk_number) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_blob00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_blob00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, chunk_number)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_float00_pk >> "%DDL_FILE%"
echo ON cei_t_ext_float00 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_float00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_float00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_string00_pk >> "%DDL_FILE%"
echo ON cei_t_ext_string00 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_string00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_string00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_int00_pk >> "%DDL_FILE%"
echo ON cei_t_ext_int00 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_int00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_int00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo CREATE UNIQUE INDEX ext_date00_pk >> "%DDL_FILE%"
echo ON cei_t_ext_date00 >> "%DDL_FILE%"
echo (global_id, element_key, array_index) >> "%DDL_FILE%"
echo PCTFREE 5; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_date00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_date00_pk PRIMARY KEY >> "%DDL_FILE%"
echo (global_id, element_key, array_index)) >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Create views >> "%DDL_FILE%"
echo CREATE VIEW cei_v_reln_eng00 AS >> "%DDL_FILE%"
echo SELECT er.global_id,er.array_index,er.assoc_event_id,ae.engine_id,ae.engine_name,ae.engine_type >> "%DDL_FILE%"
echo FROM cei_t_event_reln00 er, cei_t_assoc_eng ae >> "%DDL_FILE%"
echo WHERE er.engine_id = ae.engine_id; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Add foreign key constraints to tables using the new foreign key names >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_string00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_string00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem00 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_blob00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_blob00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem00(global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_context00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT context00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event00 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_int00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_int00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem00 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_compid00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT compid00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event00 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_msg_token00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT msg_token00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event00 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT event_reln00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event00 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_event_reln00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT reln00_engine_fk >> "%DDL_FILE%"
echo FOREIGN KEY (engine_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_assoc_eng (engine_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_anyelmnt00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT anyelmnt00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event00 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_float00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_float00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem00 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_date00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_date00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id, element_key) >> "%DDL_FILE%"
echo REFERENCES cei_t_ext_elem00 (global_id, element_key) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo ALTER TABLE cei_t_ext_elem00 >> "%DDL_FILE%"
echo ADD (CONSTRAINT ext_elem00_fk >> "%DDL_FILE%"
echo FOREIGN KEY (global_id) >> "%DDL_FILE%"
echo REFERENCES cei_t_event00 (global_id) >> "%DDL_FILE%"
echo ON DELETE CASCADE); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Update the cei_t_ext_elem00 table. Set the float_value column to null if the extended >> "%DDL_FILE%"
echo -- data element is an integer type (Boolean, byte, short, int, long) >> "%DDL_FILE%"
echo UPDATE cei_t_ext_elem00 >> "%DDL_FILE%"
echo SET float_value = NULL >> "%DDL_FILE%"
echo WHERE data_type IN (9,1,2,3,4); >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo -- Drop the old cei_t_event and cei_t_situation tables >> "%DDL_FILE%"
echo DROP TABLE cei_t_situation; >> "%DDL_FILE%"
echo DROP TABLE cei_t_event; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo -- Update the schema version information >> "%DDL_FILE%"
echo ----------------------------------------------------------------- >> "%DDL_FILE%"
echo update cei_t_properties >> "%DDL_FILE%"
echo set property_value = '6' >> "%DDL_FILE%"
echo where property_name = 'SchemaMajorVersion'; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo update cei_t_properties >> "%DDL_FILE%"
echo set property_value = '0' >> "%DDL_FILE%"
echo where property_name = 'SchemaMinorVersion'; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo update cei_t_properties >> "%DDL_FILE%"
echo set property_value = '0' >> "%DDL_FILE%"
echo where property_name = 'SchemaPtfLevel'; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo COMMIT; >> "%DDL_FILE%"
echo.>> "%DDL_FILE%"
echo quit; >> "%DDL_FILE%"
IF EXIST "%METADATA_FILE%" DEL /Q /F "%METADATA_FILE%"
echo. > "%METADATA_FILE%"
echo ----------------------------------------------------------------- >> "%METADATA_FILE%"

echo -- Licensed Materials - Property of IBM >> "%METADATA_FILE%"

echo -- (C) Copyright IBM Corp. 2004, 2010.  ALL RIGHTS RESERVED >> "%METADATA_FILE%"

echo -- 5724-I63, 5724-H88, 5655-N02, 5733-W70 >> "%METADATA_FILE%"

echo -- US Government Users Restricted Rights - Use, duplication, or disclosure >> "%METADATA_FILE%"

echo -- restricted by GSA ADP Schedule Contract with IBM Corp. >> "%METADATA_FILE%"

echo ----------------------------------------------------------------- >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo ----------------------------------------------------------------- >> "%METADATA_FILE%"

echo -- Oracle script that populates the cei_t_cbe_map table, which >> "%METADATA_FILE%"

echo -- maps CBE elements and attributes to tables and columns. It >> "%METADATA_FILE%"

echo -- also populates the cei_t_properties table, which contains >> "%METADATA_FILE%"

echo -- runtime properties >> "%METADATA_FILE%"

echo ----------------------------------------------------------------- >> "%METADATA_FILE%"

echo WHENEVER SQLERROR EXIT FAILURE; >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo ALTER SESSION set current_schema=%SCHEMA_USER%; >> "%METADATA_FILE%"

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

echo ('1.0.1','cei_t_event','has_event_assoc','boolean(CommonBaseEvent/associatedEvents)'); >> "%METADATA_FILE%"

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

echo. >> "%METADATA_FILE%"

echo quit; >> "%METADATA_FILE%"

goto RUN_UPGRADE
