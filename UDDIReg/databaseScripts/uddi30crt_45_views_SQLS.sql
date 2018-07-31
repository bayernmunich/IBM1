-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_40_views_SQLS.sql, UDDI.v3persistence, WASX.UDDI, o0643.37
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

-- Create view must be first statement in batch, hence extra GOs
use UDDI30
GO

create view ibmudi30.vbusiness_v3 (v3businesskey, businesskey, name, name_nocase,owner, operator, createdate, changedate, modifiedchild, issigned, isorphaned)
as
select
   businesskeymap.v3businesskey,
   business.businesskey,
   business.name,
   business.name_nocase,
   business.owner,
   business.operator,
   business.createdate,
   business.changedate,
   business.modifiedchild,
   business.issigned,
   businesskeymap.isorphaned
from
   ibmudi30.business business
   inner join ibmudi30.businesskeymap businesskeymap on business.businesskey = businesskeymap.businesskey 
GO


----------------------------------------------------------------------------
--
-- This view retuns full details about a Service or Service Projection.
--
-- A value of 1 in the "servicetype" column indicates a Service Projection
--
----------------------------------------------------------------------------
create view ibmudi30.vbservice_v3
   (
      v3servicekey,
      servicekey,
      v3businesskey,
      businesskey,
      name,
      name_nocase,
      createdate,
      changedate,
      modifiedchild,
      issigned,
      seqnum,
      v3owningbuskey,
      owningbusinesskey,
      isorphaned,
      servicetype
   )
as
select
   bservicekeymap.v3servicekey,
   busallservice.servicekey,
   businesskeymap.v3businesskey,
   busallservice.businesskey,
   bservice.name,
   bservice.name_nocase,
   bservice.createdate,
   bservice.changedate,
   bservice.modifiedchild,
   bservice.issigned,
   busallservice.seqnum,
   owningbuskeymap.v3businesskey,
   busallservice.owningbusinesskey,
   bservicekeymap.isorphaned,
   case when busallservice.owningbusinesskey = busallservice.businesskey then 0 else 1 end
FROM
   ibmudi30.busallservice busallservice
    left outer join ibmudi30.bservice bservice on  busallservice.servicekey  = bservice.servicekey 
    inner join ibmudi30.bservicekeymap bservicekeymap  on busallservice.servicekey = bservicekeymap.servicekey 
    inner join ibmudi30.businesskeymap businesskeymap  on busallservice.businesskey = businesskeymap.businesskey 
    inner join ibmudi30.businesskeymap owningbuskeymap on busallservice.owningbusinesskey = owningbuskeymap.businesskey 

GO

----------------------------------------------------------------------------
--
-- Service/"Parent Business" Signed version of vbservice_v3
--
----------------------------------------------------------------------------
create view ibmudi30.vbservice_v3_s
   (
      v3servicekey,
      servicekey,
      v3businesskey,
      businesskey,
      name,
      name_nocase,
      createdate,
      changedate,
      modifiedchild,
      issigned,
      seqnum,
      v3owningbuskey,
      owningbusinesskey,
      isorphaned,
      servicetype
   )
as
select
   vbservice_v3.v3servicekey,
   vbservice_v3.servicekey,
   vbservice_v3.v3businesskey,
   vbservice_v3.businesskey,
   vbservice_v3.name,
   vbservice_v3.name_nocase,
   vbservice_v3.createdate,
   vbservice_v3.changedate,
   vbservice_v3.modifiedchild,
   case
      when vbservice_v3.issigned > 0 then 1
      when business.issigned > 0 then 1
      else 0
    end,
   vbservice_v3.seqnum,
   vbservice_v3.v3businesskey,
   vbservice_v3.owningbusinesskey,
   vbservice_v3.isorphaned,
   vbservice_v3.servicetype
from

   ibmudi30.vbservice_v3 vbservice_v3
    inner join ibmudi30.business business on vbservice_v3.businesskey = business.businesskey
GO


