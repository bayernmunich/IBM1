-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_30_constraints_SQLS.sql, UDDI.v3persistence, WASX.UDDI, o0643.37
-- Version:                   1.1
-- Last-changed:              07/06/20 10:43:16
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



USE UDDI30
GO

alter table ibmudi30.businesskeymap 
   add constraint p_businesskeymap      primary key (businesskey);


alter table ibmudi30.business
    add constraint p_business            primary key (businesskey);

	alter table ibmudi30.business
    add constraint r_business            foreign key (businesskey)
                                         references ibmudi30.businesskeymap(businesskey);

alter table ibmudi30.businessname
    add constraint p_businessname        primary key (parentkey, seqnum);
alter table ibmudi30.businessname
    add constraint d_businessname        foreign key (parentkey)
                                         references ibmudi30.business(businesskey) on delete cascade;

alter table ibmudi30.businesscatbag
    add constraint p_businesscatbag      primary key (parentkey, seqnum);
alter table ibmudi30.businesscatbag
    add constraint d_businesscatbag      foreign key (parentkey)
                                         references ibmudi30.business(businesskey) on delete cascade;

alter table ibmudi30.businessidbag
    add constraint p_businessidbag       primary key (parentkey, seqnum);
alter table ibmudi30.businessidbag
    add constraint d_businessidbag       foreign key (parentkey)
                                         references ibmudi30.business(businesskey) on delete cascade;

alter table ibmudi30.contact
    add constraint p_contact             primary key (contactkey);
alter table ibmudi30.contact
    add constraint u_contact               unique (businesskey, seqnum);
alter table ibmudi30.contact
    add constraint d_contact             foreign key (businesskey)
                                         references ibmudi30.business(businesskey) on delete cascade;

alter table ibmudi30.contactdescr
    add constraint p_contactdescr        primary key (parentkey, seqnum);
alter table ibmudi30.contactdescr
    add constraint d_contactdescr        foreign key (parentkey)
                                         references ibmudi30.contact(contactkey) on delete cascade;

alter table ibmudi30.personname
    add constraint p_personname          primary key (contactkey, seqnum);
alter table ibmudi30.personname
    add constraint d_personname          foreign key (contactkey)
                                         references ibmudi30.contact(contactkey) on delete cascade;

alter table ibmudi30.email
    add constraint p_email               primary key (contactkey, seqnum);
alter table ibmudi30.email
    add constraint d_email               foreign key (contactkey)
                                         references ibmudi30.contact(contactkey) on delete cascade;

alter table ibmudi30.phone
    add constraint p_phone               primary key (contactkey, seqnum);
alter table ibmudi30.phone
    add constraint d_phone               foreign key (contactkey)
                                         references ibmudi30.contact(contactkey) on delete cascade;

alter table ibmudi30.address
    add constraint p_address             primary key (addresskey);
alter table ibmudi30.address
    add constraint u_address               unique (contactkey, seqnum);
alter table ibmudi30.address
    add constraint d_address             foreign key (contactkey)
                                         references ibmudi30.contact(contactkey) on delete cascade;

alter table ibmudi30.addrline
    add constraint p_addrline            primary key (addresskey, seqnum);
alter table ibmudi30.addrline
    add constraint d_addrline            foreign key (addresskey)
                                         references ibmudi30.address(addresskey) on delete cascade;

alter table ibmudi30.discoveryurl
    add constraint p_discoveryurl        primary key (dubusinesskey, seqnum);
alter table ibmudi30.discoveryurl
    add constraint d_discoveryurl        foreign key (dubusinesskey)
                                         references ibmudi30.business(businesskey) on delete cascade;

alter table ibmudi30.businessdescr
    add constraint p_businessdescr       primary key (parentkey, seqnum);
alter table ibmudi30.businessdescr
    add constraint d_businessdescr       foreign key (parentkey)
                                         references ibmudi30.business(businesskey) on delete cascade;

alter table ibmudi30.businesssig
    add constraint p_businesssig         primary key (parentkey, seqnum);
alter table ibmudi30.businesssig
    add constraint d_businesssig         foreign key (parentkey)
                                         references ibmudi30.business(businesskey) on delete cascade;


