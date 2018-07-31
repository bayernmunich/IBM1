-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_30_constraints_generic_iSeries.sql, UDDI, WAS855.UDDI, cf131750.05
-- Version:                   1.2
-- Last-changed:              06/01/24 09:03:38
--
-- @start_source_copyright@
-- Licensed Materials - Property of IBM
--
-- 5724-I63, 5724-H88, 5655-N02, 5733-W70                                                           
--
-- (C) COPYRIGHT IBM Corp., 2004, 2006 All Rights Reserved     
--
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-- @end_source_copyright@

alter table ibmudi30.businesskeymap
    add constraint ibmudi30.p_businesskeymap      primary key (businesskey);

alter table ibmudi30.business
    add constraint ibmudi30.p_business            primary key (businesskey);
alter table ibmudi30.business
    add constraint ibmudi30.r_business            foreign key (businesskey)
                                         references ibmudi30.businesskeymap(businesskey);

alter table ibmudi30.businessname
    add constraint ibmudi30.p_businessname        primary key (parentkey, seqnum);
alter table ibmudi30.businessname
    add constraint ibmudi30.d_businessname        foreign key (parentkey)
                                         references ibmudi30.business(businesskey) on delete cascade;

alter table ibmudi30.businesscatbag
    add constraint ibmudi30.p_businesscatbag      primary key (parentkey, seqnum);
alter table ibmudi30.businesscatbag
    add constraint ibmudi30.d_businesscatbag      foreign key (parentkey)
                                         references ibmudi30.business(businesskey) on delete cascade;

alter table ibmudi30.businessidbag
    add constraint ibmudi30.p_businessidbag       primary key (parentkey, seqnum);
alter table ibmudi30.businessidbag
    add constraint ibmudi30.d_businessidbag       foreign key (parentkey)
                                         references ibmudi30.business(businesskey) on delete cascade;

alter table ibmudi30.contact
    add constraint ibmudi30.p_contact             primary key (contactkey);
alter table ibmudi30.contact
    add constraint ibmudi30.u_contact               unique (businesskey, seqnum);
alter table ibmudi30.contact
    add constraint ibmudi30.d_contact             foreign key (businesskey)
                                         references ibmudi30.business(businesskey) on delete cascade;

alter table ibmudi30.contactdescr
    add constraint ibmudi30.p_contactdescr        primary key (parentkey, seqnum);
alter table ibmudi30.contactdescr
    add constraint ibmudi30.d_contactdescr        foreign key (parentkey)
                                         references ibmudi30.contact(contactkey) on delete cascade;

alter table ibmudi30.personname
    add constraint ibmudi30.p_personname          primary key (contactkey, seqnum);
alter table ibmudi30.personname
    add constraint ibmudi30.d_personname          foreign key (contactkey)
                                         references ibmudi30.contact(contactkey) on delete cascade;

alter table ibmudi30.email
    add constraint ibmudi30.p_email               primary key (contactkey, seqnum);
alter table ibmudi30.email
    add constraint ibmudi30.d_email               foreign key (contactkey)
                                         references ibmudi30.contact(contactkey) on delete cascade;

alter table ibmudi30.phone
    add constraint ibmudi30.p_phone               primary key (contactkey, seqnum);
alter table ibmudi30.phone
    add constraint ibmudi30.d_phone               foreign key (contactkey)
                                         references ibmudi30.contact(contactkey) on delete cascade;

alter table ibmudi30.address
    add constraint ibmudi30.p_address             primary key (addresskey);
alter table ibmudi30.address
    add constraint ibmudi30.u_address               unique (contactkey, seqnum);
alter table ibmudi30.address
    add constraint ibmudi30.d_address             foreign key (contactkey)
                                         references ibmudi30.contact(contactkey) on delete cascade;

alter table ibmudi30.addrline
    add constraint ibmudi30.p_addrline            primary key (addresskey, seqnum);
