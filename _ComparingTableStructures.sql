-- ===============================================================================================
-- Script: _ComparingTableStructures
-- Author: E.Pineda
-- ===============================================================================================

USE WalmartMXOptixStaging

-- ===============================================================================================
-- DECLARE VARIABLES and SET VALUES
-- ===============================================================================================

-- [BEGIN]

DECLARE @TGT_Database as sysname,  @TGT_Schema as sysname, @TGT_Table sysname,  @CREATE_TargetTable VARCHAR(MAX), @TGT_fqn as sysname, @SRC_Database as sysname,  @SRC_Schema as sysname, @SRC_Table as sysname, @CREATE_SourceTable VARCHAR(MAX), @SRC_fqn as sysname,   @singleQuote VARCHAR(1) = CHAR(39);

-- Target Database and Table
SET @SRC_Database = N'WMXDPO';
SET @SRC_Schema   = N'dbo'
SET @SRC_Table    = N'VendorMaster';

-- Source Database and Table
SET @TGT_Database = N'WalmartMXOptixStaging';
SET @TGT_Schema   = N'Staging'
SET @TGT_Table    = N'SupplierMaster';

IF OBJECT_ID ('tmp_Target_InformationSchemaColumns') IS NOT NULL
   DROP TABLE tmp_Target_InformationSchemaColumns

IF OBJECT_ID ('tmp_Source_InformationSchemaColumns') IS NOT NULL
   DROP TABLE tmp_Source_InformationSchemaColumns

-- ===============================================================================================
-- Create "temp" tables.
-- ===============================================================================================

-- [Target table]

SET @TGT_fqn = CONCAT(QUOTENAME(@TGT_Database),'.INFORMATION_SCHEMA.COLUMNS'
              ,' WHERE TABLE_SCHEMA = ' + @singleQuote + @TGT_Schema + @singleQuote
              ,' AND TABLE_NAME = '    + @singleQuote + @TGT_Table  + @singleQuote)

SET @CREATE_TargetTable =
'SELECT
[Database] = TABLE_CATALOG 
,TableSchema  = TABLE_SCHEMA
,TableName = TABLE_NAME
,ColumnName = COLUMN_NAME
,OrdinalPosition = ORDINAL_POSITION
,IsNullable = IS_NULLABLE
,DataType = DATA_TYPE
,CharacterMaxLenght = CHARACTER_MAXIMUM_LENGTH
,[Numeric] = NUMERIC_PRECISION
,DecimalPositions = NUMERIC_SCALE
,DateTimeBytesStorage = DATETIME_PRECISION
,CharacterSetName = CHARACTER_SET_NAME
,Collation = COLLATION_NAME
INTO dbo.tmp_Target_InformationSchemaColumns 
FROM ' + @TGT_fqn 
EXECUTE(@CREATE_TargetTable)

-- [Source table]

SET @SRC_fqn = CONCAT(QUOTENAME(@SRC_Database),'.INFORMATION_SCHEMA.COLUMNS'
              ,' WHERE TABLE_SCHEMA = ' + @singleQuote + @SRC_Schema + @singleQuote
              ,' AND TABLE_NAME = '    + @singleQuote + @SRC_Table  + @singleQuote)

SET @CREATE_SourceTable =
'SELECT
[Database] = TABLE_CATALOG 
,TableSchema  = TABLE_SCHEMA
,TableName = TABLE_NAME
,ColumnName = COLUMN_NAME
,OrdinalPosition = ORDINAL_POSITION
,IsNullable = IS_NULLABLE
,DataType = DATA_TYPE
,CharacterMaxLenght = CHARACTER_MAXIMUM_LENGTH
,[Numeric] = NUMERIC_PRECISION
,DecimalPositions = NUMERIC_SCALE
,DateTimeBytesStorage = DATETIME_PRECISION
,CharacterSetName = CHARACTER_SET_NAME
,Collation = COLLATION_NAME
INTO dbo.tmp_Source_InformationSchemaColumns 
FROM ' + @SRC_fqn 
EXECUTE(@CREATE_SourceTable)

-- ===============================================================================================
-- Create "temp" tables.
-- ===============================================================================================

-- ===============================================================================================
-- Get results
-- ===============================================================================================

