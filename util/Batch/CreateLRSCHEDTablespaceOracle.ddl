-- Scriptfile to create tablespaces for Oracle
-- 1)  Replace all occurrances or @location@ in this file with the location
--     where you want the objects to be stored
-- 2)  Replace all occurrances of @LRSCHED_TABLESPACE@ with a valid tablespace name
-- 3)  Start this script with SQL*Plus
--
-- Example: 
--         sqlplus username/password@lrsched @CreateLRSCHEDTablespaceOracle.ddl

CREATE TABLESPACE @LRSCHED_TABLESPACE@ DATAFILE '@location@/@LRSCHED_TABLESPACE@.dbf' SIZE 5M AUTOEXTEND ON NEXT 1M MAXSIZE UNLIMITED DEFAULT STORAGE (INITIAL 1M NEXT 1M MAXEXTENTS UNLIMITED PCTINCREASE 0);
