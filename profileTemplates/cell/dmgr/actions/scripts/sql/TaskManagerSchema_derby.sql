--------------- Begin Standard Header - Do not add comments here ---------------
-- 
-- File:     TaskManager/sql/TaskManagerSchema_derby.sql, otis_engine, otis_dev
-- Version:  1.42
-- Modified: 10/16/07 03:38:46
-- Build:    1 42
-- 
-- Licensed Materials - Property of IBM
-- 
-- 
-- 5724-J08, 5724-I63, 5724-H88, 5724-H89, 5655-N02, 5733-W07
-- 
-- ©  COPYRIGHT International Business Machines Corp. 1997,2007
-- 
-- The source code for this program is not published or otherwise divested
-- of its trade secrets, irrespective of what has been deposited with the
-- U.S. Copyright Office.
-- 
------------------------------ End Standard Header -----------------------------
--------------------------------------------------------------------------------
--
-- CREATE TABLES
-- 

CREATE TABLE SUBMITTED_TASK 
(
  TASK_ID                         DECIMAL(18)         NOT NULL,
  TASK_DOC_TYPE                   VARCHAR(64) 	      NOT NULL,
  DESCRIPTION                     VARCHAR(256)	              ,
  PRIORITY                        DECIMAL             NOT NULL WITH DEFAULT 5,
  GROUP_NAME                      VARCHAR(256)                ,
  SUBMITTED_TIME                  TIMESTAMP           NOT NULL,
  ACTIVATION_TIME                 TIMESTAMP           NOT NULL,
  EXPIRATION_TIME                 TIMESTAMP           NOT NULL,
  MAX_RETRIES                     DECIMAL             WITH DEFAULT 5,
  INSERTING                       VARCHAR(1)                  ,
  EXPLOITER_USE                   VARCHAR(256)                ,
  RUN_ASAP                        VARCHAR(1)                  ,
  RUN_AT_WINDOW                   VARCHAR(1)                  ,
  CLIENT_TIMEZONE                 VARCHAR(1)                  ,
  PERIODIC_TYPE                   VARCHAR(64)                 ,
  WINDOW_TYPE                     VARCHAR(64)                 ,
  PERIODIC_WINDOW                 VARCHAR(2048)               ,
  LAST_MODIFIED                   TIMESTAMP           WITH DEFAULT TIMESTAMP(convert_time()), 
    CONSTRAINT STASK_PK 
      PRIMARY KEY (TASK_ID)				        
);
CREATE INDEX ST_GROUP_NAME_X ON SUBMITTED_TASK (GROUP_NAME);
COMMIT;



CREATE TABLE TASK_HISTORY 
(
  TASK_ID                         DECIMAL(18) 	      NOT NULL,
  TASK_STATE                      VARCHAR(64)         NOT NULL,
  TASK_DOC_TYPE                   VARCHAR(64) 	      NOT NULL,
  DESCRIPTION                     VARCHAR(1024)               ,
  PRIORITY                        DECIMAL             NOT NULL WITH DEFAULT 5,
  GROUP_NAME                      VARCHAR(256)                ,
  SUBMITTED_TIME                  TIMESTAMP           NOT NULL,
  ACTIVATION_TIME                 TIMESTAMP           NOT NULL,
  EXPIRATION_TIME                 TIMESTAMP           NOT NULL,
  MAX_RETRIES                     DECIMAL             WITH DEFAULT 5,
  EXPLOITER_USE                   VARCHAR(256)                ,
  RUN_ASAP                        VARCHAR(1)                  ,
  RUN_AT_WINDOW                   VARCHAR(1)                  ,
  CLIENT_TIMEZONE                 VARCHAR(1)                  ,
  PERIODIC_TYPE                   VARCHAR(64)                 ,
  WINDOW_TYPE                     VARCHAR(64)                 ,
  PERIODIC_WINDOW                 VARCHAR(2048)               ,
  LAST_MODIFIED                   TIMESTAMP           WITH DEFAULT TIMESTAMP(convert_time()), 
    CONSTRAINT THISTORY_PK 
	PRIMARY KEY (TASK_ID)				        
);
CREATE INDEX TH_GROUP_NAME_X ON TASK_HISTORY (GROUP_NAME);
COMMIT;



