-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_50_triggers_SQLS.sql, UDDI.v3persistence, WASX.UDDI, o0643.37
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
-- Create trigger must be first statement in query batch, hence extra GOs
USE UDDI30
GO
--==========================================================
--
-- Business triggers
--
--==========================================================

CREATE TRIGGER ibmudi30.tr_dlt_business ON ibmudi30.business
AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE ibmudi30.businesskeymap 
	SET ibmudi30.businesskeymap.isorphaned = 1
	FROM deleted
	WHERE businesskeymap.businesskey = deleted.businesskey 
	
	DELETE FROM ibmudi30.businesskeymap
	FROM deleted AS dlt
    	WHERE ibmudi30.businesskeymap.businesskey = dlt.businesskey 
		AND NOT EXISTS ( SELECT 1 FROM ibmudi30.busallservice
                             		WHERE owningbusinesskey = dlt.businesskey );
	
END
GO
---==========================================================
--
-- Business Service triggers
--
--==========================================================

-- create
CREATE TRIGGER ibmudi30.tr_ins_bservice ON ibmudi30.bservice                                        
   AFTER INSERT
   AS
   BEGIN                         
        UPDATE ibmudi30.business                                                           
        SET modifiedchild = inserted.createdate       
		FROM inserted
        WHERE (ibmudi30.business.businesskey = inserted.businesskey) ;                    
     END
GO

-- update

CREATE TRIGGER ibmudi30.tr_upd_bservice ON ibmudi30.bservice
AFTER UPDATE AS
 BEGIN        
	UPDATE ibmudi30.business       
	SET ibmudi30.business.modifiedchild = inserted.modifiedchild        
	FROM ibmudi30.business , inserted       
	WHERE (business.businesskey = inserted.businesskey) 
 END
GO
 
-- delete

CREATE TRIGGER ibmudi30.tr_dlt_bservice ON ibmudi30.bservice  AFTER DELETE     
	AS   
		BEGIN                                                                          
        UPDATE ibmudi30.business         
        SET  modifiedchild = GETDATE()       
		FROM deleted		
		WHERE ibmudi30.business.businesskey = deleted.businesskey ;   
     END
GO




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

CREATE TRIGGER ibmudi30.tr_dlt_busallsvcr ON ibmudi30.busallservice                       
   AFTER DELETE                                                                           
   AS                                      
   BEGIN                                                                                 
        UPDATE ibmudi30.bservicekeymap  
          SET isorphaned = 1  
		  FROM deleted
          WHERE ibmudi30.bservicekeymap.servicekey = deleted.servicekey  
				AND (deleted.owningbusinesskey = deleted.businesskey)
        DELETE FROM ibmudi30.bservice 		
		FROM deleted
          WHERE ibmudi30.bservice.servicekey = deleted.servicekey 
			AND (deleted.owningbusinesskey = deleted.businesskey);
	       DELETE FROM ibmudi30.bservicekeymap
			FROM deleted
          WHERE (ibmudi30.bservicekeymap.servicekey = deleted.servicekey) 
		  AND (deleted.owningbusinesskey = deleted.businesskey)
		  AND  (ibmudi30.bservicekeymap.isorphaned = 1) AND     
                (NOT EXISTS ( SELECT 1 FROM ibmudi30.busallservice                        
                             WHERE servicekey = deleted.servicekey ));            
     END
GO

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

CREATE TRIGGER ibmudi30.tr_dlt_busallsvcsp  ON ibmudi30.busallservice   
   AFTER DELETE                
   AS                                                                             
	BEGIN   
        DELETE FROM ibmudi30.bservicekeymap        
		FROM deleted
          WHERE (ibmudi30.bservicekeymap.servicekey = deleted.servicekey) AND         
                (ibmudi30.bservicekeymap.isorphaned = 1) 
				AND (deleted.owningbusinesskey != deleted.businesskey)  
				AND (NOT EXISTS ( SELECT 1 FROM ibmudi30.busallservice
                             WHERE servicekey = deleted.servicekey ));                
        DELETE FROM ibmudi30.businesskeymap  
		FROM deleted		
          WHERE (ibmudi30.businesskeymap.businesskey = deleted.owningbusinesskey) 
		  AND (ibmudi30.businesskeymap.isorphaned = 1) 
		  AND (deleted.owningbusinesskey != deleted.businesskey)  
		  AND (NOT EXISTS ( SELECT 1 FROM ibmudi30.busallservice   
                            WHERE owningbusinesskey =  deleted.owningbusinesskey ));  
     END
GO


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
--CREATE TRIGGER ibmudi30.tr_upd_busallsvc_p ON ibmudi30.busallservice                                                          
--   FOR UPDATE AS
--	IF UPDATE (owningbusinesskey) 
--	BEGIN                                                                              
--	IF(old.owningbusinesskey = old.businesskey)                                                                                                       
 --       UPDATE ibmudi30.busallservice                                                               
--        WHERE (ibmudi30.busallservice.servicekey = new.servicekey)  
--		AND                
--		(ibmudi30.busallservice.owningbusinesskey != ibmudi30.busallservice.businesskey) ;   
--END
--GO

-- Alternate trigger for  above  taken from Oracle

