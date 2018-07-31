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
	ENTITY_TYPE		VARCHAR(36) NOT NULL,
	UNIQUE_ID		VARCHAR(200) NOT NULL,
	UNIQUE_NAME_KEY		VARCHAR(236),
	UNIQUE_NAME		LVARCHAR(1000),
	EXT_ID			VARCHAR(200) NOT NULL,
	FULL_EXT_ID		LVARCHAR(1000) NOT NULL,
	REPOS_ID		CHAR(36) NOT NULL
);
