/*
 This file is deprecated and is superceded by createSchemaMod1Sybase12.ddl.
 Scriptfile to create schema in Sybase v12
 1. Replace all occurrances of @TABLE_PREFIX@ to the Table Prefix you will use in the
    configured Scheduler resource.
 2. Process this script using the isql command line processor
 Example: 
    isql -U<userid> -P<password> -S<sybase server> -D<databasename> -i createSchemaSybase12.ddl
*/



CREATE TABLE @TABLE_PREFIX@TASK ( TASKID numeric(19,
               0) not null,
               VERSION varchar(5) not null,
               ROW_VERSION int not null,
               TASKTYPE int not null,
               TASKSUSPENDED tinyint not null,
               CANCELLED tinyint not null,
               NEXTFIRETIME numeric(19,
               0) not null,
               STARTBYINTERVAL varchar(254) null,
               STARTBYTIME numeric(19,
               0) null,
               VALIDFROMTIME numeric(19,
               0) null,
               VALIDTOTIME numeric(19,
               0) null,
               REPEATINTERVAL varchar(254) null,
               MAXREPEATS int not null,
               REPEATSLEFT int not null,
               TASKINFO image null,
               NAME varchar(254) not null,
               AUTOPURGE int not null,
               FAILUREACTION int null,
               MAXATTEMPTS int null,
               QOS int null,
               PARTITIONID int null,
               OWNERTOKEN varchar(200) not null,
               CREATETIME numeric(19,
               0) not null,
               PRIMARY KEY NONCLUSTERED ( TASKID ) ) LOCK DATAROWS ON 'default' 
GO

CREATE INDEX TASK_IDX1 ON @TABLE_PREFIX@TASK ( TASKID,
               OWNERTOKEN ) 
GO

CREATE INDEX TASK_IDX2 ON @TABLE_PREFIX@TASK ( NEXTFIRETIME ASC,
               REPEATSLEFT,
               PARTITIONID )
GO

CREATE TABLE @TABLE_PREFIX@TREG ( REGKEY varchar(254) not null ,
               REGVALUE varchar(254) null ,
               PRIMARY KEY NONCLUSTERED ( REGKEY ) ) LOCK DATAROWS ON 'default'
GO

CREATE TABLE @TABLE_PREFIX@LMGR ( LEASENAME varchar(254) not null,
               LEASEOWNER varchar(254) not null,
               LEASE_EXPIRE_TIME numeric(19,
               0),
               DISABLED varchar(5),
               PRIMARY KEY NONCLUSTERED ( LEASENAME ) ) LOCK DATAROWS ON 'default' 
GO

CREATE TABLE @TABLE_PREFIX@LMPR ( LEASENAME varchar(254) not null,
               NAME varchar(254) not null,
               VALUE varchar(254) not null ) LOCK DATAROWS ON 'default' 
GO

CREATE INDEX LMPR_IDX1 ON @TABLE_PREFIX@LMPR ( LEASENAME,
               NAME )
GO

