-- This script adds the necessary job log/class tables to an oracle db due to APAR PM81925.
--
-- 1.Process this script using SQL*Plus
-- 2. Replace all occurrances of @LRSCHED_TABLESPACE@ with a valid tablespace that was 
--    created by the CreateLRSCHEDTablespaceOracle.ddl script.
-- Example: 
--  o  sqlplus username/password@LRSCHED @AddLRSCHEDTablesOracle.ddl
--  o  or, at the sqlplus prompt, enter
--     SQL> @AddLRSCHEDTablesOracle.ddl
                                                                                
CREATE TABLE "JOBLOGREC" (                                               
       "JOBID" VARCHAR(250) NOT NULL,                                             
       "SERVER" VARCHAR(250) NOT NULL,                                            
       "NODE" VARCHAR(250) NOT NULL,                                              
       "LOGDIR" VARCHAR(250) )
       TABLESPACE @LRSCHED_TABLESPACE@;                                                     
                                                
ALTER TABLE "JOBLOGREC"                                                  
      ADD CONSTRAINT "PK_JOBLOGREC" PRIMARY KEY                                   
      ("JOBID",                                                                   
       "SERVER",                                                                  
       "NODE");                                                                   
                                                                                
CREATE TABLE "JOBCLASSREC" (                                             
       "JOBID" VARCHAR(250) NOT NULL,                                             
       "JOBCLASSNAME" VARCHAR(250) NOT NULL,                                      
       "METADATA" VARCHAR(16) NOT NULL)                                           
       TABLESPACE @LRSCHED_TABLESPACE@;                                                      
                                                                                
ALTER TABLE "JOBCLASSREC"                                                
       ADD CONSTRAINT "PK_JOBCLASSREC" PRIMARY KEY                                
       ("JOBID","METADATA");                                                        
                                                                                