alter table ibmudi30.bservicekeymap
    add constraint p_bservicekeymap      primary key (servicekey);

alter table ibmudi30.bservice
    add constraint p_bservice            primary key (servicekey);
alter table ibmudi30.bservice
    add constraint r_bsrvc_bsvckeymap    foreign key (servicekey)
                                         references ibmudi30.bservicekeymap(servicekey);

alter table ibmudi30.bservicename
    add constraint p_bservicename        primary key (parentkey, seqnum);
alter table ibmudi30.bservicename
    add constraint d_bservicename        foreign key (parentkey)
                                         references ibmudi30.bservice(servicekey) on delete cascade;

alter table ibmudi30.bservicecatbag
    add constraint p_bservicecatbag      primary key (parentkey, seqnum);
alter table ibmudi30.bservicecatbag
    add constraint d_bservicecatbag      foreign key (parentkey)
                                         references ibmudi30.bservice(servicekey) on delete cascade;

alter table ibmudi30.bservicedescr
    add constraint p_bservicedescr       primary key (parentkey, seqnum);
alter table ibmudi30.bservicedescr
    add constraint d_bservicedescr       foreign key (parentkey)
                                         references ibmudi30.bservice(servicekey) on delete cascade;

alter table ibmudi30.bservicesig
    add constraint p_bservicesig         primary key (parentkey, seqnum);
alter table ibmudi30.bservicesig
    add constraint d_bservicesig         foreign key (parentkey)
                                         references ibmudi30.bservice(servicekey) on delete cascade;


alter table ibmudi30.busallservice
    add constraint p_busallservice       primary key (businesskey, servicekey);
alter table ibmudi30.busallservice
    add constraint r_busallsrvc_svckm    foreign key (servicekey)
                                         references ibmudi30.bservicekeymap(servicekey);
alter table ibmudi30.busallservice
    add constraint r_busallsrvc_bus      foreign key (businesskey)
                                         references ibmudi30.business(businesskey);
alter table ibmudi30.busallservice
    add constraint r_busallsrvc_buskm    foreign key (owningbusinesskey)
                                         references ibmudi30.businesskeymap(businesskey);


alter table ibmudi30.btemplatekeymap
    add constraint p_btemplatekeymap     primary key (bindingkey);

alter table ibmudi30.btemplate
    add constraint p_btemplate           primary key (bindingkey);
alter table ibmudi30.btemplate
    add constraint r_btemplate           foreign key (servicekey)
                                         references ibmudi30.bservice(servicekey);
alter table ibmudi30.btemplate
    add constraint d_btemplate           foreign key (bindingkey)
                                         references ibmudi30.btemplatekeymap(bindingkey) on delete cascade;

alter table ibmudi30.btemplatecatbag
    add constraint p_btemplatecatbag     primary key (parentkey, seqnum);
alter table ibmudi30.btemplatecatbag
    add constraint d_btemplatecatbag     foreign key (parentkey)
                                         references ibmudi30.btemplate(bindingkey) on delete cascade;

alter table ibmudi30.tminstanceinfo
    add constraint p_tminstanceinfo      primary key (tminstinfokey);
alter table ibmudi30.tminstanceinfo
    add constraint d_tminstanceinfo      foreign key (idbindingkey)
                                         references ibmudi30.btemplate(bindingkey) on delete cascade;

alter table ibmudi30.insdtldescr
    add constraint p_insdtldescr         primary key (parentkey, seqnum);
alter table ibmudi30.insdtldescr
    add constraint d_insdtldescr         foreign key (parentkey)
                                         references ibmudi30.tminstanceinfo(tminstinfokey) on delete cascade;

alter table ibmudi30.tminfodescr
    add constraint p_tminfodescr         primary key (parentkey, seqnum);
alter table ibmudi30.tminfodescr
    add constraint d_tminfodescr         foreign key (parentkey)
                                         references ibmudi30.tminstanceinfo(tminstinfokey) on delete cascade;

alter table ibmudi30.idoviewdoc
    add constraint p_idoviewdoc          primary key (idoviewdockey);
