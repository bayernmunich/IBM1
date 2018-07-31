-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_25_tables_oracle_pre10g.sql, UDDI, WAS855.UDDI, cf131750.05
-- Version:                   1.3
-- Last-changed:              06/01/24 09:03:33
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

create table ibmudi30.discoveryurl(
    dubusinesskey     char(36)          not null,
    seqnum            integer           not null,
    url               varchar2(4000)    not null,
    usetype           varchar2(765)
);

create table ibmudi30.btemplate(
    bindingkey        char(36)          not null,
    servicekey        char(36)          not null,
    accesspoint       varchar2(4000),
    usetype           varchar2(765),
    hostingredir      varchar2(255),
    createdate        timestamp         not null,
    changedate        timestamp         not null,
    issigned          smallint          default 0 not null,
    seqnum            integer           not null
);

create table ibmudi30.tminstanceinfo(
    tminstinfokey     char(36)          not null,
    idbindingkey      char(36)          not null,
    idtmodelkey       char(36)          not null,
    instanceparms     varchar2(4000),
    seqnum            integer           not null
);

create table ibmudi30.idoviewdoc(
    idoviewdockey     char(36)          not null,
    parentkey         char(36)          not null,
    seqnum            integer           not null,
    overviewurl       varchar2(4000),
    usetype           varchar2(765)
);

create table ibmudi30.conditionallog(
    localusn          number(38) not null,
    nodeid            varchar2(255) not null,
    ackusn            number(38)
);

create table ibmudi30.tmodelkeymap(
    tmodelkey         char(36)          not null,
    v3tmodelkey       varchar2(255)     not null,
    conditional       number(38)
);

create table ibmudi30.tmodel(
    tmodelkey         char(36)          not null,
    lang              varchar2(26),
    lang_nocase       varchar2(26),
    name              varchar2(765),
    name_nodiacs      varchar2(765),
    name_nocase       varchar2(765),
    name_nc_nd        varchar2(765),
    owner             varchar2(765),
    operator          varchar2(765),
    createdate        timestamp         not null,
    changedate        timestamp         not null,
    deletedate        timestamp,
    issigned          smallint          default 0 not null,
    conditional       number(38)
);
grant references on ibmudi30.tmodel to ibmuds30;

create table ibmudi30.tmodeloviewdoc(
    tmoviewdockey     char(36)          not null,
    parentkey         char(36)          not null,
    seqnum            integer           not null,
    overviewurl       varchar2(4000),
    usetype           varchar2(765)
);

create table ibmudi30.businesssig(
    parentkey         char(36)          not null,
    seqnum            integer           not null,
    signature         varchar2(4000)    not null
);

create table ibmudi30.bservicesig(
    parentkey         char(36)          not null,
    seqnum            integer           not null,
    signature         varchar2(4000)    not null
);

create table ibmudi30.btemplatesig(
    parentkey         char(36)          not null,
    seqnum            integer           not null,
    signature         varchar2(4000)    not null
);

create table ibmudi30.tmodelsig(
    parentkey         char(36)          not null,
    seqnum            integer           not null,
    signature         varchar2(4000)    not null
);

create table ibmudi30.pubassertsig(
    parentkey         char(36)          not null,
    seqnum            integer           not null,
    fromsig           smallint          not null,
    tosig             smallint          not null,
    signature         varchar2(4000)    not null
);


create table ibmudi30.replaudit(
    localusn          number(38)        not null,
    nodeid            varchar2(255)     not null,
    globalusn         number(38)        not null,
    apiname           varchar2(32),
    replmessagename   varchar2(32),
    acknowledgement   smallint,
    owner             varchar2(765),
    created           timestamp,
    modified          timestamp,
    modifiedchild     timestamp,
    correction        number(38),
    message           varchar2(4000)
);

create sequence ibmudi30.usn start with 1 increment by 1 nominvalue nomaxvalue nocycle order;

--
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


