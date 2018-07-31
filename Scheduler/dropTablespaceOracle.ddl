-- Scriptfile to drop tablespaces for Oracle
-- 1)  Replace all occurrances of @SCHED_TABLESPACE@ with a valid tablespace name.
-- 2)  Start this script with SQL*Plus
--
-- Example: 
--         sqlplus username/password@mydb @dropTablespaceOracle.ddl

DROP TABLESPACE @SCHED_TABLESPACE@ INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;
