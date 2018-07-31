-- Scriptfile to drop tablespaces for DB2 z/OS
-- 1. Replace all occurrances of @SCHED_TABLESPACE@ with a valid tablespace name.
-- 2. Replace all occurrances of @DBNAME@ with a valid z/OS database name.
--      For example:  DSNDB04
-- 3. Execute the dropTablespaceDB2ZOS.ddl script
--
-- Example:
--      db2 connect to SCHEDDB
--      db2 -tf dropTablespaceDB2ZOS.ddl

DROP TABLESPACE @DBNAME@.@SCHED_TABLESPACE@;
DROP TABLESPACE @DBNAME@.@SCHED_TABLESPACE@1;