alter table ibmudi30.idoviewdoc
    add constraint u_idoviewdoc            unique (parentkey, seqnum);
alter table ibmudi30.idoviewdoc
    add constraint d_idoviewdoc          foreign key (parentkey)
                                         references ibmudi30.tminstanceinfo(tminstinfokey) on delete cascade;

alter table ibmudi30.idoviewdocdescr
    add constraint p_idoviewdocdescr     primary key (parentkey, seqnum);
alter table ibmudi30.idoviewdocdescr
    add constraint d_idoviewdocdescr     foreign key (parentkey)
                                         references ibmudi30.idoviewdoc(idoviewdockey) on delete cascade;

alter table ibmudi30.btemplatedescr
    add constraint p_btemplatedescr      primary key (parentkey, seqnum);
alter table ibmudi30.btemplatedescr
    add constraint d_btemplatedescr      foreign key (parentkey)
                                         references ibmudi30.btemplate(bindingkey) on delete cascade;

alter table ibmudi30.btemplatesig
    add constraint p_btemplatesig        primary key (parentkey, seqnum);
alter table ibmudi30.btemplatesig
    add constraint d_btemplatesig        foreign key (parentkey)
                                         references ibmudi30.btemplate(bindingkey) on delete cascade;


alter table ibmudi30.tmodelkeymap
    add constraint p_tmodelkeymap        primary key (tmodelkey);

alter table ibmudi30.tmodel
    add constraint p_tmodel              primary key (tmodelkey);
alter table ibmudi30.tmodel
    add constraint d_tmodel              foreign key (tmodelkey)
                                         references ibmudi30.tmodelkeymap(tmodelkey) on delete cascade;

alter table ibmudi30.tmodelcatbag
    add constraint p_tmodelcatbag        primary key (parentkey, seqnum);
alter table ibmudi30.tmodelcatbag
    add constraint d_tmodelcatbag        foreign key (parentkey)
                                         references ibmudi30.tmodel(tmodelkey) on delete cascade;

alter table ibmudi30.tmodeloviewdoc
    add constraint p_tmodeloviewdoc      primary key (tmoviewdockey);
alter table ibmudi30.tmodeloviewdoc
    add constraint u_tmodeloviewdoc        unique (parentkey, seqnum);
alter table ibmudi30.tmodeloviewdoc
    add constraint d_tmodeloviewdoc      foreign key (parentkey)
                                         references ibmudi30.tmodel(tmodelkey) on delete cascade;

alter table ibmudi30.tmodelovwdocdescr
    add constraint p_tmodelovwdocds      primary key (parentkey, seqnum);
alter table ibmudi30.tmodelovwdocdescr
    add constraint d_tmodelovwdocds      foreign key (parentkey)
                                         references ibmudi30.tmodeloviewdoc(tmoviewdockey) on delete cascade;

alter table ibmudi30.tmodelidbag
    add constraint p_tmodelidbagg        primary key (parentkey, seqnum);
alter table ibmudi30.tmodelidbag
    add constraint d_tmodelidbag         foreign key (parentkey)
                                         references ibmudi30.tmodel(tmodelkey) on delete cascade;

alter table ibmudi30.tmodeldescr
    add constraint p_tmodeldescr         primary key (parentkey, seqnum);
alter table ibmudi30.tmodeldescr
    add constraint d_tmodeldescr         foreign key (parentkey)
                                         references ibmudi30.tmodel(tmodelkey) on delete cascade;

alter table ibmudi30.tmodelsig
    add constraint p_tmodelsig           primary key (parentkey, seqnum);
alter table ibmudi30.tmodelsig
    add constraint d_tmodelsig           foreign key (parentkey)
                                         references ibmudi30.tmodel(tmodelkey) on delete cascade;


alter table ibmudi30.pubassert
    add constraint p_pubassert           primary key (pubassertkey);
alter table ibmudi30.pubassert
    add constraint r_business_from       foreign key (fromkey)
                                         references ibmudi30.business(businesskey);
alter table ibmudi30.pubassert
    add constraint r_business_to         foreign key (tokey)
                                         references ibmudi30.business(businesskey);