create view ibmudi30.vbtemplate_v3 (v3bindingkey, bindingkey, v3servicekey, servicekey, accesspoint, usetype, hostingredir, createdate, changedate, issigned, seqnum)
as
select
   btemplatekeymap.v3bindingkey,
   btemplate.bindingkey,
   bservicekeymap.v3servicekey,
   btemplate.servicekey,
   btemplate.accesspoint,
   btemplate.usetype,
   btemplate.hostingredir,
   btemplate.createdate,
   btemplate.changedate,
   btemplate.issigned,
   btemplate.seqnum
from

   ibmudi30.btemplate btemplate
    inner join ibmudi30.btemplatekeymap btemplatekeymap on btemplate.bindingkey = btemplatekeymap.bindingkey 
    inner join ibmudi30.bservicekeymap  bservicekeymap  on btemplate.servicekey = bservicekeymap.servicekey 
GO


----------------------------------------------------------------------------
--
-- Btemplate/"Parent Service"/"Parent Services'Business" Signed version of vbtemplate_v3
--
----------------------------------------------------------------------------
create view ibmudi30.vbtemplate_v3_s (v3bindingkey, bindingkey, v3servicekey, servicekey, accesspoint, usetype, hostingredir, createdate, changedate, issigned, seqnum)
as
select
   vbtemplate_v3.v3bindingkey,
   vbtemplate_v3.bindingkey,
   vbtemplate_v3.v3servicekey,
   vbtemplate_v3.servicekey,
   vbtemplate_v3.accesspoint,
   vbtemplate_v3.usetype,
   vbtemplate_v3.hostingredir,
   vbtemplate_v3.createdate,
   vbtemplate_v3.changedate,
   case
      when vbtemplate_v3.issigned > 0 then 1
      when bservice.issigned > 0 then 1
      when business.issigned > 0 then 1
      else 0
    end
   ,
   vbtemplate_v3.seqnum
from
   ibmudi30.vbtemplate_v3 vbtemplate_v3
    inner join ibmudi30.bservice bservice on ( vbtemplate_v3.servicekey = bservice.servicekey )
    inner join ibmudi30.business business on ( bservice.businesskey = business.businesskey)
GO

create view ibmudi30.vtmodel_v3 (v3tmodelkey, tmodelkey,name, name_nodiacs, name_nocase, name_nc_nd, lang, lang_nocase, owner, operator, createdate, changedate, deletedate, issigned, conditional)
as
select
   tmodelkeymap.v3tmodelkey,
   tmodel.tmodelkey,
   tmodel.name,
   tmodel.name_nodiacs,
   tmodel.name_nocase,
   tmodel.name_nc_nd,
   tmodel.lang,
   tmodel.lang_nocase,
   tmodel.owner,
   tmodel.operator,
   tmodel.createdate,
   tmodel.changedate,
   tmodel.deletedate,
   tmodel.issigned,
   tmodel.conditional
from
   ibmudi30.tmodel tmodel
   
    inner join ibmudi30.tmodelkeymap tmodelkeymap on tmodel.tmodelkey = tmodelkeymap.tmodelkey
GO

------------------------------------------------------------
--
-- Other v3 key to internal key views
--
------------------------------------------------------------
create view ibmudi30.vtminstanceinfo_v3(tminstinfokey, v3idbindingkey, idbindingkey, v3idtmodelkey, idtmodelkey, instanceparms, seqnum)
as
select
   tminstanceinfo.tminstinfokey,
   btemplatekeymap.v3bindingkey,
   tminstanceinfo.idbindingkey,
   tmodelkeymap.v3tmodelkey,
   tminstanceinfo.idtmodelkey,
   tminstanceinfo.instanceparms,
   tminstanceinfo.seqnum
from
   ibmudi30.tminstanceinfo tminstanceinfo
   
    inner join ibmudi30.btemplatekeymap btemplatekeymap on tminstanceinfo.idbindingkey = btemplatekeymap.bindingkey 
    inner join ibmudi30.tmodelkeymap   tmodelkeymap    on tminstanceinfo.idtmodelkey = tmodelkeymap.tmodelkey 
GO

