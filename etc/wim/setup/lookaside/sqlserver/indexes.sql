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
CREATE UNIQUE INDEX WIMI205 ON @dbschema.@LAENTITY
(
	ENTITY_ID		ASC,
	REPOS_ID		ASC
);


CREATE UNIQUE INDEX WIMI210 ON @dbschema.@LAENTITY
(
	EXT_ID			ASC,
	REPOS_ID		ASC
);


CREATE UNIQUE INDEX WIMI215 ON @dbschema.@LAPROP
(
	NAME			ASC,
	META_NAME		ASC
);


CREATE INDEX WIMI220 ON @dbschema.@LADBLPROP
(
	PROPVALUE		ASC
);


CREATE INDEX WIMI225 ON @dbschema.@LAINTPROP
(
	PROPVALUE		ASC
);


CREATE INDEX WIMI230 ON @dbschema.@LATSPROP
(
	PROPVALUE		ASC
);


CREATE INDEX WIMI235 ON @dbschema.@LALONGPROP
(
	PROPVALUE		ASC
);


CREATE INDEX WIMI240 ON @dbschema.@LAREFPROP
(
	REF_UNAME_KEY		ASC
);

CREATE INDEX WIMI245 ON @dbschema.@LAREFPROP
(
	REF_EXT_ID		ASC,
	REF_REPOS_ID		ASC
);

CREATE INDEX WIMI250 ON @dbschema.@LASTRPROP
(
	ENTITY_ID		ASC
);