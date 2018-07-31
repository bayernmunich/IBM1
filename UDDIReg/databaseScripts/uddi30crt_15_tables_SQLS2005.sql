-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_20_tables_SQLS2005.sql,UDDI.v3persistence, WASX.UDDI, o0643.37
-- Version:                   1.1
-- Last-changed:              07/06/20 10:43:20
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


USE UDDI30;

create table ibmuds30.uddidbschemaver(
    schemaver       nvarchar(50)      not null
);

create table ibmudi30.businesskeymap(
    businesskey     nchar(36)         not null,
    v3businesskey   nvarchar(255)     not null,
    isorphaned      smallint         default 0 not null
);

create table ibmudi30.business(
    businesskey      nchar(36)        not null,
	name            nvarchar(765),
    name_nocase      nvarchar(765),
    owner            nvarchar(765),
    operator         nvarchar(765),
    createdate       datetime       not null, -- changed from timestamp
    changedate       datetime       not null, -- changed from timestamp
    modifiedchild    datetime       not null, -- changed from timestamp
    issigned         SMALLINT        default 0 not null
);

create table ibmudi30.businessname(
    parentkey       nchar(36)        not null,
    seqnum          integer         not null,
    lang            nvarchar(26),
    lang_nocase     nvarchar(26),
    name            nvarchar(765)    not null,
    name_nodiacs    nvarchar(765)    not null,
    name_nocase     nvarchar(765)    not null,
    name_nc_nd      nvarchar(765)    not null
);

create table ibmudi30.contact(
    contactkey      nchar(36)        not null,
    businesskey     nchar(36)        not null,
    seqnum          integer         not null,
    usetype         nvarchar(765)
);

create table ibmudi30.contactdescr(
    parentkey      nchar(36)        not null,
    seqnum         integer         not null,
    description    nvarchar(765)    not null,
    lang           nvarchar(26)
);

create table ibmudi30.personname(
    contactkey     nchar(36)        not null,
    seqnum         integer         not null,
    personname     nvarchar(765)    not null,
    lang           nvarchar(26)
);

create table ibmudi30.email(
    contactkey     nchar(36)        not null,
    seqnum         integer         not null,
    emailaddr      nvarchar(765)    not null,
    usetype        nvarchar(765)
);

create table ibmudi30.phone(
    contactkey     nchar(36)        not null,
    seqnum         integer         not null,
    phone          nvarchar(765)    not null,
    usetype        nvarchar(765)
);

create table ibmudi30.address(
    addresskey     nchar(36)        not null,
    contactkey     nchar(36)        not null,
    seqnum         integer         not null,
    adtmodelkey    nchar(36),
    sortcode       nvarchar(30),
    lang           nvarchar(26),
    usetype        nvarchar(765)
);

create table ibmudi30.addrline(
    addresskey    nchar(36)        not null,
    seqnum        integer         not null,
    keyname       nvarchar(765),
    keyvalue      nvarchar(765),
    addressline   nvarchar(240)    not null
);

create table ibmudi30.businessdescr(
    parentkey       nchar(36)        not null,
    seqnum          integer         not null,
    description     nvarchar(765)    not null,
    lang            nvarchar(26)
);

create table ibmudi30.businesscatbag(
    parentkey         nchar(36)        not null,
    krtmodelkey       nchar(36)        not null,
    keyname           nvarchar(765),
    keyvalue          nvarchar(765)    not null,
    keyname_nodiacs   nvarchar(765),
    keyvalue_nodiacs  nvarchar(765)    not null,
    keyname_nc_nd     nvarchar(765),
    keyvalue_nc_nd    nvarchar(765)    not null,
    krgroupid         integer         not null,
    krgtmodelkey      nchar(36),
    seqnum            integer         not null,
    keyvalue_intkey   nchar(36),
    keyvalue_v2result nchar(41)
);

create table ibmudi30.businessidbag(
    parentkey        nchar(36)        not null,
    seqnum           integer         not null,
    krtmodelkey      nchar(36)        not null,
    keyname          nvarchar(765),
    keyvalue         nvarchar(765)    not null,
    keyname_nodiacs  nvarchar(765),
    keyvalue_nodiacs nvarchar(765)    not null,
    keyname_nc_nd    nvarchar(765),
    keyvalue_nc_nd   nvarchar(765)    not null,
    keyvalue_intkey   nchar(36),
    keyvalue_v2result nchar(41)
);

