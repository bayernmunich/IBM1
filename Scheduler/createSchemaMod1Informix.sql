-- Scriptfile to create schema (tables) for Informix
-- Mod1 - Additional tokens to allow qualifiers on Table Prefix, and tokens are unquoted.
------------------------------------------------------------------------
-- 1. Replace all occurences of @TABLE_PREFIX@ with the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Replace all occurences of @TABLE_QUALIFIER@ with a table name qualifier, such as a
--    owner name to use for owner-qualified object names.  The replacement text should include
--    a trailing period (.) to delimit the qualifier from the unqualified object name.  If an
--    unqualified object name is desired, the @TABLE_QUALIFIER@ token must be replaced with an
--    empty string (and no delimiter).
-- 3. Process this script in the Informix dbaccess command processor
-- Example:
--             dbaccess mydb createSchemaMod1Informix.sql



CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ( TASKID DECIMAL(19,
              0) NOT NULL PRIMARY KEY ,
               VERSION VARCHAR(5) NOT NULL ,
               ROW_VERSION INTEGER NOT NULL ,
               TASKTYPE INTEGER NOT NULL ,
               TASKSUSPENDED SMALLINT NOT NULL ,
               CANCELLED SMALLINT NOT NULL ,
               NEXTFIRETIME DECIMAL(19,
              0) NOT NULL ,
               STARTBYINTERVAL VARCHAR(254) ,
               STARTBYTIME DECIMAL(19,
              0) ,
               VALIDFROMTIME DECIMAL(19,
              0) ,
               VALIDTOTIME DECIMAL(19,
              0) ,
               REPEATINTERVAL VARCHAR(254) ,
               MAXREPEATS INTEGER NOT NULL ,
               REPEATSLEFT INTEGER NOT NULL ,
               TASKINFO BYTE ,
               NAME VARCHAR(254) NOT NULL ,
               AUTOPURGE INTEGER NOT NULL ,
               FAILUREACTION INTEGER ,
               MAXATTEMPTS INTEGER ,
               QOS INTEGER  ,
               PARTITIONID INTEGER ,
               OWNERTOKEN VARCHAR(200) NOT NULL ,
               CREATETIME DECIMAL(19,
              0) NOT NULL ) LOCK MODE ROW;

CREATE INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX1 ON @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ( TASKID,
               OWNERTOKEN ) ;

CREATE CLUSTER INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX2 ON @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ( NEXTFIRETIME ASC,
               REPEATSLEFT,
               PARTITIONID );

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG ( REGKEY VARCHAR(254) NOT NULL PRIMARY KEY,
               REGVALUE VARCHAR(254) ) LOCK MODE ROW;

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR ( LEASENAME VARCHAR(254) NOT NULL PRIMARY KEY,
               LEASEOWNER VARCHAR(254) NOT NULL,
               LEASE_EXPIRE_TIME NUMERIC(19,
               0),
               DISABLED VARCHAR(5) ) LOCK MODE ROW;

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR ( LEASENAME VARCHAR(254) NOT NULL,
               NAME VARCHAR(254) NOT NULL,
               VALUE VARCHAR(254) NOT NULL ) LOCK MODE ROW;

CREATE INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR_IDX1 ON @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR ( LEASENAME );

