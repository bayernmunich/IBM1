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
ALTER TABLE @dbschema.@LAENTITY
	ADD PRIMARY KEY (ENTITY_ID);
	

ALTER TABLE @dbschema.@LAKEYS
	ADD PRIMARY KEY (KEYS_ID);


ALTER TABLE @dbschema.@LAPROP
	ADD PRIMARY KEY (PROP_ID);


ALTER TABLE @dbschema.@LAPROPTYPE
	ADD PRIMARY KEY (TYPE_ID);
	

ALTER TABLE @dbschema.@LAPROPENT
	ADD PRIMARY KEY (PROP_ID, APPLICABLE_ENTTYPE);


ALTER TABLE @dbschema.@LALONGPROP
	ADD PRIMARY KEY (VALUE_ID);


ALTER TABLE @dbschema.@LABLOBPROP
	ADD PRIMARY KEY (VALUE_ID);


ALTER TABLE @dbschema.@LADBLPROP
	ADD PRIMARY KEY (VALUE_ID);


ALTER TABLE @dbschema.@LAINTPROP
	ADD PRIMARY KEY (VALUE_ID);
	

ALTER TABLE @dbschema.@LAREFPROP
	ADD PRIMARY KEY (VALUE_ID);
	

ALTER TABLE @dbschema.@LASTRPROP
	ADD PRIMARY KEY (VALUE_ID);


ALTER TABLE @dbschema.@LATSPROP
	ADD PRIMARY KEY (VALUE_ID);


ALTER TABLE @dbschema.@LACOMPREL
	ADD PRIMARY KEY (COMPOSITE_ID, COMPONENT_ID);


ALTER TABLE @dbschema.@LACOMPPROP
	ADD PRIMARY KEY (VALUE_ID);