-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_25_tables_derby.sql, UDDI, WAS855.UDDI, cf131750.05
-- Version:                   1.2
-- Last-changed:              06/01/24 09:03:30
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
    url               varchar(12288)    not null,
    usetype           varchar(765)
);

create table ibmudi30.btemplate(
    bindingkey        char(36)        not null,
    servicekey        char(36)        not null,
    accesspoint       varchar(12288),
    usetype           varchar(765),
    hostingredir      varchar(255),
    createdate        timestamp       not null,
    changedate        timestamp       not null,
    issigned          smallint        default 0 not null,
    seqnum            integer         not null
);

create table ibmudi30.tminstanceinfo(
    tminstinfokey     char(36)          not null,
    idbindingkey      char(36)          not null,
    idtmodelkey       char(36)          not null,
    instanceparms     varchar(24576),
    seqnum            integer           not null
);

create table ibmudi30.idoviewdoc(
    idoviewdockey     char(36)          not null,
    parentkey         char(36)          not null,
    seqnum            integer           not null,
    overviewurl       varchar(12288),
    usetype           varchar(765)
);

create table ibmudi30.conditionallog(
    localusn          bigint       not null,
    nodeid            varchar(255) not null,
    ackusn            bigint
);

create table ibmudi30.tmodelkeymap(
    tmodelkey         char(36)           not null,
    v3tmodelkey       varchar(255)       not null,
    conditional       bigint
);

create table ibmudi30.tmodel(
    tmodelkey         char(36)        not null,
    lang              varchar(26),
    lang_nocase       varchar(26),
    name              varchar(765),
    name_nodiacs      varchar(765),
    name_nocase       varchar(765),
    name_nc_nd        varchar(765),
    owner             varchar(765),
    operator          varchar(765),
    createdate        timestamp       not null,
    changedate        timestamp       not null,
    deletedate        timestamp,
    issigned          smallint        default 0 not null,
    conditional       bigint
);

create table ibmudi30.tmodeloviewdoc(
    tmoviewdockey     char(36)          not null,
    parentkey         char(36)          not null,
    seqnum            integer           not null,
    overviewurl       varchar(12288),
    usetype           varchar(765)
);

create table ibmudi30.businesssig(
    parentkey         char(36)       not null,
    seqnum            integer        not null,
    signature         long varchar   not null
);

create table ibmudi30.bservicesig(
    parentkey         char(36)       not null,
    seqnum            integer        not null,
    signature         long varchar   not null
);

create table ibmudi30.btemplatesig(
    parentkey         char(36)       not null,
    seqnum            integer        not null,
    signature         long varchar   not null
);

create table ibmudi30.tmodelsig(
    parentkey         char(36)       not null,
    seqnum            integer        not null,
    signature         long varchar   not null
);

create table ibmudi30.pubassertsig(
    parentkey         char(36)       not null,
    seqnum            integer        not null,
    fromsig           smallint       not null,
    tosig             smallint       not null,
    signature         long varchar   not null
);


-- Not used, replication not supported within Cloudscape
create table ibmudi30.replaudit(
    localusn          bigint       not null,
    nodeid            varchar(255) not null,
    globalusn         bigint       not null,
    apiname           varchar(32),
    replmessagename   varchar(32),
    acknowledgement   smallint,
    owner             varchar(765),
    created           timestamp,
    modified          timestamp,
    modifiedchild     timestamp,
    correction        bigint,
    message           long varchar
);

-- Not used, replication not supported within Cloudscape
-- create sequence ibmudi30.usn as bigint start with 1 increment by 1 no minvalue no maxvalue no cycle order;