create table ibmudi30.bservicekeymap(
    servicekey       nchar(36)        not null,
    v3servicekey     nvarchar(255)    not null,
    isorphaned       smallint        default 0 not null
);

create table ibmudi30.bservice(
    servicekey       nchar(36)        not null,
    businesskey      nchar(36)        not null,
    name             nvarchar(765),
    name_nocase      nvarchar(765),
    createdate       datetime       not null, 
    changedate       datetime       not null, 
    modifiedchild    datetime       not null, 
    issigned         smallint        default 0 not null
);

create table ibmudi30.bservicename(
    parentkey      nchar(36)        not null,
    seqnum         integer         not null,
    lang           nvarchar(26),
    lang_nocase    nvarchar(26),
    name           nvarchar(765)    not null,
    name_nodiacs   nvarchar(765)    not null,
    name_nocase    nvarchar(765)    not null,
    name_nc_nd     nvarchar(765)    not null
);

create table ibmudi30.bservicecatbag(
    parentkey         nchar(36)     not null,
    krtmodelkey       nchar(36)     not null,
    keyname           nvarchar(765),
    keyvalue          nvarchar(765) not null,
    keyname_nodiacs   nvarchar(765),
    keyvalue_nodiacs  nvarchar(765) not null,
    keyname_nc_nd     nvarchar(765),
    keyvalue_nc_nd    nvarchar(765) not null,
    krgroupid         integer      not null,
    krgtmodelkey      nchar(36),
    seqnum            integer      not null,
    keyvalue_intkey   nchar(36),
    keyvalue_v2result nchar(41)
);

create table ibmudi30.busallservice(
    businesskey       nchar(36)     not null,
    seqnum            integer      not null,
    servicekey        nchar(36)     not null,
    owningbusinesskey nchar(36)     not null
);

create table ibmudi30.bservicedescr(
    parentkey      nchar(36)        not null,
    seqnum         integer         not null,
    description    nvarchar(765)    not null,
    lang           nvarchar(26)
);


create table ibmudi30.btemplatekeymap(
    bindingkey     nchar(36)          not null,
    v3bindingkey   nvarchar(255)      not null
);

create table ibmudi30.btemplatedescr(
    parentkey      nchar(36)        not null,
    seqnum         integer         not null,
    description    nvarchar(765)    not null,
    lang           nvarchar(26)
);

create table ibmudi30.btemplatecatbag(
    parentkey        nchar(36)        not null,
    krtmodelkey      nchar(36)        not null,
    keyname          nvarchar(765),
    keyvalue         nvarchar(765)    not null,
    keyname_nodiacs  nvarchar(765),
    keyvalue_nodiacs nvarchar(765)    not null,
    keyname_nc_nd    nvarchar(765),
    keyvalue_nc_nd   nvarchar(765)    not null,
    krgroupid        integer         not null,
    krgtmodelkey     nchar(36),
    seqnum           integer         not null,
    keyvalue_intkey   nchar(36),
    keyvalue_v2result nchar(41)
);

create table ibmudi30.insdtldescr(
    parentkey         nchar(36)        not null,
    seqnum            integer         not null,
    description       nvarchar(765)    not null,
    lang              nvarchar(26)
);

create table ibmudi30.tminfodescr(
    parentkey      nchar(36)        not null,
    seqnum         integer         not null,
    description    nvarchar(765)    not null,
    lang           nvarchar(26)
);

create table ibmudi30.idoviewdocdescr(
    parentkey             nchar(36)        not null,
    seqnum                integer         not null,
    description           nvarchar(765)    not null,
    lang                  nvarchar(26)
);

create table ibmudi30.tmodeldescr(
    parentkey      nchar(36)        not null,
    seqnum         integer         not null,
    description    nvarchar(765)    not null,
    lang           nvarchar(26)
);

