@echo off
REM
REM Licensed Materials - Property of IBM
REM (C) Copyright IBM Corp. 2004, 2010.  ALL RIGHTS RESERVED 
REM 5724-I63, 5724-H88, 5655-N02, 5733-W70
REM US Government Users Restricted Rights - Use, duplication, or disclosure
REM restricted by GSA ADP Schedule Contract with IBM Corp.e.
REM 
REM --------------------------------------------------------------------------
REM Upgrade the Event Service DB2 z/OS database schema from v5.x to v6.1
REM
REM Usage: eventUpgradeDB2ZOS.bat -runUpgrade true_or_false \
REM                  -dbUser db_user \
REM                  [-dbName db_name] \
REM                  [-dbPassword db_password] \
REM                  [-dbNode db_node_name] \
REM                  [-scriptDir gen_scriptDir] \
REM                  [-eventDBName event_db_name] \
REM                  [-catalogDBName event_cat_db_name] \
REM                  [-storageGroup storage_group_name] \
REM                  [-bufferPool4K name_4K_buffer_pool] \
REM                  [-bufferPool8K name_8K_buffer_pool] \
REM                  [-bufferPool16K name_16K_buffer_pool] \
REM                  [-dbDiskSizeInMB db_disk_size_in_MB] 
REM
REM Where:
REM   true_or_false  - Specify true to run the upgrade.
REM                    Specify false to generate ddl scripts only. 
REM   db_user        - Require db2 userid.
REM   db_name        - Require database name if runUpgrade is true.
REM   db_password    - Optional password. DB2 will prompt if not specified.
REM   gen_script_dir - Optional directory to generate the DDL scripts.      
REM                    If not specified, the scripts will be generated in   
REM                    <current_dir>\eventDBUpgrade\DB2ZOS 
REM   eventDBName    - Optional event database group name. Default to event
REM   catalogDBName  - Optional event catalog database group name. 
REM                    Default to eventcat
REM   storage_group_name   - Optional storage group name. Default to sysdeflt.
REM   name_4K_buffer_pool  - Optional 4K buffer pool name. Default to BP9.
REM   name_8K_buffer_pool  - Optional 8K buffer pool name. Default to BP8K9.
REM   name_16K_buffer_pool - Optional 16K buffer pool name. Default to BP16K9.
REM   db_disk_size_in_MB   - Optional size of database. Default to 100.
REM  
REM   Example 1:                                                             
REM     eventUpgradeDB2ZOS runUpgrade=false dbUser=db2inst1        
REM
REM   Example 2:                                                             
REM     eventUpgradeDB2ZOS runUpgrade=true dbName=event dbUser=db2inst1   
REM
REM Return Codes:  0 for success, 1 for fail, 2 for no upgrade
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
SET RUN_UPGRADE=
SET IS_CONNECTED=0
SET UPGRADE_CAT=0

REM ------------------------------------------------------------------------
SET EVENT_DB_NAME=event
SET CAT_DB_NAME=eventcat
SET STORAGE_GROUP=sysdeflt
SET BUFFER_POOL_4K=BP9
SET BUFFER_POOL_8K=BP8K9
SET BUFFER_POOL_16K=BP16K9
SET DB_DISK_SIZE_MB=100
REM ------------------------------------------------------------------------

IF "%1"=="" SET RC=1&goto PRINT_USAGE

:PARAM_LOOP
echo %1
REM No more parameters to process
IF "%1"=="" GOTO VERIFY_INPUTS
IF "%1"=="-runUpgrade" SET RUN_UPGRADE=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="-dbName" SET DB_NAME=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="-dbUser" SET DB_USER=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="-dbPassword" SET DB_PASSWORD=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="-scriptDir" SET SCRIPT_DIR=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="-eventDBName" SET EVENT_DB_NAME=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="-catDBName" SET CAT_DB_NAME=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="-storageGroup" SET STORAGE_GROUP=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="-bufferPool4K" SET BUFFER_POOL_4K=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="-bufferPool8K" SET BUFFER_POOL_8K=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="-bufferPool16K" SET BUFFER_POOL_16K=%2%&shift&shift&goto PARAM_LOOP
IF "%1"=="-dbDiskSizeInMB" SET DB_DISK_SIZE_MB=%2%&shift&shift&goto PARAM_LOOP

