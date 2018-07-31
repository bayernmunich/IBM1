----------------------------------------------------------------------------------
-- @(#) 1.9 CFG/ws/code/profile.templates.management/src/common/actions/scripts/sql/JobManagerExt_derby.sql, WAS.config.templates, WASX.CFG, nn1044.52 7/28/08 00:26:10 [11/11/10 06:54:35]
-- Licensed Materials - Property of IBM
-- 
-- Restricted Materials of IBM
-- 
-- 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W70
-- 
-- (C) COPYRIGHT IBM CORP. 2000, 2008.  All Rights Reserved.
-- The source code for this program is not published or otherwise divested
-- of its trade secrets, irrespective of what has been deposited with the
-- U.S. Copyright Office.
-- 
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-- 
------------------------------ End Standard Header --------------------------------
--
--  CREATE TABLES
--

CREATE TABLE ENDPOINTS 
(
  UUID                         VARCHAR(128)         NOT NULL,
  ENDPOINT_NAME            	   VARCHAR(128)  	   NOT NULL,
  ENDPOINT_TYPE                VARCHAR(64)	       NOT NULL,
    CONSTRAINT ENDPOINTS_PK 
      PRIMARY KEY (UUID),
    CONSTRAINT ENDPOINTS_UNIQ
      UNIQUE (ENDPOINT_NAME)	
);
CREATE INDEX EPS_NAME_X ON ENDPOINTS (ENDPOINT_NAME);
CREATE INDEX EPS_TYPE_X ON ENDPOINTS (ENDPOINT_TYPE);
COMMIT;

CREATE TABLE ENDPOINT_PROPS
(
  ID						   INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  UUID                         VARCHAR(128)         NOT NULL,
  KEY_ID                	   VARCHAR(256) 	   NOT NULL,
  VALUE                        VARCHAR(512)	       NOT NULL,
    CONSTRAINT EPROPS_PK 
      PRIMARY KEY (ID),
    CONSTRAINT EPROPS_FK1 
      FOREIGN KEY (UUID)
	      REFERENCES ENDPOINTS(UUID)
		      ON DELETE CASCADE
);
CREATE INDEX EP_PROPS_UUID_KEYS_X ON ENDPOINT_PROPS (UUID, KEY_ID);
CREATE INDEX EP_PROPS_KEYS_X ON ENDPOINT_PROPS (KEY_ID);
COMMIT;


CREATE TABLE ENDPOINT_JOBS_METADATA
(
  JOBTYPE                      VARCHAR(256)         NOT NULL,
  METADATA                     BLOB(64K),
    CONSTRAINT EJMETADATA_PK 
      PRIMARY KEY (JOBTYPE)
);
COMMIT;

CREATE TABLE ENDPOINT_JOBS
(
  ID						   INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  UUID                         VARCHAR(128)         NOT NULL,
  JOBTYPE                      VARCHAR(256) 	   NOT NULL,
    CONSTRAINT EJOBS_PK 
      PRIMARY KEY (ID),
	CONSTRAINT EJOBS_FK1 
      FOREIGN KEY (UUID)
	      REFERENCES ENDPOINTS(UUID)
		      ON DELETE CASCADE,
    CONSTRAINT EJOBS_FK2 
      FOREIGN KEY (JOBTYPE)
	      REFERENCES ENDPOINT_JOBS_METADATA(JOBTYPE)
		      ON DELETE RESTRICT,
    CONSTRAINT EJOBS_UNIQ
      UNIQUE (JOBTYPE, UUID)
);
CREATE INDEX EP_JOBS_UUID_JOBTYPE_X ON ENDPOINT_JOBS (UUID, JOBTYPE);
CREATE INDEX EP_JOBS_JOBTYPE_X ON ENDPOINT_JOBS (JOBTYPE);
COMMIT;

CREATE TABLE MANAGED_RESOURCES
(
  RESOURCE_ID                  VARCHAR(640)        NOT NULL,
  UUID                   	   VARCHAR(128) 	       NOT NULL,
  RESOURCE_TYPE                VARCHAR(256)	       NOT NULL,
  CONTEXT                      VARCHAR(256),
  RESOURCE_NAME                VARCHAR(128)         NOT NULL,
    CONSTRAINT MRESOURCE_FK1 
      FOREIGN KEY (UUID)
	      REFERENCES ENDPOINTS(UUID)
		      ON DELETE CASCADE,
    CONSTRAINT MRESOURCE_UNIQ
      UNIQUE (RESOURCE_ID)
);
CREATE INDEX MR_RESOURCE_ID_X ON MANAGED_RESOURCES (RESOURCE_ID);
CREATE INDEX MR_UUID_X ON MANAGED_RESOURCES (UUID);
CREATE INDEX MR_RESOURCE_TYPE_X ON MANAGED_RESOURCES (RESOURCE_TYPE);
CREATE INDEX MR_RESOURCE_NAME_X ON MANAGED_RESOURCES (RESOURCE_NAME);
COMMIT;

CREATE TABLE MANAGED_RESOURCE_PROPS
(
  ID						   INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  RESOURCE_ID                  VARCHAR(640)        NOT NULL,
  KEY_ID                   	   VARCHAR(256) 	   NOT NULL,
  VALUE                        VARCHAR(256)	       NOT NULL,
    CONSTRAINT MRPROPS_PK 
      PRIMARY KEY (ID),
    CONSTRAINT MRPROPS_FK1 
      FOREIGN KEY (RESOURCE_ID)
	      REFERENCES MANAGED_RESOURCES(RESOURCE_ID)
		      ON DELETE CASCADE
);
CREATE INDEX MR_PROPS_RESOURCE_ID_X ON MANAGED_RESOURCE_PROPS (RESOURCE_ID, KEY_ID);
CREATE INDEX MR_PROPS_KEY_ID_X ON MANAGED_RESOURCE_PROPS (KEY_ID);
COMMIT;

CREATE TABLE PAYLOAD_REGISTRY 
(
  NAME                         VARCHAR(256)        NOT NULL,
  REGISTRY_TYPE			       VARCHAR(256)        NOT NULL,
  DESCRIPTION                  VARCHAR(256),
  URL                          VARCHAR(256)	       NOT NULL,
    CONSTRAINT PREGISTRY_PK 
      PRIMARY KEY (NAME)				        
);
CREATE INDEX PP_REGISTRY_TYPE ON PAYLOAD_REGISTRY (REGISTRY_TYPE);
COMMIT;

CREATE TABLE PAYLOAD_REGISTRY_PROPS 
(
  ID						   INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  NAME                         VARCHAR(256)        NOT NULL,
  KEY_ID                       VARCHAR(256)        NOT NULL,
  VALUE                        VARCHAR(256)	       NOT NULL,
    CONSTRAINT PRPROPS_PK 
      PRIMARY KEY (ID),
    CONSTRAINT PRPROPS_FK1 
      FOREIGN KEY (NAME)
	      REFERENCES PAYLOAD_REGISTRY(NAME)
		      ON DELETE CASCADE
);
CREATE INDEX PR_PROPS_NAME_ID_X ON PAYLOAD_REGISTRY_PROPS (NAME, KEY_ID);
CREATE INDEX PR_PROPS_KEY_ID_X ON PAYLOAD_REGISTRY_PROPS (KEY_ID);
COMMIT;

CREATE TABLE GROUP_EXT 
(
  NAME                         VARCHAR(128)         NOT NULL,
  DESCRIPTION                  VARCHAR(256),
  GROUP_TYPE                   VARCHAR(256)	       NOT NULL,
  COUNT                        INTEGER             WITH DEFAULT 0,
    CONSTRAINT GEXT_PK 
      PRIMARY KEY (NAME)				        
);
CREATE INDEX GE_G_TYPE_X ON GROUP_EXT (GROUP_TYPE);
COMMIT;

CREATE TABLE JOBMANAGER_EXT 
(
  JOB_ID                  	   VARCHAR(256)		   NOT NULL,
  EMAILS                   	   VARCHAR(256),
  METADATA                     BLOB(64K),
    CONSTRAINT JOBMANAGER_PK 
      PRIMARY KEY (JOB_ID)				        
);
CREATE INDEX JM_EXT_X ON JOBMANAGER_EXT (EMAILS);
COMMIT;

CREATE TABLE JOBMANAGER_VERSION_INFO 
(
  ID						   INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  WAS_DB_VERSION               VARCHAR(256)		   NOT NULL,
  OTIS_VERSION                 VARCHAR(256),
    CONSTRAINT JOBMANAGER_VERSION_INFO_PK 
      PRIMARY KEY (ID)				        
);
INSERT INTO JOBMANAGER_VERSION_INFO (WAS_DB_VERSION, OTIS_VERSION) VALUES ('JMGR1.1', 'OTIS RELEASE:1.0-VERSION:0.9.9.11');
COMMIT;
