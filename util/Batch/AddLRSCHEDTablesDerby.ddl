-- This script adds the necessary job log/class tables to a Derby database due to APAR PM81925.
-- This script can be modified if needed to change the name of database or name of the Schema used. 
-- Default database name is LRSCHED and default schema name is LRSSCHEMA.
-- The script will alter the Derby database in the directory 
-- from which it is invoked.
-- Process This script in the ij command line processor.  
-- Example:  
-- java -Djava.ext.dirs=C:/WebSphere/AppServer/derby/lib -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij AddLRSCHEDTablesDerby.ddl
                                                                                
CREATE TABLE "LRSSCHEMA"."JOBLOGREC" (                                               
       "JOBID" VARCHAR(250) NOT NULL,                                             
       "SERVER" VARCHAR(250) NOT NULL,                                            
       "NODE" VARCHAR(250) NOT NULL,                                              
       "LOGDIR" VARCHAR(250) );                                                    
                                                
ALTER TABLE "LRSSCHEMA"."JOBLOGREC"                                                  
      ADD CONSTRAINT "PK_JOBLOGREC" PRIMARY KEY                                   
      ("JOBID",                                                                   
       "SERVER",                                                                  
       "NODE");                                                                   
                                                                                
CREATE TABLE "LRSSCHEMA"."JOBCLASSREC" (                                             
       "JOBID" VARCHAR(250) NOT NULL,                                             
       "JOBCLASSNAME" VARCHAR(250) NOT NULL,                                      
       "METADATA" VARCHAR(16) NOT NULL);                                        
                                                                                
ALTER TABLE "LRSSCHEMA"."JOBCLASSREC"                                                
       ADD CONSTRAINT "PK_JOBCLASSREC" PRIMARY KEY                                
       ("JOBID","METADATA");                                                        
                                                                                
COMMIT WORK;

DISCONNECT;
                                                                                