create view ibmudi30.vpubassert_v3(pubassertkey, v3fromkey, fromkey, v3tokey, tokey, v3patmodelkey, patmodelkey,keyname, keyvalue, keyname_nodiacs, keyvalue_nodiacs,keyname_nc_nd, keyvalue_nc_nd,status, createdate, changedate, paseqnum, issigned)
as
select
   pubassert.pubassertkey,
   businesskeymap_fr.v3businesskey,
   pubassert.fromkey,
   businesskeymap_to.v3businesskey,
   pubassert.tokey,
   tmodelkeymap.v3tmodelkey,
   pubassert.patmodelkey,
   pubassert.keyname,
   pubassert.keyvalue,
   pubassert.keyname_nodiacs,
   pubassert.keyvalue_nodiacs,
   pubassert.keyname_nc_nd,
   pubassert.keyvalue_nc_nd,
   pubassert.status,
   pubassert.createdate,
   pubassert.changedate,
   pubassert.paseqnum,
   pubassert.issigned
from
   ibmudi30.pubassert pubassert
   
    inner join ibmudi30.businesskeymap businesskeymap_fr on pubassert.fromkey     = businesskeymap_fr.businesskey 
    inner join ibmudi30.businesskeymap businesskeymap_to on pubassert.tokey       = businesskeymap_to.businesskey 
    inner join ibmudi30.tmodelkeymap   tmodelkeymap  on pubassert.patmodelkey = tmodelkey 
GO

------------------------------------------------------------
--
-- categorybag views
--
------------------------------------------------------------

create view ibmudi30.vbusinesscatbag_v3 (parentkey, v3krtmodelkey, krtmodelkey,keyname, keyvalue, keyname_nodiacs, keyvalue_nodiacs,keyname_nc_nd, keyvalue_nc_nd,krgroupid, v3krgtmodelkey, krgtmodelkey, seqnum)
as
select
   businesscatbag.parentkey,
   tmodelkeymap.v3tmodelkey,
   businesscatbag.krtmodelkey,
   businesscatbag.keyname,
   businesscatbag.keyvalue,
   businesscatbag.keyname_nodiacs,
   businesscatbag.keyvalue_nodiacs,
   businesscatbag.keyname_nc_nd,
   businesscatbag.keyvalue_nc_nd,
   businesscatbag.krgroupid,
   krgtmodelkeymap.v3tmodelkey,
   businesscatbag.krgtmodelkey,
   businesscatbag.seqnum
from
   ibmudi30.businesscatbag businesscatbag
   
    inner      join ibmudi30.tmodelkeymap tmodelkeymap on businesscatbag.krtmodelkey = tmodelkeymap.tmodelkey 
    left outer join ibmudi30.tmodelkeymap krgtmodelkeymap on businesscatbag.krgtmodelkey = krgtmodelkeymap.tmodelkey 
	
GO



create view ibmudi30.vbservicecatbag_v3 (parentkey, v3krtmodelkey, krtmodelkey,keyname, keyvalue, keyname_nodiacs, keyvalue_nodiacs,keyname_nc_nd, keyvalue_nc_nd,krgroupid, v3krgtmodelkey, krgtmodelkey, seqnum)
as
select
   bservicecatbag.parentkey,
   tmodelkeymap.v3tmodelkey,
   bservicecatbag.krtmodelkey,
   bservicecatbag.keyname,
   bservicecatbag.keyvalue,
   bservicecatbag.keyname_nodiacs,
   bservicecatbag.keyvalue_nodiacs,
   bservicecatbag.keyname_nc_nd,
   bservicecatbag.keyvalue_nc_nd,
   bservicecatbag.krgroupid,
   krgtmodelkeymap.v3tmodelkey,
   bservicecatbag.krgtmodelkey,
   bservicecatbag.seqnum
from
   ibmudi30.bservicecatbag bservicecatbag
   
    inner join ibmudi30.tmodelkeymap tmodelkeymap on bservicecatbag.krtmodelkey = tmodelkeymap.tmodelkey 
    left outer join ibmudi30.tmodelkeymap krgtmodelkeymap on bservicecatbag.krgtmodelkey = krgtmodelkeymap.tmodelkey
