/*
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
   Script: Generate Stats 
   Author: E.Pineda 
   Updated on: May 2018
   Comments: Create Stats from selected columns.
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
*/

select @@ServerName -- ATL20WS1100SQ10

USE [WALMART_GT_2017_AP_W]

select db_name() -- WALMART_GT_2017_AP_W

-- [ #1]
-- ================================================
--	Prepare Temp Stats table 
-- ================================================

IF OBJECT_ID('tempdb..#Stats') IS NOT NULL 
	DROP TABLE #Stats
GO

CREATE TABLE #Stats 
(
    TABLE_CATALOG sysname,
	TABLE_SCHEMA sysname,
	TABLE_NAME sysname ,
    COLUMN_NAME sysname,
	ORDINAL_POSITION int,
	DATA_TYPE sysname,
	max_length smallint,
	[precision] tinyint,
	scale tinyint
)

-- [ #2]
-- ================================================
--	Build script INSERT scripts
-- ================================================

SELECT 'INSERT INTO #Stats (TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, max_length, [precision], scale) 
       VALUES ('
	   + char(39) + QUOTENAME(TABLE_CATALOG)  + char(39) + ',' 
	   + char(39) + QUOTENAME(TABLE_SCHEMA)  + char(39) + ',' 
	   + char(39) + QUOTENAME(TABLE_NAME)  + char(39) + ',' 
	   + char(39) + QUOTENAME(COLUMN_NAME)  + char(39) + ',' 
	   + STR(ORDINAL_POSITION) + ',' 
	   + char(39) + DATA_TYPE  + char(39) + ',' 
	   + STR(max_length) + ',' 
	   + STR([precision]) + ',' 
	   + STR(scale) + ');' 
FROM  information_schema.columns T1
INNER JOIN sys.columns T2 ON
	T1.COLUMN_NAME = T2.name 
WHERE T1.TABLE_NAME = 'P_AP' AND T2.OBJECT_ID = OBJECT_ID('P_AP')
       
-- [ #3]
-- ================================================
--	Select the columns to be processed (copy/paste)
-- ================================================

-- [Begin: Copy Insert statements then execute them]
--  ====>>>
INSERT INTO #Stats (TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, max_length, [precision], scale)          VALUES ('[WALMART_GT_2017_AP_W]','[dbo]','[P_AP]','[InvDt]',         5,'smalldatetime',         4,        16,         0);
INSERT INTO #Stats (TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, max_length, [precision], scale)          VALUES ('[WALMART_GT_2017_AP_W]','[dbo]','[P_AP]','[ChkDT]',        30,'smalldatetime',         4,        16,         0);
INSERT INTO #Stats (TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, max_length, [precision], scale)          VALUES ('[WALMART_GT_2017_AP_W]','[dbo]','[P_AP]','[DueDt]',        31,'numeric',        13,        21,         2);
INSERT INTO #Stats (TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, max_length, [precision], scale)          VALUES ('[WALMART_GT_2017_AP_W]','[dbo]','[P_AP]','[ChkClearDt]',        35,'smalldatetime',         4,        16,         0);
INSERT INTO #Stats (TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, max_length, [precision], scale)          VALUES ('[WALMART_GT_2017_AP_W]','[dbo]','[P_AP]','[VoidDt]',        38,'int',         4,        10,         0);
INSERT INTO #Stats (TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, max_length, [precision], scale)          VALUES ('[WALMART_GT_2017_AP_W]','[dbo]','[P_AP]','[CanDt]',        40,'int',         4,        10,         0);
INSERT INTO #Stats (TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, max_length, [precision], scale)          VALUES ('[WALMART_GT_2017_AP_W]','[dbo]','[P_AP]','[BatDt]',        42,'int',         4,        10,         0);
INSERT INTO #Stats (TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, max_length, [precision], scale)          VALUES ('[WALMART_GT_2017_AP_W]','[dbo]','[P_AP]','[EntryDt]',        95,'smalldatetime',         4,        16,         0);
INSERT INTO #Stats (TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, max_length, [precision], scale)          VALUES ('[WALMART_GT_2017_AP_W]','[dbo]','[P_AP]','[PostingDt]',        96,'smalldatetime',         4,        16,         0);
INSERT INTO #Stats (TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, max_length, [precision], scale)          VALUES ('[WALMART_GT_2017_AP_W]','[dbo]','[P_AP]','[ChkVoidDt]',        98,'smalldatetime',         4,        16,         0);
--  ====>>>
-- [End: Copy Insert statements]

-- [ #4]
-- ================================================
--	Create the table where Stats be inserted
-- ================================================
IF OBJECT_ID('tempdb..#StatResults') IS NOT NULL 
	DROP TABLE #StatResults
GO

CREATE TABLE #StatResults
(
    [Database]	sysname,
	[Schema] sysname,
	[TableName]	 sysname ,
    [ColumnName] sysname,
	[Sequence] int,
	[Data Type]	 sysname,
	[LEN] smallint,
	[Precision] tinyint,
	[Dec] tinyint,
	[TableRows] bigint,
    [POPULATED]	bigint,
    [% POP] Decimal(8,4),
    [MINLENGTH] int,
    [MAXLENGTH] int,
    [MINIMUMVALUE]	nvarchar(50),
    [MAXIMUMVALUE]	nvarchar(50),
    [Spaces]	int,
    [Zeros] int,
    [Nulls]	int
);
GO

-- [ #5]
-- ================================================
--	Build Scripts that generate the Stats
-- ================================================
SELECT 
'INSERT INTO #StatResults ([Database] , [Schema], [TableName], [ColumnName], [Sequence], [Data Type], [LEN], [Precision], [Dec], [TableRows],
[Populated], [% Pop], [MinLength], [MaxLength], [MinimumValue], [MaximumValue], [Spaces], [Zeros] , [Nulls] ) ' +
'SELECT ' + 
'[Database] = ' + char(39) + TABLE_CATALOG + Char(39) + ', ' +
'[Schema] = '   + char(39) + TABLE_SCHEMA + Char(39) + ', ' +
'TableName = ' + char(39) + TABLE_NAME + Char(39) + ', ' +
'ColumnName = ' + char(39) + COLUMN_NAME + Char(39) + ', ' +
'[Sequence] = ' +  STR(ORDINAL_POSITION)  + ', ' +
'[Data Type] = ' + char(39) + DATA_TYPE + Char(39) + ', ' +
'LEN = ' +  STR(max_length ) + ', ' +
'[Precision] = ' + STR([precision])  + ', ' +
'Dec = ' + STR(scale) + ', ' +
'TABLE_ROWS = x.[CtRows],
 [POPULATED] = (  x.CtRows - (x.[Spaces] + x.[Nulls] + x.[Zeros]) ) ,  
  [% POP] = CAST( ( 100.0 * (( CAST(x.CtRows  - ( x.[Spaces]   + x.[Nulls]  + x.[Zeros] ) as Numeric(12,0))) / x.CtRows )  ) AS Numeric(12,4)),  
  x.[MINLENGTH],  
  x.[MAXLENGTH],  
   [MINIMUMVALUE] = CASE WHEN  x.[DataType] =' + CHAR(39) + 'date' + CHAR(39) + ' OR x.[DataType] = ' + CHAR(39) + 'smalldatetime' + CHAR(39) + ' OR x.[DataType] = ' + CHAR(39) +'datetime' + CHAR(39) + ' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MINIMUMVALUE] ,101) , 120)  ELSE  CAST(x.[MINIMUMVALUE] as NVARCHAR(50)) END,
[MAXIMUMVALUE] = CASE WHEN  x.[DataType] = ' + CHAR(39) + 'date' + CHAR(39) + ' OR x.[DataType] = ' + CHAR(39) +'smalldatetime'	+ CHAR(39) + ' OR x.[DataType] = ' + CHAR(39) +'datetime' + CHAR(39) + ' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MAXIMUMVALUE] ,101) , 120)  ELSE CAST(x.[MAXIMUMVALUE] as NVARCHAR(50)) END,
  x.[Spaces],  
  x.[Zeros], 
  x.[Nulls]
