-- Scriptfile to create schema for DB2 z/OS
-- 1  Replace all occurrances of @TABLE_PREFIX@ to the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Replace all occurrances of @SCHED_TABLESPACE@ with a valid tablespace that was 
--    created by the createTablesapceDb2zOs.ddl script.
-- 3. Replace all occurrances of @STG@ with the storage group
-- 4. Replace all occurrances of @DBNAME@ with a valid z/OS database name.
--      For example:  DSNDB04
-- 5. Process this script in the DB2 command line processor
-- Example:
--             db2 connect to SCHEDDB
--             db2 -tf createSchemaDB2ZOS.ddl
-- The schema assumes existing tablespaces that should have been
-- created before using createTablespaceDB2ZOS.ddl script.


CREATE TABLE @TABLE_PREFIX@TASK
(
      TASKID           NUMERIC(19)    NOT NULL , 
      VERSION          VARCHAR(5)     NOT NULL , 
      ROW_VERSION      INTEGER        NOT NULL , 
      TASKTYPE         INTEGER        NOT NULL , 
      TASKSUSPENDED    SMALLINT       NOT NULL , 
      CANCELLED        SMALLINT       NOT NULL , 
      NEXTFIRETIME     NUMERIC(19)    NOT NULL , 
      STARTBYINTERVAL  VARCHAR(254)    , 
      STARTBYTIME      NUMERIC(19)     , 
      VALIDFROMTIME    NUMERIC(19)     , 
      VALIDTOTIME      NUMERIC(19)     , 
      REPEATINTERVAL   VARCHAR(254)    , 
      MAXREPEATS       INTEGER        NOT NULL , 
      REPEATSLEFT      INTEGER        NOT NULL , 
      TASKINFO         BLOB(102400)    , 
      NAME             VARCHAR(254)   NOT NULL ,
      AUTOPURGE        INTEGER        NOT NULL , 
      FAILUREACTION    INTEGER         , 
      MAXATTEMPTS      INTEGER         , 
      QOS              INTEGER         , 
      PARTITIONID      INTEGER         ,
      OWNERTOKEN       VARCHAR(200)   NOT NULL ,
      CREATETIME       NUMERIC(19)    NOT NULL , 
      ROW_ID           ROWID          NOT NULL GENERATED ALWAYS,
      PRIMARY KEY ( TASKID )
)
IN @DBNAME@.@SCHED_TABLESPACE@; 


-- unique index for primary key
CREATE UNIQUE INDEX @TABLE_PREFIX@TASKPK 
   ON @TABLE_PREFIX@TASK
( 
    TASKID
) 
USING STOGROUP @STG@;
                

CREATE INDEX @TABLE_PREFIX@TASK_IDX1
  ON @TABLE_PREFIX@TASK
(
    TASKID,OWNERTOKEN
)
USING STOGROUP @STG@;
 

CREATE INDEX @TABLE_PREFIX@TASK_IDX2
  ON @TABLE_PREFIX@TASK
(
    NEXTFIRETIME ASC, REPEATSLEFT, PARTITIONID
)
USING STOGROUP @STG@;


-- auxiliary table for LOB column TASKINFO
CREATE AUX TABLE @TABLE_PREFIX@TASK1
   IN @DBNAME@.@SCHED_TABLESPACE@1
   STORES  @TABLE_PREFIX@TASK COLUMN TASKINFO;
-- auxiliary index for LOB column TASKINFO
CREATE UNIQUE INDEX @TABLE_PREFIX@TASK1I ON @TABLE_PREFIX@TASK1
   USING STOGROUP @STG@;


CREATE TABLE @TABLE_PREFIX@TREG
(
    REGKEY                       VARCHAR(254)         NOT NULL ,
    REGVALUE                     VARCHAR(254)         ,
    PRIMARY KEY ( REGKEY )
)
 IN @DBNAME@.@SCHED_TABLESPACE@; 

 -- unique index for primary key
CREATE UNIQUE INDEX @TABLE_PREFIX@TREGPK 
   ON @TABLE_PREFIX@TREG
( 
    REGKEY
) 
USING STOGROUP @STG@;

-- Lease Manager
CREATE TABLE @TABLE_PREFIX@LMGR
(
    LEASENAME                         VARCHAR(254) NOT NULL,
    LEASEOWNER                        VARCHAR(254) NOT NULL,
    LEASE_EXPIRE_TIME                 NUMERIC(19),
    DISABLED                          VARCHAR(5),
    PRIMARY KEY ( LEASENAME )
)
 IN @DBNAME@.@SCHED_TABLESPACE@; 


CREATE UNIQUE INDEX @TABLE_PREFIX@LMGR_IDX1 ON @TABLE_PREFIX@LMGR
(
    LEASENAME
)
USING STOGROUP @STG@;


CREATE TABLE @TABLE_PREFIX@LMPR
(
    LEASENAME                         VARCHAR(254) NOT NULL,
    NAME                              VARCHAR(254) NOT NULL,
    VALUE                             VARCHAR(254) NOT NULL
)
 IN @DBNAME@.@SCHED_TABLESPACE@; 

CREATE INDEX @TABLE_PREFIX@LMPR_IDX1 ON @TABLE_PREFIX@LMPR
(
    LEASENAME
)
USING STOGROUP @STG@;

