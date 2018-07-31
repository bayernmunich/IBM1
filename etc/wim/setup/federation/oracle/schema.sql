--------------- Begin Copyright - Do not add comments here --------------
--
-- Licensed Materials - Property of IBM
--
-- Restricted Materials of IBM
--
-- Virtual Member Manager
--
-- (C) Copyright IBM Corp. 2005, 2010
--
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract with
-- IBM Corp.
--
----------------------------- End Copyright -----------------------------
CREATE TABLE @dbschema.@FEDENTITY (
	ENTITY_TYPE		VARCHAR2(36) NOT NULL,
	UNIQUE_ID		VARCHAR2(200) NOT NULL,
	UNIQUE_NAME_KEY		VARCHAR2(236) NULL,
	UNIQUE_NAME		VARCHAR2(1000) NULL,
	EXT_ID			VARCHAR2(200) NOT NULL,
	FULL_EXT_ID		VARCHAR2(1000) NOT NULL,
	REPOS_ID		VARCHAR2(36) NOT NULL
);
