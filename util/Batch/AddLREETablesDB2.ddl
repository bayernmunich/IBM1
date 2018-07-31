-- This script adds JOBLOGREC and JOBCLASSREC tables on a db2 instance.
-- The default name of the database is LREE, default schema name is
-- LREESCHEMA and default tablesapce is USERSPACE1. All these defaults
-- can be replaced with different names if needed.
-- The following commands can be issue from DB2 command line processor
-- to run this script:
--             db2 -tf AddLREETablesDB2.ddl 

CREATE TABLE LREESCHEMA.JOBLOGREC (                                               
       JOBID VARCHAR(250) NOT NULL,                                             
       SERVER VARCHAR(250) NOT NULL,                                            
       NODE VARCHAR(250) NOT NULL,                                              
       LOGDIR VARCHAR(250) )                                                    
       IN "USERSPACE1";                                                        
                                                                                
ALTER TABLE LREESCHEMA.JOBLOGREC                                                  
      ADD CONSTRAINT PK_JOBLOGREC PRIMARY KEY                                   
      (JOBID,                                                                   
       SERVER,                                                                  
       NODE);                                                                   
                                                                                
CREATE TABLE LREESCHEMA.JOBCLASSREC (                                             
       JOBID VARCHAR(250) NOT NULL,                                             
       JOBCLASSNAME VARCHAR(250) NOT NULL,                                      
       METADATA VARCHAR(16) NOT NULL)                                           
       IN "USERSPACE1";                                                        
                                                                                
ALTER TABLE LREESCHEMA.JOBCLASSREC                                                
       ADD CONSTRAINT PK_JOBCLASSREC PRIMARY KEY                                
       (JOBID,METADATA);                                                        
                                                                                
COMMIT WORK;

TERMINATE;
                                                                                
