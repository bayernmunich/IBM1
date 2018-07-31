-- Scriptfile to create schema (tables) for DB2
-- Mod1 - Additional tokens to allow qualifiers on Table Prefix, and tokens are unquoted.
-- Note: DB2 also uses the term "Schema" as the qualifier on a DB object name, which
-- typically is the ID of the user owning the object.
------------------------------------------------------------------------
-- 1. Replace all occurences of @TABLE_PREFIX@ with the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Replace all occurences of @TABLE_QUALIFIER@ with a table name qualifier, such as a
--    Schema Name to use for Schema-qualified object names.  The replacement text should include
--    a trailing period (.) to delimit the qualifier from the unqualified object name.  If an
--    unqualified object name is desired, the @TABLE_QUALIFIER@ token must be replaced with an
--    empty string (and no delimiter).
-- 3. Replace all occurences of @SCHED_TABLESPACE@ with a valid tablespace that was 
--    created by the createTablespaceDB2.ddl script.
-- 4. Process this script in the DB2 command line processor
-- Example:
--             db2 connect to SCHEDDB
--             db2 -tf createSchemaMod1DB2.ddl
-- The schema assumes existing tablespaces that should have been
-- created previously, using createTablespaceDB2.ddl script.


CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ("TASKID" BIGINT NOT NULL ,
              "VERSION" VARCHAR(5) NOT NULL ,
              "ROW_VERSION" INTEGER NOT NULL ,
              "TASKTYPE" INTEGER NOT NULL ,
              "TASKSUSPENDED" SMALLINT NOT NULL ,
              "CANCELLED" SMALLINT NOT NULL ,
              "NEXTFIRETIME" BIGINT NOT NULL ,
              "STARTBYINTERVAL" VARCHAR(254) ,
              "STARTBYTIME" BIGINT ,
              "VALIDFROMTIME" BIGINT ,
              "VALIDTOTIME" BIGINT ,
              "REPEATINTERVAL" VARCHAR(254) ,
              "MAXREPEATS" INTEGER NOT NULL ,
              "REPEATSLEFT" INTEGER NOT NULL ,
              "TASKINFO" BLOB(102400) LOGGED NOT COMPACT ,
              "NAME" VARCHAR(254) NOT NULL ,
              "AUTOPURGE" INTEGER NOT NULL ,
              "FAILUREACTION" INTEGER ,
              "MAXATTEMPTS" INTEGER ,
              "QOS" INTEGER ,
              "PARTITIONID" INTEGER ,
              "OWNERTOKEN" VARCHAR(200) NOT NULL ,
              "CREATETIME" BIGINT NOT NULL )  IN @SCHED_TABLESPACE@;

ALTER TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ADD PRIMARY KEY ("TASKID");

CREATE INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX1 ON @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ("TASKID",
              "OWNERTOKEN") ;

CREATE INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX2 ON @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ("NEXTFIRETIME" ASC,
               "REPEATSLEFT",
               "PARTITIONID") CLUSTER;

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG ("REGKEY" VARCHAR(254) NOT NULL ,
              "REGVALUE" VARCHAR(254) ) IN @SCHED_TABLESPACE@;

ALTER TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG ADD PRIMARY KEY ("REGKEY");

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR (LEASENAME VARCHAR(254) NOT NULL,
               LEASEOWNER VARCHAR(254) NOT NULL,
               LEASE_EXPIRE_TIME  BIGINT,
              DISABLED VARCHAR(5))IN @SCHED_TABLESPACE@;

ALTER TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR ADD PRIMARY KEY ("LEASENAME");

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR (LEASENAME VARCHAR(254) NOT NULL,
              NAME VARCHAR(254) NOT NULL,
              VALUE VARCHAR(254) NOT NULL)IN @SCHED_TABLESPACE@;

CREATE INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR_IDX1 ON @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR (LEASENAME,
               NAME);

