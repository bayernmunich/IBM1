--------------- Begin Copyright - Do not add comments here --------------
--
-- Licensed Materials - Property of IBM
--
-- Restricted Materials of IBM
--
-- Virtual Member Manager
--
-- Copyright IBM Corp. 2005, 2010
--
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract with
-- IBM Corp.
--
----------------------------- End Copyright -----------------------------
CREATE TABLE @dbschema.@FEDENTITY (
	ENTITY_TYPE		VARGRAPHIC(36) CCSID 13488 NOT NULL,
	UNIQUE_ID		VARGRAPHIC(200) CCSID 13488 NOT NULL,
	UNIQUE_NAME_KEY		VARGRAPHIC(236) CCSID 13488,
	UNIQUE_NAME		VARGRAPHIC(1000) CCSID 13488,
	EXT_ID			VARGRAPHIC(200) CCSID 13488 NOT NULL,
	FULL_EXT_ID		VARGRAPHIC(1000) CCSID 13488 NOT NULL,
	REPOS_ID		CHAR(36) NOT NULL
);
