-- Scriptfile to create schema (tables) in Microsoft SQL Server
-- Mod1 - Additional tokens to allow qualifiers on Table Prefix, and tokens are unquoted.
------------------------------------------------------------------------
-- 1. Replace all occurences of @TABLE_PREFIX@ with the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Replace all occurences of @TABLE_QUALIFIER@ with a table name qualifier, such as a
--    Schema Name to use for Schema-qualified object names.  The replacement text should include
--    a trailing period (.) to delimit the qualifier from the unqualified object name.  If an
--    unqualified object name is desired, the @TABLE_QUALIFIER@ token must be replaced with an
--    empty string (and no delimiter).
-- 3. Process this script by one of the following methods:
--   a) Load this script into the SQL Query Analyzer and execute it.
--   b) Use the isql command to run the script.
--      Example:
--        isql -Umyuserid -Pmypassword -Smyserver -dmydatabase -icreateSchemaMod1MSSQL.sql



CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ( [TASKID] BIGINT NOT NULL ,
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
               [CREATETIME] BIGINT NOT NULL ) ;

ALTER TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK WITH NOCHECK ADD CONSTRAINT @TABLE_PREFIX@TASK_PK PRIMARY KEY  NONCLUSTERED ( [TASKID] ) ;

CREATE INDEX @TABLE_PREFIX@TASK_IDX1 ON @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ( [TASKID],
               [OWNERTOKEN] ) ;

CREATE CLUSTERED INDEX @TABLE_PREFIX@TASK_IDX2 ON @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ( [NEXTFIRETIME] ASC,
               [REPEATSLEFT],
               [PARTITIONID] );

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG ( [REGKEY] VARCHAR(254) NOT NULL ,
               [REGVALUE] VARCHAR(254) NULL ,
               PRIMARY KEY ( [REGKEY] ) );

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR ( [LEASENAME] VARCHAR(254) NOT NULL,
               [LEASEOWNER] VARCHAR(254) NOT NULL,
               [LEASE_EXPIRE_TIME] BIGINT,
               [DISABLED] VARCHAR(5) );

ALTER TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR WITH NOCHECK ADD CONSTRAINT @TABLE_PREFIX@LMGR_PK PRIMARY KEY  NONCLUSTERED ( [LEASENAME] ) ;

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR ( [LEASENAME] VARCHAR(254) NOT NULL,
               [NAME] VARCHAR(254) NOT NULL,
               [VALUE] VARCHAR(254) NOT NULL );

CREATE INDEX @TABLE_PREFIX@LMPR_IDX1 ON @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR ( [LEASENAME],
               [NAME] ) ;

