--------------- Begin Standard Header - Do not add comments here ---------------
-- 
-- File:     OMADMProtocolEngine/sql/createOMADMTables_derby.sql, otis_omadm, otis_dev
-- Version:  1.12
-- Modified: 1/24/07 08:49:26
-- Build:    1 12
-- 
-- Licensed Materials - Property of IBM
-- 
-- Restricted Materials of IBM
-- 
-- 5724-C06, 5724-C94 , 5724-B07, 5724-E69, 5724-L91, 5608-TPM
-- 
-- (C) COPYRIGHT IBM CORP. 2000, 2006.  All Rights Reserved.
-- 
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-- 
------------------------------ End Standard Header -----------------------------

CREATE TABLE OMADM_DEVICE 
(
   DEVICE_ID                 VARCHAR(254) NOT NULL,
   LAST_MODIFIED             TIMESTAMP  ,
   CONSTRAINT DEVICE_PK 
      PRIMARY KEY (DEVICE_ID)
); 
COMMIT;

CREATE TABLE OMADM_CREDS 
(
   DEVICE_ID                 VARCHAR(254) NOT NULL,
   CLIENT_ID                 VARCHAR(254),
   CLIENT_PASSWORD           VARCHAR(60),
   CLIENT_NONCE              VARCHAR(254),
   SERVER_ID                 VARCHAR(254),
   SERVER_PASSWORD           VARCHAR(60),
   SERVER_NONCE              VARCHAR(254),
   LAST_MODIFIED             TIMESTAMP WITH DEFAULT TIMESTAMP(convert_time()),
   CONSTRAINT OMADM_CREDS_PK 
      PRIMARY KEY (DEVICE_ID),
   CONSTRAINT OMADM_CREDS_FK 
      FOREIGN KEY (DEVICE_ID)
      REFERENCES OMADM_DEVICE(DEVICE_ID)                
           ON DELETE CASCADE                
); 
COMMIT;

CREATE TABLE OMADM_PROPS 
(
   DEVICE_ID                 VARCHAR(254) NOT NULL,
   PROPKEY                   VARCHAR(500) NOT NULL,
   PROPVALUE                 VARCHAR(1000),
   LAST_MODIFIED             TIMESTAMP WITH DEFAULT TIMESTAMP(convert_time()),
   CONSTRAINT OMADM_PROPS_PK 
      PRIMARY KEY (DEVICE_ID, PROPKEY),
   CONSTRAINT OMADM_PROPS_FK 
      FOREIGN KEY (DEVICE_ID)
      REFERENCES OMADM_DEVICE(DEVICE_ID)                
           ON DELETE CASCADE                
); 
COMMIT;

CREATE TABLE OMADM_TREE 
(
   DEVICE_ID                 VARCHAR(254) NOT NULL,
   URI                       VARCHAR(500) NOT NULL, 
   META_FORMAT               VARCHAR(32), 
   META_TYPE                 VARCHAR(254), 
   DATA                      BLOB(1M), 
   LAST_MODIFIED             TIMESTAMP WITH DEFAULT TIMESTAMP(convert_time()),
   CONSTRAINT OMADM_TREE_PK 
      PRIMARY KEY (DEVICE_ID, URI),
   CONSTRAINT OMADM_TREE_FK 
      FOREIGN KEY (DEVICE_ID)
      REFERENCES OMADM_DEVICE(DEVICE_ID)                
           ON DELETE CASCADE                
); 
COMMIT;


CREATE TRIGGER omadm_creds_trg
   AFTER UPDATE OF
   CLIENT_ID,
   CLIENT_PASSWORD,
   CLIENT_NONCE,
   SERVER_ID,
   SERVER_PASSWORD,
   SERVER_NONCE
   ON OMADM_CREDS
   REFERENCING NEW AS newRow
   FOR EACH ROW MODE DB2SQL
   UPDATE OMADM_CREDS SET LAST_MODIFIED = TIMESTAMP(convert_time()) WHERE DEVICE_ID=newRow.DEVICE_ID;
COMMIT;

CREATE TRIGGER omadm_props_trg
   AFTER UPDATE OF
   PROPVALUE
   ON OMADM_PROPS
   REFERENCING NEW AS newRow
   FOR EACH ROW MODE DB2SQL
   UPDATE OMADM_PROPS SET LAST_MODIFIED = TIMESTAMP(convert_time()) WHERE DEVICE_ID=newRow.DEVICE_ID;
COMMIT;

CREATE TRIGGER omadm_tree_trg
   AFTER UPDATE OF
   META_FORMAT,
   META_TYPE,
   DATA
   ON OMADM_TREE
   REFERENCING NEW AS newRow
   FOR EACH ROW MODE DB2SQL
   UPDATE OMADM_TREE SET LAST_MODIFIED = TIMESTAMP(convert_time()) WHERE DEVICE_ID=newRow.DEVICE_ID AND URI=newRow.URI;
COMMIT;
