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
INSERT INTO @dbschema.@DBPROPTYPE (TYPE_ID, DESCRIPTION) VALUES ('LONG', 'Description of LONG');
INSERT INTO @dbschema.@DBPROPTYPE (TYPE_ID, DESCRIPTION) VALUES ('TIMESTAMP', 'Description of TIMESTAMP');
INSERT INTO @dbschema.@DBPROPTYPE (TYPE_ID, DESCRIPTION) VALUES ('DOUBLE', 'Description of DOUBLE');
INSERT INTO @dbschema.@DBPROPTYPE (TYPE_ID, DESCRIPTION) VALUES ('INTEGER', 'Description of INTEGER');
INSERT INTO @dbschema.@DBPROPTYPE (TYPE_ID, DESCRIPTION) VALUES ('STRING', 'Description of STRING');
INSERT INTO @dbschema.@DBPROPTYPE (TYPE_ID, DESCRIPTION) VALUES ('OBJECT', 'Description of OBJECT');
INSERT INTO @dbschema.@DBPROPTYPE (TYPE_ID, DESCRIPTION) VALUES ('IDENTIFIER', 'Description of IDENTIFIER');
INSERT INTO @dbschema.@DBPROPTYPE (TYPE_ID, DESCRIPTION) VALUES ('BYTEARRAY','Description for BYTEARRAY');


INSERT INTO @dbschema.@DBENTITY(ENTITY_ID, ENTITY_TYPE, UNIQUE_ID, UNIQUE_NAME, UNIQUE_NAME_KEY) VALUES (-2000, 'OrgContainer', 'a9e5a980-3cec-11da-a833-828d43500d84', 'o=Default Organization', 'o=default organization');
