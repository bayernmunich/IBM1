-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_drop_triggers_cloudscape.sql, UDDI, WAS855.UDDI, cf131750.05
-- Version:                   1.1
-- Last-changed:              05/10/06 06:22:15
--
-- @start_source_copyright@
-- Licensed Materials - Property of IBM                              
--                                                                   
-- 5724-I63, 5724-H88, 5655-N02, 5733-W70                                                           
--                                                                   
-- (C) COPYRIGHT IBM Corp., 2004, 2005 All Rights Reserved     
--                                                                   
-- US Government Users Restricted Rights - Use, duplication or       
-- disclosure restricted by GSA ADP Schedule Contract with IBM Corp. 
-- @end_source_copyright@



--==========================================================
--
-- This script is used to drop the UDDI triggers in the 
-- Cloudscape database prior to using the Cloudscape -> Derby 
-- migration tool.
--
--==========================================================



--==========================================================
--
-- Drop triggers
--
--==========================================================
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