create table ibmudi30.tmodelcatbag(
    parentkey        nchar(36)        not null,
    krtmodelkey      nchar(36)        not null,
    keyname          nvarchar(765),
    keyvalue         nvarchar(765)    not null,
    keyname_nodiacs  nvarchar(765),
    keyvalue_nodiacs nvarchar(765)    not null,
    keyname_nc_nd    nvarchar(765),
    keyvalue_nc_nd   nvarchar(765)    not null,
    krgroupid        integer         not null,
    krgtmodelkey     nchar(36),
    seqnum           integer         not null,
    keyvalue_intkey   nchar(36),
    keyvalue_v2result nchar(41)
);

create table ibmudi30.tmodelovwdocdescr(
    parentkey             nchar(36)        not null,
    seqnum                integer         not null,
    description           nvarchar(765)    not null,
    lang                  nvarchar(26)
);

create table ibmudi30.tmodelidbag(
    parentkey        nchar(36)        not null,
    seqnum           integer         not null,
    krtmodelkey      nchar(36)        not null,
    keyname          nvarchar(765),
    keyvalue         nvarchar(765)    not null,
    keyname_nodiacs  nvarchar(765),
    keyvalue_nodiacs nvarchar(765)    not null,
    keyname_nc_nd    nvarchar(765),
    keyvalue_nc_nd   nvarchar(765)    not null,
    keyvalue_intkey   nchar(36),
    keyvalue_v2result nchar(41)
);


create table ibmudi30.pubassert(
    pubassertkey     nchar(36)        not null,
    fromkey          nchar(36)        not null,
    tokey            nchar(36)        not null,
    patmodelkey      nchar(36)        not null,
    keyname          nvarchar(765),
    keyvalue         nvarchar(765)    not null,
    keyname_nodiacs  nvarchar(765),
    keyvalue_nodiacs nvarchar(765)    not null,
    keyname_nocase   nvarchar(765),
    keyvalue_nocase  nvarchar(765),
    keyname_nc_nd    nvarchar(765),
    keyvalue_nc_nd   nvarchar(765),
    status           nvarchar(18),
    createdate       datetime       not null, 
    changedate       datetime       not null, 
    paseqnum         integer         not null,
    issigned         smallint        default 0 not null
);

create table ibmudi30.valueset(
    tmodelkey        nchar(36)      not null,
    keyvalue         nvarchar(765)  not null,
    keyname          nvarchar(765),
    parentkeyvalue   nvarchar(765)
);


create table ibmudi30.transfertoken(
    opaquetoken      nchar(36)       not null,
    authorizedname   nvarchar(765)   not null,
    expirationtime   datetime       not null 
);

create table ibmudi30.transferkey(
    opaquetoken      nchar(36)       not null,
    entitykey        nvarchar(765)   not null
);


create table ibmuds30.uddiuser (
    userid          nvarchar(93)    not null,
    uniqueuserid    nvarchar(1536)  not null,
    tierid          integer        not null,
    sessionkey      nchar(36),
    sessiondate     datetime 
);



create table ibmuds30.policy(
    id                     integer      not null,
    activedp               nvarchar(8)   not null,
    valuetype              nvarchar(255) not null,
    policytype             nvarchar(63),
    alias                  nvarchar(63),
    namekey                nvarchar(255) not null,
    descriptionkey         nvarchar(255) not null,
    readonly               smallint,
    required               smallint,
    unitskey               nvarchar(63)
);


create table ibmuds30.policyvalue(
    id                     integer      not null,
    pdp                    nvarchar(8)   not null,
    booleanvalue           smallint,
    intvalue               integer,
    stringvalue            nvarchar(255)
);

create table ibmuds30.policygroup(
    groupid               integer      not null,
    policyid              integer      not null
);

create table ibmuds30.policygroupdetail(
    id                     integer      not null,
    namekey                nvarchar(255) not null,
    descriptionkey         nvarchar(255) not null
);


create table ibmuds30.configproperty(
    propertyid             nvarchar(127) not null,
    booleanvalue           smallint,
    intvalue               integer,
    stringvalue            nvarchar(255),
    timestampvalue         datetime, 
    valuetype              nvarchar(255) not null,
    namekey                nvarchar(255) not null,
    descriptionkey         nvarchar(255) not null,
    readonly               smallint,
    required               smallint,
    internal               smallint,
    unitskey               nvarchar(63),
    displayorder           integer
);