:VERIFY_INPUTS
IF "%DB_USER%"=="" SET RC=1&echo dbUser is required.&GOTO PRINT_USAGE
IF "%RUN_UPGRADE%"=="" SET RC=1&echo runUpgrade is required.&GOTO PRINT_USAGE
IF "%RUN_UPGRADE%"=="true" SET RUN_UPGRADE=TRUE&goto GET_MORE_INPUTS
IF "%RUN_UPGRADE%"=="false" goto INITIALIZE
SET RC=1&goto PRINT_USAGE

:GET_MORE_INPUTS
IF "%DB_NAME%"=="" SET RC=1&echo dbName is required.&GOTO PRINT_USAGE

:INITIALIZE
REM initialize values
IF NOT EXIST "%SCRIPT_DIR%" goto DIR_NOT_FOUND
SET EVENT_UPGRADE_DIR=%SCRIPT_DIR%\eventDBUpgrade
IF NOT EXIST "%EVENT_UPGRADE_DIR%" MKDIR "%EVENT_UPGRADE_DIR%"
SET DB_UPGRADE_DIR=%EVENT_UPGRADE_DIR%\DB2ZOS
IF NOT EXIST "%DB_UPGRADE_DIR%" MKDIR "%DB_UPGRADE_DIR%"
SET SCHEMA_VERSION_DB2=%DB_UPGRADE_DIR%\schema_version.db2
SET SCHEMA_VERSION_TXT=%DB_UPGRADE_DIR%\schema_version.txt
SET FINDSTR_OUTPUT_TXT=%DB_UPGRADE_DIR%\findstr_output.txt
SET DDL_FILE=%DB_UPGRADE_DIR%\upgrade_event_db.db2
SET CAT_DDL_FILE=%DB_UPGRADE_DIR%\upgrage_tbl_catalog.db2
SET METADATA_FILE=%DB_UPGRADE_DIR%\ins_metadata.db2
SET CHECK_VERSION_FILE=%DB_UPGRADE_DIR%\check_version.ctl

IF "%RUN_UPGRADE%"=="false" goto GEN_UPGRADE_FILES

:BEGIN
ECHO Upgrading the Event Service DB2 database schema
SET USING=USING %DB_PASSWORD%
IF "%DB_PASSWORD%"=="" SET USING=

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
IF %RC% NEQ 0 SET RC=1&echo Failed to check the Event Service schema version&GOTO DISCONNECT_DB 


REM if version 5.1.0 found then upgrade catalog to 5.1.1 then to 6.1.0
IF EXIST "%FINDSTR_OUTPUT_TXT%" DEL /F /Q "%FINDSTR_OUTPUT_TXT%"
FINDSTR "5.1.0" "%SCHEMA_VERSION_TXT%" > "%FINDSTR_OUTPUT_TXT%"
SET RC=%ERRORLEVEL%
IF %RC% EQU 0 SET UPGRADE_CAT=1&goto GEN_UPGRADE_FILES

REM if version 5.1.1 found then upgrade from 5.1.1 to 6.1.0
IF EXIST "%FINDSTR_OUTPUT_TXT%" DEL /F /Q "%FINDSTR_OUTPUT_TXT%"
FINDSTR "5.1.1" "%SCHEMA_VERSION_TXT%" > "%FINDSTR_OUTPUT_TXT%"
SET RC=%ERRORLEVEL%
IF %RC% EQU 0 goto GEN_UPGRADE_FILES
SET RC=2&GOTO NO_UPGRADE

:RUN_UPGRADE
IF %RC% NEQ 0 SET RC=1&goto CHECK_RESULT
IF "%RUN_UPGRADE%"=="false" SET RC=0&goto END
IF "%UPGRADE_CAT%"=="0" goto UPGRADE_511_TO_700

REM Upgrade 5.1.0 to 5.1.1
ECHO db2 -td@ -f "%CAT_DDL_FILE% -s +c"
db2 -td@ -f "%CAT_DDL_FILE%" -s +c
SET RC=%ERRORLEVEL%
IF %RC% NEQ 0 echo DB2 command returned RC=%RC%&SET RC=1&GOTO DISCONNECT_DB

:UPGRADE_511_TO_700
REM call upgrade script
ECHO db2 -td@ -f "%DDL_FILE% -s +c"
db2 -td@ -f "%DDL_FILE%" -s +c
SET RC=%ERRORLEVEL%
IF %RC% NEQ 0 echo DB2 command returned RC=%RC%&SET RC=1&GOTO DISCONNECT_DB

