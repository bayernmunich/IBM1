-- This file is deprecated and is superceded by dropSchemaMod1MSSQL.sql.
-- Scriptfile to drop the schema in Microsoft SQL Server
-- 1. Replace all occurrances of @TABLE_PREFIX@ to the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Process this script by loading it in the SQL Query Analyzer and running it.
--   a) Load this script into the SQL Query Analyzer and execute it.
--   b) Use the isql command to run the script.
--      Example:
--        isql -Usa -Pmypassword -Smyserver -dmydatabase -idropSchemaMSSQL.sql



DROP INDEX [@TABLE_PREFIX@TASK].[@TABLE_PREFIX@TASK_IDX1]
GO

DROP INDEX [@TABLE_PREFIX@TASK].[@TABLE_PREFIX@TASK_IDX2]
GO

DROP TABLE [@TABLE_PREFIX@TASK]
GO

DROP TABLE [@TABLE_PREFIX@TREG]
GO

DROP TABLE [@TABLE_PREFIX@LMGR]
GO

DROP INDEX [@TABLE_PREFIX@LMPR].[@TABLE_PREFIX@LMPR_IDX1]
GO

DROP TABLE [@TABLE_PREFIX@LMPR]
GO

