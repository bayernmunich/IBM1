-- Path, Component, Release:  src/database/uddi30crt_20_tables_generic.sql, v3persistence, dev
-- Version:                   1.22
-- Last-changed:              05/05/06 15:20:28
--
-- @start_source_copyright@
-- Licensed Materials - Property of IBM
--
-- 5724i63, 5724H88
--
-- (C) COPYRIGHT IBM Corp., 2004 All Rights Reserved
--
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-- @end_source_copyright@
--

create table ibmuds30.uddidbschemaver(
    schemaver       varchar(50)      not null
);

create table ibmudi30.businesskeymap(
    businesskey     char(36)         not null,
    v3businesskey   varchar(255)     not null,
    isorphaned      smallint         default 0 not null
);

create table ibmudi30.business(
    businesskey      char(36)        not null,
    name             varchar(765),
    name_nocase      varchar(765),
    owner            varchar(765),
    operator         varchar(765),
    createdate       timestamp       not null,
    changedate       timestamp       not null,
    modifiedchild    timestamp       not null,
    issigned         SMALLINT        default 0 not null
);

create table ibmudi30.businessname(
    parentkey       char(36)        not null,
    seqnum          integer         not null,
    lang            varchar(26),
    lang_nocase     varchar(26),
    name            varchar(765)    not null,
    name_nodiacs    varchar(765)    not null,
    name_nocase     varchar(765)    not null,
    name_nc_nd      varchar(765)    not null
);

create table ibmudi30.contact(
    contactkey      char(36)        not null,
    businesskey     char(36)        not null,
    seqnum          integer         not null,
    usetype         varchar(765)
);

create table ibmudi30.contactdescr(
    parentkey      char(36)        not null,
    seqnum         integer         not null,
    description    varchar(765)    not null,
    lang           varchar(26)
);

create table ibmudi30.personname(
    contactkey     char(36)        not null,
    seqnum         integer         not null,
    personname     varchar(765)    not null,
    lang           varchar(26)
);

create table ibmudi30.email(
    contactkey     char(36)        not null,
    seqnum         integer         not null,
    emailaddr      varchar(765)    not null,
    usetype        varchar(765)
);

create table ibmudi30.phone(
    contactkey     char(36)        not null,
    seqnum         integer         not null,
    phone          varchar(765)    not null,
    usetype        varchar(765)
);

create table ibmudi30.address(
    addresskey     char(36)        not null,
    contactkey     char(36)        not null,
    seqnum         integer         not null,
    adtmodelkey    char(36),
    sortcode       varchar(30),
    lang           varchar(26),
    usetype        varchar(765)
);

create table ibmudi30.addrline(
    addresskey    char(36)        not null,
    seqnum        integer         not null,
    keyname       varchar(765),
    keyvalue      varchar(765),
    addressline   varchar(240)    not null
);

create table ibmudi30.businessdescr(
    parentkey       char(36)        not null,
    seqnum          integer         not null,
    description     varchar(765)    not null,
    lang            varchar(26)
);

create table ibmudi30.businesscatbag(
    parentkey         char(36)        not null,
    krtmodelkey       char(36)        not null,
    keyname           varchar(765),
    keyvalue          varchar(765)    not null,
    keyname_nodiacs   varchar(765),
    keyvalue_nodiacs  varchar(765)    not null,
    keyname_nc_nd     varchar(765),
    keyvalue_nc_nd    varchar(765)    not null,
    krgroupid         integer         not null,
    krgtmodelkey      char(36),
    seqnum            integer         not null,
    keyvalue_intkey   char(36),
    keyvalue_v2result char(41)
);

create table ibmudi30.businessidbag(
    parentkey        char(36)        not null,
    seqnum           integer         not null,
    krtmodelkey      char(36)        not null,
    keyname          varchar(765),
    keyvalue         varchar(765)    not null,
    keyname_nodiacs  varchar(765),
    keyvalue_nodiacs varchar(765)    not null,
    keyname_nc_nd    varchar(765),
    keyvalue_nc_nd   varchar(765)    not null,
    keyvalue_intkey   char(36),
    keyvalue_v2result char(41)
);

create table ibmudi30.bservicekeymap(
    servicekey       char(36)        not null,
    v3servicekey     varchar(255)    not null,
    isorphaned       smallint        default 0 not null
);