CREATE TABLE TASK_DOC 
(
  TASK_ID                       DECIMAL(18)            NOT NULL,
  TASK_DOC                      BLOB(64K)              NOT NULL,
  PARM_DOC                      BLOB(64K)                      ,
  LAST_MODIFIED                 TIMESTAMP              WITH DEFAULT TIMESTAMP(convert_time()),
    CONSTRAINT TDOC_FK1 
      FOREIGN KEY (TASK_ID)
        REFERENCES TASK_HISTORY(TASK_ID) 	  	  		  
          ON DELETE CASCADE
);
CREATE INDEX TD_TASK_ID_X ON TASK_DOC (TASK_ID);
COMMIT;



CREATE TABLE TASK_TARGETS 
(
  TASK_ID                       DECIMAL(18)            NOT NULL,
  DEVICE_ID                     VARCHAR(256)           NOT NULL,
  LAST_MODIFIED                 TIMESTAMP              WITH DEFAULT TIMESTAMP(convert_time()), 
    CONSTRAINT TTARGETS_FK1 
      FOREIGN KEY (TASK_ID)
        REFERENCES TASK_HISTORY(TASK_ID) 		  		  
          ON DELETE CASCADE                                    ,
    CONSTRAINT TTARGETS_UNIQ 
      UNIQUE (TASK_ID, DEVICE_ID)			    			
);
COMMIT;



CREATE TABLE DEVICE_TASK_STATUS 
(
  TASK_ID                       DECIMAL(18)            NOT NULL,
  DEVICE_ID                     VARCHAR(256)           NOT NULL,
  RESULT_ID                     DECIMAL(18)                    ,
  TASK_STATUS                   VARCHAR(32)            NOT NULL,
  TASK_MANAGER_SERVER           VARCHAR(256)                   ,
  RETRIES_AVAILABLE             DECIMAL                        ,
  TASK_COMPLETION_DATE          TIMESTAMP              WITH DEFAULT TIMESTAMP(convert_time()),
  INSERTION_TIME                DECIMAL(15)                    ,
  DELIVERABLE                   CHAR(1)                NOT NULL WITH DEFAULT 'T',
  IN_PROGRESS                   CHAR(1)                WITH DEFAULT 'F',
  HISTORY_TYPE                  CHAR(1)                        ,
  NEXT_RUN_TIME                 TIMESTAMP                      ,
  LAST_MODIFIED                 TIMESTAMP              WITH DEFAULT TIMESTAMP(convert_time()),  
    CONSTRAINT LDT_STATUS_UNIQ 
      UNIQUE (TASK_ID, DEVICE_ID)
);
CREATE INDEX LDTS_TASK_ID_X ON DEVICE_TASK_STATUS (TASK_ID);
CREATE INDEX LDTS_DEVICE_ID_X ON DEVICE_TASK_STATUS (DEVICE_ID);
COMMIT;



CREATE TABLE DEVICE_TASK_RESULTS 
(
  RESULT_ID                     DECIMAL(18)            NOT NULL,
  TASK_ID                       DECIMAL(18)            NOT NULL,
  DEVICE_ID                     VARCHAR(256)           NOT NULL,
  TASK_STATUS			  VARCHAR(32)		   NOT NULL,
  TASK_MANAGER_SERVER		  VARCHAR(256)			    ,
  INSERTION_TIME		  DECIMAL(15),
  TASK_COMPLETION_DATE		  TIMESTAMP  WITH DEFAULT TIMESTAMP(convert_time()),
  TASK_RESULT_TYPE              VARCHAR(256)                   ,
  TASK_RESULT                   BLOB(64K)                      ,
    CONSTRAINT DTRD_PK 
      PRIMARY KEY (RESULT_ID)                                  
);
CREATE INDEX DTR_TASK_DEVICE_X ON DEVICE_TASK_RESULTS(TASK_ID, DEVICE_ID);
COMMIT;



CREATE TABLE DEVICE_TASK_MESSAGES 
(
  RESULT_ID                     DECIMAL(18)            NOT NULL,
  TASK_ID                       DECIMAL(18)            NOT NULL,
  DEVICE_ID                     VARCHAR(256)           NOT NULL,
  TASK_STATUS			  VARCHAR(32)		   NOT NULL,
  TASK_MANAGER_SERVER		  VARCHAR(256)			    ,
  INSERTION_TIME		  DECIMAL(15),
  TASK_COMPLETION_DATE		  TIMESTAMP  WITH DEFAULT TIMESTAMP(convert_time()),
  MESSAGE                       VARCHAR(2048)                  ,
  MESSAGE_BUNDLE                VARCHAR(512)                   ,
  MESSAGE_PARMS                 BLOB(64K)                      ,
    CONSTRAINT DTMD_PK 
      PRIMARY KEY (RESULT_ID)                                  
);
CREATE INDEX DTM_TASK_DEVICE_X ON DEVICE_TASK_MESSAGES(TASK_ID, DEVICE_ID);
COMMIT;



