-- Scriptfile to drop schema for DB2 z/OS
-- 1. Replace all occurrances of @TABLE_PREFIX@ to the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Process this script in the DB2 command line processor
-- Example:
--             db2 connect to SCHEDDB
--             db2 -tf dropSchemaDB2ZOS.ddl

-- Auxillary table indices
DROP INDEX @TABLE_PREFIX@TASK1I;

-- Auxillary tables
DROP TABLE @TABLE_PREFIX@TASK1;

-- Indices
DROP INDEX @TABLE_PREFIX@TASK_IDX1;
DROP INDEX @TABLE_PREFIX@TASK_IDX2;

-- Main table
DROP TABLE @TABLE_PREFIX@TASK;

-- Registry table
DROP TABLE @TABLE_PREFIX@TREG;

-- Lease Manager Tables
DROP TABLE @TABLE_PREFIX@LMGR;
DROP TABLE @TABLE_PREFIX@LMPR;