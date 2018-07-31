-- Path, Component, Release:  src/database/uddi30crt_50_triggers_db2udb.sql, v3persistence, dev
-- Version:                   1.10
-- Last-changed:              04/08/19 16:18:27
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
--
-- Business triggers
--
--==========================================================

-- delete
create trigger ibmudi30.tr_dlt_business                                                   \
   after delete                                                                           \
   on ibmudi30.business                                                                   \
       referencing old as dlt_business                                                    \
   for each row mode db2sql                                                               \
     begin atomic                                                                         \
        update ibmudi30.businesskeymap                                                    \
          set  isorphaned = 1                                                             \
          where (ibmudi30.businesskeymap.businesskey = dlt_business.businesskey) ;        \
        delete from ibmudi30.businesskeymap                                               \
          where (ibmudi30.businesskeymap.businesskey = dlt_business.businesskey) and      \
                (not exists ( select 1 from ibmudi30.busallservice                        \
                             where owningbusinesskey = dlt_business.businesskey ));       \
     end
--==========================================================
--
-- Business Service triggers
--
--==========================================================

-- insert
create trigger ibmudi30.tr_ins_bservice                                                    \
   after insert                                                                            \
   on ibmudi30.bservice                                                                    \
   referencing new as ins_child                                                            \
   for each row mode db2sql                                                                \
     begin atomic                                                                          \
        update ibmudi30.business                                                           \
        set modifiedchild = ins_child.createdate                                           \
        where (ibmudi30.business.businesskey = ins_child.businesskey) ;                    \
     end

-- update
create trigger ibmudi30.tr_upd_bservice                                                    \
   after update                                                                            \
   on ibmudi30.bservice                                                                    \
       referencing new as upd_new_child                                                    \
   for each row mode db2sql                                                                \
     begin atomic                                                                          \
        update ibmudi30.business                                                           \
        set modifiedchild = upd_new_child.modifiedchild                                    \
        where ibmudi30.business.businesskey = upd_new_child.businesskey ;                  \
     end

-- delete
create trigger ibmudi30.tr_dlt_bservice                                                    \
   after delete                                                                            \
   on ibmudi30.bservice                                                                    \
       referencing old as dlt_child                                                        \
   for each row mode db2sql                                                                \
     begin atomic                                                                          \
        update ibmudi30.business                                                           \
        set  modifiedchild = current timestamp                                             \
        where ibmudi30.business.businesskey = dlt_child.businesskey ;                      \
     end


--==========================================================
--
-- Business All Service triggers
--
--==========================================================

------------------------------------------------------------
-- Delete REAL service
--
--   i) "hide" the parent Business Service Key Map row for
--      the service row being deleted - MANDATORY!
--  ii) delete the parent Business Service - MANDATORY!
-- iii) ATTEMPT to delete the previously hidden Business
--      Service Key Map row - OPTIONAL!
--      (This may fail if there are Service Projections
--       which reference the row, hence optional)
--
------------------------------------------------------------
create trigger ibmudi30.tr_dlt_busallsvcr                                                 \
   after delete                                                                           \
   on ibmudi30.busallservice                                                              \
       referencing old as dlt_realservice                                                 \
   for each row mode db2sql                                                               \
   when (dlt_realservice.owningbusinesskey = dlt_realservice.businesskey)                 \
     begin atomic                                                                         \
        update ibmudi30.bservicekeymap                                                    \
          set isorphaned = 1                                                              \
          where ibmudi30.bservicekeymap.servicekey = dlt_realservice.servicekey ;         \
        delete from ibmudi30.bservice                                                     \
          where ibmudi30.bservice.servicekey = dlt_realservice.servicekey ;               \
        delete from ibmudi30.bservicekeymap                                               \
          where (ibmudi30.bservicekeymap.servicekey = dlt_realservice.servicekey) and     \
                (ibmudi30.bservicekeymap.isorphaned = 1)                          and     \
                (not exists ( select 1 from ibmudi30.busallservice                        \
                             where servicekey = dlt_realservice.servicekey ));            \
     end

