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
CREATE UNIQUE INDEX WIMI110 ON @dbschema.@FEDENTITY
(
	EXT_ID			ASC,
	REPOS_ID		ASC
);

CREATE INDEX WIMI115 ON @dbschema.@FEDENTITY
(
	UNIQUE_NAME_KEY		ASC
);

