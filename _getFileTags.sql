/****** Script for SelectTopNRows command from SSMS  ******/
-- =======================================================================================================
-- Script name: _getFileTags
-- Author     : E.Pineda
-- =======================================================================================================
use WALMART_SAP_AP_MX_2015_S

IF OBJECT_ID('Table_FileTag', 'U') IS NOT NULL
   DROP TABLE dbo.Table_FileTag
CREATE TABLE dbo.Table_FileTag (TableName varchar(128), FileTag varchar(128))

exec sp_msForEachTable
@command1 ='INSERT INTO dbo.Table_FileTag (TableName, FileTag) SELECT Distinct ''?'' , Filetag FROM ? ' ,
@whereand = N'AND o.name LIKE ''C_%'' '

select * from Table_FileTag order by TableName, FileTag
IF OBJECT_ID('Table_FileTag', 'U') IS NOT NULL
	DROP TABLE dbo.Table_FileTag
-- =======================================================================================================