CREATE TABLE DEVICE_GROUPS
(
  GROUP_NAME                    VARCHAR(256)           NOT NULL,
  DEVICE_ID                     VARCHAR(256)           NOT NULL,
  LAST_MODIFIED                 TIMESTAMP              WITH DEFAULT TIMESTAMP(convert_time()), 
  CONSTRAINT DGROUPS_UNIQ 
      UNIQUE (GROUP_NAME, DEVICE_ID)			    			
);
CREATE INDEX DG_GROUP_NAME_X ON DEVICE_GROUPS (GROUP_NAME);
CREATE INDEX DG_DEVICE_ID_X ON DEVICE_GROUPS (DEVICE_ID);
COMMIT;



CREATE TABLE DEVICE_CONNECTIONS
(
  DEVICE_ID                     VARCHAR(256)           NOT NULL,
  TASK_MANAGER_SERVER           VARCHAR(256)                   ,
  TIME_ZONE                     VARCHAR(16)                    ,
  CONNECTION_TIME               TIMESTAMP              WITH DEFAULT TIMESTAMP(convert_time()) 
); 
CREATE INDEX DC_DEVICE_ID_X ON DEVICE_CONNECTIONS (DEVICE_ID);
COMMIT;



CREATE TABLE PENDING_EVENTS
(
  CHANGE_FLAG                   DECIMAL(18)            NOT NULL,
  EVENT_TYPE                    VARCHAR(256)           NOT NULL,
  PROCESSED                     DECIMAL                        ,
  ATTRIBUTE1                    DECIMAL(18)                    ,
  ATTRIBUTE2                    DECIMAL(18)                    ,
  ATTRIBUTE3                    VARCHAR(1024)                  ,
  ATTRIBUTE4                    VARCHAR(1024)                  ,
  ATTRIBUTE5                    VARCHAR(1024)                  ,
  ATTRIBUTE6                    VARCHAR(1024)                  ,
  ATTRIBUTE7                    VARCHAR(2048)                  ,
  ATTRIBUTE8                    BLOB(64K)                      ,
  LAST_MODIFIED                 TIMESTAMP             WITH DEFAULT TIMESTAMP(convert_time()), 
 	CONSTRAINT PECHG_FLG_UNIQ 
		UNIQUE (CHANGE_FLAG)
);
COMMIT;



CREATE TABLE PENDING_EVENT_LOCK
(
	LOCKED                        DECIMAL(18) 
);
INSERT INTO PENDING_EVENT_LOCK (LOCKED) VALUES (0);
COMMIT;



CREATE TABLE DEVICE_EVENTS
(
  DEVICE_ID                     VARCHAR(256)           NOT NULL,
  SEVERITY                      DECIMAL                        ,
  DEVICE_EVENT_TIME             TIMESTAMP                      ,
  MESSAGE_BUNDLE                VARCHAR(512)                   ,
  MESSAGE_PARMS                 BLOB(64K)                      ,
  MESSAGE                       VARCHAR(2048)                  ,
  LAST_MODIFIED                 TIMESTAMP              WITH DEFAULT TIMESTAMP(convert_time()) 
);
COMMIT;

--
-- CREATE TRIGGERS   
--

CREATE TRIGGER stask_updateLM
   AFTER UPDATE OF
   TASK_DOC_TYPE,
   DESCRIPTION,  
   PRIORITY,     
   GROUP_NAME,   
   SUBMITTED_TIME, 
   ACTIVATION_TIME,
   EXPIRATION_TIME,
   MAX_RETRIES,
   EXPLOITER_USE  
   ON submitted_task
      REFERENCING NEW AS n
   FOR EACH ROW MODE DB2SQL
      UPDATE submitted_task SET last_modified = TIMESTAMP(convert_time()) WHERE TASK_ID=n.TASK_ID;
COMMIT;