echo db2 -s -t -f "%METADATA_FILE%"
db2 -s -t -f "%METADATA_FILE%"
set RC=%ERRORLEVEL%
REM suppress warnings
IF %RC% EQU 7 SET RC=0
IF %RC% EQU 3 SET RC=0

REM suppress warnings about empty rows
IF %RC% EQU 1 SET RC=0
goto DISCONNECT_DB

:NO_UPGRADE
REM Check for errors
FINDSTR "SQLSTATE" "%SCHEMA_VERSION_TXT%" >> "%FINDSTR_OUTPUT_TXT%"
SET RC=%ERRORLEVEL%
IF %RC% EQU 0 type "%SCHEMA_VERSION_TXT%"&SET RC=1

IF %IS_CONNECTED% EQU 1 goto DISCONNECT_DB
goto END

:DISCONNECT_DB
REM Disconnect DB
ECHO db connect reset
db2 connect reset
goto CHECK_RESULT

:PRINT_USAGE
ECHO.
ECHO  Usage: upgrade_event_db2zos.bat -runUpgrade true_or_false \
ECHO      -dbUser db_user \
ECHO      [-dbName db_name] \
ECHO      [-dbPassword db_password] \
ECHO      [-scriptDir gen_script_dir] \
ECHO      [-eventDBName event_db_name] \
ECHO      [-catalogDBNam =event_cat_db_name] \
ECHO      [-storageGroup storage_group_name] \
ECHO      [-bufferPool4K name_4K_buffer_pool] \
ECHO      [-bufferPool8K name_8K_buffer_pool] \
ECHO      [-bufferPool16K name_16K_buffer_pool] \
ECHO      [-dbDiskSizeInMB db_disk_size_in_MB]
ECHO. 
ECHO  Where:
ECHO    true_or_false - Specify true to run the upgrade.                    
ECHO                    Specify false to generate ddl scripts only.
ECHO    db_user       - Require db2 userid.
ECHO    db_name       - Require database name if runUpgrade is true.
ECHO    db_password   - Optional password. DB2 will prompt if not specified.
ECHO    gen_script_dir- Optional directory to generate the DDL scripts.
ECHO                    If not specified, the scripts will be generated in
ECHO                    ^<current_dir^>\eventDBUpgrade\DB2ZOS
ECHO    eventDBName   - Optional event database group name. Default to event
ECHO    catalogDBName  - Optional event catalog database group name.
ECHO                    Default to eventcat 
ECHO    storage_group_name   - Optional storage group name.
ECHO                           Default to sysdeflt.
ECHO    name_4K_buffer_pool  - Optional 4K buffer pool name.
ECHO                           Default to BP9.
ECHO    name_8K_buffer_pool  - Optional 8K buffer pool name.
ECHO                           Default to BP8K9.
ECHO    name_16K_buffer_pool - Optional 16K buffer pool name.
ECHO                           Default to BP16K9.
ECHO    db_disk_size_in_MB   - Optional size of database. 
ECHO                           Default to 100.
ECHO.
ECHO  Example 1:
ECHO     upgrade_event_db2 runUpgrade=false dbUser=db2inst1 
ECHO.
ECHO  Example 2:
ECHO     upgrade_event_db2zos runUpgrade=true dbName=event dbUser=db2inst1
ECHO.
GOTO END

:CHECK_RESULT
IF %RC% EQU 0 ECHO The Event Service DB2 z/OS database schema upgrade completed successfully.&goto END
IF %RC% EQU 2 ECHO The Event Service DB2 z/OS database schema is up to date. No upgrade is needed.&goto END
ECHO Errors occurred during the Event Service DB2 z/OS database schema upgrade.&goto END

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
echo Generating the Event Service DB2 z/OS database schema upgrade scripts to directory %SCRIPT_DIR%

REM Set the Derby classpath
call "%~dp0setupCmdLine.bat"

REM Construct the parameters to be passed to the java script generator
SET INPUT_PARAMS=-DDB_TYPE=DB2ZOS -DOUTPUT_DIR=%DB_UPGRADE_DIR%
SET INPUT_PARAMS=%INPUT_PARAMS% -Deventdbname=%EVENT_DB_NAME% 
SET INPUT_PARAMS=%INPUT_PARAMS% -Dcatalogdbname=%CAT_DB_NAME%
SET INPUT_PARAMS=%INPUT_PARAMS% -DstorageGroup=%STORAGE_GROUP%
SET INPUT_PARAMS=%INPUT_PARAMS% -DbufferPool4K=%BUFFER_POOL_4K%
SET INPUT_PARAMS=%INPUT_PARAMS% -DbufferPool8K=%BUFFER_POOL_8K%
SET INPUT_PARAMS=%INPUT_PARAMS% -DbufferPool16K=%BUFFER_POOL_16K%
SET INPUT_PARAMS=%INPUT_PARAMS% -DdbDiskSizeInMB=%DB_DISK_SIZE_MB%

