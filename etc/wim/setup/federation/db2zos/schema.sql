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
CREATE TABLESPACE @TSPREFIX@TS018 IN @DbName@
	BUFFERPOOL @DEFAULT_TABLE@
	LOCKSIZE ROW
	SEGSIZE 32
	PCTFREE 15;
	
CREATE TABLE @dbschema.@FEDENTITY (
	ENTITY_TYPE		VARCHAR(36) NOT NULL,
	UNIQUE_ID		VARCHAR(200) NOT NULL,
	UNIQUE_NAME_KEY		VARCHAR(236),
	UNIQUE_NAME		VARCHAR(1000),
	EXT_ID			VARCHAR(200) NOT NULL,
	FULL_EXT_ID		VARCHAR(1000) NOT NULL,
	REPOS_ID		CHAR(36) NOT NULL,
	CONSTRAINT PK018 PRIMARY KEY (UNIQUE_ID)
)IN @DbName@.@TSPREFIX@TS018;

CREATE UNIQUE INDEX @dbschema.@IXWIM180PK ON @dbschema.@FEDENTITY (UNIQUE_ID);

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE @dbschema.@FEDENTITY
	TO PUBLIC AT ALL LOCATIONS;

	
