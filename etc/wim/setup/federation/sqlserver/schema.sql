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
CREATE TABLE @DbUser@.FEDENTITY (
	ENTITY_TYPE		VARCHAR(36) NOT NULL,
	UNIQUE_ID		NVARCHAR(200) NOT NULL,
	UNIQUE_NAME_KEY		NVARCHAR(236) NULL,
	UNIQUE_NAME		NVARCHAR(1000) NULL,
	EXT_ID			NVARCHAR(200) NOT NULL,
	FULL_EXT_ID		NVARCHAR(1000) NOT NULL,
	REPOS_ID		CHAR(36) NOT NULL
);