"%JAVA_HOME%\bin\java" %WAS_LOGGING% %CONSOLE_ENCODING% -Dwas.install.root="%WAS_HOME%" -Dws.ext.dirs="%WAS_EXT_DIRS%" %USER_INSTALL_PROP% -Xbootclasspath/p:"%WAS_BOOTCLASSPATH%" -classpath "%WAS_CLASSPATH%" %INPUT_PARAMS% com.ibm.ws.bootstrap.WSLauncher com.ibm.events.install.db.DBGenerateUpgradeScripts %*   

SET RC=%ERRORLEVEL%

IF %RC% NEQ 0 SET RC=1&GOTO CHECK_RESULT


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

echo ('CbeMajorVersion', 'CbeMinorVersion', 'CbePtfLevel', >> "%METADATA_FILE%"

echo 'SchemaMajorVersion', >> "%METADATA_FILE%"

echo 'SchemaMinorVersion', 'SchemaPtfLevel', >> "%METADATA_FILE%"

echo 'CurrentBucketNumber', 'NumberOfBuckets'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo COMMIT; >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --base event table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','version','CommonBaseEvent/@version'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','extension_name', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@extensionName'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map(cbe_version,table_name,column_name, >> "%METADATA_FILE%"

echo element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','local_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@localInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES ('1.0.1','cei_t_event','creation_time', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@creationTime'); >> "%METADATA_FILE%"

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

echo ('1.0.1','cei_t_event','sequence_number', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@sequenceNumber'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES ('1.0.1','cei_t_event','repeat_count', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@repeatCount'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','elapsed_time', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@elapsedTime'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg','CommonBaseEvent/@msg'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/msgDataElement/msgId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg_id_type', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/msgDataElement/msgIdType'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg_catalog_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/msgDataElement/msgCatalogId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg_catalog_type', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/msgDataElement/msgCatalogType'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg_catalog', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/msgDataElement/msgCatalog'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','msg_locale', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/msgDataElement/@msgLocale'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','has_context', >> "%METADATA_FILE%"

echo 'boolean(CommonBaseEvent/contextDataElements)'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','has_msg_tokens', >> "%METADATA_FILE%"

echo 'boolean(CommonBaseEvent/msgDataElement/msgCatalogTokens)'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','has_extended_elem', >> "%METADATA_FILE%"

echo 'boolean(CommonBaseEvent/extendedDataElements)'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','has_any_element','hasAnyElement'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','has_event_assoc', >> "%METADATA_FILE%"

echo 'boolean(CommonBaseEvent/associatedEvents)'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --context table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_context','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_context','context_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/contextDataElements/contextId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_context','context_name', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/contextDataElements/@name'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_context','context_position','position'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_context','context_type', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/contextDataElements/@type'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_context','context_value', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/contextDataElements/contextValue'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Message catalog token table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_msg_token','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_msg_token','array_index','arrayIndex'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_msg_token','token', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/msgDataElement/msgCatalogTokens'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Situation table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','sit_category_name', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/situation/@categoryName'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','reasoning_scope', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/situation/situationType/@reasoningScope'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','sit_has_any_elem','sitHasAnyElement'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','success_disp', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/situation/situationType/@successDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','situation_qual', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/situation/situationType/@situationQualifier'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','situation_disp', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/situation/situationType/@situationDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','operation_disp', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/situation/situationType/@operationDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','availability_disp', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/situation/situationType/@availabilityDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','processing_disp', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/situation/situationType/@processingDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','report_category', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/situation/situationType/@reportCategory'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','feature_disp', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/situation/situationType/@featureDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event','dependency_disp', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/situation/situationType/@dependencyDisposition'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Event association table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event_reln','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event_reln','assoc_event_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/associatedEvents/@resolvedEvents'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_event_reln','engine_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/associatedEvents/associationEngine'); >> "%METADATA_FILE%"

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

echo ('1.0.1','cei_t_assoc_eng','engine_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/associatedEvents/associationEngineInfo/@id'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_assoc_eng','engine_type', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/associatedEvents/associationEngineInfo/@type'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_assoc_eng','engine_name', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/associatedEvents/associationEngineInfo/@name'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Event association view >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_v_reln_eng','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_v_reln_eng','assoc_event_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/associatedEvents/@resolvedEvents'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_v_reln_eng','engine_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/associatedEvents/associationEngineInfo/@id'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_v_reln_eng','array_index','arrayIndex'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_v_reln_eng','engine_type', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/associatedEvents/associationEngineInfo/@type'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_v_reln_eng','engine_name', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/associatedEvents/associationEngineInfo/@name'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Component table >> "%METADATA_FILE%"

echo --Both the reporter and source components map to the same table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

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

echo 'CommonBaseEvent/reporterComponentId/@componentType;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/sourceComponentId/@componentType'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','component', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@component;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/sourceComponentId/@component'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','sub_component', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@subComponent;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/sourceComponentId/@subComponent'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','comp_id_type', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@componentIdType;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/sourceComponentId/@componentIdType'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','instance_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@instanceId;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/sourceComponentId/@instanceId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','application', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@application;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/sourceComponentId/@application'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','exec_env', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@executionEnvironment;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/sourceComponentId/@executionEnvironment'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','location', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@location;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/sourceComponentId/@location'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','location_type', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@locationType;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/sourceComponentId/@locationType'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','process_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@processId;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/sourceComponentId/@processId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_compid','thread_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/reporterComponentId/@threadId;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/sourceComponentId/@threadId'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Any element table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_anyelmnt','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

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

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES ('1.0.1','cei_t_anyelmnt','rowid','rowid'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Extended data element table >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

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

echo ('1.0.1','cei_t_ext_elem','element_name', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements/@name'); >> "%METADATA_FILE%"

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

echo ('1.0.1','cei_t_ext_elem','data_type', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements/@type'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','string_value', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements[@type=''string'']/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','long_value', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements[@type=''boolean'']/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo UPDATE cei_t_cbe_map >> "%METADATA_FILE%"

echo SET element_xpath = element_xpath ^|^| >> "%METADATA_FILE%"

echo ';CommonBaseEvent/extendedDataElements[@type=''byte'']/values' >> "%METADATA_FILE%"

echo WHERE cbe_version='1.0.1' >> "%METADATA_FILE%"

echo AND table_name = 'cei_t_ext_elem' >> "%METADATA_FILE%"

echo AND column_name = 'long_value'; >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo UPDATE cei_t_cbe_map >> "%METADATA_FILE%"

echo SET element_xpath = element_xpath ^|^| >> "%METADATA_FILE%"

echo ';CommonBaseEvent/extendedDataElements[@type=''short'']/values' ^|^| >> "%METADATA_FILE%"

echo ';CommonBaseEvent/extendedDataElements[@type=''int'']/values' >> "%METADATA_FILE%"

echo WHERE cbe_version='1.0.1' >> "%METADATA_FILE%"

echo AND table_name = 'cei_t_ext_elem' >> "%METADATA_FILE%"

echo AND column_name = 'long_value'; >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo UPDATE cei_t_cbe_map >> "%METADATA_FILE%"

echo SET element_xpath = element_xpath ^|^| >> "%METADATA_FILE%"

echo ';CommonBaseEvent/extendedDataElements[@type=''long'']/values;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements[@type=''dateTime'']/values' >> "%METADATA_FILE%"

echo WHERE cbe_version='1.0.1' >> "%METADATA_FILE%"

echo AND table_name = 'cei_t_ext_elem' >> "%METADATA_FILE%"

echo AND column_name = 'long_value'; >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_elem','float_value', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements[@type=''float'']/values;' ^|^| >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements[@type=''double'']/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --String extended data element values >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_string','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

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

echo ('1.0.1','cei_t_ext_string','value', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Integer extended data element values >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_int','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

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

echo ('1.0.1','cei_t_ext_int','value', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo --Float extended data element values >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_float','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

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

echo ('1.0.1','cei_t_ext_float','value', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements/values'); >> "%METADATA_FILE%"

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

echo ('1.0.1','cei_t_ext_date','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

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

echo ('1.0.1','cei_t_ext_date','value', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements/values'); >> "%METADATA_FILE%"

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

echo ('1.0.1','cei_t_ext_blob','global_id', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/@globalInstanceId'); >> "%METADATA_FILE%"

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

echo ('1.0.1','cei_t_ext_blob','value', >> "%METADATA_FILE%"

echo 'CommonBaseEvent/extendedDataElements/values'); >> "%METADATA_FILE%"

echo. >> "%METADATA_FILE%"

echo INSERT INTO cei_t_cbe_map >> "%METADATA_FILE%"

echo (cbe_version,table_name,column_name,element_xpath) >> "%METADATA_FILE%"

echo VALUES >> "%METADATA_FILE%"

echo ('1.0.1','cei_t_ext_blob','rowid','rowid'); >> "%METADATA_FILE%"

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

IF EXIST "%CHECK_VERSION_FILE%" DEL /Q /F "%CHECK_VERSION_FILE%"
echo. > "%CHECK_VERSION_FILE%"
echo -------------------------------------------------------------------------- >> "%CHECK_VERSION_FILE%"

echo -- Licensed Materials - Property of IBM >> "%CHECK_VERSION_FILE%"

echo -- (C) Copyright IBM Corp. 2004, 2010.  ALL RIGHTS RESERVED >> "%CHECK_VERSION_FILE%"

echo -- 5724-I63, 5724-H88, 5655-N02, 5733-W70 >> "%CHECK_VERSION_FILE%"

echo -- US Government Users Restricted Rights - Use, duplication, or disclosure >> "%CHECK_VERSION_FILE%"

echo -- restricted by GSA ADP Schedule Contract with IBM Corp. >> "%CHECK_VERSION_FILE%"

echo -------------------------------------------------------------------------- >> "%CHECK_VERSION_FILE%"

echo CHECK DATA >> "%CHECK_VERSION_FILE%"

echo -- DB2 Utility control file that is used with the CHECK DATA DB2 >> "%CHECK_VERSION_FILE%"

echo -- utility after a CEI 5.1.0 or 5.1.1 database is upgraded to a >> "%CHECK_VERSION_FILE%"

echo -- CEI 6.0.0 database. Running the CHECK DATA utility gets >> "%CHECK_VERSION_FILE%"

echo -- tablespaces out of the check pending state. >> "%CHECK_VERSION_FILE%"

echo -- >> "%CHECK_VERSION_FILE%"

echo -- All of the data will be valid, so we do not need to specify >> "%CHECK_VERSION_FILE%"

echo -- where to place invalid rows. >> "%CHECK_VERSION_FILE%"

echo -- >> "%CHECK_VERSION_FILE%"

echo -- To submit the CHECK DATA DB2 utility: >> "%CHECK_VERSION_FILE%"

echo --  1. Upload the contents of this file to a data set on the host. >> "%CHECK_VERSION_FILE%"

echo --     It must be uploaded with a fixed record format with a logical >> "%CHECK_VERSION_FILE%"

echo --     record length of 80. >> "%CHECK_VERSION_FILE%"

echo --  2. In ISPF, go to the DB2I Primary Option Menu >> "%CHECK_VERSION_FILE%"

echo --  3. Select option 8 Utilities >> "%CHECK_VERSION_FILE%"

echo --  4. In entry field 1 FUNCTION, specify EDITJCL >> "%CHECK_VERSION_FILE%"

echo --  5. In entry field 3 UTILITY, specify CHECK DATA >> "%CHECK_VERSION_FILE%"

echo --  6. In entry field 4 STATEMENT DATA SET, specify the data set >> "%CHECK_VERSION_FILE%"

echo --     name for the dataset that contains the contents of this file. >> "%CHECK_VERSION_FILE%"

echo --  7. In the entry field 6 LISTDEF? YES/NO , specify NO >> "%CHECK_VERSION_FILE%"

echo --  8. In the entry field TEMPLATE? YES/NO, specify NO >> "%CHECK_VERSION_FILE%"

echo --  9. Press the enter key to generate the JCL >> "%CHECK_VERSION_FILE%"

echo -- 10. Press the enter key to clear the screen of output messages >> "%CHECK_VERSION_FILE%"

echo -- 11. Edit the generated JCL as needed >> "%CHECK_VERSION_FILE%"

echo -- 12. On the Command ===>, enter submit and press enter >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceicfg >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceievent >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceiextel >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceiexstr >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceiexint >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceiexflt >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceiexdte >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceiexblb >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceianyel >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceireln >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceicntxt >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceicomp >> "%CHECK_VERSION_FILE%"

echo TABLESPACE event.ceimsgtk >> "%CHECK_VERSION_FILE%"

goto RUN_UPGRADE
