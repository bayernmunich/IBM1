-- This file is deprecated and is superceded by dropSchemaMod1Informix.sql.
-- Scriptfile to drop schema for Informix
-- 1. Replace all occurrances of @TABLE_PREFIX@ to the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Process this script in the Informix dbaccess command processor
-- Example:
--             dbaccess mydb dropSchemaInformix.sql



DROP INDEX @TABLE_PREFIX@TASK_IDX1;

DROP INDEX @TABLE_PREFIX@TASK_IDX2;

DROP TABLE @TABLE_PREFIX@TASK;

DROP TABLE @TABLE_PREFIX@TREG;

DROP TABLE @TABLE_PREFIX@LMGR;

DROP INDEX @TABLE_PREFIX@LMPR_IDX1;

DROP TABLE @TABLE_PREFIX@LMPR;