------------------------------------------------------------
-- Delete Service Projection
--
--   i) ATTEMPT to delete a previously hidden Business
--      Service Key Map row - OPTIONAL!
--      (This may fail if there are other Service
--       Projections which reference the row, hence optional)
--  ii) ATTEMPT to delete a previously hidden Business
--      Key Map row - OPTIONAL!
--      (This may fail if there are Service Projections
--       which reference the row, hence optional)
--
------------------------------------------------------------
create trigger ibmudi30.tr_dlt_busallsvcsp                                                    \
   after delete                                                                               \
   on ibmudi30.busallservice                                                                  \
       referencing old as dlt_serviceproj                                                     \
   for each row mode db2sql                                                                   \
   when (dlt_serviceproj.owningbusinesskey != dlt_serviceproj.businesskey)                    \
     begin atomic                                                                             \
        delete from ibmudi30.bservicekeymap                                                   \
          where (ibmudi30.bservicekeymap.servicekey = dlt_serviceproj.servicekey) and         \
                (ibmudi30.bservicekeymap.isorphaned = 1)                          and         \
                (not exists ( select 1 from ibmudi30.busallservice                            \
                             where servicekey = dlt_serviceproj.servicekey ));                \
        delete from ibmudi30.businesskeymap                                                   \
          where (ibmudi30.businesskeymap.businesskey = dlt_serviceproj.owningbusinesskey) and \
                (ibmudi30.businesskeymap.isorphaned = 1)                                  and \
                (not exists ( select 1 from ibmudi30.busallservice                            \
                             where owningbusinesskey =                                        \
                                   dlt_serviceproj.owningbusinesskey ));                      \
     end


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
------------------------------------------------------------
create trigger ibmudi30.tr_upd_busallsvc_p                                                          \
   after update                                                                                     \
   of ibmudi30.busallservice.owningbusinesskey                                                      \
   on ibmudi30.busallservice                                                                        \
        referencing old as old_real_service new as upd_real_service                                 \
   for each row mode db2sql                                                                         \
   when (old_real_service.owningbusinesskey = old_real_service.businesskey)                         \
     begin atomic                                                                                   \
        update ibmudi30.busallservice                                                               \
        set owningbusinesskey = upd_real_service.owningbusinesskey                                  \
        where (ibmudi30.busallservice.servicekey = upd_real_service.servicekey)  and                \
              (ibmudi30.busallservice.owningbusinesskey != ibmudi30.busallservice.businesskey) ;    \
     end

--==========================================================
--
-- Binding Template triggers
--
--==========================================================

-- insert
create trigger ibmudi30.tr_ins_btemplate                                                   \
   after insert                                                                            \
   on ibmudi30.btemplate                                                                   \
       referencing new as ins_child                                                        \
   for each row mode db2sql                                                                \
     begin atomic                                                                          \
        update ibmudi30.bservice                                                           \
        set modifiedchild = ins_child.createdate                                           \
        where ibmudi30.bservice.servicekey = ins_child.servicekey ;                        \
     end