alter table ibmudi30.addrline
    add constraint ibmudi30.d_addrline            foreign key (addresskey)
                                         references ibmudi30.address(addresskey) on delete cascade;

alter table ibmudi30.discoveryurl
    add constraint ibmudi30.p_discoveryurl        primary key (dubusinesskey, seqnum);
alter table ibmudi30.discoveryurl
    add constraint ibmudi30.d_discoveryurl        foreign key (dubusinesskey)
                                         references ibmudi30.business(businesskey) on delete cascade;

alter table ibmudi30.businessdescr
    add constraint ibmudi30.p_businessdescr       primary key (parentkey, seqnum);
alter table ibmudi30.businessdescr
    add constraint ibmudi30.d_businessdescr       foreign key (parentkey)
                                         references ibmudi30.business(businesskey) on delete cascade;

alter table ibmudi30.businesssig
    add constraint ibmudi30.p_businesssig         primary key (parentkey, seqnum);
alter table ibmudi30.businesssig
    add constraint ibmudi30.d_businesssig         foreign key (parentkey)
                                         references ibmudi30.business(businesskey) on delete cascade;


alter table ibmudi30.bservicekeymap
    add constraint ibmudi30.p_bservicekeymap      primary key (servicekey);

alter table ibmudi30.bservice
    add constraint ibmudi30.p_bservice            primary key (servicekey);
alter table ibmudi30.bservice
    add constraint ibmudi30.r_bsrvc_bsvckeymap    foreign key (servicekey)
                                         references ibmudi30.bservicekeymap(servicekey);

alter table ibmudi30.bservicename
    add constraint ibmudi30.p_bservicename        primary key (parentkey, seqnum);
alter table ibmudi30.bservicename
    add constraint ibmudi30.d_bservicename        foreign key (parentkey)
                                         references ibmudi30.bservice(servicekey) on delete cascade;

alter table ibmudi30.bservicecatbag
    add constraint ibmudi30.p_bservicecatbag      primary key (parentkey, seqnum);
alter table ibmudi30.bservicecatbag
    add constraint ibmudi30.d_bservicecatbag      foreign key (parentkey)
                                         references ibmudi30.bservice(servicekey) on delete cascade;

alter table ibmudi30.bservicedescr
    add constraint ibmudi30.p_bservicedescr       primary key (parentkey, seqnum);
alter table ibmudi30.bservicedescr
    add constraint ibmudi30.d_bservicedescr       foreign key (parentkey)
                                         references ibmudi30.bservice(servicekey) on delete cascade;

alter table ibmudi30.bservicesig
    add constraint ibmudi30.p_bservicesig         primary key (parentkey, seqnum);
alter table ibmudi30.bservicesig
    add constraint ibmudi30.d_bservicesig         foreign key (parentkey)
                                         references ibmudi30.bservice(servicekey) on delete cascade;


alter table ibmudi30.busallservice
    add constraint ibmudi30.p_busallservice       primary key (businesskey, servicekey);
alter table ibmudi30.busallservice
    add constraint ibmudi30.r_busallsrvc_svckm    foreign key (servicekey)
                                         references ibmudi30.bservicekeymap(servicekey);
alter table ibmudi30.busallservice
    add constraint ibmudi30.r_busallsrvc_bus      foreign key (businesskey)
                                         references ibmudi30.business(businesskey);
alter table ibmudi30.busallservice
    add constraint ibmudi30.r_busallsrvc_buskm    foreign key (owningbusinesskey)
                                         references ibmudi30.businesskeymap(businesskey);


alter table ibmudi30.btemplatekeymap
    add constraint ibmudi30.p_btemplatekeymap     primary key (bindingkey);

alter table ibmudi30.btemplate
    add constraint ibmudi30.p_btemplate           primary key (bindingkey);
alter table ibmudi30.btemplate
    add constraint ibmudi30.r_btemplate           foreign key (servicekey)
                                         references ibmudi30.bservice(servicekey);
