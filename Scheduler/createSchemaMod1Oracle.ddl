-- Scriptfile to create schema (tables) for Oracle
-- Mod1 - Additional tokens to allow qualifiers on Table Prefix, and tokens are unquoted.
-- Note: Oracle also uses the term "Schema" as the qualifier on a DB object name, which
-- typically is the ID of the user owning the object.
------------------------------------------------------------------------
-- 1. Replace all occurrences of @TABLE_PREFIX@ with the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Replace all occurrences of @TABLE_QUALIFIER@ with a table name qualifier, such as a
--    Schema Name to use for Schema-qualified object names.  The replacement text should include
--    a trailing period (.) to delimit the qualifier from the unqualified object name.  If an
--    unqualified object name is desired, the @TABLE_QUALIFIER@ token must be replaced with an
--    empty string (and no delimiter).
-- 3. Replace all occurrences of @SCHED_TABLESPACE@ with a valid tablespace that was 
--    created by the createTablespaceOracle.ddl script.
-- 4. Process this script using SQL*Plus
-- Example: 
--  o  sqlplus username/password@mydb @createSchemaMod1Oracle.ddl
--  o  or, at the sqlplus prompt, enter
--     SQL> @createSchemaMod1Oracle.ddl



CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ("TASKID" NUMBER(19) NOT NULL,
               "VERSION" VARCHAR2(5) NOT NULL,
               "ROW_VERSION" NUMBER(10) NOT NULL,
               "TASKTYPE" NUMBER(10) NOT NULL,
               "TASKSUSPENDED" NUMBER(1) NOT NULL,
               "CANCELLED" NUMBER(1) NOT NULL,
               "NEXTFIRETIME" NUMBER(19) NOT NULL,
               "STARTBYINTERVAL" VARCHAR2(254),
               "STARTBYTIME" NUMBER(19),
               "VALIDFROMTIME" NUMBER(19),
               "VALIDTOTIME" NUMBER(19),
               "REPEATINTERVAL" VARCHAR2(254),
               "MAXREPEATS" NUMBER(10) NOT NULL,
               "REPEATSLEFT" NUMBER(10) NOT NULL,
               "TASKINFO" BLOB,
               "NAME" VARCHAR2(254),
               "AUTOPURGE" NUMBER(10) NOT NULL,
               "FAILUREACTION" NUMBER(10),
               "MAXATTEMPTS" NUMBER(10),
               "QOS" NUMBER(10),
               "PARTITIONID" NUMBER(10),
               "OWNERTOKEN" VARCHAR2(200) NOT NULL,
               "CREATETIME" NUMBER(19) NOT NULL,
               PRIMARY KEY ("TASKID") ) TABLESPACE @SCHED_TABLESPACE@;

CREATE INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX1 ON @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ("TASKID",
              "OWNERTOKEN") ;

CREATE INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX2 ON @TABLE_QUALIFIER@@TABLE_PREFIX@TASK ("NEXTFIRETIME" ASC,
               "REPEATSLEFT",
               "PARTITIONID") ;

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG ("REGKEY" VARCHAR2(254) NOT NULL ,
               "REGVALUE" VARCHAR2(254) ,
               PRIMARY KEY ( "REGKEY" )) TABLESPACE @SCHED_TABLESPACE@;

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR ("LEASENAME" VARCHAR2(254) NOT NULL,
               "LEASEOWNER" VARCHAR2(254),
               "LEASE_EXPIRE_TIME" NUMBER(19),
               "DISABLED" VARCHAR2(254),
               PRIMARY KEY ( "LEASENAME" )) TABLESPACE @SCHED_TABLESPACE@;

CREATE TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR ("LEASENAME" VARCHAR2(254) NOT NULL,
               "NAME" VARCHAR2(254) NOT NULL,
               "VALUE" VARCHAR2(254) NOT NULL ) TABLESPACE @SCHED_TABLESPACE@;

CREATE INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR_IDX1 ON @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR ("LEASENAME",
               "NAME") ;

