-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_50_triggers_derby.sql, UDDI, WAS855.UDDI, cf131750.05
-- Version:                   1.3
-- Last-changed:              08/09/09 11:55:33
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

--==========================================================
--  As Derby (10.1) does not support the "when" clause on triggers, an
--  alternative approach has been taken.  The "when" clause condition has been
--  relocated to the "where" clause of the SQL statement to execute.
--==========================================================

--==========================================================
--
-- Business triggers
--
--==========================================================

-- delete
create trigger ibmudi30.tr_dlt_business
   after delete
   on ibmudi30.business
       referencing old as dlt_business
   for each row mode db2sql 
      update ibmudi30.businesskeymap
         set  isorphaned = 1
         where ibmudi30.businesskeymap.businesskey = dlt_business.businesskey;

create trigger ibmudi30.tr_dlt_busines2
   after delete
   on ibmudi30.business
       referencing old as dlt_business
   for each row mode db2sql 
      delete from ibmudi30.businesskeymap
         where ibmudi30.businesskeymap.businesskey = dlt_business.businesskey and
               not exists ( select 1 from ibmudi30.busallservice
                            where owningbusinesskey = dlt_business.businesskey );

--==========================================================
--
-- Business Service triggers
--
--==========================================================

-- insert
create trigger ibmudi30.tr_ins_bservice
   after insert
   on ibmudi30.bservice
   referencing new as ins_child
   for each row mode db2sql
     update ibmudi30.business
     set ibmudi30.business.modifiedchild = ins_child.createdate
     where ibmudi30.business.businesskey = ins_child.businesskey;

-- update
create trigger ibmudi30.tr_upd_bservice
   after update
   on ibmudi30.bservice
   referencing new as upd_new_child
   for each row mode db2sql
     update ibmudi30.business
     set ibmudi30.business.modifiedchild = upd_new_child.modifiedchild
     where ibmudi30.business.businesskey = upd_new_child.businesskey;

-- delete
create trigger ibmudi30.tr_dlt_bservice
   after delete
   on ibmudi30.bservice
   referencing old as dlt_child
   for each row mode db2sql
     update ibmudi30.business
     set  modifiedchild = current timestamp
     where ibmudi30.business.businesskey = dlt_child.businesskey;

--==========================================================
--
-- Business All Service triggers
--
--==========================================================

------------------------------------------------------------
-- Delete REAL service
------------------------------------------------------------
--
-- DB2
-- Version:                   1.8
-- Last-changed:              04/07/07 10:32:45
--
--create trigger ibmudi30.tr_dlt_busallsvcr                                                 \
--   after delete                                                                           \
--   on ibmudi30.busallservice                                                              \
--       referencing old as dlt_realservice                                                 \
--   for each row mode db2sql mode db2sql                                                               \
--   when (dlt_realservice.owningbusinesskey = dlt_realservice.businesskey)                 \
--     begin atomic                                                                         \
--        update ibmudi30.bservicekeymap as bservicekeymap                                  \
--          set isorphaned = 1                                                              \
--          where bservicekeymap.servicekey = dlt_realservice.servicekey ;                  \
--        delete from ibmudi30.bservice as bservice                                         \
--          where bservice.servicekey = dlt_realservice.servicekey ;                        \
--        delete from ibmudi30.bservicekeymap as bservicekeymap                             \
--          where bservicekeymap.servicekey = dlt_realservice.servicekey and                \
--                bservicekeymap.isorphaned = 1 and                                         \
--                not exists ( select 1 from ibmudi30.busallservice                         \
--                             where servicekey = dlt_realservice.servicekey );             \
--     end
--
------------------------------------------------------------
--
--   i) "hide" the parent Business Service Key Map row for
--      the service row being deleted - MANDATORY!create trigger ibmudi30.tr_dlt1busallsvcr
create trigger ibmudi30.tr_dlt1busallsvcr
   after delete
   on ibmudi30.busallservice
       referencing old as dlt_realservice
   for each row mode db2sql
        update ibmudi30.bservicekeymap
          set isorphaned = 1
          where ibmudi30.bservicekeymap.servicekey = dlt_realservice.servicekey and
                dlt_realservice.owningbusinesskey = dlt_realservice.businesskey;