create table ibmudi30.bservice(
    servicekey       char(36)        not null,
    businesskey      char(36)        not null,
    name             varchar(765),
    name_nocase      varchar(765),
    createdate       timestamp       not null,
    changedate       timestamp       not null,
    modifiedchild    timestamp       not null,
    issigned         smallint        default 0 not null
);

create table ibmudi30.bservicename(
    parentkey      char(36)        not null,
    seqnum         integer         not null,
    lang           varchar(26),
    lang_nocase    varchar(26),
    name           varchar(765)    not null,
    name_nodiacs   varchar(765)    not null,
    name_nocase    varchar(765)    not null,
    name_nc_nd     varchar(765)    not null
);

create table ibmudi30.bservicecatbag(
    parentkey         char(36)     not null,
    krtmodelkey       char(36)     not null,
    keyname           varchar(765),
    keyvalue          varchar(765) not null,
    keyname_nodiacs   varchar(765),
    keyvalue_nodiacs  varchar(765) not null,
    keyname_nc_nd     varchar(765),
    keyvalue_nc_nd    varchar(765) not null,
    krgroupid         integer      not null,
    krgtmodelkey      char(36),
    seqnum            integer      not null,
    keyvalue_intkey   char(36),
    keyvalue_v2result char(41)
);

create table ibmudi30.busallservice(
    businesskey       char(36)     not null,
    seqnum            integer      not null,
    servicekey        char(36)     not null,
    owningbusinesskey char(36)     not null
);

create table ibmudi30.bservicedescr(
    parentkey      char(36)        not null,
    seqnum         integer         not null,
    description    varchar(765)    not null,
    lang           varchar(26)
);


create table ibmudi30.btemplatekeymap(
    bindingkey     char(36)          not null,
    v3bindingkey   varchar(255)      not null
);

create table ibmudi30.btemplatedescr(
    parentkey      char(36)        not null,
    seqnum         integer         not null,
    description    varchar(765)    not null,
    lang           varchar(26)
);

create table ibmudi30.btemplatecatbag(
    parentkey        char(36)        not null,
    krtmodelkey      char(36)        not null,
    keyname          varchar(765),
    keyvalue         varchar(765)    not null,
    keyname_nodiacs  varchar(765),
    keyvalue_nodiacs varchar(765)    not null,
    keyname_nc_nd    varchar(765),
    keyvalue_nc_nd   varchar(765)    not null,
    krgroupid        integer         not null,
    krgtmodelkey     char(36),
    seqnum           integer         not null,
    keyvalue_intkey   char(36),
    keyvalue_v2result char(41)
);

create table ibmudi30.insdtldescr(
    parentkey         char(36)        not null,
    seqnum            integer         not null,
    description       varchar(765)    not null,
    lang              varchar(26)
);

create table ibmudi30.tminfodescr(
    parentkey      char(36)        not null,
    seqnum         integer         not null,
    description    varchar(765)    not null,
    lang           varchar(26)
);

create table ibmudi30.idoviewdocdescr(
    parentkey             char(36)        not null,
    seqnum                integer         not null,
    description           varchar(765)    not null,
    lang                  varchar(26)
);

create table ibmudi30.tmodeldescr(
    parentkey      char(36)        not null,
    seqnum         integer         not null,
    description    varchar(765)    not null,
    lang           varchar(26)
);

create table ibmudi30.tmodelcatbag(
    parentkey        char(36)        not null,
    krtmodelkey      char(36)        not null,
    keyname          varchar(765),
    keyvalue         varchar(765)    not null,
    keyname_nodiacs  varchar(765),
    keyvalue_nodiacs varchar(765)    not null,
    keyname_nc_nd    varchar(765),
    keyvalue_nc_nd   varchar(765)    not null,
    krgroupid        integer         not null,
    krgtmodelkey     char(36),
    seqnum           integer         not null,
    keyvalue_intkey   char(36),
    keyvalue_v2result char(41)
);

create table ibmudi30.tmodelovwdocdescr(
    parentkey             char(36)        not null,
    seqnum                integer         not null,
    description           varchar(765)    not null,
    lang                  varchar(26)
);

