-- This file is deprecated and is superceded by createSchemaMod1DB2iSeries.ddl.
-- Scriptfile to create schema (tables) in DB2 on iSeries
------------------------------------------------------------------------
-- The code assumes an implicit schema, i.e. the tables
-- and views have to be created in a collection that has
-- the name of the user connected to use the product.
-- You may want to create the collection using:
--     db2 create collection <username>
-- before applying this script
------------------------------------------------------------------------
-- 1. Replace all occurrances of @TABLE_PREFIX@ to the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Process this script in the DB2 command line processor
-- Example: 
--            db2 connect to <dbname> user <user name> using <user password> 
--            db2 -tf createSchemaDb2iSeries.ddl



CREATE TABLE "@TABLE_PREFIX@TASK" ("TASKID" BIGINT NOT NULL ,
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

ALTER TABLE "@TABLE_PREFIX@TASK" ADD PRIMARY KEY ("TASKID");

CREATE INDEX "@TABLE_PREFIX@TASK_IDX1" ON "@TABLE_PREFIX@TASK" ( "TASKID",
              "OWNERTOKEN" ) ;

CREATE INDEX "@TABLE_PREFIX@TASK_IDX2" ON "@TABLE_PREFIX@TASK" ( "NEXTFIRETIME" ASC,
               "REPEATSLEFT",
               "PARTITIONID" );

CREATE TABLE "@TABLE_PREFIX@TREG" ( "REGKEY" VARCHAR(254) NOT NULL ,
                "REGVALUE" VARCHAR(254) );

ALTER TABLE "@TABLE_PREFIX@TREG" ADD PRIMARY KEY ("REGKEY");

CREATE TABLE "@TABLE_PREFIX@LMGR" ("LEASENAME" VARCHAR(254) NOT NULL,
               "LEASEOWNER" VARCHAR(254) NOT NULL,
               "LEASE_EXPIRE_TIME" BIGINT,
              "DISABLED" VARCHAR(5) );

ALTER TABLE "@TABLE_PREFIX@LMGR"  ADD PRIMARY KEY ("LEASENAME");

CREATE TABLE "@TABLE_PREFIX@LMPR" ("LEASENAME" VARCHAR(254) NOT NULL,
               "NAME" VARCHAR(254) NOT NULL,
               "VALUE" VARCHAR(254) NOT NULL );

CREATE INDEX "@TABLE_PREFIX@LMPR_IDX1" ON "@TABLE_PREFIX@LMPR" ("LEASENAME",
               "NAME" );