--  ii) delete the parent Business Service - MANDATORY!
create trigger ibmudi30.tr_dlt2busallsvcr
   after delete
   on ibmudi30.busallservice
       referencing old as dlt_realservice
   for each row mode db2sql
        delete from ibmudi30.bservice
          where ibmudi30.bservice.servicekey = dlt_realservice.servicekey and
                dlt_realservice.owningbusinesskey = dlt_realservice.businesskey;

-- iii) ATTEMPT to delete the previously hidden Business
--      Service Key Map row - OPTIONAL!
--      (This may fail if there are Service Projections
--       which reference the row, hence optional)
--
create trigger ibmudi30.tr_dlt3busallsvcr
   after delete
   on ibmudi30.busallservice
       referencing old as dlt_realservice
   for each row mode db2sql
        delete from ibmudi30.bservicekeymap
          where ibmudi30.bservicekeymap.servicekey = dlt_realservice.servicekey and
                ibmudi30.bservicekeymap.isorphaned = 1  and
                dlt_realservice.owningbusinesskey = dlt_realservice.businesskey and
                not exists ( select 1 from ibmudi30.busallservice
                             where servicekey = dlt_realservice.servicekey );

------------------------------------------------------------
-- Delete Service Projection
--
------------------------------------------------------------
--create trigger ibmudi30.tr_dlt_busallsvcsp                                                \
--   after delete                                                                           \
--   on ibmudi30.busallservice                                                              \
--       referencing old as dlt_serviceprojection                                           \
--   for each row mode db2sql mode db2sql                                                               \
--   when (dlt_serviceprojection.owningbusinesskey != dlt_serviceprojection.businesskey)    \
--     begin atomic                                                                         \
--        delete from ibmudi30.bservicekeymap as bservicekeymap                             \
--          where bservicekeymap.servicekey = dlt_serviceprojection.servicekey and          \
--                bservicekeymap.isorphaned = 1 and                                         \
--                not exists ( select 1 from ibmudi30.busallservice                         \
--                             where servicekey = dlt_serviceprojection.servicekey );       \
--        delete from ibmudi30.businesskeymap as businesskeymap                             \
--          where businesskeymap.businesskey = dlt_serviceprojection.owningbusinesskey and  \
--                businesskeymap.isorphaned = 1 and                                         \
--                not exists ( select 1 from ibmudi30.busallservice                         \
--                             where owningbusinesskey =                                    \
--                                   dlt_serviceprojection.owningbusinesskey );             \
--     end
--
------------------------------------------------------------
--
--   i) ATTEMPT to delete a previously hidden Business
--      Service Key Map row - OPTIONAL!
--      (This may fail if there are other Service
--       Projections which reference the row, hence optional)
create trigger ibmudi30.tr_dlt1busallsvcsp
   after delete
   on ibmudi30.busallservice
      referencing old as dlt_serviceprojection
   for each row mode db2sql
        delete from ibmudi30.bservicekeymap
          where ibmudi30.bservicekeymap.servicekey = dlt_serviceprojection.servicekey and
                ibmudi30.bservicekeymap.isorphaned = 1 and
                dlt_serviceprojection.owningbusinesskey != dlt_serviceprojection.businesskey and
                not exists ( select 1 from ibmudi30.busallservice
                             where servicekey = dlt_serviceprojection.servicekey );


--  ii) ATTEMPT to delete a previously hidden Business
--      Key Map row - OPTIONAL!
--      (This may fail if there are Service Projections
--       which reference the row, hence optional)
create trigger ibmudi30.tr_dlt2busallsvcsp
   after delete
   on ibmudi30.busallservice
      referencing old as dlt_serviceprojection
   for each row mode db2sql
      delete from ibmudi30.businesskeymap
         where ibmudi30.businesskeymap.businesskey = dlt_serviceprojection.owningbusinesskey and
               ibmudi30.businesskeymap.isorphaned = 1 and
               dlt_serviceprojection.owningbusinesskey != dlt_serviceprojection.businesskey and
               not exists ( select 1 from ibmudi30.busallservice
                            where owningbusinesskey = dlt_serviceprojection.owningbusinesskey );