create table ibmudi30.tmodelidbag(
    parentkey        char(36)        not null,
    seqnum           integer         not null,
    krtmodelkey      char(36)        not null,
    keyname          varchar(765),
    keyvalue         varchar(765)    not null,
    keyname_nodiacs  varchar(765),
    keyvalue_nodiacs varchar(765)    not null,
    keyname_nc_nd    varchar(765),
    keyvalue_nc_nd   varchar(765)    not null,
    keyvalue_intkey   char(36),
    keyvalue_v2result char(41)
);


create table ibmudi30.pubassert(
    pubassertkey     char(36)        not null,
    fromkey          char(36)        not null,
    tokey            char(36)        not null,
    patmodelkey      char(36)        not null,
    keyname          varchar(765),
    keyvalue         varchar(765)    not null,
    keyname_nodiacs  varchar(765),
    keyvalue_nodiacs varchar(765)    not null,
    keyname_nocase   varchar(765),
    keyvalue_nocase  varchar(765),
    keyname_nc_nd    varchar(765),
    keyvalue_nc_nd   varchar(765),
    status           varchar(18),
    createdate       timestamp       not null,
    changedate       timestamp       not null,
    paseqnum         integer         not null,
    issigned         smallint        default 0 not null
);

create table ibmudi30.valueset(
    tmodelkey        char(36)      not null,
    keyvalue         varchar(765)  not null,
    keyname          varchar(765),
    parentkeyvalue   varchar(765)
);


create table ibmudi30.transfertoken(
    opaquetoken      char(36)       not null,
    authorizedname   varchar(765)   not null,
    expirationtime   timestamp      not null
);

create table ibmudi30.transferkey(
    opaquetoken      char(36)       not null,
    entitykey        varchar(765)   not null
);


create table ibmuds30.uddiuser (
    userid          varchar(93)    not null,
    uniqueuserid    varchar(1536)  not null,
    tierid          integer        not null,
    sessionkey      char(36),
    sessiondate     timestamp
);



create table ibmuds30.policy(
    id                     integer      not null,
    activedp               varchar(8)   not null,
    valuetype              varchar(255) not null,
    policytype             varchar(63),
    alias                  varchar(63),
    namekey                varchar(255) not null,
    descriptionkey         varchar(255) not null,
    readonly               smallint,
    required               smallint,
    unitskey               varchar(63)
);


create table ibmuds30.policyvalue(
    id                     integer      not null,
    pdp                    varchar(8)   not null,
    booleanvalue           smallint,
    intvalue               integer,
    stringvalue            varchar(255)
);

create table ibmuds30.policygroup(
    groupid               integer      not null,
    policyid              integer      not null
);

create table ibmuds30.policygroupdetail(
    id                     integer      not null,
    namekey                varchar(255) not null,
    descriptionkey         varchar(255) not null
);


create table ibmuds30.configproperty(
    propertyid             varchar(127) not null,
    booleanvalue           smallint,
    intvalue               integer,
    stringvalue            varchar(255),
    timestampvalue         timestamp,
    valuetype              varchar(255) not null,
    namekey                varchar(255) not null,
    descriptionkey         varchar(255) not null,
    readonly               smallint,
    required               smallint,
    internal               smallint,
    unitskey               varchar(63),
    displayorder           integer
);


create table ibmuds30.tierlimits (
    tierid          integer        not null,
    limitid         varchar(15)    not null,
    limitvalue      integer        not null
);

create table ibmuds30.tier(
    tierid          integer        not null,
    name            varchar(255)   not null,
    description     varchar(765)
);

create table ibmuds30.defaulttier(
    tierid          integer        not null
);

create table ibmuds30.limit(
    limitid          varchar(15)   not null,
    displayorder     integer       not null
);

create table ibmuds30.entitlement(
    entitlementid    varchar(32)   not null,
    displayorder     integer       not null
);

create table ibmuds30.userentitlement (
    userid           varchar(93)   not null,
    entitlementid    varchar(32)   not null,
    allowed          smallint      not null
);


create table ibmuds30.vss_policyadmin(
    tmodelkey          char(36)     not null,
    name               varchar(255) not null,
    supported          smallint     not null,
    checked            smallint     not null,
    cached             smallint     not null,
    externalcacheable  smallint,
    externallyvalidate smallint,
    datelastcached     timestamp,
    unvalidatable      smallint
);