GO

	
create view ibmudi30.vbtempltcatbag_v3 (parentkey, v3krtmodelkey, krtmodelkey,keyname, keyvalue, keyname_nodiacs, keyvalue_nodiacs,keyname_nc_nd, keyvalue_nc_nd,krgroupid, v3krgtmodelkey, krgtmodelkey, seqnum, servicekey)
as
select
   btemplatecatbag.parentkey,
   tmodelkeymap.v3tmodelkey,
   btemplatecatbag.krtmodelkey,
   btemplatecatbag.keyname,
   btemplatecatbag.keyvalue,
   btemplatecatbag.keyname_nodiacs,
   btemplatecatbag.keyvalue_nodiacs,
   btemplatecatbag.keyname_nc_nd,
   btemplatecatbag.keyvalue_nc_nd,
   btemplatecatbag.krgroupid,
   krgtmodelkeymap.v3tmodelkey,
   btemplatecatbag.krgtmodelkey,
   btemplatecatbag.seqnum,
   btemplate.servicekey
from
   ibmudi30.btemplatecatbag btemplatecatbag
   
    inner      join ibmudi30.tmodelkeymap tmodelkeymap     on btemplatecatbag.krtmodelkey  = tmodelkeymap.tmodelkey 
    inner      join ibmudi30.btemplate    btemplate        on btemplatecatbag.parentkey    = btemplate.bindingkey 
    left outer join ibmudi30.tmodelkeymap krgtmodelkeymap  on btemplatecatbag.krgtmodelkey = krgtmodelkeymap.tmodelkey 
GO


create view ibmudi30.vtmodelcatbag_v3 (parentkey, v3krtmodelkey, krtmodelkey,keyname, keyvalue, keyname_nodiacs, keyvalue_nodiacs,keyname_nc_nd, keyvalue_nc_nd,krgroupid, v3krgtmodelkey, krgtmodelkey, seqnum)
as
select
   tmodelcatbag.parentkey,
   tmodelkeymap.v3tmodelkey,
   tmodelcatbag.krtmodelkey,
   tmodelcatbag.keyname,
   tmodelcatbag.keyvalue,
   tmodelcatbag.keyname_nodiacs,
   tmodelcatbag.keyvalue_nodiacs,
   tmodelcatbag.keyname_nc_nd,
   tmodelcatbag.keyvalue_nc_nd,
   tmodelcatbag.krgroupid,
   krgtmodelkeymap.v3tmodelkey,
   tmodelcatbag.krgtmodelkey,
   tmodelcatbag.seqnum
from

   ibmudi30.tmodelcatbag tmodelcatbag
    inner join ibmudi30.tmodelkeymap tmodelkeymap    on tmodelcatbag.krtmodelkey  = tmodelkeymap.tmodelkey 
    left outer join ibmudi30.tmodelkeymap krgtmodelkeymap on tmodelcatbag.krgtmodelkey = krgtmodelkeymap.tmodelkey 

GO


------------------------------------------------------------
-- Additional CategoryBag views
-- for the "COMBINE CATEGORIES" Find Qualifier
------------------------------------------------------------

-- All CategorBags for Services & Binding Templates
create view ibmudi30.vSVCCmbnCatbag_v3 (cbtype, servicekey, v3krtmodelkey, krtmodelkey,keyname, keyvalue, keyname_nodiacs, keyvalue_nodiacs,keyname_nc_nd, keyvalue_nc_nd,krgroupid, v3krgtmodelkey, krgtmodelkey, seqnum)
as
select
   'service',
   parentkey,
   v3krtmodelkey,
   krtmodelkey,
   keyname,
   keyvalue,
   keyname_nodiacs,
   keyvalue_nodiacs,
   keyname_nc_nd,
   keyvalue_nc_nd,
   krgroupid,
   v3krgtmodelkey,
   krgtmodelkey,
   seqnum
from
   ibmudi30.vbservicecatbag_v3
union
select
   'binding',
   servicekey,
   v3krtmodelkey,
   krtmodelkey,
   keyname,
   keyvalue,
   keyname_nodiacs,
   keyvalue_nodiacs,
   keyname_nc_nd,
   keyvalue_nc_nd,krgroupid,
   v3krgtmodelkey,
   krgtmodelkey,
   seqnum