create table ibmuds30.tierlimits (
    tierid          integer        not null,
    limitid         nvarchar(15)    not null,
    limitvalue      integer        not null
);

create table ibmuds30.tier(
    tierid          integer        not null,
    name            nvarchar(255)   not null,
    description     nvarchar(765)
);

create table ibmuds30.defaulttier(
    tierid          integer        not null
);

create table ibmuds30.limit(
    limitid          nvarchar(15)   not null,
    displayorder     integer       not null
);

create table ibmuds30.entitlement(
    entitlementid    nvarchar(32)   not null,
    displayorder     integer       not null
);

create table ibmuds30.userentitlement (
    userid           nvarchar(93)   not null,
    entitlementid    nvarchar(32)   not null,
    allowed          smallint      not null
);


create table ibmuds30.vss_policyadmin(
    tmodelkey          nchar(36)     not null,
    name               nvarchar(255) not null,
    supported          smallint     not null,
    checked            smallint     not null,
    cached             smallint     not null,
    externalcacheable  smallint,
    externallyvalidate smallint,
    datelastcached     datetime , 
    unvalidatable      smallint
);


USE UDDI30

create table ibmudi30.discoveryurl(
    dubusinesskey     nchar(36)          not null,
    seqnum            integer           not null,
    url               nvarchar(4000)    not null,
    usetype    	    nvarchar(4000)
);

create table ibmudi30.btemplate(
    bindingkey        nchar(36)        not null,
    servicekey        nchar(36)        not null,
    accesspoint       ntext,
    usetype           nvarchar(765),
    hostingredir      nvarchar(255),
    createdate        datetime       not null,
    changedate        datetime       not null,
    issigned          smallint        default 0 not null,
    seqnum            integer         not null
);

create table ibmudi30.tminstanceinfo(
    tminstinfokey     nchar(36)          not null,
    idbindingkey      nchar(36)          not null,
    idtmodelkey       nchar(36)          not null,
    instanceparms     ntext,
    seqnum            integer           not null
);

create table ibmudi30.idoviewdoc(
    idoviewdockey     nchar(36)          not null,
    parentkey         nchar(36)          not null,
    seqnum            integer           not null,
    overviewurl       ntext,
    usetype           nvarchar(765)
);

create table ibmudi30.conditionallog(
    localusn          bigint       not null,
    nodeid            nvarchar(255) not null,
    ackusn            bigint
);

create table ibmudi30.tmodelkeymap(
    tmodelkey         nchar(36)           not null,
    v3tmodelkey       nvarchar(255)       not null,
    conditional       bigint
);

create table ibmudi30.tmodel(
    tmodelkey         nchar(36)        not null,
    lang              nvarchar(26),
    lang_nocase       nvarchar(26),
	name              nvarchar(765),
    name_nodiacs      nvarchar(765),
    name_nocase       nvarchar(765),
    name_nc_nd        nvarchar(765),
    owner             nvarchar(765),
    operator          nvarchar(765),
    createdate        datetime       not null,
    changedate        datetime       not null,
    deletedate        datetime,
    issigned          smallint        default  0 not null,
    conditional       bigint
);

create table ibmudi30.tmodeloviewdoc(
    tmoviewdockey     nchar(36)          not null,
    parentkey         nchar(36)          not null,
    seqnum            integer           not null,
    overviewurl       ntext,
    usetype           nvarchar(765)
);

create table ibmudi30.businesssig(
    parentkey         nchar(36)       not null,
    seqnum            integer        not null,
    signature         ntext   		not null
);

create table ibmudi30.bservicesig(
    parentkey         nchar(36)       not null,
    seqnum            integer        not null,
    signature         ntext		   not null
);

create table ibmudi30.btemplatesig(
    parentkey         nchar(36)       not null,
    seqnum            integer        not null,
    signature         ntext			not null
);

create table ibmudi30.tmodelsig(
    parentkey         nchar(36)       not null,
    seqnum            integer        not null,
    signature         ntext		   	not null
);

