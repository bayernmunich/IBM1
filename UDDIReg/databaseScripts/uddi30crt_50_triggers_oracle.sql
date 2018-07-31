-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_50_triggers_oracle.sql, UDDI, WAS855.UDDI, cf131750.05
-- Version:                   1.1
-- Last-changed:              05/07/18 10:43:14
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
create trigger ibmudi30.tr_dlt_business
   after delete
   on ibmudi30.business
   for each row
     begin
        update ibmudi30.businesskeymap
          set  isorphaned = 1
          where businesskeymap.businesskey = :old.businesskey ;
        delete from ibmudi30.businesskeymap
          where businesskeymap.businesskey = :old.businesskey and
                not exists ( select 1 from ibmudi30.busallservice
                             where owningbusinesskey = :old.businesskey );
     end;
/
--==========================================================
--
-- Business Service triggers
--
--==========================================================

-- insert
create trigger ibmudi30.tr_ins_bservice
   after insert
   on ibmudi30.bservice
   for each row
     begin
        update ibmudi30.business  business
        set business.modifiedchild = :new.createdate
        where business.businesskey = :new.businesskey ;
     end;
/

-- update
create trigger ibmudi30.tr_upd_bservice
   after update
   on ibmudi30.bservice
   for each row
     begin
        update ibmudi30.business  business
        set business.modifiedchild = :new.modifiedchild
        where business.businesskey = :new.businesskey ;
     end;
/

------------------------------------------------------------
--
-- This trigger corresponds to the DB2 trigger
--   
--     tr_upd_busallsvc_p
--
-- and is positioned here as Oracle has problems running the
-- trigger processing on the BUSALLSERVICE table.
--
--
-- update service - changing parent
--
-- For each service projection on the changed service,
--
--  i.e. each BUSALLSERVICE row with:
--         matching SERVICEKEY as the changed BSERVCICE row
--        AND
--         with different OWNINGBUSINESSKEY and BUSINESSKEY
--
-- Set the owningbusinesskey to the new BUSINESSKEY!
--
------------------------------------------------------------
create trigger ibmudi30.tr_upd_bservice_p
   after update
   of businesskey
   on ibmudi30.bservice
   for each row
     begin
        update ibmudi30.busallservice
          set busallservice.owningbusinesskey = :new.businesskey
          where busallservice.servicekey         = :new.servicekey  and
                busallservice.owningbusinesskey != busallservice.businesskey ;
     end;
/


-- delete
create trigger ibmudi30.tr_dlt_bservice
   after delete
   on ibmudi30.bservice
   for each row
     begin
        update ibmudi30.business  business
           set  business.modifiedchild = current_timestamp
           where business.businesskey = :old.businesskey ;
     end;
/

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
--
--  Oracle can not support the iii) option which is on DB2
--  due to the MUTATING TABLES issue.
--
--  Therefore, under Oracle, deleted Business and Service 
--  key map rows are NEVER deleted, but remain orphaned, and 
--  hence invisible to the API layer, and may be reused by
--  removing their orphaned status.
--
------------------------------------------------------------
create trigger ibmudi30.tr_dlt_busallsvcr
   after delete
   on ibmudi30.busallservice
   for each row
   when (old.owningbusinesskey = old.businesskey)
     begin
        update ibmudi30.bservicekeymap
          set isorphaned = 1
          where bservicekeymap.servicekey = :old.servicekey ;
        delete from ibmudi30.bservice
          where bservice.servicekey = :old.servicekey ;
     end;
/