-- The following contraint is added during node initialisation after the 
-- reference tModel's have been inserted. This is to avoid integrity problems 
-- during any Migration phase
--
--alter table ibmudi30.pubassert
--    add constraint r_tmodel              foreign key (patmodelkey)
--                                         references ibmudi30.tmodel(tmodelkey);

alter table ibmudi30.pubassertsig
    add constraint p_pubassertsig        primary key (parentkey, fromsig, tosig, seqnum);
alter table ibmudi30.pubassertsig
    add constraint d_pubassertsig        foreign key (parentkey)
                                         references ibmudi30.pubassert(pubassertkey) on delete cascade;

alter table ibmudi30.valueset
    add constraint p_valueset            primary key (tmodelkey, keyvalue);

-- The following contraint is added during node initialisation after the 
-- reference tModel's have been inserted. This is to avoid integrity problems 
-- during any Migration phase
--
--alter table ibmudi30.valueset
--    add constraint r_valueset            foreign key (tmodelkey)
--                                         references ibmudi30.tmodel(tmodelkey);


alter table ibmudi30.transfertoken
    add constraint p_transfertoken       primary key (opaquetoken);

alter table ibmudi30.transferkey
    add constraint p_transferkey         primary key (opaquetoken, entitykey);
alter table ibmudi30.transferkey
    add constraint d_transferkey         foreign key (opaquetoken)
                                         references ibmudi30.transfertoken(opaquetoken) on delete cascade;


alter table ibmudi30.replaudit
    add constraint p_replaudit           primary key (localusn);
alter table ibmudi30.replaudit
    add constraint u_replaudit             unique (nodeid, globalusn);

alter table ibmudi30.conditionallog
    add constraint p_conditionallog      primary key (localusn,nodeid);
alter table ibmudi30.conditionallog
    add constraint r_conditionallog      foreign key (localusn)
                                         references ibmudi30.replaudit(localusn);


create index b1   on ibmudi30.business (businesskey desc);
create index b2   on ibmudi30.business (owner asc);
create index b3   on ibmudi30.business (name asc);
create index b4   on ibmudi30.business (name desc);
create index b5   on ibmudi30.business (name_nocase asc);
create index b6   on ibmudi30.business (name_nocase desc);
create index b7   on ibmudi30.business (modifiedchild asc);
create index b8   on ibmudi30.business (modifiedchild desc);

create index bs1  on ibmudi30.bservice (servicekey asc, businesskey asc);
create index bs2  on ibmudi30.bservice (businesskey desc);
create index bs3  on ibmudi30.bservice (businesskey asc, changedate asc, servicekey asc);
create index bs4  on ibmudi30.bservice (businesskey asc, servicekey asc);
create index bs5  on ibmudi30.bservice (servicekey desc);
create index bs6  on ibmudi30.bservice (name asc);
create index bs7  on ibmudi30.bservice (name desc);
create index bs8  on ibmudi30.bservice (name_nocase asc);
create index bs9  on ibmudi30.bservice (name_nocase desc);
create index bs10 on ibmudi30.bservice (modifiedchild asc);
create index bs11 on ibmudi30.bservice (modifiedchild desc);

create index bt1  on ibmudi30.btemplate (bindingkey asc, servicekey asc);
create index bt2  on ibmudi30.btemplate (bindingkey desc);
create index bt3  on ibmudi30.btemplate (servicekey asc, bindingkey asc);
create index bt4  on ibmudi30.btemplate (servicekey desc);
create index bt5  on ibmudi30.btemplate (servicekey asc, seqnum asc);
create index bt6  on ibmudi30.btemplate (changedate asc);
create index bt7  on ibmudi30.btemplate (changedate desc);

create index ba1  on ibmudi30.busallservice (businesskey asc, seqnum asc);

create index pa1  on ibmudi30.pubassert (fromkey, tokey, patmodelkey);

create index tm1  on ibmudi30.tmodel (tmodelkey desc);
create index tm2  on ibmudi30.tmodel (owner desc);
create index tm3  on ibmudi30.tmodel (deletedate desc);
create index tm4  on ibmudi30.tmodel (name asc);
create index tm5  on ibmudi30.tmodel (name desc);
create index tm6  on ibmudi30.tmodel (name_nocase asc);
create index tm7  on ibmudi30.tmodel (name_nocase desc);