from
   ibmudi30.vbtempltcatbag_v3
GO

------------------------------------------------------------
--
-- identifierbag views
--
------------------------------------------------------------
create view ibmudi30.vbusinessidbag_v3 (parentkey, seqnum, v3krtmodelkey, krtmodelkey,keyname, keyvalue, keyname_nodiacs, keyvalue_nodiacs,keyname_nc_nd, keyvalue_nc_nd)
as
select
   businessidbag.parentkey,
   businessidbag.seqnum,
   tmodelkeymap.v3tmodelkey,
   businessidbag.krtmodelkey,
   businessidbag.keyname,
   businessidbag.keyvalue,
   businessidbag.keyname_nodiacs,
   businessidbag.keyvalue_nodiacs,
   businessidbag.keyname_nc_nd,
   businessidbag.keyvalue_nc_nd
from
   ibmudi30.businessidbag businessidbag
   
    inner join ibmudi30.tmodelkeymap tmodelkeymap on businessidbag.krtmodelkey = tmodelkeymap.tmodelkey

GO

create view ibmudi30.vtmodelidbag_v3 (parentkey, seqnum, v3krtmodelkey, krtmodelkey,keyname, keyvalue, keyname_nodiacs, keyvalue_nodiacs,keyname_nc_nd, keyvalue_nc_nd)
as
select
   tmodelidbag.parentkey,
   tmodelidbag.seqnum,
   tmodelkeymap.v3tmodelkey,
   tmodelidbag.krtmodelkey,
   tmodelidbag.keyname,
   tmodelidbag.keyvalue,
   tmodelidbag.keyname_nodiacs,
   tmodelidbag.keyvalue_nodiacs,
   tmodelidbag.keyname_nc_nd,
   tmodelidbag.keyvalue_nc_nd
from
   ibmudi30.tmodelidbag tmodelidbag
   
    inner join ibmudi30.tmodelkeymap tmodelkeymap  on tmodelidbag.krtmodelkey = tmodelkeymap.tmodelkey
GO

create view ibmuds30.vactivepolicy (id, activedp, valuetype, booleanvalue, intvalue, stringvalue, namekey, descriptionkey, readonly, required, unitskey, alias, policytype)
as
select
   policy.id,
   policy.activedp,
   valuetype,
   booleanvalue,
   intvalue,
   stringvalue,
   namekey,
   descriptionkey,
   readonly,
   required,
   unitskey,
   alias,
   policy.policytype
from
  ibmuds30.policy policy
    inner join ibmuds30.policyvalue policyvalue on policy.id = policyvalue.id and policy.activedp = policyvalue.pdp
GO


create view ibmuds30.vlimitvalue (limitid, limitvalue, displayorder, tierid)
as
select
   tierlimits.limitid,
   limitvalue,
   displayorder,
   tierid
from
  ibmuds30.tierlimits tierlimits
    inner join ibmuds30.limit limit on limit.limitid = tierlimits.limitid
GO

create view ibmuds30.vusertier(userid, tierid, tiername, tierdesc, sessionkey, sessiondate)
as
select
   uddiuser.userid,
   tier.tierid,
   tier.name,
   tier.description,
   sessionkey,
   sessiondate
from
   ibmuds30.uddiuser uddiuser 
     inner join ibmuds30.tier tier on uddiuser.tierid = tier.tierid
GO

create view ibmuds30.vuserentitlement(userid, entitlementid, allowed, displayorder)
as
select
   userentitlement.userid,
   userentitlement.entitlementid,
   userentitlement.allowed,
   entitlement.displayorder
from
   ibmuds30.userentitlement userentitlement
     inner join ibmuds30.entitlement entitlement on userentitlement.entitlementid = entitlement.entitlementid
GO

create view ibmuds30.vtierincdefault(tierid, name, description, defaulttierid)
as
select
   tier.tierid,
   name,
   description,
   defaulttier.tierid
from
   ibmuds30.tier tier 
     left outer join ibmuds30.defaulttier defaulttier on tier.tierid=defaulttier.tierid
GO

