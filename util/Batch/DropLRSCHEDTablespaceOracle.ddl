-- Scriptfile to drop tablespaces for Oracle
-- 1)  Replace all occurrances of @LRSCHED_TABLESPACE@ with a valid tablespace name.
-- 2)  Start this script with SQL*Plus
--
-- Example: 
--         sqlplus username/password@lrsched @DroLRSCHEDTablespaceOracle.ddl

DROP TABLESPACE @LRSCHED_TABLESPACE@ INCLUDING CONTENTS;