alter table ibmudi30.btemplate
    add constraint ibmudi30.d_btemplate           foreign key (bindingkey)
                                         references ibmudi30.btemplatekeymap(bindingkey) on delete cascade;

alter table ibmudi30.btemplatecatbag
    add constraint ibmudi30.p_btemplatecatbag     primary key (parentkey, seqnum);
alter table ibmudi30.btemplatecatbag
    add constraint ibmudi30.d_btemplatecatbag     foreign key (parentkey)
                                         references ibmudi30.btemplate(bindingkey) on delete cascade;

alter table ibmudi30.tminstanceinfo
    add constraint ibmudi30.p_tminstanceinfo      primary key (tminstinfokey);
alter table ibmudi30.tminstanceinfo
    add constraint ibmudi30.d_tminstanceinfo      foreign key (idbindingkey)
                                         references ibmudi30.btemplate(bindingkey) on delete cascade;

alter table ibmudi30.insdtldescr
    add constraint ibmudi30.p_insdtldescr         primary key (parentkey, seqnum);
alter table ibmudi30.insdtldescr
    add constraint ibmudi30.d_insdtldescr         foreign key (parentkey)
                                         references ibmudi30.tminstanceinfo(tminstinfokey) on delete cascade;

alter table ibmudi30.tminfodescr
    add constraint ibmudi30.p_tminfodescr         primary key (parentkey, seqnum);
alter table ibmudi30.tminfodescr
    add constraint ibmudi30.d_tminfodescr         foreign key (parentkey)
                                         references ibmudi30.tminstanceinfo(tminstinfokey) on delete cascade;

alter table ibmudi30.idoviewdoc
    add constraint ibmudi30.p_idoviewdoc          primary key (idoviewdockey);
alter table ibmudi30.idoviewdoc
    add constraint ibmudi30.u_idoviewdoc            unique (parentkey, seqnum);
alter table ibmudi30.idoviewdoc
    add constraint ibmudi30.d_idoviewdoc          foreign key (parentkey)
                                         references ibmudi30.tminstanceinfo(tminstinfokey) on delete cascade;

alter table ibmudi30.idoviewdocdescr
    add constraint ibmudi30.p_idoviewdocdescr     primary key (parentkey, seqnum);
alter table ibmudi30.idoviewdocdescr
    add constraint ibmudi30.d_idoviewdocdescr     foreign key (parentkey)
                                         references ibmudi30.idoviewdoc(idoviewdockey) on delete cascade;

alter table ibmudi30.btemplatedescr
    add constraint ibmudi30.p_btemplatedescr      primary key (parentkey, seqnum);
alter table ibmudi30.btemplatedescr
    add constraint ibmudi30.d_btemplatedescr      foreign key (parentkey)
                                         references ibmudi30.btemplate(bindingkey) on delete cascade;

alter table ibmudi30.btemplatesig
    add constraint ibmudi30.p_btemplatesig        primary key (parentkey, seqnum);
alter table ibmudi30.btemplatesig
    add constraint ibmudi30.d_btemplatesig        foreign key (parentkey)
                                         references ibmudi30.btemplate(bindingkey) on delete cascade;


alter table ibmudi30.tmodelkeymap
    add constraint ibmudi30.p_tmodelkeymap        primary key (tmodelkey);

alter table ibmudi30.tmodel
    add constraint ibmudi30.p_tmodel              primary key (tmodelkey);
alter table ibmudi30.tmodel
    add constraint ibmudi30.d_tmodel              foreign key (tmodelkey)
                                         references ibmudi30.tmodelkeymap(tmodelkey) on delete cascade;

alter table ibmudi30.tmodelcatbag
    add constraint ibmudi30.p_tmodelcatbag        primary key (parentkey, seqnum);
alter table ibmudi30.tmodelcatbag
    add constraint ibmudi30.d_tmodelcatbag        foreign key (parentkey)
                                         references ibmudi30.tmodel(tmodelkey) on delete cascade;

alter table ibmudi30.tmodeloviewdoc
    add constraint ibmudi30.p_tmodeloviewdoc      primary key (tmoviewdockey);