------------------------------------------------------------
--
-- View equates to UDDI20 contact table
--
------------------------------------------------------------
create view ibmudi30.vcontact_v2 (contactkey, businesskey, seqnum, usetype, personname, lang)
as
select
   contact.contactkey,
   contact.businesskey,
   contact.seqnum,
   contact.usetype,
   personname.personname,
   personname.lang
from
   ibmudi30.contact contact
    inner join ibmudi30.personname personname on personname.contactkey = contact.contactkey and personname.seqnum = 1 
GO


------------------------------------------------------------
--
-- Return a timestamp indicating the last time the cache was refreshed!
--
------------------------------------------------------------
create view ibmuds30.vconfigproperty (
   propertyid,
   booleanvalue,
   intvalue,
   stringvalue,
   timestampvalue,
   valuetype,
   namekey,
   descriptionkey,
   readonly,
   required,
   internal,
   unitskey,
   displayorder,
   cacheTimeStamp
)as
select
   configproperty.propertyid,
   configproperty.booleanvalue,
   configproperty.intvalue,
   configproperty.stringvalue,
   configproperty.timestampvalue,
   configproperty.valuetype,
   configproperty.namekey,
   configproperty.descriptionkey,
   configproperty.readonly,
   configproperty.required,
   configproperty.internal,
   configproperty.unitskey,
   configproperty.displayorder,
   cachetimestampcp.timestampvalue
from
   ibmuds30.configproperty configproperty
    left outer join ibmuds30.configproperty cachetimestampcp on cachetimestampcp.propertyid = 'cacheRefreshedTimeStamp' 
GO

------------------------------------------------------------
--
-- operationalinfo view
--
-- The column "modifiedchildvalid" is a means to determine
-- whether the "modifiedchild" column REALLY IS "modifiedchild"
-- or "current timestamp".
--
-- The column tmodelHidden = 0 for any row OTHER THAN a
-- tmodel with a non-null DELETEDATE
--
------------------------------------------------------------

create view ibmudi30.voperatnlinfo_v3
(type, internalkey, v3key, owner, operator, createdate, changedate, modifiedchild, modifiedchildvalid, tmodelHidden)
as
select
   'business',
   business.businesskey,
   businesskeymap.v3businesskey,
   business.owner,
   business.operator,
   business.createdate,
   business.changedate,
   business.modifiedchild,
   1,
   0
from
  ibmudi30.business business
   inner join ibmudi30.businesskeymap businesskeymap on business.businesskey = businesskeymap.businesskey
union
select
   'service',
   bservice.servicekey,
   bservicekeymap.v3servicekey,
   business.owner,
   business.operator,
   bservice.createdate,
   bservice.changedate,
   bservice.modifiedchild,
   1,
   0
from
  ibmudi30.bservice bservice
    inner join ibmudi30.bservicekeymap bservicekeymap on bservice.servicekey  = bservicekeymap.servicekey
    inner join ibmudi30.business       business       on bservice.businesskey = business.businesskey
union
select
   'bindingtemplate',
   btemplate.bindingkey,
   btemplatekeymap.v3bindingkey,
   business.owner,
   business.operator,
   btemplate.createdate,
   btemplate.changedate,
   GETDATE(),
   0,
   0
from
  ibmudi30.btemplate btemplate
    inner join ibmudi30.btemplatekeymap btemplatekeymap on  btemplate.bindingkey = btemplatekeymap.bindingkey 
    inner join ibmudi30.bservice        bservice        on  btemplate.servicekey = bservice.servicekey 
    inner join ibmudi30.business        business        on  bservice.businesskey = business.businesskey 
union
select
   'tmodel',
   tmodel.tmodelkey,
   tmodelkeymap.v3tmodelkey,
   tmodel.owner,
   tmodel.operator,
   tmodel.createdate,
   tmodel.changedate,
   GETDATE(),
   0,
   (CASE WHEN deletedate IS NULL THEN 0 ELSE 1 END)
from
  ibmudi30.tmodel tmodel
    inner join ibmudi30.tmodelkeymap tmodelkeymap on tmodel.tmodelkey = tmodelkeymap.tmodelkey
where
  tmodel.conditional is null

GO



