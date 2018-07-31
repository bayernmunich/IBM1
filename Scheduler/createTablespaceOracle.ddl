-- Scriptfile to create tablespaces for Oracle
-- 1)  Replace all occurrances or @location@ in this file with the location
--     where you want the objects to be stored
-- 2)  Replace all occurrances of @SCHED_TABLESPACE@ with a valid tablespace name
-- 3)  Start this script with SQL*Plus
--
-- Example: 
--         sqlplus username/password@scheddb @createTablespaceOracle.ddl

CREATE TABLESPACE @SCHED_TABLESPACE@ DATAFILE '@location@/@SCHED_TABLESPACE@.dbf' SIZE 5M AUTOEXTEND ON NEXT 1M MAXSIZE UNLIMITED;