create index ct1  on ibmudi30.contact (businesskey asc, contactkey asc);
create index id1  on ibmudi30.tminstanceinfo (idbindingkey desc);
create index id2  on ibmudi30.tminstanceinfo (idbindingkey asc, idtmodelkey asc, tminstinfokey asc);
create index id3  on ibmudi30.tminstanceinfo ( idbindingkey asc, idtmodelkey desc);

create index ib1  on ibmudi30.businessidbag (parentkey desc);

create index ib2  on ibmudi30.tmodelidbag (parentkey desc);

create index e1   on ibmudi30.email (contactkey asc);

create index a1   on ibmudi30.address (contactkey asc, usetype asc, sortcode asc, addresskey asc);

create index du1  on ibmudi30.discoveryurl (dubusinesskey desc);

create index p1   on ibmudi30.phone (contactkey asc, usetype asc);

create index al2  on ibmudi30.addrline (addresskey asc, seqnum asc, addressline asc);

create index vs1  on ibmudi30.valueset (tmodelkey asc, keyvalue desc);
GO

alter table ibmuds30.policy
    add constraint p_policy              primary key (id);

alter table ibmuds30.policyvalue
    add constraint p_policyvalue         primary key (id, pdp);

alter table ibmuds30.configproperty
    add constraint p_configproperty      primary key (propertyid);

alter table ibmuds30.tier
    add constraint p_tier                primary key (tierid);

alter table ibmuds30.defaulttier
    add constraint p_defaulttier         primary key (tierid);


alter table ibmuds30.defaulttier
    add constraint r_defaulttier         foreign key (tierid)
                                         references ibmuds30.tier (tierid);


alter table ibmuds30.limit
    add constraint p_limit               primary key (limitid);

alter table ibmuds30.entitlement
    add constraint p_entitlement         primary key (entitlementid);

alter table ibmuds30.uddiuser
    add constraint p_uddiuser            primary key (userid);

alter table ibmuds30.uddiuser
    add constraint d_uddiuser            foreign key(tierid)
                                         references ibmuds30.tier(tierid);

alter table ibmuds30.userentitlement
    add constraint p_userentitlement     primary key (userid, entitlementid);

alter table ibmuds30.userentitlement
    add constraint d_userentitlement     foreign key(userid)
                                         references ibmuds30.uddiuser(userid) on delete cascade;

alter table ibmuds30.userentitlement
    add constraint r_userentitlement     foreign key(entitlementid)
                                         references ibmuds30.entitlement(entitlementid);

alter table ibmuds30.tierlimits
    add constraint p_tierlimits          primary key (tierid, limitid);

alter table ibmuds30.tierlimits
    add constraint d_tierlimit           foreign key(tierid)
                                         references ibmuds30.tier(tierid) on delete cascade

										 
alter table ibmuds30.tierlimits
    add constraint r_tierlimit           foreign key(limitid)
                                         references ibmuds30.limit(limitid);

alter table ibmuds30.vss_policyadmin
    add constraint p_vss_policyadmin     primary key (tmodelkey);

alter table ibmuds30.vss_policyadmin
    add constraint r_vss_policyadmin     foreign key(tmodelkey)
                                         references ibmudi30.tmodel(tmodelkey);

										 
alter table ibmuds30.policyvalue
    add constraint r_policyvalue         foreign key (id)
                                         references ibmuds30.policy(id) on delete cascade;
									 
alter table ibmuds30.policygroupdetail
	add constraint p_policygroupdetail     primary key (id);
	
alter table ibmuds30.policygroup
    add constraint p_policygroup         primary key (policyid);

alter table ibmuds30.policygroup
    add constraint d_policygroup         foreign key (groupid)
                                         references ibmuds30.policygroupdetail(id) on delete cascade;

alter table ibmuds30.policygroup
    add constraint r_policygroup         foreign key (policyid)
                                         references ibmuds30.policy(id);
				
GO

