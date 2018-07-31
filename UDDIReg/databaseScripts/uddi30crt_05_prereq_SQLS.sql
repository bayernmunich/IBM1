-- Path, Component, Release:  UDDI/ws/code/uddi.install/src/database/uddi30crt_10_prereq_SQLS.sql, UDDI.v3persistence, WASX.UDDI, o0643.37
-- Version:                   1.1
-- Last-changed:              05/07/18 10:43:16
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



--Prereq script for SQL Server - creates database
-- The installer must use a create database command here to create the UDDI30 database according
-- to their needs and advice given in info centre docs.

 
USE UDDI30
-- Add the logins
EXEC sp_addlogin 'ibmudi30', 'any1as_ibmudi30', 'UDDI30'
GO
EXEC sp_addlogin 'ibmuds30' , 'any1as_ibmuds30', 'UDDI30'
GO
EXEC sp_addlogin 'IBMUDDI', 'any1as_IBMUDDI', 'UDDI30'
GO


EXEC sp_adduser ibmudi30
go

EXEC sp_adduser ibmuds30
go

EXEC sp_adduser IBMUDDI
GO



-- Add the schemas for table creation only

CREATE SCHEMA AUTHORIZATION ibmuds30
GO
CREATE SCHEMA AUTHORIZATION ibmudi30
GO