------------------------------------------------------------
--
--  Similarly to the above, Business and Service key map rows
--  are never deleted, but ARE orhaned.
--
--
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
--create trigger ibmudi30.tr_dlt_busallsvcsp
--   after delete
--   on ibmudi30.busallservice
--   for each row
--   when (old.owningbusinesskey != old.businesskey)
--     begin
--        delete from ibmudi30.bservicekeymap
--          where bservicekeymap.servicekey = :old.servicekey and
--                bservicekeymap.isorphaned = 1 and
--                not exists ( select 1 from ibmudi30.busallservice
--                             where servicekey = :old.servicekey );
--        delete from ibmudi30.businesskeymap
--          where businesskeymap.businesskey = :old.owningbusinesskey and
--                businesskeymap.isorphaned = 1 and
--                not exists ( select 1 from ibmudi30.busallservice
--                             where owningbusinesskey =
--                                   :old.owningbusinesskey );
--     end;
--/

--==========================================================
--
-- Binding Template triggers
--
--==========================================================

-- insert
create trigger ibmudi30.tr_ins_btemplate
   after insert
   on ibmudi30.btemplate
   for each row
     begin
        update ibmudi30.bservice  bservice
        set bservice.modifiedchild = :new.createdate
        where bservice.servicekey = :new.servicekey ;
     end;
/

-- update - changing parent (modify old parent's date)
create trigger ibmudi30.tr_upd_btemplate_p
   after update
   of bindingkey
   on ibmudi30.btemplate
   for each row
     begin
        update ibmudi30.bservice  bservice
        set bservice.modifiedchild = :new.changedate
        where bservice.servicekey = :old.servicekey ;
     end;
/

-- update
create trigger ibmudi30.tr_upd_btemplate
   after update
   on ibmudi30.btemplate
   for each row
     begin
        update ibmudi30.bservice  bservice
        set bservice.modifiedchild = :new.changedate
        where bservice.servicekey = :new.servicekey ;
     end;
/

-- delete
create trigger ibmudi30.tr_dlt_btemplate
   after delete
   on ibmudi30.btemplate
   for each row
     begin
        update ibmudi30.bservice  bservice
        set bservice.modifiedchild = current_timestamp
        where bservice.servicekey = :old.servicekey ;
     end;
/


--==========================================================
--
-- business name insert and update triggers
--
--==========================================================

-- insert
create trigger ibmudi30.tr_ins_name_bus
   after insert
   on ibmudi30.businessname
  for each row
    begin
      update ibmudi30.business  business
        set business.name = :new.name,
            business.name_nocase = :new.name_nocase
        where business.businesskey = :new.parentkey
          and :new.seqnum = 1;
    end;
/

-- update
create trigger ibmudi30.tr_upd_name_bus
   after update
   on ibmudi30.businessname
  for each row
    begin
      update ibmudi30.business  business
        set business.name = :new.name,
            business.name_nocase = :new.name_nocase
        where business.businesskey = :new.parentkey
          and :new.seqnum = 1;
    end;
/

--==========================================================
--
-- bservice name insert and update triggers
--
--==========================================================

-- insert
create trigger ibmudi30.tr_ins_name_bsrv
   after insert
   on ibmudi30.bservicename
   for each row
     begin
       update ibmudi30.bservice  bservice
         set bservice.name = :new.name,
             bservice.name_nocase = :new.name_nocase
         where bservice.servicekey = :new.parentkey
           and :new.seqnum = 1;
     end;
/

-- update
create trigger ibmudi30.tr_upd_name_bsrv
   after update
   on ibmudi30.bservicename
   for each row
     begin
       update ibmudi30.bservice  bservice
         set bservice.name = :new.name,
             bservice.name_nocase = :new.name_nocase
         where bservice.servicekey = :new.parentkey
           and :new.seqnum = 1;
     end;
/


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
   for each row
     begin
        update ibmudi30.tmodelkeymap  tmodelkeymap
        set tmodelkeymap.conditional = :new.conditional
        where tmodelkeymap.tmodelkey = :new.tmodelkey;
     end;
/

-- delete
create trigger ibmudi30.tr_dlt_tmdlkeymap
   after delete
   on ibmudi30.tmodelkeymap
   for each row
     begin
        delete from ibmudi30.conditionallog  conditionallog
        where conditionallog.localusn = :old.conditional;
     end;
/


-- exit;
