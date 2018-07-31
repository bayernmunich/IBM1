-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_70_insert_default_database_indicator.sql, UDDI, WAS855.UDDI, cf131750.05
-- Version:                   1.1
-- Last-changed:              05/07/18 10:43:20
--
-- @start_source_copyright@
-- Licensed Materials - Property of IBM                              
--                                                                   
-- 5724-I63, 5724-H88, 5655-N01, 5733-W60                                                           
--                                                                   
-- (C) COPYRIGHT IBM Corp., 2004, 2005 All Rights Reserved     
--                                                                   
-- US Government Users Restricted Rights - Use, duplication or       
-- disclosure restricted by GSA ADP Schedule Contract with IBM Corp. 
-- @end_source_copyright@
--

-- inserts row into configproperty to indicate this node is DEFAULT
insert into ibmuds30.configproperty(
  propertyid,
  valuetype,
  booleanvalue,
  namekey,
  descriptionkey,
  internal,
  readonly,
  required,
  displayorder
)
values(
  'DEFAULTCONFIG',
  'java.lang.Boolean',
   1,
  'property.name.DEFAULTCONFIG',
  'property.desc.DEFAULTCONFIG',
  1,
  0,
  0,
  0
);
