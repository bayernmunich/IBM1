-- Scriptfile to drop tablespaces for DB2
-- 1)  Replace all occurrances of @SCHED_TABLESPACE@ with a valid tablespace name.
-- 2)  Execute the dropTablespaceDB2.ddl script
--
-- Example:
--      db2 connect to SCHEDDB
--      db2 -tf dropTablespaceDB2.ddl

DROP TABLESPACE @SCHED_TABLESPACE@;
