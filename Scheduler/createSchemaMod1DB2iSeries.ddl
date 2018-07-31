-- Scriptfile to create schema (tables) in DB2 on iSeries
-- Mod1 - Additional tokens to allow qualifiers on Table Prefix, and tokens are unquoted.
------------------------------------------------------------------------
-- If the @TABLE_QUALIFIER@ token is not used, then
-- the code assumes an implicit schema, i.e. the tables
-- and views have to be created in a collection that has
-- the name of the user connected to use the product.
-- You may want to create the collection using:
--     db2 create collection <username>
-- before applying this script
------------------------------------------------------------------------
-- 1. Replace all occurrences of @TABLE_PREFIX@ with the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Replace all occurrences of @TABLE_QUALIFIER@ with a table name qualifier, such as a
--    Collection Name to use for Collection-qualified object names.  The replacement text should include
--    a trailing period (.) to delimit the qualifier from the unqualified object name.  If an
--    unqualified object name is desired, the @TABLE_QUALIFIER@ token must be replaced with an
--    empty string (and no delimiter).
-- 3. Process this script in the DB2 command line processor
-- Example: 
--            db2 -tf createSchemaMod1DB2iSeries.ddl



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
               "TASKINFO" BLOB(102400) ,
               "NAME" VARCHAR(254) NOT NULL ,
               "AUTOPURGE" INTEGER NOT NULL ,
               "FAILUREACTION" INTEGER ,
               "MAXATTEMPTS" INTEGER ,
               "QOS" INTEGER ,
               "PARTITIONID" INTEGER ,
               "OWNERTOKEN" VARCHAR(200) NOT NULL ,
               "CREATETIME" BIGINT NOT NULL );

ALTER TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ADD PRIMARY KEY ("TASKID");

CREATE INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX1 ON @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ("TASKID",
              "OWNERTOKEN" ) ;

CREATE INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX2 ON @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ("NEXTFIRETIME" ASC,
               "REPEATSLEFT",
               "PARTITIONID" );

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG ("REGKEY" VARCHAR(254) NOT NULL ,
                "REGVALUE" VARCHAR(254) );

ALTER TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG ADD PRIMARY KEY ("REGKEY");

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR (LEASENAME VARCHAR(254) NOT NULL,
               "LEASEOWNER" VARCHAR(254) NOT NULL,
               "LEASE_EXPIRE_TIME" BIGINT,
              "DISABLED" VARCHAR(5) );

ALTER TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR ADD PRIMARY KEY ("LEASENAME");

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR (LEASENAME VARCHAR(254) NOT NULL,
              NAME VARCHAR(254) NOT NULL,
              VALUE VARCHAR(254) NOT NULL);

CREATE INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR_IDX1 ON @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR (LEASENAME,
               NAME);