CREATE TRIGGER thistory_updateLM
	AFTER UPDATE OF
      TASK_STATE,
      TASK_DOC_TYPE,
      DESCRIPTION,
      PRIORITY,
      GROUP_NAME,
      SUBMITTED_TIME,
      ACTIVATION_TIME,
      EXPIRATION_TIME,
      MAX_RETRIES,
      EXPLOITER_USE
      ON task_history
      REFERENCING NEW AS n
        FOR EACH ROW MODE DB2SQL
      UPDATE task_history SET last_modified = TIMESTAMP(convert_time()) WHERE TASK_ID=n.TASK_ID;
COMMIT;

-- Currently we do not allow updating the TASK_DOC table
-- we don't update the TASK_TARGETS, just insert or delete entries
-- We don't update entries in the DEVICE_TASK_RESULTS table so don't need a trigger for last_modified

-- I don't believe we update this table, I think we always do a delete/insert instead
CREATE TRIGGER ldtstatus_updateLM
	AFTER UPDATE OF
      RESULT_ID, 
      TASK_STATUS,
      TASK_MANAGER_SERVER,
      RETRIES_AVAILABLE,
      TASK_COMPLETION_DATE,
      INSERTION_TIME,
      DELIVERABLE,
      IN_PROGRESS,
      NEXT_RUN_TIME
      ON DEVICE_TASK_STATUS
      REFERENCING NEW AS n
        FOR EACH ROW MODE DB2SQL
      UPDATE DEVICE_TASK_STATUS SET last_modified =  TIMESTAMP(convert_time()) WHERE TASK_ID=n.TASK_ID AND DEVICE_ID=n.DEVICE_ID;
COMMIT;

-- we don't update entries in the DEVICE_TASK_RESULTS_DATA table so no last_modified trigger required
-- we don't update the DEVICE_GROUPS, just insert or delete entries
-- we don't update entries in the PENDING_EVNETS table so no last_modified trigger required
-- we don't update entries in the DEVICE_EVENTS table so no last_modified trigger required


--
-- CREATE VIEWS
--



--
-- This view only adds one column to the TASK_HISTORY table
-- TASK_STATUS will by dynamically calculated based on activation and expiration time
--
CREATE VIEW TaskHistoryPlusStatus(task_id, task_state, task_status, task_doc_type, description, priority, group_name, 
                            submitted_time, activation_time, expiration_time, max_retries, exploiter_use, 
                            run_asap, run_at_window, client_timezone, periodic_type, 
                            window_type, periodic_window, last_modified)
as
  SELECT task_id, task_state, 
		CASE
			WHEN TASK_STATE = 'SUSPENDED' THEN 'SUSPENDED'
                  WHEN TASK_STATE = 'EXPIRED' THEN 'EXPIRED'
			WHEN TASK_STATE = 'SUBMITTED' AND  TIMESTAMP(convert_time()) < ACTIVATION_TIME THEN 'PENDING'
			WHEN TASK_STATE = 'SUBMITTED' AND  TIMESTAMP(convert_time()) >= ACTIVATION_TIME AND TIMESTAMP(convert_time()) < EXPIRATION_TIME THEN 'ACTIVE'
			WHEN TASK_STATE = 'SUBMITTED' AND  TIMESTAMP(convert_time()) >= EXPIRATION_TIME THEN 'EXPIRED'
			ELSE 'ERROR'
		END AS task_status, 
         task_doc_type, description, priority, group_name, submitted_time, activation_time, expiration_time, 
         max_retries, exploiter_use, run_asap, run_at_window, client_timezone, 
         periodic_type, window_type, periodic_window, last_modified
  FROM TASK_HISTORY;
COMMIT;


--
-- This view will only return tasks that have associated devices in the TASK_TARGETS table.
-- If the task was for a group and had no devices then the task will NOT be returned by this view.
--
CREATE VIEW AllTasksPlusTargetDevices(task_id, task_doc_type, task_status, priority, submitted_time, group_name, max_retries,  
                                      description, exploiter_use, activation_time, expiration_time, 
                                      run_asap, run_at_window, client_timezone, 
                                      periodic_type, window_type, periodic_window, last_modified, device_id)
as
  SELECT t.task_id, t.task_doc_type, t.task_status, t.priority, t.submitted_time, t.group_name, t.max_retries,  
         t.description, t.exploiter_use, t.activation_time, t.expiration_time, t.run_asap,  
         t.run_at_window, t.client_timezone, t.periodic_type, t.window_type, t.periodic_window, t.last_modified, d.device_id
  FROM TaskHistoryPlusStatus t, TASK_TARGETS d
  WHERE t.task_id = d.task_id;
COMMIT;