FROM (
SELECT TOP(1) ' + 
' [CtRows] = (SELECT count(*) FROM ' + TABLE_NAME + '),' , +  
' [MINLENGTH] = (SELECT MIN(LEN(' + COLUMN_NAME + ')) FROM ' + TABLE_NAME + '),' , 
' [MAXLENGTH] = (SELECT MAX(LEN(' + COLUMN_NAME + ')) FROM ' + TABLE_NAME + ') ,' , 
' [MINIMUMVALUE] = ( SELECT MIN(' + COLUMN_NAME+ ')   FROM ' + TABLE_NAME + '), ' ,  
' [MAXIMUMVALUE] = ( SELECT MAX(' + COLUMN_NAME + ')  FROM ' + TABLE_NAME + '),' ,
' [DataType] =  ' + char(39) + Data_Type + char(39) + ',' , 
CASE WHEN 
			Data_Type = 'varchar'   OR
			Data_Type = 'char'		OR
			Data_Type = 'text'		OR
			Data_Type = 'nchar'		OR
			Data_Type = 'nvarchar'	OR
			Data_Type = 'ntext'		
--
            THEN  '[Nulls]  = (SELECT count(*) FROM ' + TABLE_NAME + ' WHERE ' + COLUMN_NAME + ' IS Null ),' + char(13) +
			      '[Spaces] = (SELECT count(*) FROM ' + TABLE_NAME + ' WHERE ' + COLUMN_NAME + ' = ' + char(39) + '' + char(39) + '),'  + 
				  '[Zeros]  = (SELECT count(*) FROM ( Select Var = Case When IsNumeric(' + COLUMN_NAME + ') = 1 Then CAST(' + COLUMN_NAME + ' as float) Else Null End From ' + TABLE_NAME + ' Where PATINDEX(' + char(39) + '%[^0-9]%' + char(39) + ' ,' +  COLUMN_NAME + ') = 0 AND ' + COLUMN_NAME + ' NOT LIKE ' + char(39) + '' + char(39) + ') a WHERE Var = 0) ) ' 
			ELSE CASE WHEN Data_Type = 'numeric'		OR 
				  Data_Type = 'decimal'		OR
				  Data_Type = 'int'			OR
				  Data_Type = 'bigint'		OR
				  Data_Type = 'bit'			OR
				  Data_Type = 'smallint'	OR
				  Data_Type = 'smallmoney'  OR
				  Data_Type = 'tinyint'		OR
				  Data_Type = 'money'		OR
				  Data_Type = 'float'		OR
				  Data_Type = 'real'  
--
            THEN  
			' [Nulls] = (SELECT count(*) FROM ' + TABLE_NAME + ' WHERE ' + COLUMN_NAME + ' IS Null ),' + 
		    ' [Spaces] = 0, '  +
			' [Zeros] = (SELECT count(*) FROM ' + TABLE_NAME + ' WHERE ' + COLUMN_NAME + ' = 0 ) ) ' 
			ELSE CASE WHEN 
				  Data_Type = 'date'			OR 
				  Data_Type = 'datetimeoffset'	OR
				  Data_Type = 'datetime2'		OR
				  Data_Type = 'smalldatetime'	OR
				  Data_Type = 'datetime'		OR
				  Data_Type = 'time'  
				  THEN
				  '[Nulls]  = (SELECT count(*) FROM ' + TABLE_NAME + ' WHERE ' + COLUMN_NAME + ' IS Null ),' + char(13) +
				  '[Spaces] = (SELECT count(*) FROM ' + TABLE_NAME + ' WHERE ' + COLUMN_NAME + ' = ' + char(39) + '' + char(39) + ' ),' +
				  '[Zeros]  = (SELECT count(*) FROM ' + TABLE_NAME + ' WHERE ISDate(' + COLUMN_NAME + ') = 0 AND ' + COLUMN_NAME + ' IS NOT NULL ) ) ' 
			ELSE '' End End 
			END 
			+ ' x ;'
FROM #Stats 

-- [ #6]
-- ================================================
--	Copy/Pate the scripts and execute them
-- ================================================

SET NOCOUNT ON

-- [Begin: Copy Insert statements then execute them]

-- ===>>>
INSERT INTO #StatResults ([Database] , [Schema], [TableName], [ColumnName], [Sequence], [Data Type], [LEN], [Precision], [Dec], [TableRows],  [Populated], [% Pop], [MinLength], [MaxLength], [MinimumValue], [MaximumValue], [Spaces], [Zeros] , [Nulls] ) SELECT [Database] = '[WALMART_GT_2017_AP_W]', [Schema] = '[dbo]', TableName = '[P_AP]', ColumnName = '[InvDt]', [Sequence] =          5, [Data Type] = 'smalldatetime', LEN =          4, [Precision] =         16, Dec =          0, TABLE_ROWS = x.[CtRows],   [POPULATED] = (  x.CtRows - (x.[Spaces] + x.[Nulls] + x.[Zeros]) ) ,      [% POP] = CAST( ( 100.0 * (( CAST(x.CtRows  - ( x.[Spaces]   + x.[Nulls]  + x.[Zeros] ) as Numeric(12,0))) / x.CtRows )  ) AS Numeric(12,4)),      x.[MINLENGTH],      x.[MAXLENGTH],       [MINIMUMVALUE] = CASE WHEN  x.[DataType] ='date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MINIMUMVALUE] ,101) , 120)  ELSE  NULL END,  [MAXIMUMVALUE] = CASE WHEN  x.[DataType] = 'date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MAXIMUMVALUE] ,101) , 120)  ELSE NULL END,    x.[Spaces],      x.[Zeros],     x.[Nulls]  FROM (  SELECT TOP(1)  [CtRows] = (SELECT count(*) FROM [P_AP]),	 [MINLENGTH] = (SELECT MIN(LEN([InvDt])) FROM [P_AP]),	 [MAXLENGTH] = (SELECT MAX(LEN([InvDt])) FROM [P_AP]) ,	 [MINIMUMVALUE] = ( SELECT MIN([InvDt])   FROM [P_AP]), 	 [MAXIMUMVALUE] = ( SELECT MAX([InvDt])  FROM [P_AP]),	 [DataType] =  'smalldatetime',	[Nulls]  = (SELECT count(*) FROM [P_AP] WHERE [InvDt] IS Null ), [Spaces] = (SELECT count(*) FROM [P_AP] WHERE [InvDt] = '' ),[Zeros]  = (SELECT count(*) FROM [P_AP] WHERE ISDate([InvDt]) = 0 AND [InvDt] IS NOT NULL ) )  x ;
INSERT INTO #StatResults ([Database] , [Schema], [TableName], [ColumnName], [Sequence], [Data Type], [LEN], [Precision], [Dec], [TableRows],  [Populated], [% Pop], [MinLength], [MaxLength], [MinimumValue], [MaximumValue], [Spaces], [Zeros] , [Nulls] ) SELECT [Database] = '[WALMART_GT_2017_AP_W]', [Schema] = '[dbo]', TableName = '[P_AP]', ColumnName = '[ChkDT]', [Sequence] =         30, [Data Type] = 'smalldatetime', LEN =          4, [Precision] =         16, Dec =          0, TABLE_ROWS = x.[CtRows],   [POPULATED] = (  x.CtRows - (x.[Spaces] + x.[Nulls] + x.[Zeros]) ) ,      [% POP] = CAST( ( 100.0 * (( CAST(x.CtRows  - ( x.[Spaces]   + x.[Nulls]  + x.[Zeros] ) as Numeric(12,0))) / x.CtRows )  ) AS Numeric(12,4)),      x.[MINLENGTH],      x.[MAXLENGTH],       [MINIMUMVALUE] = CASE WHEN  x.[DataType] ='date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MINIMUMVALUE] ,101) , 120)  ELSE  NULL END,  [MAXIMUMVALUE] = CASE WHEN  x.[DataType] = 'date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MAXIMUMVALUE] ,101) , 120)  ELSE NULL END,    x.[Spaces],      x.[Zeros],     x.[Nulls]  FROM (  SELECT TOP(1)  [CtRows] = (SELECT count(*) FROM [P_AP]),	 [MINLENGTH] = (SELECT MIN(LEN([ChkDT])) FROM [P_AP]),	 [MAXLENGTH] = (SELECT MAX(LEN([ChkDT])) FROM [P_AP]) ,	 [MINIMUMVALUE] = ( SELECT MIN([ChkDT])   FROM [P_AP]), 	 [MAXIMUMVALUE] = ( SELECT MAX([ChkDT])  FROM [P_AP]),	 [DataType] =  'smalldatetime',	[Nulls]  = (SELECT count(*) FROM [P_AP] WHERE [ChkDT] IS Null ), [Spaces] = (SELECT count(*) FROM [P_AP] WHERE [ChkDT] = '' ),[Zeros]  = (SELECT count(*) FROM [P_AP] WHERE ISDate([ChkDT]) = 0 AND [ChkDT] IS NOT NULL ) )  x ;
INSERT INTO #StatResults ([Database] , [Schema], [TableName], [ColumnName], [Sequence], [Data Type], [LEN], [Precision], [Dec], [TableRows],  [Populated], [% Pop], [MinLength], [MaxLength], [MinimumValue], [MaximumValue], [Spaces], [Zeros] , [Nulls] ) SELECT [Database] = '[WALMART_GT_2017_AP_W]', [Schema] = '[dbo]', TableName = '[P_AP]', ColumnName = '[DueDt]', [Sequence] =         31, [Data Type] = 'numeric', LEN =         13, [Precision] =         21, Dec =          2, TABLE_ROWS = x.[CtRows],   [POPULATED] = (  x.CtRows - (x.[Spaces] + x.[Nulls] + x.[Zeros]) ) ,      [% POP] = CAST( ( 100.0 * (( CAST(x.CtRows  - ( x.[Spaces]   + x.[Nulls]  + x.[Zeros] ) as Numeric(12,0))) / x.CtRows )  ) AS Numeric(12,4)),      x.[MINLENGTH],      x.[MAXLENGTH],       [MINIMUMVALUE] = CASE WHEN  x.[DataType] ='date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MINIMUMVALUE] ,101) , 120)  ELSE  NULL END,  [MAXIMUMVALUE] = CASE WHEN  x.[DataType] = 'date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MAXIMUMVALUE] ,101) , 120)  ELSE NULL END,    x.[Spaces],      x.[Zeros],     x.[Nulls]  FROM (  SELECT TOP(1)  [CtRows] = (SELECT count(*) FROM [P_AP]),	 [MINLENGTH] = (SELECT MIN(LEN([DueDt])) FROM [P_AP]),	 [MAXLENGTH] = (SELECT MAX(LEN([DueDt])) FROM [P_AP]) ,	 [MINIMUMVALUE] = ( SELECT MIN([DueDt])   FROM [P_AP]), 	 [MAXIMUMVALUE] = ( SELECT MAX([DueDt])  FROM [P_AP]),	 [DataType] =  'numeric',	 [Nulls] = (SELECT count(*) FROM [P_AP] WHERE [DueDt] IS Null ), [Spaces] = 0,  [Zeros] = (SELECT count(*) FROM [P_AP] WHERE [DueDt] = 0 ) )  x ;
INSERT INTO #StatResults ([Database] , [Schema], [TableName], [ColumnName], [Sequence], [Data Type], [LEN], [Precision], [Dec], [TableRows],  [Populated], [% Pop], [MinLength], [MaxLength], [MinimumValue], [MaximumValue], [Spaces], [Zeros] , [Nulls] ) SELECT [Database] = '[WALMART_GT_2017_AP_W]', [Schema] = '[dbo]', TableName = '[P_AP]', ColumnName = '[ChkClearDt]', [Sequence] =         35, [Data Type] = 'smalldatetime', LEN =          4, [Precision] =         16, Dec =          0, TABLE_ROWS = x.[CtRows],   [POPULATED] = (  x.CtRows - (x.[Spaces] + x.[Nulls] + x.[Zeros]) ) ,      [% POP] = CAST( ( 100.0 * (( CAST(x.CtRows  - ( x.[Spaces]   + x.[Nulls]  + x.[Zeros] ) as Numeric(12,0))) / x.CtRows )  ) AS Numeric(12,4)),      x.[MINLENGTH],      x.[MAXLENGTH],       [MINIMUMVALUE] = CASE WHEN  x.[DataType] ='date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MINIMUMVALUE] ,101) , 120)  ELSE  NULL END,  [MAXIMUMVALUE] = CASE WHEN  x.[DataType] = 'date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MAXIMUMVALUE] ,101) , 120)  ELSE NULL END,    x.[Spaces],      x.[Zeros],     x.[Nulls]  FROM (  SELECT TOP(1)  [CtRows] = (SELECT count(*) FROM [P_AP]),	 [MINLENGTH] = (SELECT MIN(LEN([ChkClearDt])) FROM [P_AP]),	 [MAXLENGTH] = (SELECT MAX(LEN([ChkClearDt])) FROM [P_AP]) ,	 [MINIMUMVALUE] = ( SELECT MIN([ChkClearDt])   FROM [P_AP]), 	 [MAXIMUMVALUE] = ( SELECT MAX([ChkClearDt])  FROM [P_AP]),	 [DataType] =  'smalldatetime',	[Nulls]  = (SELECT count(*) FROM [P_AP] WHERE [ChkClearDt] IS Null ), [Spaces] = (SELECT count(*) FROM [P_AP] WHERE [ChkClearDt] = '' ),[Zeros]  = (SELECT count(*) FROM [P_AP] WHERE ISDate([ChkClearDt]) = 0 AND [ChkClearDt] IS NOT NULL ) )  x ;
INSERT INTO #StatResults ([Database] , [Schema], [TableName], [ColumnName], [Sequence], [Data Type], [LEN], [Precision], [Dec], [TableRows],  [Populated], [% Pop], [MinLength], [MaxLength], [MinimumValue], [MaximumValue], [Spaces], [Zeros] , [Nulls] ) SELECT [Database] = '[WALMART_GT_2017_AP_W]', [Schema] = '[dbo]', TableName = '[P_AP]', ColumnName = '[VoidDt]', [Sequence] =         38, [Data Type] = 'int', LEN =          4, [Precision] =         10, Dec =          0, TABLE_ROWS = x.[CtRows],   [POPULATED] = (  x.CtRows - (x.[Spaces] + x.[Nulls] + x.[Zeros]) ) ,      [% POP] = CAST( ( 100.0 * (( CAST(x.CtRows  - ( x.[Spaces]   + x.[Nulls]  + x.[Zeros] ) as Numeric(12,0))) / x.CtRows )  ) AS Numeric(12,4)),      x.[MINLENGTH],      x.[MAXLENGTH],       [MINIMUMVALUE] = CASE WHEN  x.[DataType] ='date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MINIMUMVALUE] ,101) , 120)  ELSE  NULL END,  [MAXIMUMVALUE] = CASE WHEN  x.[DataType] = 'date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MAXIMUMVALUE] ,101) , 120)  ELSE NULL END,    x.[Spaces],      x.[Zeros],     x.[Nulls]  FROM (  SELECT TOP(1)  [CtRows] = (SELECT count(*) FROM [P_AP]),	 [MINLENGTH] = (SELECT MIN(LEN([VoidDt])) FROM [P_AP]),	 [MAXLENGTH] = (SELECT MAX(LEN([VoidDt])) FROM [P_AP]) ,	 [MINIMUMVALUE] = ( SELECT MIN([VoidDt])   FROM [P_AP]), 	 [MAXIMUMVALUE] = ( SELECT MAX([VoidDt])  FROM [P_AP]),	 [DataType] =  'int',	 [Nulls] = (SELECT count(*) FROM [P_AP] WHERE [VoidDt] IS Null ), [Spaces] = 0,  [Zeros] = (SELECT count(*) FROM [P_AP] WHERE [VoidDt] = 0 ) )  x ;
INSERT INTO #StatResults ([Database] , [Schema], [TableName], [ColumnName], [Sequence], [Data Type], [LEN], [Precision], [Dec], [TableRows],  [Populated], [% Pop], [MinLength], [MaxLength], [MinimumValue], [MaximumValue], [Spaces], [Zeros] , [Nulls] ) SELECT [Database] = '[WALMART_GT_2017_AP_W]', [Schema] = '[dbo]', TableName = '[P_AP]', ColumnName = '[CanDt]', [Sequence] =         40, [Data Type] = 'int', LEN =          4, [Precision] =         10, Dec =          0, TABLE_ROWS = x.[CtRows],   [POPULATED] = (  x.CtRows - (x.[Spaces] + x.[Nulls] + x.[Zeros]) ) ,      [% POP] = CAST( ( 100.0 * (( CAST(x.CtRows  - ( x.[Spaces]   + x.[Nulls]  + x.[Zeros] ) as Numeric(12,0))) / x.CtRows )  ) AS Numeric(12,4)),      x.[MINLENGTH],      x.[MAXLENGTH],       [MINIMUMVALUE] = CASE WHEN  x.[DataType] ='date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MINIMUMVALUE] ,101) , 120)  ELSE  NULL END,  [MAXIMUMVALUE] = CASE WHEN  x.[DataType] = 'date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MAXIMUMVALUE] ,101) , 120)  ELSE NULL END,    x.[Spaces],      x.[Zeros],     x.[Nulls]  FROM (  SELECT TOP(1)  [CtRows] = (SELECT count(*) FROM [P_AP]),	 [MINLENGTH] = (SELECT MIN(LEN([CanDt])) FROM [P_AP]),	 [MAXLENGTH] = (SELECT MAX(LEN([CanDt])) FROM [P_AP]) ,	 [MINIMUMVALUE] = ( SELECT MIN([CanDt])   FROM [P_AP]), 	 [MAXIMUMVALUE] = ( SELECT MAX([CanDt])  FROM [P_AP]),	 [DataType] =  'int',	 [Nulls] = (SELECT count(*) FROM [P_AP] WHERE [CanDt] IS Null ), [Spaces] = 0,  [Zeros] = (SELECT count(*) FROM [P_AP] WHERE [CanDt] = 0 ) )  x ;
INSERT INTO #StatResults ([Database] , [Schema], [TableName], [ColumnName], [Sequence], [Data Type], [LEN], [Precision], [Dec], [TableRows],  [Populated], [% Pop], [MinLength], [MaxLength], [MinimumValue], [MaximumValue], [Spaces], [Zeros] , [Nulls] ) SELECT [Database] = '[WALMART_GT_2017_AP_W]', [Schema] = '[dbo]', TableName = '[P_AP]', ColumnName = '[BatDt]', [Sequence] =         42, [Data Type] = 'int', LEN =          4, [Precision] =         10, Dec =          0, TABLE_ROWS = x.[CtRows],   [POPULATED] = (  x.CtRows - (x.[Spaces] + x.[Nulls] + x.[Zeros]) ) ,      [% POP] = CAST( ( 100.0 * (( CAST(x.CtRows  - ( x.[Spaces]   + x.[Nulls]  + x.[Zeros] ) as Numeric(12,0))) / x.CtRows )  ) AS Numeric(12,4)),      x.[MINLENGTH],      x.[MAXLENGTH],       [MINIMUMVALUE] = CASE WHEN  x.[DataType] ='date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MINIMUMVALUE] ,101) , 120)  ELSE  NULL END,  [MAXIMUMVALUE] = CASE WHEN  x.[DataType] = 'date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MAXIMUMVALUE] ,101) , 120)  ELSE NULL END,    x.[Spaces],      x.[Zeros],     x.[Nulls]  FROM (  SELECT TOP(1)  [CtRows] = (SELECT count(*) FROM [P_AP]),	 [MINLENGTH] = (SELECT MIN(LEN([BatDt])) FROM [P_AP]),	 [MAXLENGTH] = (SELECT MAX(LEN([BatDt])) FROM [P_AP]) ,	 [MINIMUMVALUE] = ( SELECT MIN([BatDt])   FROM [P_AP]), 	 [MAXIMUMVALUE] = ( SELECT MAX([BatDt])  FROM [P_AP]),	 [DataType] =  'int',	 [Nulls] = (SELECT count(*) FROM [P_AP] WHERE [BatDt] IS Null ), [Spaces] = 0,  [Zeros] = (SELECT count(*) FROM [P_AP] WHERE [BatDt] = 0 ) )  x ;
INSERT INTO #StatResults ([Database] , [Schema], [TableName], [ColumnName], [Sequence], [Data Type], [LEN], [Precision], [Dec], [TableRows],  [Populated], [% Pop], [MinLength], [MaxLength], [MinimumValue], [MaximumValue], [Spaces], [Zeros] , [Nulls] ) SELECT [Database] = '[WALMART_GT_2017_AP_W]', [Schema] = '[dbo]', TableName = '[P_AP]', ColumnName = '[EntryDt]', [Sequence] =         95, [Data Type] = 'smalldatetime', LEN =          4, [Precision] =         16, Dec =          0, TABLE_ROWS = x.[CtRows],   [POPULATED] = (  x.CtRows - (x.[Spaces] + x.[Nulls] + x.[Zeros]) ) ,      [% POP] = CAST( ( 100.0 * (( CAST(x.CtRows  - ( x.[Spaces]   + x.[Nulls]  + x.[Zeros] ) as Numeric(12,0))) / x.CtRows )  ) AS Numeric(12,4)),      x.[MINLENGTH],      x.[MAXLENGTH],       [MINIMUMVALUE] = CASE WHEN  x.[DataType] ='date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MINIMUMVALUE] ,101) , 120)  ELSE  NULL END,  [MAXIMUMVALUE] = CASE WHEN  x.[DataType] = 'date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MAXIMUMVALUE] ,101) , 120)  ELSE NULL END,    x.[Spaces],      x.[Zeros],     x.[Nulls]  FROM (  SELECT TOP(1)  [CtRows] = (SELECT count(*) FROM [P_AP]),	 [MINLENGTH] = (SELECT MIN(LEN([EntryDt])) FROM [P_AP]),	 [MAXLENGTH] = (SELECT MAX(LEN([EntryDt])) FROM [P_AP]) ,	 [MINIMUMVALUE] = ( SELECT MIN([EntryDt])   FROM [P_AP]), 	 [MAXIMUMVALUE] = ( SELECT MAX([EntryDt])  FROM [P_AP]),	 [DataType] =  'smalldatetime',	[Nulls]  = (SELECT count(*) FROM [P_AP] WHERE [EntryDt] IS Null ), [Spaces] = (SELECT count(*) FROM [P_AP] WHERE [EntryDt] = '' ),[Zeros]  = (SELECT count(*) FROM [P_AP] WHERE ISDate([EntryDt]) = 0 AND [EntryDt] IS NOT NULL ) )  x ;
INSERT INTO #StatResults ([Database] , [Schema], [TableName], [ColumnName], [Sequence], [Data Type], [LEN], [Precision], [Dec], [TableRows],  [Populated], [% Pop], [MinLength], [MaxLength], [MinimumValue], [MaximumValue], [Spaces], [Zeros] , [Nulls] ) SELECT [Database] = '[WALMART_GT_2017_AP_W]', [Schema] = '[dbo]', TableName = '[P_AP]', ColumnName = '[PostingDt]', [Sequence] =         96, [Data Type] = 'smalldatetime', LEN =          4, [Precision] =         16, Dec =          0, TABLE_ROWS = x.[CtRows],   [POPULATED] = (  x.CtRows - (x.[Spaces] + x.[Nulls] + x.[Zeros]) ) ,      [% POP] = CAST( ( 100.0 * (( CAST(x.CtRows  - ( x.[Spaces]   + x.[Nulls]  + x.[Zeros] ) as Numeric(12,0))) / x.CtRows )  ) AS Numeric(12,4)),      x.[MINLENGTH],      x.[MAXLENGTH],       [MINIMUMVALUE] = CASE WHEN  x.[DataType] ='date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MINIMUMVALUE] ,101) , 120)  ELSE  NULL END,  [MAXIMUMVALUE] = CASE WHEN  x.[DataType] = 'date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MAXIMUMVALUE] ,101) , 120)  ELSE NULL END,    x.[Spaces],      x.[Zeros],     x.[Nulls]  FROM (  SELECT TOP(1)  [CtRows] = (SELECT count(*) FROM [P_AP]),	 [MINLENGTH] = (SELECT MIN(LEN([PostingDt])) FROM [P_AP]),	 [MAXLENGTH] = (SELECT MAX(LEN([PostingDt])) FROM [P_AP]) ,	 [MINIMUMVALUE] = ( SELECT MIN([PostingDt])   FROM [P_AP]), 	 [MAXIMUMVALUE] = ( SELECT MAX([PostingDt])  FROM [P_AP]),	 [DataType] =  'smalldatetime',	[Nulls]  = (SELECT count(*) FROM [P_AP] WHERE [PostingDt] IS Null ), [Spaces] = (SELECT count(*) FROM [P_AP] WHERE [PostingDt] = '' ),[Zeros]  = (SELECT count(*) FROM [P_AP] WHERE ISDate([PostingDt]) = 0 AND [PostingDt] IS NOT NULL ) )  x ;
INSERT INTO #StatResults ([Database] , [Schema], [TableName], [ColumnName], [Sequence], [Data Type], [LEN], [Precision], [Dec], [TableRows],  [Populated], [% Pop], [MinLength], [MaxLength], [MinimumValue], [MaximumValue], [Spaces], [Zeros] , [Nulls] ) SELECT [Database] = '[WALMART_GT_2017_AP_W]', [Schema] = '[dbo]', TableName = '[P_AP]', ColumnName = '[ChkVoidDt]', [Sequence] =         98, [Data Type] = 'smalldatetime', LEN =          4, [Precision] =         16, Dec =          0, TABLE_ROWS = x.[CtRows],   [POPULATED] = (  x.CtRows - (x.[Spaces] + x.[Nulls] + x.[Zeros]) ) ,      [% POP] = CAST( ( 100.0 * (( CAST(x.CtRows  - ( x.[Spaces]   + x.[Nulls]  + x.[Zeros] ) as Numeric(12,0))) / x.CtRows )  ) AS Numeric(12,4)),      x.[MINLENGTH],      x.[MAXLENGTH],       [MINIMUMVALUE] = CASE WHEN  x.[DataType] ='date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MINIMUMVALUE] ,101) , 120)  ELSE  NULL END,  [MAXIMUMVALUE] = CASE WHEN  x.[DataType] = 'date' OR x.[DataType] = 'smalldatetime' OR x.[DataType] = 'datetime' THEN CONVERT(nvarchar(19),CONVERT(SMALLDATETIME, x.[MAXIMUMVALUE] ,101) , 120)  ELSE NULL END,    x.[Spaces],      x.[Zeros],     x.[Nulls]  FROM (  SELECT TOP(1)  [CtRows] = (SELECT count(*) FROM [P_AP]),	 [MINLENGTH] = (SELECT MIN(LEN([ChkVoidDt])) FROM [P_AP]),	 [MAXLENGTH] = (SELECT MAX(LEN([ChkVoidDt])) FROM [P_AP]) ,	 [MINIMUMVALUE] = ( SELECT MIN([ChkVoidDt])   FROM [P_AP]), 	 [MAXIMUMVALUE] = ( SELECT MAX([ChkVoidDt])  FROM [P_AP]),	 [DataType] =  'smalldatetime',	[Nulls]  = (SELECT count(*) FROM [P_AP] WHERE [ChkVoidDt] IS Null ), [Spaces] = (SELECT count(*) FROM [P_AP] WHERE [ChkVoidDt] = '' ),[Zeros]  = (SELECT count(*) FROM [P_AP] WHERE ISDate([ChkVoidDt]) = 0 AND [ChkVoidDt] IS NOT NULL ) )  x ;
-- <<<===

PRINT 'Stats Completed'
-- [End:   Copy Insert statements then execute them]

	  ----------------------------------------------------------------------------------------

-- [ #7]
-- ================================================
--	Browse results
-- ================================================
Select * from #StatResults

-- [ #8]
-- ================================================
--	Drop Temporary tables
-- ================================================
IF OBJECT_ID('tempdb..#Stats') IS NOT NULL 
	DROP TABLE #Stats
GO
IF OBJECT_ID('tempdb..#StatResults') IS NOT NULL 
	DROP TABLE #StatResults
GO
-- ==============================================================

