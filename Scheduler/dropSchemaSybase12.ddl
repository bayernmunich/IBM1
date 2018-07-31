/*
 This file is deprecated and is superceded by dropSchemaMod1Sybase12.ddl.
 Scriptfile to drop schema in Sybase v12
 1. Replace all occurrances of @TABLE_PREFIX@ to the Table Prefix you will use in the
    configured Scheduler resource.
 2. Process this script using the isql command line processor
 Example: 
     isql -U<userid> -P<password> -S<sybase server> -D<databasename> -i dropSchemaSybase12.ddl
*/


DROP INDEX @TABLE_PREFIX@TASK.TASK_IDX1
GO

DROP INDEX @TABLE_PREFIX@TASK.TASK_IDX2
GO

DROP TABLE @TABLE_PREFIX@TASK
GO

DROP TABLE @TABLE_PREFIX@TREG
GO

DROP TABLE @TABLE_PREFIX@LMGR
GO

DROP INDEX @TABLE_PREFIX@LMPR.LMPR_IDX1
GO

DROP TABLE @TABLE_PREFIX@LMPR
GO

