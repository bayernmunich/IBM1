-- This file is deprecated and is superceded by dropSchemaMod1Derby.ddl.
-- Scriptfile to drop schema in Derby
-- 1. Replace all occurrances of @TABLE_PREFIX@ to the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Process this script in the ij command line processor
-- Example: 
--    java -Djava.ext.dirs=C:/WebSphere/AppServer/derby/lib -Dij.database=C:/drivers/derby/databases/SCHEDDB -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij dropSchemaDerby.ddl



DROP INDEX @TABLE_PREFIX@TASK_IDX1;

DROP INDEX @TABLE_PREFIX@TASK_IDX2;

DROP TABLE @TABLE_PREFIX@TASK;

DROP TABLE @TABLE_PREFIX@TREG;

DROP TABLE @TABLE_PREFIX@LMGR;

DROP INDEX @TABLE_PREFIX@LMPR_IDX1;

DROP TABLE @TABLE_PREFIX@LMPR;