CREATE TRIGGER ibmudi30.tr_upd_bservice_p ON ibmudi30.bservice
   FOR UPDATE 
   --OF businesskey
	AS
     BEGIN
        UPDATE ibmudi30.busallservice
          SET ibmudi30.busallservice.owningbusinesskey = inserted.businesskey
		  FROM inserted
          WHERE busallservice.servicekey = inserted.servicekey  AND
                busallservice.owningbusinesskey != busallservice.businesskey ;
     END;

GO


--==========================================================
--
-- Binding Template triggers
--
--==========================================================

-- insert

CREATE TRIGGER ibmudi30.tr_ins_btemplate  ON ibmudi30.btemplate    
   AFTER INSERT                                                                            
      AS                                                                 
     BEGIN 	 
        UPDATE ibmudi30.bservice                                                           
        SET modifiedchild = inserted.createdate   
		FROM inserted
        WHERE ibmudi30.bservice.servicekey = inserted.servicekey ;                        
     END
GO

-- update - changing parent (modify old parent's date)

CREATE TRIGGER ibmudi30.tr_upd_btemplate_p  ON ibmudi30.btemplate                                               
   AFTER UPDATE 
   AS
   IF UPDATE (bindingkey)                             
   BEGIN                                                                         
        UPDATE ibmudi30.bservice                                                           
        SET modifiedchild = inserted.changedate
		FROM inserted
        WHERE ibmudi30.bservice.servicekey = inserted.servicekey ;                    
     END
GO

-- update

CREATE TRIGGER ibmudi30.tr_upd_btemplate ON ibmudi30.btemplate                                                 
	AFTER UPDATE
	AS                                                 
    BEGIN                                                                          
        UPDATE ibmudi30.bservice                                                           
        SET modifiedchild = inserted.changedate                             
		FROM inserted
        WHERE ibmudi30.bservice.servicekey = inserted.servicekey ;                    
     END
GO

-- delete

CREATE TRIGGER ibmudi30.tr_dlt_btemplate ON ibmudi30.btemplate                                              
   AFTER DELETE                                                                            
   AS                                                                   
   BEGIN                                                                           
        UPDATE ibmudi30.bservice                                                           
        SET modifiedchild = GETDATE()     
		FROM deleted
        WHERE ibmudi30.bservice.servicekey = deleted.servicekey ;                        
     END
GO

--==========================================================
--
-- business name insert and update triggers
--
--==========================================================

-- insert, note table "business" does not have a column "name", has been fixed in constraints also

CREATE TRIGGER ibmudi30.tr_ins_name_bus ON ibmudi30.businessname                         
   AFTER INSERT                                                                           
   AS                                                                                    
   BEGIN                                                                              
      UPDATE ibmudi30.business                                                             
        SET name = inserted.name,
		name_nocase = inserted.name_nocase
		FROM inserted
        WHERE (ibmudi30.business.businesskey = inserted.parentkey)                      
			AND (inserted.seqnum = 1);                                                    
    END
GO

-- update

CREATE TRIGGER ibmudi30.tr_upd_name_bus  ON ibmudi30.businessname                 
   AFTER UPDATE                                                               
   AS                                                                              
    BEGIN                                                                             
      UPDATE ibmudi30.business                                
		SET name = inserted.name,                                                            
            name_nocase = inserted.name_nocase
		FROM inserted
        WHERE (ibmudi30.business.businesskey = inserted.parentkey)                           
          AND (inserted.seqnum = 1);                                                         
    END
GO	

--==========================================================
--
-- bservice name insert and update triggers
--
--==========================================================

-- insert

CREATE TRIGGER ibmudi30.tr_ins_name_bsrv ON ibmudi30.bservicename                    
   AFTER INSERT                                                                    
   AS                                                                               
   BEGIN                                                                             
      UPDATE ibmudi30.bservice                                                      
        SET name = inserted.name ,                                                          
            name_nocase = inserted.name_nocase                                            
		FROM inserted
        WHERE (ibmudi30.bservice.servicekey = inserted.parentkey)                         
          AND (inserted.seqnum = 1);      
    END
GO	

-- update - this only handles "insert" updates

CREATE TRIGGER ibmudi30.tr_upd_name_bsrv ON ibmudi30.bservicename
   AFTER UPDATE                                                                           
   AS                                                                                
    BEGIN
      UPDATE ibmudi30.bservice                                                            
        SET name = inserted.name,                                                            
            name_nocase = inserted.name_nocase                                               
		FROM inserted
        WHERE (ibmudi30.bservice.servicekey = inserted.parentkey)                            
          AND (inserted.seqnum = 1)   	
    END
GO


--==========================================================
--
-- Replication triggers (on tmodel,tmodelkeymap and conditionallog
--
--==========================================================

-- update of conditional flag
CREATE TRIGGER ibmudi30.tr_upd_tmodel_cond ON ibmudi30.tmodel                         
	AFTER UPDATE
	AS   
	IF UPDATE (conditional)                                                               
     BEGIN                                                                             
        UPDATE ibmudi30.tmodelkeymap                                                 
        SET conditional = inserted.conditional                           
		FROM inserted
        WHERE (ibmudi30.tmodelkeymap.tmodelkey = inserted.tmodelkey);                       
     END
GO

-- delete

CREATE TRIGGER ibmudi30.tr_dlt_tmdlkeymap  ON ibmudi30.tmodelkeymap                  
	AFTER DELETE    
	AS
   BEGIN                                                                                   
        DELETE FROM ibmudi30.conditionallog        
		FROM deleted
        WHERE deleted.conditional = ibmudi30.conditionallog.localusn;            
     END
GO

