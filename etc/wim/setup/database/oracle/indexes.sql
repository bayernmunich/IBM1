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
CREATE UNIQUE INDEX WIMI005 ON @dbschema.@DBENTITY
(
	UNIQUE_NAME_KEY		ASC
);


CREATE UNIQUE INDEX WIMI010 ON @dbschema.@DBENTITY
(
	UNIQUE_ID		ASC
);


CREATE UNIQUE INDEX WIMI015 ON @dbschema.@DBPROP
(
	NAME			ASC,
	META_NAME		ASC
);


CREATE INDEX WIMI020 ON @dbschema.@DBDBLPROP
(
	PROPVALUE		ASC
);


CREATE INDEX WIMI025 ON @dbschema.@DBINTPROP
(
	PROPVALUE		ASC
);


CREATE INDEX WIMI030 ON @dbschema.@DBTSPROP
(
	PROPVALUE		ASC
);


CREATE INDEX WIMI035 ON @dbschema.@DBLONGPROP
(
	PROPVALUE		ASC
);

CREATE INDEX WIMI040 ON @dbschema.@DBSTRPROP
(
	ENTITY_ID		ASC
);

CREATE INDEX WIMI045 ON @dbschema.@DBREFPROP
(
	REF_UNAME_KEY		ASC
);

CREATE INDEX WIMI050 ON @dbschema.@DBREFPROP
(
	REF_EXT_ID		ASC,
	REF_REPOS_ID		ASC
);


CREATE INDEX WIMI055 ON @dbschema.@DBGRPREL
(
	REPOS_ID		ASC,
	EXT_ID			ASC
);

