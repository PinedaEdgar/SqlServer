-- ============================================
-- Name: _ListOfColumns
-- Author: E.Pineda
-- Comments: Gets List of columns
-- ============================================

-- ===========================================================================
--  Get List of Columns
-- ===========================================================================

-- #1 
sp_columns 'EP_BSIK' 

-- #2 
sp_help 'EP_BSIK'

-- #3
SELECT top 100 * from EP_BSIK -- Cntrl-Shift-Q

-- #4
-- SQL 2012 and UP
SELECT fqn = CONCAT(
   QUOTENAME(@@SERVERNAME), '.',
   QUOTENAME(DB_NAME()), '.',
   QUOTENAME(SCHEMA_NAME([schema_id])),'.',
   QUOTENAME([name])
  ), *
    from sys.objects where type = 'U'
	ORDER BY Name

-- #5
-- ===========================================================================
--  Get tables and it's columns
-- ===========================================================================
WITH cte_Tables AS 
(
	select * from sys.tables where type = 'U' and name = 'EP_BSAK'
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
-- SQL Server 2012 and UP
--is_nullable = IIF ( CLM.is_nullable = 1, 'YES', 'NO' ) ,
--[Is_LargeValueDataType(max)] =  IIF ( CLM.max_length = -1, 'YES', 'NO' ),
--is_computed = IIF ( CLM.is_computed = 1, 'YES', 'NO' ),
--is_sparse   = IIF ( CLM.is_sparse   = 1, 'YES', 'NO' ),
TBL.object_id 
from cte_Tables TBL
INNER JOIN cte_Columns CLM
ON	TBL.object_id = CLM.object_id
--WHERE CLM.max_length <> columnproperty(CLM.object_id, CLM.name, 'charmaxlen') 
ORDER BY  TBL.schema_id,  TBL.name, CLM.column_id


-- #6  
-- =====================
Select ',' + name + ' = ' -- , * -- Remove or comment the ',*' if you don't want to see the rest of the columns
From sys.columns
WHERE object_id = OBJECT_Id('[dbo].[G_22]')
ORDER BY name

[dbo].[EP_PAYR] -- Highlight the table the Alt F1

sp_mstablespace 'EP_PAYR'

sp_helptext 'prgrefnbr'


use [CORE_MARK_USA_2017_AP_W]

-- ========================================
--	Create Variable tables
-- ========================================

--DECLARE #TableColumnsA TABLE 
IF OBJECT_ID('tempdb..#TableColumnsA') IS NOT NULL
    TRUNCATE TABLE #TableColumnsA

CREATE TABLE #TableColumnsA
(
  Name			sysname,
  Type			sysname,
  Length        int,
  Precision     int
)


-- DECLARE #TableColumnsB TABLE 
IF OBJECT_ID('tempdb..#TableColumnsB') IS NOT NULL
    TRUNCATE TABLE #TableColumnsB

CREATE TABLE #TableColumnsB
(
  Name			sysname,
  Type			sysname,
  Length        int,
  Precision     int
)

-- ========================================
--	Insert Data
-- ========================================

INSERT INTO #TableColumnsA
SELECT
 COLUMN_NAME	as Name
,DATA_TYPE		as Type
,CHARACTER_MAXIMUM_LENGTH as Length
,NUMERIC_PRECISION	as	Presicion
FROM  information_schema.columns
WHERE TABLE_NAME = 'EP_REGUH'

INSERT INTO #TableColumnsB
SELECT
  COLUMN_NAME	as Name
,DATA_TYPE		as Type
,CHARACTER_MAXIMUM_LENGTH as Length
,NUMERIC_PRECISION	as	Presicion
FROM  information_schema.columns
WHERE TABLE_NAME = 'EP_REGUP'

-- ========================================
--	Compare Data - Different info.
-- ========================================

-- Columns in Table 'A' but not in 'B'
SELECT * FROM #TableColumnsA
EXCEPT
SELECT * FROM #TableColumnsB

 -- Columns in Table 'B' but not in 'A'
SELECT * FROM #TableColumnsB
EXCEPT
SELECT * FROM #TableColumnsA

 -- Common columns in both tables
SELECT * FROM #TableColumnsA
INTERSECT
SELECT * FROM #TableColumnsB

-- ===============================
--	Checking column names only
-- ===============================

-- Columns in Table 'A' but not in 'B'
SELECT name FROM #TableColumnsA
EXCEPT
SELECT name FROM #TableColumnsB

 -- Columns in Table 'B' but not in 'A'
SELECT name FROM #TableColumnsB
EXCEPT
SELECT name FROM #TableColumnsA

 -- Common columns in both tables
SELECT name FROM #TableColumnsA
INTERSECT
SELECT name FROM #TableColumnsB