alter table ibmudi30.tmodeloviewdoc
    add constraint ibmudi30.u_tmodeloviewdoc        unique (parentkey, seqnum);
alter table ibmudi30.tmodeloviewdoc
    add constraint ibmudi30.d_tmodeloviewdoc      foreign key (parentkey)
                                         references ibmudi30.tmodel(tmodelkey) on delete cascade;

alter table ibmudi30.tmodelovwdocdescr
    add constraint ibmudi30.p_tmodelovwdocds      primary key (parentkey, seqnum);
alter table ibmudi30.tmodelovwdocdescr
    add constraint ibmudi30.d_tmodelovwdocds      foreign key (parentkey)
                                         references ibmudi30.tmodeloviewdoc(tmoviewdockey) on delete cascade;

alter table ibmudi30.tmodelidbag
    add constraint ibmudi30.p_tmodelidbagg        primary key (parentkey, seqnum);
alter table ibmudi30.tmodelidbag
    add constraint ibmudi30.d_tmodelidbag         foreign key (parentkey)
                                         references ibmudi30.tmodel(tmodelkey) on delete cascade;

alter table ibmudi30.tmodeldescr
    add constraint ibmudi30.p_tmodeldescr         primary key (parentkey, seqnum);
alter table ibmudi30.tmodeldescr
    add constraint ibmudi30.d_tmodeldescr         foreign key (parentkey)
                                         references ibmudi30.tmodel(tmodelkey) on delete cascade;

alter table ibmudi30.tmodelsig
    add constraint ibmudi30.p_tmodelsig           primary key (parentkey, seqnum);
alter table ibmudi30.tmodelsig
    add constraint ibmudi30.d_tmodelsig           foreign key (parentkey)
                                         references ibmudi30.tmodel(tmodelkey) on delete cascade;


alter table ibmudi30.pubassert
    add constraint ibmudi30.p_pubassert           primary key (pubassertkey);
alter table ibmudi30.pubassert
    add constraint ibmudi30.r_business_from       foreign key (fromkey)
                                         references ibmudi30.business(businesskey);
alter table ibmudi30.pubassert
    add constraint ibmudi30.r_business_to         foreign key (tokey)
                                         references ibmudi30.business(businesskey);
-- The following contraint is added during node initialisation after the 
-- reference tModel's have been inserted. This is to avoid integrity problems 
-- during any Migration phase
--
--alter table ibmudi30.pubassert
--    add constraint r_tmodel              foreign key (patmodelkey)
--                                         references ibmudi30.tmodel(tmodelkey);

alter table ibmudi30.pubassertsig
    add constraint ibmudi30.p_pubassertsig        primary key (parentkey, fromsig, tosig, seqnum);
alter table ibmudi30.pubassertsig
    add constraint ibmudi30.d_pubassertsig        foreign key (parentkey)
                                         references ibmudi30.pubassert(pubassertkey) on delete cascade;

alter table ibmudi30.valueset
    add constraint ibmudi30.p_valueset            primary key (tmodelkey, keyvalue);
-- The following contraint is added during node initialisation after the 
-- reference tModel's have been inserted. This is to avoid integrity problems 
-- during any Migration phase
--
--alter table ibmudi30.valueset
--    add constraint r_valueset            foreign key (tmodelkey)
--                                         references ibmudi30.tmodel(tmodelkey);


alter table ibmudi30.transfertoken
    add constraint ibmudi30.p_transfertoken       primary key (opaquetoken);

alter table ibmudi30.transferkey
    add constraint ibmudi30.p_transferkey         primary key (opaquetoken, entitykey);
alter table ibmudi30.transferkey
    add constraint ibmudi30.d_transferkey         foreign key (opaquetoken)
                                         references ibmudi30.transfertoken(opaquetoken) on delete cascade;


alter table ibmudi30.replaudit
    add constraint ibmudi30.p_replaudit           primary key (localusn);
