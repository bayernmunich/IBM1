-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_05_drop_derby.sql, UDDI, WAS855.UDDI, cf131750.05
-- Version:                   1.1
-- Last-changed:              05/07/18 10:42:15
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


-- Drop Triggers

drop trigger ibmudi30.tr_dlt_business;
drop trigger ibmudi30.tr_dlt_busines2;
drop trigger ibmudi30.tr_ins_bservice;
drop trigger ibmudi30.tr_upd_bservice;
drop trigger ibmudi30.tr_dlt_bservice;
drop trigger ibmudi30.tr_dlt1busallsvcr;
drop trigger ibmudi30.tr_dlt2busallsvcr;
drop trigger ibmudi30.tr_dlt3busallsvcr;
drop trigger ibmudi30.tr_dlt1busallsvcsp;
drop trigger ibmudi30.tr_dlt2busallsvcsp;
drop trigger ibmudi30.tr_upd_busallsvc_p;
drop trigger ibmudi30.tr_ins_btemplate;
drop trigger ibmudi30.tr_upd_btemplate_p;
drop trigger ibmudi30.tr_upd_btemplate;
drop trigger ibmudi30.tr_dlt_btemplate;
drop trigger ibmudi30.tr_ins_name_bus;
drop trigger ibmudi30.tr_upd_name_bus;
drop trigger ibmudi30.tr_ins_name_bsrv;
drop trigger ibmudi30.tr_upd_name_bsrv;
drop trigger ibmudi30.tr_upd_tmodel_cond;
drop trigger ibmudi30.tr_dlt_tmdlkeymap;

-- Drop Views

drop view ibmudi30.voperatnlinfo_v3;
drop view ibmuds30.vconfigproperty;
drop view ibmudi30.vcontact_v2;   
drop view ibmuds30.vtierincdefault;  
drop view ibmuds30.vuserentitlement;
drop view ibmuds30.vusertier;       
drop view ibmuds30.vlimitvalue;     
drop view ibmuds30.vactivepolicy;   
drop view ibmudi30.vtmodelidbag_v3; 
drop view ibmudi30.vbusinessidbag_v3;  
drop view ibmudi30.vSVCCmbnCatbag_v3;  
drop view ibmudi30.vtmodelcatbag_v3; 
drop view ibmudi30.vbtempltcatbag_v3;
drop view ibmudi30.vbservicecatbag_v3;
drop view ibmudi30.vbusinesscatbag_v3;
drop view ibmudi30.vpubassert_v3;
drop view ibmudi30.vtminstanceinfo_v3;
drop view ibmudi30.vtmodel_v3;         
drop view ibmudi30.vbtemplate_v3_s;
drop view ibmudi30.vbtemplate_v3;
drop view ibmudi30.vbservice_v3_s;
drop view ibmudi30.vbservice_v3;
drop view ibmudi30.vbusiness_v3;

-- Drop Tables

drop table ibmudi30.idoviewdocdescr;
drop table ibmudi30.idoviewdoc;
drop table ibmudi30.insdtldescr;
drop table ibmudi30.tminfodescr;
drop table ibmudi30.tminstanceinfo;
drop table ibmudi30.btemplatedescr;
drop table ibmudi30.btemplatecatbag;
drop table ibmudi30.btemplatesig;
drop table ibmudi30.btemplate;
drop table ibmudi30.btemplatekeymap;

drop table ibmudi30.busallservice;

drop table ibmudi30.bservicesig;
drop table ibmudi30.bservicename;
drop table ibmudi30.bservicecatbag;
drop table ibmudi30.bservicedescr;
drop table ibmudi30.bservice;
drop table ibmudi30.bservicekeymap;

drop table ibmuds30.vss_policyadmin;

drop table ibmudi30.tmodeldescr;
drop table ibmudi30.tmodelcatbag;
drop table ibmudi30.tmodelovwdocdescr;
drop table ibmudi30.tmodelidbag;
drop table ibmudi30.tmodeloviewdoc;
drop table ibmudi30.tmodelsig;
drop table ibmudi30.tmodel;
drop table ibmudi30.tmodelkeymap;

drop table ibmudi30.pubassertsig;
drop table ibmudi30.pubassert;

drop table ibmuds30.uddidbschemaver;
drop table ibmudi30.contactdescr;
drop table ibmudi30.personname;
drop table ibmudi30.email;
drop table ibmudi30.phone;
drop table ibmudi30.addrline;
drop table ibmudi30.address;
drop table ibmudi30.contact;
drop table ibmudi30.discoveryurl;
drop table ibmudi30.businesssig;
drop table ibmudi30.businessdescr;
drop table ibmudi30.businesscatbag;
drop table ibmudi30.businessidbag;
drop table ibmudi30.businessname;
drop table ibmudi30.business;
drop table ibmudi30.businesskeymap;

drop table ibmudi30.valueset;

drop table ibmudi30.transferkey;
drop table ibmudi30.transfertoken;

drop table ibmuds30.policyvalue;
drop table ibmuds30.policygroup;
drop table ibmuds30.policygroupdetail;
drop table ibmuds30.policy;

drop table ibmuds30.configproperty;

drop table ibmuds30.tierlimits ;
drop table ibmuds30.limit;
drop table ibmuds30.userentitlement ;
drop table ibmuds30.entitlement;
drop table ibmuds30.uddiuser ;
drop table ibmuds30.defaulttier;
drop table ibmuds30.tier;


drop table ibmudi30.conditionallog;
drop table ibmudi30.replaudit;

-- Drop Schemas

drop schema ibmudi30 restrict;
drop schema ibmuds30 restrict;
