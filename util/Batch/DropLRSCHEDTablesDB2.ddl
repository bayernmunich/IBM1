CONNECT TO LRSCHED;
DROP TABLE LRSSCHEMA.GLOBALJOBIDASSIGNMENT;
DROP TABLE LRSSCHEMA.LOGMESSAGES;
DROP TABLE LRSSCHEMA.JOBSTATUS;
DROP TABLE LRSSCHEMA.CAPACITYDETECTION;
DROP TABLE LRSSCHEMA.SCHEDULERCOUNTER;
DROP TABLE LRSSCHEMA.XJCLREPOSITORY;
DROP TABLE LRSSCHEMA.JOBREPOSITORY;
DROP TABLE LRSSCHEMA.RECURRINGREQUEST;
DROP TABLE LRSSCHEMA.JMCUSERPREF;
DROP TABLE LRSSCHEMA.JOBPROFILE;
DROP TABLE LRSSCHEMA.JOBUSAGE;
DROP TABLE LRSSCHEMA.JOBCLASSMAXCONCJOBS;
DROP TABLE LRSSCHEMA.JOBCLASSEXEREC;
DROP TABLE LRSSCHEMA.JOBIDCONTROL;
DROP TABLE LRSSCHEMA.JOBREDOLIST;
DROP TABLE LRSSCHEMA.LOCALJOBSTATUS;
DROP TABLE LRSSCHEMA.CHECKPOINTREPOSITORY;
DROP TABLE LRSSCHEMA.JOBSTEPSTATUS;
DROP TABLE LRSSCHEMA.SUBMITTEDJOBS;
DROP TABLE LRSSCHEMA.LOGICALTX;
DROP TABLE LRSSCHEMA.JOBCONTEXT;
DROP TABLE LRSSCHEMA.JOBREPOSITORYHISTORY;
DROP TABLE LRSSCHEMA.JOBLOGREC;
DROP TABLE LRSSCHEMA.JOBCLASSREC;
DROP SEQUENCE LRSSCHEMA.JOBNUMBER RESTRICT;
DROP SCHEMA LRSSCHEMA RESTRICT;
COMMIT WORK;

connect reset;

terminate; 