create table ibmudi30.pubassertsig(
    parentkey         nchar(36)       not null,
    seqnum            integer        not null,
    fromsig           smallint       not null,
    tosig             smallint       not null,
    signature         ntext		   not null
);


create table ibmudi30.replaudit(
    localusn          bigint       not null,
    nodeid            varchar(255) not null,
    globalusn         bigint       not null,
    apiname           varchar(32),
    replmessagename   varchar(32),
    acknowledgement   smallint,
    owner             varchar(765),
    created           datetime,
    modified          datetime,
    modifiedchild     datetime,
    correction        bigint,
    message           ntext
);
GO

-- Apply Permissions
--

grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.address to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.addrline to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.bservice to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.bservicecatbag to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.bservicedescr to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.bservicekeymap to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.bservicename to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.bservicesig to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.btemplate to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.btemplatecatbag to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.btemplatedescr to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.btemplatekeymap to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.btemplatesig to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.busallservice to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.business to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.businesscatbag to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.businessdescr to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.businessidbag to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.businesskeymap to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.businessname to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.businesssig to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.conditionallog to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.contact to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.contactdescr to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.discoveryurl to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.email to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.idoviewdoc to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.idoviewdocdescr to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.insdtldescr to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.personname to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.phone to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.pubassert to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.pubassertsig to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.replaudit to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.tminfodescr to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.tminstanceinfo to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.tmodel to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.tmodelcatbag to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.tmodeldescr to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.tmodelidbag to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.tmodelkeymap to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.tmodeloviewdoc to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.tmodelovwdocdescr to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.tmodelsig to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.transferkey to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.transfertoken to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmudi30.valueset to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.configproperty to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.defaulttier to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.entitlement to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.limit to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.policy to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.policygroup to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.policygroupdetail to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.policyvalue to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.tier to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.tierlimits to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.uddidbschemaver to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.uddiuser to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.userentitlement to IBMUDDI;
grant SELECT, INSERT, DELETE, UPDATE on ibmuds30.vss_policyadmin to IBMUDDI;

-- Change collation of columns to allow case sensitive comparisons by default
ALTER TABLE ibmudi30.business ALTER COLUMN name nvarchar(765) COLLATE SQL_Latin1_General_CP1_CS_AS 

ALTER TABLE ibmudi30.businessname ALTER COLUMN name nvarchar(765) COLLATE SQL_Latin1_General_CP1_CS_AS not null

ALTER TABLE ibmudi30.businesscatbag ALTER COLUMN keyname nvarchar(765) COLLATE SQL_Latin1_General_CP1_CS_AS 

ALTER TABLE ibmudi30.businessidbag ALTER COLUMN keyname nvarchar(765) COLLATE SQL_Latin1_General_CP1_CS_AS 

ALTER TABLE ibmudi30.bservice ALTER COLUMN name nvarchar(765) COLLATE SQL_Latin1_General_CP1_CS_AS 

ALTER TABLE ibmudi30.bservicename ALTER COLUMN name nvarchar(765) COLLATE SQL_Latin1_General_CP1_CS_AS not null

ALTER TABLE ibmudi30.bservicecatbag ALTER COLUMN keyname nvarchar(765) COLLATE SQL_Latin1_General_CP1_CS_AS 

ALTER TABLE ibmudi30.btemplatecatbag ALTER COLUMN keyname nvarchar(765) COLLATE SQL_Latin1_General_CP1_CS_AS 

ALTER TABLE ibmudi30.tmodelcatbag ALTER COLUMN keyname nvarchar(765) COLLATE SQL_Latin1_General_CP1_CS_AS

ALTER TABLE ibmudi30.tmodelidbag ALTER COLUMN keyname nvarchar(765) COLLATE SQL_Latin1_General_CP1_CS_AS 

ALTER TABLE ibmudi30.pubassert ALTER COLUMN keyname nvarchar(765) COLLATE SQL_Latin1_General_CP1_CS_AS 

ALTER TABLE ibmudi30.tmodel ALTER COLUMN name nvarchar(765) COLLATE SQL_Latin1_General_CP1_CS_AS 

GO
