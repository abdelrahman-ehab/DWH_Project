-- Creating New Database for the DWH Project

USE master;
GO
-- Checking if the data base exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DWH')
BEGIN
	ALTER DATABASE DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DWH
END;
GO

--Creating the database
CREATE DATABASE DWH;

USE DWH;
--Creating the 3 layers of the data warehouse
CREATE SCHEMA bronze;
GO --separator to execute each command till finishing
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;