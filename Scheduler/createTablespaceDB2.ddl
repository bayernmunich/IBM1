-- Scriptfile to create tablespaces for DB2
-- 1)  Replace occurence or @location@ in this file with the location
--     where you want the objects to be stored
-- 2)  Replace all occurrances of @SCHED_TABLESPACE@ with a valid tablespace name
-- 3)  Execute the createTablespaceDB2.ddl script
--
-- Example:
--      db2 connect to SCHEDDB
--      db2 -tf createTablespaceDB2.ddl

CREATE TABLESPACE @SCHED_TABLESPACE@ MANAGED BY SYSTEM USING( '@location@\@SCHED_TABLESPACE@' );