--
-- This view will only return tasks that have associated devices in the DEVICE_GROUPS table.
-- If the task was not assigned a group name to associate with then the task will NOT be returned.
--
CREATE VIEW AllTasksPlusGroupDevices(task_id, task_doc_type, task_status, priority, submitted_time, group_name, max_retries, 
                                     description, exploiter_use, activation_time, expiration_time, 
                                     run_asap, run_at_window, client_timezone, 
                                     periodic_type, window_type, periodic_window, last_modified, device_id)
as
  SELECT t.task_id, t.task_doc_type, t.task_status, t.priority, t.submitted_time, t.group_name, t.max_retries,  
         t.description, t.exploiter_use, t.activation_time, t.expiration_time, t.run_asap,  
         t.run_at_window, t.client_timezone, t.periodic_type, t.window_type, t.periodic_window, t.last_modified, g.device_id
  FROM TaskHistoryPlusStatus t, DEVICE_GROUPS g
  WHERE t.group_name = g.group_name;
COMMIT;


--
-- This view will contain an additional TASK_STATUS column to the SUBMITTED_TASK table.
-- This table does not contain SUSPENDED tasks so we are only concerned with pending, expired, and active
--
CREATE VIEW SubmittedTaskPlusStatus(task_id, task_status, task_doc_type, description, priority, group_name, 
                            submitted_time, activation_time, expiration_time, max_retries, inserting,  
                            exploiter_use, run_asap, run_at_window, client_timezone, 
                            periodic_type, window_type, periodic_window, last_modified)
as
  SELECT task_id,  
		CASE
			WHEN TIMESTAMP(convert_time()) < ACTIVATION_TIME THEN 'PENDING'
			WHEN TIMESTAMP(convert_time()) >= ACTIVATION_TIME AND TIMESTAMP(convert_time()) < EXPIRATION_TIME THEN 'ACTIVE'
			WHEN TIMESTAMP(convert_time()) >= EXPIRATION_TIME THEN 'EXPIRED'
			ELSE 'ERROR'
		END AS task_status, 
         task_doc_type, description, priority, group_name, submitted_time, activation_time, expiration_time, 
         max_retries, inserting, exploiter_use, run_asap, run_at_window, client_timezone, 
         periodic_type, window_type, periodic_window, last_modified
  FROM SUBMITTED_TASK;
COMMIT;


--
-- This view will only return tasks that have associated devices in the TASK_TARGETS table.
-- If the task was for a group and had no devices then the task will NOT be returned by this view.
--
CREATE VIEW TasksWithTargetDevices(task_id, task_doc_type, task_status, priority, submitted_time, group_name,   
                                   max_retries, description, exploiter_use, activation_time, expiration_time, 
                                   run_asap, run_at_window, client_timezone, periodic_type, 
                                   window_type, periodic_window, last_modified, device_id)
as
  SELECT s.task_id, s.task_doc_type, s.task_status, s.priority, s.submitted_time, s.group_name, s.max_retries,  
         s.description, s.exploiter_use, s.activation_time, s.expiration_time, s.run_asap,  
         s.run_at_window, s.client_timezone, s.periodic_type, s.window_type, s.periodic_window, s.last_modified, d.device_id
  FROM SubmittedTaskPlusStatus s, TASK_TARGETS d
  WHERE s.task_status = 'ACTIVE' AND s.INSERTING = 'F' AND s.task_id = d.task_id;
COMMIT;


--
-- This view will only return tasks that target a group containing devices in the DEVICE_GROUPS table. 
-- If the task was not assigned a group name to associate with then the task will NOT be returned.
--
CREATE VIEW TasksWithGroupDevices(task_id, task_doc_type, task_status, priority, submitted_time, group_name, 
                                  max_retries, description, exploiter_use, activation_time, expiration_time, 
                                  run_asap, run_at_window, client_timezone, periodic_type, 
                                  window_type, periodic_window, last_modified, device_id)
as
  SELECT s.task_id, s.task_doc_type, s.task_status, s.priority, s.submitted_time, s.group_name, s.max_retries, 
         s.description, s.exploiter_use, s.activation_time, s.expiration_time, s.run_asap,  
         s.run_at_window, s.client_timezone, s.periodic_type, s.window_type, s.periodic_window, s.last_modified, g.device_id
  FROM SubmittedTaskPlusStatus s, DEVICE_GROUPS g
  WHERE s.task_status = 'ACTIVE' AND s.INSERTING = 'F' AND s.group_name = g.group_name;