alter table ibmudi30.replaudit
    add constraint ibmudi30.u_replaudit             unique (nodeid, globalusn);

alter table ibmudi30.conditionallog
    add constraint ibmudi30.p_conditionallog      primary key (localusn,nodeid);
alter table ibmudi30.conditionallog
    add constraint ibmudi30.r_conditionallog      foreign key (localusn)
                                         references ibmudi30.replaudit(localusn);

alter table ibmuds30.policy
    add constraint ibmuds30.p_policy              primary key (id);

alter table ibmuds30.policyvalue
    add constraint ibmuds30.p_policyvalue         primary key (id, pdp);
alter table ibmuds30.policyvalue
    add constraint ibmuds30.r_policyvalue         foreign key (id)
                                         references ibmuds30.policy(id) on delete cascade;

alter table ibmuds30.policygroupdetail
    add constraint ibmuds30.policygroupdetail     primary key (id);

alter table ibmuds30.policygroup
    add constraint ibmuds30.p_policygroup         primary key (policyid);
alter table ibmuds30.policygroup
    add constraint ibmuds30.d_policygroup         foreign key (groupid)
                                         references ibmuds30.policygroupdetail(id) on delete cascade;
alter table ibmuds30.policygroup
    add constraint ibmuds30.r_policygroup         foreign key (policyid)
                                         references ibmuds30.policy(id);

alter table ibmuds30.configproperty
    add constraint ibmuds30.p_configproperty      primary key (propertyid);

alter table ibmuds30.tier
    add constraint ibmuds30.p_tier                primary key (tierid);

alter table ibmuds30.defaulttier
    add constraint ibmuds30.p_defaulttier         primary key (tierid);
alter table ibmuds30.defaulttier
    add constraint ibmuds30.r_defaulttier         foreign key(tierid)
                                         references ibmuds30.tier(tierid);

alter table ibmuds30.limit
    add constraint ibmuds30.p_limit               primary key (limitid);

alter table ibmuds30.entitlement
    add constraint ibmuds30.p_entitlement         primary key (entitlementid);

alter table ibmuds30.uddiuser
    add constraint ibmuds30.p_uddiuser            primary key (userid);
alter table ibmuds30.uddiuser
    add constraint ibmuds30.d_uddiuser            foreign key(tierid)
                                         references ibmuds30.tier(tierid);

alter table ibmuds30.userentitlement
    add constraint ibmuds30.p_userentitlement     primary key (userid, entitlementid);
alter table ibmuds30.userentitlement
    add constraint ibmuds30.d_userentitlement     foreign key(userid)
                                         references ibmuds30.uddiuser(userid) on delete cascade;
alter table ibmuds30.userentitlement
    add constraint ibmuds30.r_userentitlement     foreign key(entitlementid)
                                         references ibmuds30.entitlement(entitlementid);

alter table ibmuds30.tierlimits
    add constraint ibmuds30.p_tierlimits          primary key (tierid, limitid);
alter table ibmuds30.tierlimits
    add constraint ibmuds30.d_tierlimit           foreign key(tierid)
                                         references ibmuds30.tier(tierid) on delete cascade;
alter table ibmuds30.tierlimits
    add constraint ibmuds30.r_tierlimit           foreign key(limitid)
                                         references ibmuds30.limit(limitid);

alter table ibmuds30.vss_policyadmin
    add constraint ibmuds30.p_vss_policyadmin     primary key (tmodelkey);
alter table ibmuds30.vss_policyadmin
    add constraint ibmuds30.r_vss_policyadmin     foreign key(tmodelkey)
                                         references ibmudi30.tmodel(tmodelkey);


create index ibmudi30.b1   on ibmudi30.business (businesskey desc);
create index ibmudi30.b2   on ibmudi30.business (owner asc);
create index ibmudi30.b3   on ibmudi30.business (name asc);
create index ibmudi30.b4   on ibmudi30.business (name desc);
create index ibmudi30.b5   on ibmudi30.business (name_nocase asc);
create index ibmudi30.b6   on ibmudi30.business (name_nocase desc);
create index ibmudi30.b7   on ibmudi30.business (modifiedchild asc);
create index ibmudi30.b8   on ibmudi30.business (modifiedchild desc);