-- update - changing parent (modify old parent's date)
create trigger ibmudi30.tr_upd_btemplate_p                                                 \
   after update of ibmudi30.btemplate.bindingkey                                           \
   on ibmudi30.btemplate                                                                   \
        referencing old as upd_old_child new as upd_new_child                              \
   for each row mode db2sql                                                                \
     begin atomic                                                                          \
        update ibmudi30.bservice                                                           \
        set modifiedchild = upd_new_child.changedate                                       \
        where ibmudi30.bservice.servicekey = upd_old_child.servicekey ;                    \
     end

-- update
create trigger ibmudi30.tr_upd_btemplate                                                   \
   after update                                                                            \
   on ibmudi30.btemplate                                                                   \
       referencing new as upd_new_child                                                    \
   for each row mode db2sql                                                                \
     begin atomic                                                                          \
        update ibmudi30.bservice                                                           \
        set modifiedchild = upd_new_child.changedate                                       \
        where ibmudi30.bservice.servicekey = upd_new_child.servicekey ;                    \
     end

-- delete
create trigger ibmudi30.tr_dlt_btemplate                                                   \
   after delete                                                                            \
   on ibmudi30.btemplate                                                                   \
       referencing old as dlt_child                                                        \
   for each row mode db2sql                                                                \
     begin atomic                                                                          \
        update ibmudi30.bservice                                                           \
        set modifiedchild = current timestamp                                              \
        where ibmudi30.bservice.servicekey = dlt_child.servicekey ;                        \
     end


--==========================================================
--
-- business name insert and update triggers
--
--==========================================================

-- insert
create trigger ibmudi30.tr_ins_name_bus                                                       \
   after insert                                                                               \
   on ibmudi30.businessname                                                                   \
   referencing new as ins_names                                                               \
  for each row mode db2sql                                                                    \
    begin atomic                                                                              \
      update ibmudi30.business                                                                \
        set name = ins_names.name,                                                            \
            name_nocase = ins_names.name_nocase                                               \
        where (ibmudi30.business.businesskey = ins_names.parentkey)                           \
          and (ins_names.seqnum = 1);                                                         \
    end

-- update
create trigger ibmudi30.tr_upd_name_bus                                                       \
   after update                                                                               \
   on ibmudi30.businessname                                                                   \
   referencing new as upd_names                                                               \
  for each row mode db2sql                                                                    \
    begin atomic                                                                              \
      update ibmudi30.business                                                                \
        set name = upd_names.name,                                                            \
            name_nocase = upd_names.name_nocase                                               \
        where (ibmudi30.business.businesskey = upd_names.parentkey)                           \
          and (upd_names.seqnum = 1);                                                         \
    end

--==========================================================
--
-- bservice name insert and update triggers
--
--==========================================================

-- insert
create trigger ibmudi30.tr_ins_name_bsrv                                                      \
   after insert                                                                               \
   on ibmudi30.bservicename                                                                   \
   referencing new as ins_names                                                               \
  for each row mode db2sql                                                                    \
    begin atomic                                                                              \
      update ibmudi30.bservice                                                                \
        set name = ins_names.name,                                                            \
            name_nocase = ins_names.name_nocase                                               \
        where (ibmudi30.bservice.servicekey = ins_names.parentkey)                            \
          and (ins_names.seqnum = 1);                                                         \
    end

-- update
create trigger ibmudi30.tr_upd_name_bsrv                                                      \
   after update                                                                               \
   on ibmudi30.bservicename                                                                   \
   referencing new as upd_names                                                               \
  for each row mode db2sql                                                                    \
    begin atomic                                                                              \
      update ibmudi30.bservice                                                                \
        set name = upd_names.name,                                                            \
            name_nocase = upd_names.name_nocase                                               \
        where (ibmudi30.bservice.servicekey = upd_names.parentkey)                            \
          and (upd_names.seqnum = 1);                                                         \
    end


--==========================================================
--
-- Replication triggers (on tmodel,tmodelkeymap and conditionallog
--
--==========================================================

-- update of conditional flag
create trigger ibmudi30.tr_upd_tmodel_cond                                                    \
   after update                                                                               \
   of ibmudi30.tmodel.conditional                                                             \
   on ibmudi30.tmodel                                                                         \
        referencing new as upd_tmodel                                                         \
   for each row mode db2sql                                                                   \
     begin atomic                                                                             \
        update ibmudi30.tmodelkeymap                                                          \
        set conditional = upd_tmodel.conditional                                              \
        where (ibmudi30.tmodelkeymap.tmodelkey = upd_tmodel.tmodelkey);                       \
     end

-- delete
create trigger ibmudi30.tr_dlt_tmdlkeymap                                                     \
   after delete                                                                               \
   on ibmudi30.tmodelkeymap                                                                   \
       referencing old as dlt_tmodelkeymap                                                    \
   for each row mode db2sql                                                                   \
     begin atomic                                                                             \
        delete from ibmudi30.conditionallog                                                   \
        where dlt_tmodelkeymap.conditional = ibmudi30.conditionallog.localusn;                \
     end