-- =====================================
-- Query #1
-- Columns in "Source" and "Target"
-- =====================================
Select SRC.ColumnName 
,IsNullable = CASE WHEN SRC.IsNullable <> TGT.IsNullable THEN  'Different ' ELSE 'Same on both tables' end
,DataType   = CASE WHEN SRC.DataType <> TGT.DataType THEN  'Different' ELSE 'Same on both tables' end
,CharacterMaxLenght =  CASE WHEN SRC.CharacterMaxLenght <> TGT.CharacterMaxLenght THEN  'Different' ELSE 'Same on both tables' end
,[Numeric] =  CASE WHEN SRC.[Numeric] <> TGT.[Numeric] THEN  'Different' ELSE 'Same on both tables' end
,DecimalPositions =  CASE WHEN SRC.DecimalPositions <> TGT.DecimalPositions THEN  'Different' ELSE 'Same on both tables' end
,DateTimeBytesStorage = CASE WHEN SRC.DateTimeBytesStorage <> TGT.DateTimeBytesStorage THEN  'Different' ELSE 'Same on both tables' end
,CharacterSetName =  CASE WHEN SRC.CharacterSetName <> TGT.CharacterSetName THEN  'Different' ELSE 'Same on both tables' end
,Collation =  CASE WHEN SRC.Collation <> TGT.Collation THEN  'Different' ELSE 'Same on both tables' end ,
SRC_IsNullable = SRC.IsNullable, 
SRC_DataType = SRC.DataType, 
SRC_LENGTH = SRC.CharacterMaxLenght , 
SRC_Number = SRC.Numeric ,
SRC_Decimals = SRC.DecimalPositions, 
--SRC_DateTimeBytes = SRC.DateTimeBytesStorage, 
SRC_Collation = SRC.Collation,
-- ============================================== >>>
TGT_IsNullable = TGT.IsNullable, 
TGT_DataType   = TGT.DataType, 
TGT_LENGTH     = TGT.CharacterMaxLenght , 
TGT_Number     = TGT.Numeric ,
TGT_Decimals   = TGT.DecimalPositions, 
--TGT_DateTimeBytes = TGT.DateTimeBytesStorage, 
TGT_Collation  = TGT.Collation
FROM dbo.tmp_Source_InformationSchemaColumns SRC
INNER Join dbo.tmp_Target_InformationSchemaColumns TGT
ON SRC.ColumnName = TGT.ColumnName

-- =====================================
-- Query #2
-- Columns in "Source" but not in Target
-- =====================================
Select DISTINCT SRC.[Database], SRC.TableName, SRC.ColumnName, SRC.OrdinalPosition
FROM dbo.tmp_Source_InformationSchemaColumns SRC
LEFT Join dbo.tmp_Target_InformationSchemaColumns TGT
ON SRC.ColumnName = TGT.ColumnName
WHERE TGT.ColumnName is null
ORDER BY SRC.OrdinalPosition
--
-- =====================================
-- Query #3
-- Columns in "Target" but not in Source
-- =====================================
Select DISTINCT TGT.[Database], TGT.TableName, TGT.ColumnName, TGT.OrdinalPosition 
FROM dbo.tmp_Source_InformationSchemaColumns SRC
RIGHT Join dbo.tmp_Target_InformationSchemaColumns TGT
ON SRC.ColumnName = TGT.ColumnName
WHERE SRC.ColumnName is null
ORDER BY TGT.OrdinalPosition

-- [END]

-- ===============================================================================================
-- DROP Work Tables
-- ===============================================================================================
IF OBJECT_ID ('tmp_Target_InformationSchemaColumns') IS NOT NULL
   DROP TABLE tmp_Target_InformationSchemaColumns

IF OBJECT_ID ('tmp_Source_InformationSchemaColumns') IS NOT NULL
   DROP TABLE tmp_Source_InformationSchemaColumns

-- ===============================================================================================
-- Get Tables and its columns
-- ===============================================================================================

WITH cte_Tables AS 
(
	select * from sys.tables where type = 'U' and name = 'VendorMaster'
),
cte_Columns AS
(
	select * from sys.columns 
)
Select 
SqlServer = @@SERVERNAME,
[Database] = db_name(),
[schema] = SCHEMA_NAME(TBL.schema_id), 
TableName = TBL.name,  
TBL.type, 
TableCreated = TBL.create_date, 
TableUpdated = TBL.modify_date, 
#Columns = TBL.max_Column_id_used, 
ColumnName = CLM.name, 
ColumnId = CLM.column_id, 
-- DataType = CLM.system_type_id, 
DataType = TYPE_NAME(CLM.system_type_id) ,
[Length] = columnproperty(CLM.object_id, CLM.name, 'charmaxlen') ,
LenghtInBytes_UNICODE = CLM.max_length, 
[Precision] = CLM.precision, 
[Decimals] = CLM.scale, 
Collation = CLM.collation_name, 
is_nullable = IIF ( CLM.is_nullable = 1, 'YES', 'NO' ) ,
[Is_LargeValueDataType(max)] =  IIF ( CLM.max_length = -1, 'YES', 'NO' ),
is_computed = IIF ( CLM.is_computed = 1, 'YES', 'NO' ),
is_sparse   = IIF ( CLM.is_sparse   = 1, 'YES', 'NO' ),
TBL.object_id 
from cte_Tables TBL
INNER JOIN cte_Columns CLM
ON	TBL.object_id = CLM.object_id
--WHERE CLM.max_length <> columnproperty(CLM.object_id, CLM.name, 'charmaxlen') 
ORDER BY  TBL.schema_id,  TBL.name, CLM.column_id





