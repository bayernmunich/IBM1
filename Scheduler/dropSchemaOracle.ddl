-- This file is deprecated and is superceded by dropSchemaMod1Oracle.ddl.
-- Scriptfile to drop schema for Oracle
-- 1. Process this script using SQL*Plus
-- 2. Replace all occurrances of @TABLE_PREFIX@ to the Table Prefix you will use in the
--    configured Scheduler resource.
-- Example: 
--  o  sqlplus username/password@mydb @dropSchemaOracle.ddl
--  o  or, at the sqlplus prompt, enter
--     SQL> @dropSchemaOracle.ddl



DROP INDEX @TABLE_PREFIX@TASK_IDX1;

DROP INDEX @TABLE_PREFIX@TASK_IDX2;

DROP TABLE @TABLE_PREFIX@TASK;

DROP TABLE @TABLE_PREFIX@TREG;

DROP TABLE @TABLE_PREFIX@LMGR;

DROP INDEX @TABLE_PREFIX@LMPR_IDX1;

DROP TABLE @TABLE_PREFIX@LMPR;

