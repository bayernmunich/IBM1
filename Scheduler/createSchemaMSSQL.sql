-- This file is deprecated and is superceded by createSchemaMod1MSSQL.sql.
-- Scriptfile to create schema in Microsoft SQL Server
-- 1. Replace all occurrances of @TABLE_PREFIX@ to the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Process this script by one of the following methods:
--   a) Load this script into the SQL Query Analyzer and execute it.
--   b) Use the isql command to run the script.
--      Example:
--        isql -Umyuserid -Pmypassword -Smyserver -dmydatabase -icreateSchemaMSSQL.sql



CREATE TABLE [@TABLE_PREFIX@TASK] ( [TASKID] BIGINT NOT NULL ,
               [VERSION] VARCHAR(5) NOT NULL ,
               [ROW_VERSION] INT NOT NULL ,
               [TASKTYPE] INT NOT NULL ,
               [TASKSUSPENDED] TINYINT NOT NULL ,
               [CANCELLED] TINYINT NOT NULL ,
               [NEXTFIRETIME] BIGINT NOT NULL ,
               [STARTBYINTERVAL] VARCHAR(254) NULL ,
               [STARTBYTIME] BIGINT NULL ,
               [VALIDFROMTIME] BIGINT NULL ,
               [VALIDTOTIME] BIGINT NULL ,
               [REPEATINTERVAL] VARCHAR(254) NULL ,
               [MAXREPEATS] INT NOT NULL ,
               [REPEATSLEFT] INT NOT NULL ,
               [TASKINFO] IMAGE NULL ,
               [NAME] VARCHAR(254) NOT NULL ,
               [AUTOPURGE] INT NOT NULL ,
               [FAILUREACTION] INT NULL ,
               [MAXATTEMPTS] INT NULL ,
               [QOS] INT NULL ,
               [PARTITIONID] INT NULL ,
               [OWNERTOKEN] VARCHAR(200) NOT NULL ,
               [CREATETIME] BIGINT NOT NULL ) 
GO

ALTER TABLE [@TABLE_PREFIX@TASK] WITH NOCHECK ADD CONSTRAINT [@TABLE_PREFIX@TASK_PK] PRIMARY KEY  NONCLUSTERED ( [TASKID] ) 
GO

CREATE INDEX [@TABLE_PREFIX@TASK_IDX1] ON [@TABLE_PREFIX@TASK] ( [TASKID],
               [OWNERTOKEN] ) 
GO

CREATE CLUSTERED INDEX [@TABLE_PREFIX@TASK_IDX2] ON [@TABLE_PREFIX@TASK] ( [NEXTFIRETIME] ASC,
               [REPEATSLEFT],
               [PARTITIONID] )
GO

CREATE TABLE [@TABLE_PREFIX@TREG] ( [REGKEY] VARCHAR(254) NOT NULL ,
               [REGVALUE] VARCHAR(254) NULL ,
               PRIMARY KEY ( [REGKEY] ) )
GO

CREATE TABLE [@TABLE_PREFIX@LMGR] ( [LEASENAME] VARCHAR(254) NOT NULL,
               [LEASEOWNER] VARCHAR(254) NOT NULL,
               [LEASE_EXPIRE_TIME] BIGINT,
               [DISABLED] VARCHAR(5) )
GO

ALTER TABLE [@TABLE_PREFIX@LMGR] WITH NOCHECK ADD CONSTRAINT [@TABLE_PREFIX@LMGR_PK] PRIMARY KEY  NONCLUSTERED ( [LEASENAME] ) 
GO

CREATE TABLE [@TABLE_PREFIX@LMPR] ( [LEASENAME] VARCHAR(254) NOT NULL,
               [NAME] VARCHAR(254) NOT NULL,
               [VALUE] VARCHAR(254) NOT NULL )
GO

CREATE INDEX [@TABLE_PREFIX@LMPR_IDX1] ON [@TABLE_PREFIX@LMPR] ( [LEASENAME],
               [NAME] ) 
GO

