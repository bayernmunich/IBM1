-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_10_prereq_oracle.sql, UDDI, WAS855.UDDI, cf131750.05
-- Version:                   1.2
-- Last-changed:              06/01/09 08:05:46
--
-- @start_source_copyright@
-- Licensed Materials - Property of IBM                              
--                                                                   
-- 5724-I63, 5724-H88, 5655-N01, 5733-W60                                                           
--                                                                   
-- (C) COPYRIGHT IBM Corp., 2004, 2005 All Rights Reserved     
--                                                                   
-- US Government Users Restricted Rights - Use, duplication or       
-- disclosure restricted by GSA ADP Schedule Contract with IBM Corp. 
-- @end_source_copyright@

CREATE USER "IBMUDI30"  PROFILE "DEFAULT"
    IDENTIFIED BY "PASSWORD" DEFAULT TABLESPACE "USERS"
    QUOTA UNLIMITED
    ON "USERS"
    ACCOUNT UNLOCK;
GRANT "CONNECT" TO "IBMUDI30";
GRANT "RESOURCE" TO "IBMUDI30";


CREATE USER "IBMUDS30"  PROFILE "DEFAULT"
    IDENTIFIED BY "PASSWORD" DEFAULT TABLESPACE "USERS"
    QUOTA UNLIMITED
    ON "USERS"
    ACCOUNT UNLOCK;
GRANT "CONNECT" TO "IBMUDS30";
GRANT "RESOURCE" TO "IBMUDS30";


CREATE USER "IBMUDDI"  PROFILE "DEFAULT"
    IDENTIFIED BY "PASSWORD" DEFAULT TABLESPACE "USERS"
    QUOTA UNLIMITED
    ON "USERS"
    ACCOUNT UNLOCK;
GRANT "CONNECT" TO "IBMUDDI";
GRANT "RESOURCE" TO "IBMUDDI";

CREATE OR REPLACE TRIGGER "IBMUDDI"."GLOBAL_NLS_SESSION_SETTINGS"
    AFTER
LOGON ON DATABASE BEGIN
   execute IMMEDIATE 'alter session SET NLS_TIMESTAMP_FORMAT=''YYYY-MM-DD HH24:MI:SS.FF''';
END;
/

