-- This file is deprecated and is superceded by dropSchemaMod1DB2iSeries.ddl.
-- Scriptfile to drop schema (tables) in DB2 on iSeries
-- 1. Replace all occurrances of @TABLE_PREFIX@ to the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Process this script in the DB2 command line processor
-- Example:
--            db2 connect to <dbname> user <user name> using <user password> 
--            db2 -tf dropSchemaDb2.ddl



DROP INDEX @TABLE_PREFIX@TASK_IDX1;

DROP INDEX @TABLE_PREFIX@TASK_IDX2;

DROP TABLE @TABLE_PREFIX@TASK;

DROP TABLE @TABLE_PREFIX@TREG;

DROP TABLE @TABLE_PREFIX@LMGR;

DROP INDEX @TABLE_PREFIX@LMPR_IDX1;

DROP TABLE @TABLE_PREFIX@LMPR;

