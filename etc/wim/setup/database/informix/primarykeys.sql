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
ALTER TABLE @dbschema.@DBENTITY
	ADD CONSTRAINT PRIMARY KEY (ENTITY_ID);


ALTER TABLE @dbschema.@DBPROPTYPE
	ADD CONSTRAINT PRIMARY KEY (TYPE_ID);
		
	
ALTER TABLE @dbschema.@DBPROP
	ADD CONSTRAINT PRIMARY KEY (PROP_ID);


ALTER TABLE @dbschema.@DBPROPENT
	ADD CONSTRAINT PRIMARY KEY (PROP_ID, APPLICABLE_ENTTYPE);


ALTER TABLE @dbschema.@DBCOMPREL
	ADD CONSTRAINT PRIMARY KEY (COMPOSITE_ID, COMPONENT_ID);


ALTER TABLE @dbschema.@DBCOMPPROP
	ADD CONSTRAINT PRIMARY KEY (VALUE_ID);


ALTER TABLE @dbschema.@DBENTREL
	ADD CONSTRAINT PRIMARY KEY (DESCENDANT_ID, ANCESTOR_ID);


ALTER TABLE @dbschema.@DBGRPREL
	ADD CONSTRAINT PRIMARY KEY (GRP_ID, REPOS_ID, EXT_ID);


ALTER TABLE @dbschema.@DBACCT
       ADD CONSTRAINT PRIMARY KEY (ENTITY_ID);
