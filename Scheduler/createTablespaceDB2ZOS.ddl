-- Scriptfile to create tablespaces for DB2 z/OS
-- 1. Replace all occurrances of @STG@ with the storage group
--      For example:  SYSDEFLT
-- 2. Replace all occurrances of @SCHED_TABLESPACE@ with a valid tablespace name
--      For example:  MYTS
-- 3. Replace all occurrances of @DBNAME@ with a valid z/OS database name.
--      For example:  DSNDB04
-- Example:
--      db2 connect to SCHEDDB
--      db2 -tf createTablespaceDB2ZOS.ddl
--
--

CREATE TABLESPACE @SCHED_TABLESPACE@ IN @DBNAME@ USING STOGROUP @STG@ LOCKSIZE ROW CCSID UNICODE;

-- Auxillary Tablespaces for LOB columns
CREATE LOB TABLESPACE @SCHED_TABLESPACE@1 IN @DBNAME@ USING STOGROUP @STG@;

