-- This script update Long Running Scheduler to create a sequence nubmer on a db2 instance.
-- The default name of the database is LRSCHED, default schema name is
-- LRSSCHEMA and default tablesapce is USERSPACE1. All these defaults
-- can be replaced with different names if needed.
-- The following commands can be issue from DB2 command line processor
-- to run this script:
--             db2 -tf updateSchedulerDBtoUseSequenceDB2.ddl
 
CONNECT TO LRSCHED;

-- generate sequence number to be use as jobnumber
-- MAXVALUE must be set to equal to JOBIDCONTROL.CONTROLVALUE  		
CREATE SEQUENCE "LRSSCHEMA"."JOBNUMBER"	
	START WITH 0
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 999999
	CACHE 20
	CYCLE;
	
		
COMMIT WORK;

CONNECT RESET;



TERMINATE;
