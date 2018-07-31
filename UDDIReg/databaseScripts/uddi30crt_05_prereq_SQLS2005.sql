--Prereq script for SQL Server - creates database

-- The installer must use a create database command here to create the UDDI30 database according
-- to their needs and advice given in info centre docs.



 -- Add the users

 
USE UDDI30

EXEC sp_addlogin 'ibmudi30', 'any1as_ibmudi30', 'UDDI30'
GO
EXEC sp_addlogin 'ibmuds30' , 'any1as_ibmuds30', 'UDDI30'
GO
EXEC sp_addlogin 'IBMUDDI', 'any1as_IBMUDDI', 'UDDI30'
GO

-- Add the schemas for table creation only

CREATE SCHEMA ibmuds30
GO
CREATE SCHEMA ibmudi30
GO


-- Add the users

CREATE USER ibmudi30 FOR LOGIN ibmudi30
	WITH DEFAULT_SCHEMA=ibmudi30
GO

CREATE USER ibmuds30 FOR LOGIN ibmuds30
	WITH DEFAULT_SCHEMA=ibmuds30
GO

CREATE USER IBMUDDI FOR LOGIN IBMUDDI 
GO
-- Must give ownership of schema ibmudi30 to user ibmudi30
-- Necesary to create triggers
USE [UDDI30]
GO
ALTER AUTHORIZATION ON SCHEMA::[ibmudi30] TO [ibmudi30]
GO
ALTER AUTHORIZATION ON SCHEMA::[ibmuds30] TO [ibmuds30]
GO
GRANT INSERT TO [IBMUDDI]
GO
GRANT SELECT TO [IBMUDDI]
GO