create index ibmudi30.bs1  on ibmudi30.bservice (servicekey asc, businesskey asc);
create index ibmudi30.bs2  on ibmudi30.bservice (businesskey desc);
create index ibmudi30.bs3  on ibmudi30.bservice (businesskey asc, changedate asc, servicekey asc);
create index ibmudi30.bs4  on ibmudi30.bservice (businesskey asc, servicekey asc);
create index ibmudi30.bs5  on ibmudi30.bservice (servicekey desc);
create index ibmudi30.bs6  on ibmudi30.bservice (name asc);
create index ibmudi30.bs7  on ibmudi30.bservice (name desc);
create index ibmudi30.bs8  on ibmudi30.bservice (name_nocase asc);
create index ibmudi30.bs9  on ibmudi30.bservice (name_nocase desc);
create index ibmudi30.bs10 on ibmudi30.bservice (modifiedchild asc);
create index ibmudi30.bs11 on ibmudi30.bservice (modifiedchild desc);

create index ibmudi30.bt1  on ibmudi30.btemplate (bindingkey asc, servicekey asc);
create index ibmudi30.bt2  on ibmudi30.btemplate (bindingkey desc);
create index ibmudi30.bt3  on ibmudi30.btemplate (servicekey asc, bindingkey asc);
create index ibmudi30.bt4  on ibmudi30.btemplate (servicekey desc);
create index ibmudi30.bt5  on ibmudi30.btemplate (servicekey asc, seqnum asc);
create index ibmudi30.bt6  on ibmudi30.btemplate (changedate asc);
create index ibmudi30.bt7  on ibmudi30.btemplate (changedate desc);

create index ibmudi30.ba1  on ibmudi30.busallservice (businesskey asc, seqnum asc);

create index ibmudi30.pa1  on ibmudi30.pubassert (fromkey, tokey, patmodelkey);

create index ibmudi30.tm1  on ibmudi30.tmodel (tmodelkey desc);
create index ibmudi30.tm2  on ibmudi30.tmodel (owner desc);
create index ibmudi30.tm3  on ibmudi30.tmodel (deletedate desc);
create index ibmudi30.tm4  on ibmudi30.tmodel (name asc);
create index ibmudi30.tm5  on ibmudi30.tmodel (name desc);
create index ibmudi30.tm6  on ibmudi30.tmodel (name_nocase asc);
create index ibmudi30.tm7  on ibmudi30.tmodel (name_nocase desc);


create index ibmudi30.ct1  on ibmudi30.contact (businesskey asc, contactkey asc);

create index ibmudi30.id1  on ibmudi30.tminstanceinfo (idbindingkey desc);
create index ibmudi30.id2  on ibmudi30.tminstanceinfo (idbindingkey asc, idtmodelkey asc, tminstinfokey asc);
create index ibmudi30.id3  on ibmudi30.tminstanceinfo ( idbindingkey asc, idtmodelkey desc);

create index ibmudi30.ib1  on ibmudi30.businessidbag (parentkey desc);

create index ibmudi30.ib2  on ibmudi30.tmodelidbag (parentkey desc);

create index ibmudi30.e1   on ibmudi30.email (contactkey asc);

create index ibmudi30.a1   on ibmudi30.address (contactkey asc, usetype asc, sortcode asc, addresskey asc);

create index ibmudi30.du1  on ibmudi30.discoveryurl (dubusinesskey desc);

create index ibmudi30.p1   on ibmudi30.phone (contactkey asc, usetype asc);

create index ibmudi30.al2  on ibmudi30.addrline (addresskey asc, seqnum asc, addressline asc);

create index ibmudi30.vs1  on ibmudi30.valueset (tmodelkey asc, keyvalue desc);