COMMIT;


--
-- This view will use a UNION to put the above two views together.
-- There will be one row for each task that has a target device either via a group or within a list of devices.
-- Only keep the columns we need, may need to the interval stuff when we support range intervals!
--
CREATE VIEW AllTaskDevices (task_id, task_doc_type, task_status, priority, submitted_time, max_retries, description, exploiter_use, 
                            activation_time, expiration_time, run_asap, run_at_window, client_timezone, periodic_type, 
                            window_type, periodic_window, device_id)
as
  SELECT task_id, task_doc_type, task_status, priority, submitted_time, max_retries, description, exploiter_use, activation_time, expiration_time, 
         run_asap, run_at_window, client_timezone, periodic_type, window_type, periodic_window, device_id
  FROM TasksWithTargetDevices
  UNION 
  SELECT task_id, task_doc_type, task_status, priority, submitted_time, max_retries, description, exploiter_use, activation_time, expiration_time,
         run_asap, run_at_window, client_timezone, periodic_type, window_type, periodic_window, device_id
  FROM TasksWithGroupDevices;
COMMIT;



CREATE VIEW NonDeliverableTasks (task_id, device_id)
as
  SELECT task_id, device_id
  FROM DEVICE_TASK_STATUS
  WHERE DELIVERABLE = 'F' OR NEXT_RUN_TIME > TIMESTAMP(convert_time()); 
commit;



CREATE VIEW SubmittedTaskPlusTaskDoc (task_id, task_doc_type, description, priority, group_name,
                                      submitted_time, activation_time, expiration_time, task_doc, parm_doc,
                                      max_retries, inserting, exploiter_use, run_asap, run_at_window, 
                                      client_timezone, periodic_type, window_type, periodic_window, last_modified) 
as
  SELECT s.task_id, s.task_doc_type, s.description, s.priority, s.group_name, s.submitted_time, s.activation_time,
         s.expiration_time, t.task_doc, t.parm_doc, s.max_retries, s.inserting, s.exploiter_use, s.run_asap,
         s.run_at_window, s.client_timezone, s.periodic_type, s.window_type, s.periodic_window, s.last_modified
  FROM SUBMITTED_TASK s LEFT JOIN TASK_DOC t
  ON s.TASK_ID = t.TASK_ID;
COMMIT;

CREATE VIEW LastDeviceConnection (device_id, task_manager_server, connection_time, time_zone)
as
Select DC.device_id, DC.task_manager_server, DC.connection_time, DC.time_zone 
From DEVICE_CONNECTIONS DC, 
(Select DEVICE_ID, MAX(CONNECTION_TIME) CONNECTION_TIME FROM DEVICE_CONNECTIONS GROUP BY DEVICE_ID) DC2
WHERE DC.DEVICE_ID = DC2.DEVICE_ID AND DC.CONNECTION_TIME = DC2.CONNECTION_TIME;
COMMIT;

CREATE VIEW AllResultsPlusTask (task_id, device_id, result_id, task_result_status, task_manager_server, task_completion_date, insertion_time,
                                task_result_type, task_result, 
                                description, exploiter_use)
as 
  SELECT r.TASK_ID, r.DEVICE_ID, r.RESULT_ID, r.TASK_STATUS, r.TASK_MANAGER_SERVER, r.TASK_COMPLETION_DATE, r.INSERTION_TIME, 
         r.TASK_RESULT_TYPE, r.TASK_RESULT, 
         t.DESCRIPTION, t.EXPLOITER_USE
  FROM DEVICE_TASK_RESULTS r LEFT JOIN TASK_HISTORY t
  ON t.TASK_ID = r.TASK_ID;
commit;



CREATE VIEW AllMessagesPlusTask (task_id, device_id, result_id, task_result_status, task_manager_server, task_completion_date, insertion_time,
                                message, message_bundle, message_parms, 
                                description, exploiter_use)
as 
  SELECT m.TASK_ID, m.DEVICE_ID, m.RESULT_ID, m.TASK_STATUS, m.TASK_MANAGER_SERVER, m.TASK_COMPLETION_DATE, m.INSERTION_TIME, 
         m.MESSAGE, m.MESSAGE_BUNDLE, m.MESSAGE_PARMS, 
         t.DESCRIPTION, t.EXPLOITER_USE
  FROM DEVICE_TASK_MESSAGES m LEFT JOIN TASK_HISTORY t
  ON t.TASK_ID = m.TASK_ID;
commit;