------------------------------------------------------------
--
-- update REAL service - changing parent
--
-- For each service projection on the changed service,
--
--  i.e. each row with the same service key AND with a
--  different OWNINGBUSINESSKEY and BUSINESSKEY
--
-- Set the owningbusinesskey to the NEW value!
--
-- Updated based on the Oracle trigger since the previous Derby trigger was
-- recursive and caused an SQLException in Derby releases from 10.2 onwards.
------------------------------------------------------------
create trigger ibmudi30.tr_upd_bservice_p
   after update
   of businesskey
   on ibmudi30.bservice
     referencing old as old_real_service new as new_real_service
   for each row mode db2sql
     update ibmudi30.busallservice
       set ibmudi30.busallservice.owningbusinesskey = new_real_service.businesskey
       where ibmudi30.busallservice.servicekey = new_real_service.servicekey and
              ibmudi30.busallservice.owningbusinesskey != ibmudi30.busallservice.businesskey;

--==========================================================
--
-- Binding Template triggers
--
--==========================================================

-- insert
create trigger ibmudi30.tr_ins_btemplate
   after insert
   on ibmudi30.btemplate
   referencing new as ins_child
   for each row mode db2sql
     update ibmudi30.bservice
     set modifiedchild = ins_child.createdate
     where servicekey = ins_child.servicekey;

-- update - changing parent (modify old parent's date)
create trigger ibmudi30.tr_upd_btemplate_p
   after update of bindingkey
   on ibmudi30.btemplate
   referencing old as upd_old_child new as upd_new_child
   for each row mode db2sql
     update ibmudi30.bservice
     set modifiedchild = upd_new_child.changedate
     where servicekey = upd_old_child.servicekey;

-- update
create trigger ibmudi30.tr_upd_btemplate
   after update
   on ibmudi30.btemplate
   referencing new as upd_new_child
   for each row mode db2sql
     update ibmudi30.bservice
     set modifiedchild = upd_new_child.changedate
     where servicekey = upd_new_child.servicekey;

-- delete
create trigger ibmudi30.tr_dlt_btemplate
   after delete
   on ibmudi30.btemplate
   referencing old as dlt_child
   for each row mode db2sql
     update ibmudi30.bservice
     set modifiedchild = current timestamp
     where servicekey = dlt_child.servicekey;


------------------------------------------------------------
--
-- business name insert and update triggers
--
------------------------------------------------------------

-- insert
create trigger ibmudi30.tr_ins_name_bus
   after insert
   on ibmudi30.businessname
   referencing new as ins_names
   for each row mode db2sql
     update ibmudi30.business
     set name = ins_names.name,
         name_nocase = ins_names.name_nocase
     where businesskey = ins_names.parentkey and ins_names.seqnum = 1;

-- update
create trigger ibmudi30.tr_upd_name_bus
   after update
   on ibmudi30.businessname
   referencing new as upd_names
     for each row mode db2sql
       update ibmudi30.business
       set name = upd_names.name,
           name_nocase = upd_names.name_nocase
       where businesskey = upd_names.parentkey and upd_names.seqnum = 1;

------------------------------------------------------------
--
-- bservice name insert and update triggers
--
------------------------------------------------------------

-- insert
create trigger ibmudi30.tr_ins_name_bsrv
   after insert
   on ibmudi30.bservicename
   referencing new as ins_names
     for each row mode db2sql
       update ibmudi30.bservice
       set name = ins_names.name,
           name_nocase = ins_names.name_nocase
       where servicekey = ins_names.parentkey and ins_names.seqnum = 1;

-- update
create trigger ibmudi30.tr_upd_name_bsrv
   after update
   on ibmudi30.bservicename
   referencing new as upd_names
     for each row mode db2sql
       update ibmudi30.bservice
       set name = upd_names.name,
           name_nocase = upd_names.name_nocase
       where servicekey = upd_names.parentkey and upd_names.seqnum = 1;

-------------------------------------------------------------------
--
-- Replication triggers (on tmodel,tmodelkeymap and conditionallog
--
-------------------------------------------------------------------

-- update of conditional flag
create trigger ibmudi30.tr_upd_tmodel_cond
   after update
   of conditional
   on ibmudi30.tmodel
   referencing new as upd_tmodel
   for each row mode db2sql
     update ibmudi30.tmodelkeymap
     set conditional = upd_tmodel.conditional
     where tmodelkey = upd_tmodel.tmodelkey;

-- delete
create trigger ibmudi30.tr_dlt_tmdlkeymap
   after delete
   on ibmudi30.tmodelkeymap
       referencing old as dlt_tmodel
   for each row mode db2sql
     delete from ibmudi30.conditionallog
     where localusn = dlt_tmodel.conditional;
