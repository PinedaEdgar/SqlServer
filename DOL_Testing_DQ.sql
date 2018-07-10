USE [DollarGeneralOptixStaging]

selECT * FROM manage.DQ_test   
selECT * FROM sys.tables where name like 'DQ%'
--
DQ_test
DQ_test_detailColumn
DQ_test_hierarchy
DQ_test_result
DQ_test_status
DQ_testType
DQ_testType_ColumnValue_parameters
DQ_testType_ReferentialCheck_parameters

-- =========================================================
--
-- =========================================================
SELECT count(*) FROM manage.DQ_test -- 6
SELECT count(*) FROM manage.DQ_test_detailColumn -- 31 - before 30 
SELECT count(*) FROM manage.DQ_test_hierarchy -- 3
SELECT count(*) FROM manage.DQ_test_result    -- 0 ?? after execution = 1, increases
SELECT count(*) FROM manage.DQ_test_status    -- 4
SELECT count(*) FROM manage.DQ_testType	   -- 2
SELECT count(*) FROM manage.DQ_testType_ColumnValue_parameters -- 4
SELECT count(*) FROM manage.DQ_testType_ReferentialCheck_parameters -- 4 before 1 --
SELECT count(*) FROM manage.SpiderChart -- 22
SELECT count(*) FROM manage.SpiderChartcolumn -- 163

/* Testing Backup
SELECT count(*) FROM dbo.Original_DQ_test -- 5
SELECT count(*) FROM dbo.Original_DQ_test_detailColumn -- 30
SELECT count(*) FROM dbo.Original_DQ_test_hierarchy -- 3
SELECT count(*) FROM dbo.Original_DQ_test_result    -- 6
SELECT count(*) FROM dbo.Original_DQ_test_status    -- 4
SELECT count(*) FROM dbo.Original_DQ_testType	   -- 2
SELECT count(*) FROM dbo.Original_DQ_testType_ColumnValue_parameters -- 4
SELECT count(*) FROM dbo.Original_DQ_testType_ReferentialCheck_parameters -- 1
SELECT count(*) FROM dbo.Original_SpiderChart -- 22
SELECT count(*) FROM dbo.Original_SpiderChartcolumn -- 163
*/

select * from manage.DQ_test ; select * from dbo.Original_DQ_test 


SELECT count(*) from [dbo].[WF_FieldReferenceTest] -- 184
SELECT count(*) FROM [dbo].[WF_NullTest] -- 317

SELECT TOP (1000) * FROM manage.DQ_test
SELECT TOP (1000) * FROM manage.DQ_test_detailColumn -- ??
SELECT TOP (1000) * FROM manage.DQ_test_hierarchy -- ?? tables ..
SELECT TOP (1000) * FROM manage.DQ_test_result    -- ?? TestKey, results, Status, spare -- 
SELECT TOP (1000) * FROM manage.DQ_test_status    -- Status Drop Down
SELECT TOP (1000) * FROM manage.DQ_testType	   -- Test Type Drop Down
SELECT TOP (1000) * FROM manage.DQ_testType_ColumnValue_parameters -- ?? TestKey ... missing the 4 ??  table and columns
SELECT TOP (1000) * FROM manage.DQ_testType_ReferentialCheck_parameters -- ??
-- --------------------------------------------------------
SELECT TOP (1000) * from [dbo].[WF_FieldReferenceTest]
SELECT TOP (1000) * FROM [dbo].[WF_NullTest]

Select distinct schemaname, objectname  FROM manage.DQ_testType_ColumnValue_parameters

-- ========================================================================
--	Queries from Ian
-- ========================================================================

--The TEST table shows all the tests, it also stores the latest test status and when it  was last run.
SelECT * FROM manage.DQ_test  t 
join [manage].[DQ_test_status] ts   
on t.status = ts.teststatus 

-- Results
testkey	testTypekey	description					daterun					RunBy			status	hierarchykey	primaryDrillReport	DrillReporttype	testStatus	statusDescription
1		1			Null Vendor ID				2017-08-08 10:16:37.710	EMEA\ikirka01	1		3				companyLedger		company			1			Passed
2		1			Null line net amount group	2017-04-27 05:07:31.170	EMEA\ikirka01	2		3				companyLedger		company			2			Failed
3		1			Null Vendor country			2017-04-27 05:07:33.120	EMEA\ikirka01	1		1				companyLedger		Ledger			1			Passed
4		2			Invalid Company country		NULL					NULL			0		1				companyLedger		Ledger			0			Not Run
5		1			Blank Vendor addr2			2017-04-27 05:07:33.137	EMEA\ikirka01	2		3				companyLedger		company			2			Failed

--each test belongs to a TEST TYPE. Currently we only have two test types Column value and referential check.
-- ===============================
-- Drop Down values: 
--	1 - "Column Value"
--	2 - "Referential Check"
-- ===============================
SelECT * FROM manage.DQ_test  t 
join [manage].[DQ_testtype] ts   
on t.testtypekey = ts.testtypekey

-- Results
testkey	testTypekey	description					daterun					RunBy			status	hierarchykey	primaryDrillReport	DrillReporttype	testTypekey	testTypeDescription	storedprocedure			Explanation
1		1			Null Vendor ID				2017-08-08 10:16:37.710	EMEA\ikirka01	1		3				companyLedger		company			1			Column Value		DQ_TestType_ColumnValue	NULL
2		1			Null line net amount group	2017-04-27 05:07:31.170	EMEA\ikirka01	2		3				companyLedger		company			1			Column Value		DQ_TestType_ColumnValue	NULL
3		1			Null Vendor country			2017-04-27 05:07:33.120	EMEA\ikirka01	1		1				companyLedger		Ledger			1			Column Value		DQ_TestType_ColumnValue	NULL
4		2			Invalid Company country		NULL					NULL			0		1				companyLedger		Ledger			2			Referential Check	DQ_TestType_ReferentialCheck	NULL
5		1			Blank Vendor addr2	2		017-04-27 05:07:33.137	EMEA\ikirka01	2		3				companyLedger		company			1			Column Value		DQ_TestType_ColumnValue	NULL


--The tests are arranged into hierarchy which is used To group the tests together
SelECT * FROM manage.DQ_test  t 
join [manage].[DQ_test_hierarchy] th 
on t.hierarchykey =th.hierarchykey 

-- Results
testkey	testTypekey	description					daterun					RunBy			status	hierarchykey	primaryDrillReport	DrillReporttype	hierarchyKey	Level1		level2
1		1			Null Vendor ID				2017-08-08 10:16:37.710	EMEA\ikirka01	1		3				companyLedger		company			3				Process		Process
2		1			Null line net amount group	2017-04-27 05:07:31.170	EMEA\ikirka01	2		3				companyLedger		company			3				Process		Process
3		1			Null Vendor country			2017-04-27 05:07:33.120	EMEA\ikirka01	1		1				companyLedger		Ledger			1				Staging		DQ	VN
4		2			Invalid Company country		NULL					NULL			0		1				companyLedger		Ledger			1				Staging		DQ	VN
5		1			Blank Vendor addr2			2017-04-27 05:07:33.137	EMEA\ikirka01	2		3				companyLedger		company			3				Process		Process

--Each test shows a certain level of detail when drilled into. the following table controls what columns are shown
seleCT * FROM [manage].[DQ_test_detailColumn]  ORDER BY Testkey -- where testkey <> 1

-- Results:
detailColumnTestkey	testkey	ColumnName				ord	format
1					1		companyRef				1	
2					1		InvoiceGrossAmountGroup	5	#,##0.0
3					1		InvoiceGrossAmountLoc	6	#,##0.0
4					1		invoiceid				4	
5					1		invoiceref				3	
6					1		vendorid				2	

--This table holds the history 
 selECT * FROM [manage].[DQ_test_result]
 resultkey	testkey	result	daterun					RunBy			status	spare1	spare2	spare3
1			1		NULL	2017-04-27 05:07:30.740	EMEA\ikirka01	1		0		NULL	NULL
2			2		NULL	2017-04-27 05:07:31.170	EMEA\ikirka01	2		8130471	NULL	NULL
3			3		NULL	2017-04-27 05:07:33.017	EMEA\ikirka01	1		0		NULL	NULL
4			3		NULL	2017-04-27 05:07:33.120	EMEA\ikirka01	1		0		NULL	NULL
5			5		NULL	2017-04-27 05:07:33.137	EMEA\ikirka01	2		271419	NULL	NULL
6			1		NULL	2017-08-08 10:16:37.710	EMEA\ikirka01	1		0		NULL	NULL


-- for the column Value test type, the following table holds the paramaters for each test.
selecT * FROM [manage].[DQ_testType_ColumnValue_parameters]  
TestKey	SchemaName	ObjecTName		ColumnName			WhereClause
1		staging		InvoiceHeader	VendorID			Vendorid	is null
2		staging		InvoiceDetail	LineNetaMountGroup	LineNetaMountGroup	is null
3		staging		SupplierMaster	VendorCountry		VendorCountry	is null
5		staging		SupplierMaster	Vendoraddr2			isnull(VendorAddr2,'')=''

-- Execute SP
-- To execute each test you can just called the execute test sproc  

[manage].[DQ_TEST_EXECUTE] @testkey = 1


-- ========================================================================
--	Making a backup from orignal data
-- ========================================================================

SELECT * INTO dbo.Original_DQ_test  FROM manage.DQ_test
SELECT * INTO dbo.Original_DQ_test_detailColumn  FROM manage.DQ_test_detailColumn -- ??
SELECT * INTO dbo.Original_DQ_test_hierarchy  FROM manage.DQ_test_hierarchy -- ??
SELECT * INTO dbo.Original_DQ_test_result  FROM manage.DQ_test_result    -- ?? TestKey, results, Status, spare
SELECT * INTO dbo.Original_DQ_test_status  FROM manage.DQ_test_status    -- Status Drop Down
SELECT * INTO dbo.Original_DQ_testType  FROM manage.DQ_testType	   -- Test Type Drop Down
SELECT * INTO dbo.Original_DQ_testType_ColumnValue_parameters  FROM manage.DQ_testType_ColumnValue_parameters -- ?? TestKey ... missing the 4 ??
SELECT * INTO dbo.Original_DQ_testType_ReferentialCheck_parameters  FROM manage.DQ_testType_ReferentialCheck_parameters -- ??
-- SpideChart
SELECT * INTO dbo.Original_SpiderChart  FROM [manage].[SpiderChart]
SELECT * INTO dbo.Original_SpiderChartcolumn  FROM [manage].[SpiderChartcolumn]
/*
(5 row(s) affected)
(30 row(s) affected)
(3 row(s) affected)
(6 row(s) affected)
(4 row(s) affected)
(2 row(s) affected)
(4 row(s) affected)
(1 row(s) affected)
(22 row(s) affected)
(163 row(s) affected) */

SELECT * FROM dbo.Original_DQ_test  
SELECT * FROM dbo.Original_DQ_test_detailColumn  
SELECT * FROM dbo.Original_DQ_test_hierarchy  
SELECT * FROM dbo.Original_DQ_test_result  ; SELECT * FROM manage.DQ_test_result 
SELECT * FROM dbo.Original_DQ_test_status  
SELECT * FROM dbo.Original_DQ_testType  
SELECT * FROM dbo.Original_DQ_testType_ColumnValue_parameters  
SELECT * FROM dbo.Original_DQ_testType_ReferentialCheck_parameters  
SELECT * FROM dbo.Original_SpiderChart  
SELECT * FROM dbo.Original_SpiderChartcolumn  


select * from [manage].[DQ_test_hierarchy]
-- ==================================================
--	TRUNCATE Tables
-- ==================================================

TRUNCATE TABLE manage.DQ_test
TRUNCATE TABLE manage.DQ_test_detailColumn 
TRUNCATE TABLE manage.DQ_test_hierarchy 
TRUNCATE TABLE manage.DQ_test_result    
TRUNCATE TABLE manage.DQ_test_status    
TRUNCATE TABLE manage.DQ_testType	   
TRUNCATE TABLE manage.DQ_testType_ColumnValue_parameters 
TRUNCATE TABLE manage.DQ_testType_ReferentialCheck_parameters 
TRUNCATE TABLE manage.SpiderChart
TRUNCATE TABLE manage.SpiderChartcolumn


SELECT * FROM manage.DQ_test
SELECT * FROM manage.DQ_test_detailColumn -- ??
SELECT * FROM manage.DQ_test_hierarchy -- ??
SELECT * FROM manage.DQ_test_result    -- ?? TestKey, results, Status, spare
SELECT * FROM manage.DQ_test_status    -- Status Drop Down
SELECT * FROM manage.DQ_testType	   -- Test Type Drop Down
SELECT * FROM manage.DQ_testType_ColumnValue_parameters -- ?? TestKey ... missing the 4 ??
SELECT * FROM manage.DQ_testType_ReferentialCheck_parameters -- ??
-- --------------------------------------------------------
SELECT * from manage.SpiderChart
SELECT * FROM manage.SpiderChartcolumn


-- ==================================================
--	EXECUTE DQ_TEST_EXECUTE
-- ==================================================
EXEC [manage].[DQ_TEST_EXECUTE] @testkey = 1
/*
 if exists ( 
		seleCT 1
		FROM staging.InvoiceHeader
		where Vendorid is null
 	)
	begin
	 
		Insert manage.DQ_test_result  ( testkey, status, spare1 )
 		seleCT 1 testkey , 2, COUNT(*) c
		FROM staging.InvoiceHeader
		where Vendorid is null  
 	end 
	else 
	begin
	 
		Insert manage.DQ_test_result  ( testkey, status, spare1 )
 		seleCT 1  testkey , 1, 0 c
	end 
	

(1 row(s) affected)

(1 row(s) affected)
*/

use [DollarGeneralOptixStaging]



CREATE TABLE #temp (
dt		DATETIME,
col1	XML
)

/*Use the OPENROWSET and BULK load to load an xml file into 
the table.  GETDATE() is used to populate the first column*/
INSERT #temp
SELECT GETDATE(), *
 FROM OPENROWSET(BULK 'C:\Users\epined01\Documents\DQ_DataProfile.xml',
   SINGLE_BLOB) AS x;

SELECT *
FROM #temp

DROP TABLE #temp

SELECT * FROM OPENROWSET


[Staging].[AGM_Calculation_Config]
[Staging].[AGM_ChannelMaster]
[Staging].[AGM_ChannelMaster]

use [DollarGeneralOptixStaging]

select * from sys.tables where SCHEMA_ID = 6

SELECT COUNT(*) FROM Staging.AGM_Calculation_Config -- 39
SELECT COUNT(*) FROM Staging.AGM_ChannelMaster -- 0
SELECT COUNT(*) FROM Staging.agm_fact_full -- 89,817
SELECT COUNT(*) FROM Staging.BusinessUnit -- 0
SELECT COUNT(*) FROM Staging.Category -- 936
SELECT COUNT(*) FROM Staging.Company -- 2
SELECT COUNT(*) FROM Staging.CostCentre -- 0
SELECT COUNT(*) FROM Staging.DiscountRate -- 62
SELECT COUNT(*) FROM Staging.GeneralLedgerAccount -- 0
SELECT COUNT(*) FROM Staging.InvoiceDetail -- 8,130,471
SELECT COUNT(*) FROM Staging.InvoiceHeader -- 757,059
SELECT COUNT(*) FROM Staging.Ledger -- 1
SELECT COUNT(*) FROM Staging.materialImages -- 2370
SELECT COUNT(*) FROM Staging.MaterialMaster -- 511,619
SELECT COUNT(*) FROM Staging.MaterialMasterAttribute -- 487,889
SELECT COUNT(*) FROM Staging.Payment -- 0
SELECT COUNT(*) FROM Staging.PaymentLink -- 0
SELECT COUNT(*) FROM Staging.ProfitCentre -- 0
SELECT COUNT(*) FROM Staging.PurchaseOrderDetail -- 0
SELECT COUNT(*) FROM Staging.PurchaseOrderHeader -- 0
SELECT COUNT(*) FROM Staging.ReportingCategory -- 936
SELECT COUNT(*) FROM Staging.SupplierMaster -- 350427
SELECT COUNT(*) FROM Staging.SupplierMasterToParent -- 0
SELECT COUNT(*) FROM Staging.VendorDiscountTerm -- 0

-- =======================================================
select * from sys.tables where name like 'WF_PF%'
SELECT TOP (1000) * FROM WF_PF_AGM_Calc_Config
SELECT TOP (1000) * FROM WF_PF_AGM_Fact_Full
SELECT TOP (1000) * FROM WF_PF_BusinessUnit
SELECT TOP (1000) * FROM WF_PF_Category
SELECT TOP (1000) * FROM WF_PF_InvoiceHeader
SELECT TOP (1000) * FROM WF_PF_SupplierMaster

SELECT COUNT(*) FROM WF_PF_AGM_Calc_Config -- 153
SELECT COUNT(*) FROM WF_PF_AGM_Fact_Full -- 465
SELECT COUNT(*) FROM WF_PF_BusinessUnit -- 22
SELECT COUNT(*) FROM WF_PF_Category -- 1892
SELECT COUNT(*) FROM WF_PF_InvoiceHeader -- 834
SELECT COUNT(*) FROM WF_PF_SupplierMaster -- 541

select column_name from Information_schema.columns where table_name like 'WF_PF_SupplierMaster'

table25, schema5, datasource, database , rowcount, name26, sqldbtype, maxlenght, isNullable, ns1:NullCount, 



schema, table, ProfileRequestid, 


select distinct ProfileRequestid from WF_PF_SupplierMaster --NullRatioReq
select distinct ProfileRequestid28 from WF_PF_SupplierMaster --StatisticsReq
select distinct ProfileRequestid44 from WF_PF_SupplierMaster --LengthDistReq
select distinct ProfileRequestid64 from WF_PF_SupplierMaster --ValueDistReq
select distinct ProfileRequestid82 from WF_PF_SupplierMaster -- KeyReq

-- NullRatioReq -- Done
Select 
[DataSource] as DataSource, 
[database] as DB, 
[schema24] as [Schema], 
[table25] as TableName, 
ProfileRequestid,
[rowcount] as #Rows, name26 as columnName,  
[ns1:NullCount] as NullCount, 
CAST(((CAST([ns1:NullCount] as float) / CAST([rowcount] as float) ) * 100) as Decimal(10,4)) as [Null Percentage] 
FROM WF_PF_SupplierMaster where ProfileRequestid = 'NullRatioReq' ORDER BY name26 -- SqlDBType, [MaxLength], [Precision], Scale, IsNullable,


-- StatisticsReq -- Done
select 
DataSource30 as DataSource, 
database31 as DB, 
[schema32] as [Schema], 
[table33] as TableName, 
ProfileRequestid28,  [rowcount34] as #Rows, name35 as columnName,  [ns1:MaxValue] as Maximum, [ns1:Mean] as Mean,  [ns1:StdDev] as [Standard Deviation] 
FROM WF_PF_SupplierMaster where ProfileRequestid28 = 'StatisticsReq' ORDER BY Name35 -- [ns1:Option], SqlDbType36, [MaxLength37], [Precision38], Scale39, IsNullable42, [ns1:MinValue] as Minimum,

 
-- LengthDistReq -- Done
select 
DataSource47 as DataSource, 
database48 as DB, 
[schema49] as [Schema], 
[table50] as TableName, 
ProfileRequestid44,
[rowcount51] as #Rows, 
Name52 as ColumnName, 
[ns1:IgnoreLeadingSpace61] AS [Ignore Leading Spaces], 	
[ns1:IgnoreTrailingSpace62] AS [Ignore Trailing Spaces],	
[ns1:MinLength] AS [Minimum Length], 
[ns1:MaxLength] AS [Maximum Length], 
[ns1:Length] AS [LENGTH], 
[ns1:Count] AS [Count] ,
CAST(((CAST([ns1:Count] as float) / CAST([rowcount51] as float) ) * 100) as Decimal(10,4)) as [Percentage] 
FROM WF_PF_SupplierMaster where ProfileRequestid44 = 'LengthDistReq' ORDER BY Name52
--SqlDbType53,  [MaxLength54], [Precision55], Scale56, IsNullable59, 

-- ValueDistReq -- Done
select
DataSource66 as DataSource, 
database67 as DB, 
[schema68] as [Schema], 
[table69] as TableName, 
ProfileRequestid64,
[rowcount70] as #Rows, 
Name71 as ColumnName,
[ns1:NumberOfDistinctValues] as [Number of Distinct Values],	
[ns1:Value] AS [Value],	
[ns1:Count80] AS [Count],
CAST(((CAST([ns1:Count80] as float) / CAST([rowcount70] as float) ) * 100) as Decimal(10,4)) as [Percentage] 
FROM WF_PF_SupplierMaster where ProfileRequestid64 = 'ValueDistReq' ORDER BY Name71, [ns1:Value] 
--Select * FROM WF_PF_SupplierMaster where ProfileRequestid64 = 'ValueDistReq'
-- SqlDbType72,  [MaxLength73], [Precision74], Scale75, IsNullable78, 

-- ValueDistReq
select
DataSource84 as DataSource, 
database85 as DB, 
[schema86] as [Schema], 
[table87] as TableName, 
ProfileRequestid82,
[rowcount88] as #Rows, 
Name89 as ColumnName, 
Name89 as ColumnName, SqlDbType90, 
[MaxLength91], [Precision92], Scale93, IsNullable96, [ns1:IsExactKey] AS IsExactKey
FROM WF_PF_SupplierMaster where ProfileRequestid82 = 'KeyReq' ORDER BY Name89

Select * FROM WF_PF_SupplierMaster where ProfileRequestid82 = 'KeyReq' ORDER BY Name89 

Select * FROM [dbo].[WF_PF_InvoiceHeader] where ProfileRequestid82 = 'KeyReq' ORDER BY Name89 



select
DataSource84 as DataSource, 
database85 as DB, 
[schema86] as [Schema], 
[table87] as TableName, 
ProfileRequestid82,
[rowcount88] as #Rows, 
Name89 as ColumnName, 
[ns1:KeyStrength],
[ns1:ColumnValue],
[ns1:Count98],
CAST(((CAST([ns1:Count98] as float) / CAST([rowcount88] as float) ) * 100) as Decimal(10,4)) as [Percentage] 
--FROM WF_PF_SupplierMaster where ProfileRequestid82 = 'KeyReq' ORDER BY Name89
FROM [dbo].[WF_PF_InvoiceHeader] where ProfileRequestid82 = 'KeyReq' ORDER BY Name89
-- [MaxLength91], [Precision92], Scale93, IsNullable96, [ns1:IsExactKey] AS IsExactKey


Select top 0 *
INTO [dbo].[WF_PF_InvoiceHeader_JN]
FROM [dbo].[WF_PF_InvoiceHeader]

INSERT INTO [dbo].[WF_PF_InvoiceHeader_JN]
-- SELECT * FROM [dbo].[WF_PF_InvoiceHeader] where ProfileRequestid82 = 'KeyReq' ORDER BY Name89 -- (201 row(s) affected)
SELECT * FROM [dbo].[WF_PF_SupplierMaster] where ProfileRequestid82 = 'KeyReq' ORDER BY Name89

INSERT INTO [dbo].[WF_PF_InvoiceHeader_JN] 
(
[ns1:ProfileVersion],
[ID],
[Name],
[ns1:DtsConnectionManagerID],
[ns1:ProfileMode],
[ns1:Timeout],
[ID2],
[ns1:DataSourceID],
[Schema],
[Table],
[IsWildCard],
[ID3],
[ns1:DataSourceID4],
[Schema5],
[Table6],
[IsWildCard7],
[ID8],
[ns1:DataSourceID9],
[Schema10],
[Table11],
[IsWildCard12],
[ns1:IgnoreLeadingSpace],
[ns1:IgnoreTrailingSpace],
[ID13],
[ns1:DataSourceID14],
[Schema15],
[Table16],
[IsWildCard17],
[ns1:Option],
[ns1:FrequentValueThreshold],
[ID18],
[ns1:DataSourceID19],
[Schema20],
[Table21],
[IsWildCard22],
[ns1:ThresholdSetting],
[ns1:KeyStrengthThreshold],
[ns1:VerifyOutputInFastMode],
[ns1:MaxNumberOfViolations],
[ProfileRequestID],
[IsExact],
[ns1:DataSourceID23],
[DataSource],
[Database],
[Schema24],
[Table25],
[RowCount],
[Name26],
[SqlDbType],
[MaxLength],
[Precision],
[Scale],
[LCID],
[CodePage],
[IsNullable],
[StringCompareOptions],
[ns1:NullCount],
[IsExact27],
[ProfileRequestID28],
[ns1:DataSourceID29],
[DataSource30],
[Database31],
[Schema32],
[Table33],
[RowCount34],
[Name35],
[SqlDbType36],
[MaxLength37],
[Precision38],
[Scale39],
[LCID40],
[CodePage41],
[IsNullable42],
[StringCompareOptions43],
[ns1:MinValue],
[ns1:MaxValue],
[ns1:Mean],
[ns1:StdDev],
[ProfileRequestID44],
[IsExact45],
[ns1:DataSourceID46],
[DataSource47],
[Database48],
[Schema49],
[Table50],
[RowCount51],
[Name52],
[SqlDbType53],
[MaxLength54],
[Precision55],
[Scale56],
[LCID57],
[CodePage58],
[IsNullable59],
[StringCompareOptions60],
[ns1:IgnoreLeadingSpace61],
[ns1:IgnoreTrailingSpace62],
[ns1:MinLength],
[ns1:MaxLength],
[ns1:Length],
[ns1:Count],
[IsExact63],
[ProfileRequestID64],
[ns1:DataSourceID65],
[DataSource66],
[Database67],
[Schema68],
[Table69],
[RowCount70],
[Name71],
[SqlDbType72],
[MaxLength73],
[Precision74],
[Scale75],
[LCID76],
[CodePage77],
[IsNullable78],
[StringCompareOptions79],
[ns1:NumberOfDistinctValues],
[ns1:Value],
[ns1:Count80],
[IsExact81],
[ProfileRequestID82],
[ns1:DataSourceID83],
[DataSource84],
[Database85],
[Schema86],
[Table87],
[RowCount88],
[Name89],
[SqlDbType90],
[MaxLength91],
[Precision92],
[Scale93],
[LCID94],
[CodePage95],
[IsNullable96],
[StringCompareOptions97],
[ns1:IsExactKey]
)
SELECT 
[ns1:ProfileVersion],
[ID],
[Name],
[ns1:DtsConnectionManagerID],
[ns1:ProfileMode],
[ns1:Timeout],
[ID2],
[ns1:DataSourceID],
[Schema],
[Table],
[IsWildCard],
[ID3],
[ns1:DataSourceID4],
[Schema5],
[Table6],
[IsWildCard7],
[ID8],
[ns1:DataSourceID9],
[Schema10],
[Table11],
[IsWildCard12],
[ns1:IgnoreLeadingSpace],
[ns1:IgnoreTrailingSpace],
[ID13],
[ns1:DataSourceID14],
[Schema15],
[Table16],
[IsWildCard17],
[ns1:Option],
[ns1:FrequentValueThreshold],
[ID18],
[ns1:DataSourceID19],
[Schema20],
[Table21],
[IsWildCard22],
[ns1:ThresholdSetting],
[ns1:KeyStrengthThreshold],
[ns1:VerifyOutputInFastMode],
[ns1:MaxNumberOfViolations],
[ProfileRequestID],
[IsExact],
[ns1:DataSourceID23],
[DataSource],
[Database],
[Schema24],
[Table25],
[RowCount],
[Name26],
[SqlDbType],
[MaxLength],
[Precision],
[Scale],
[LCID],
[CodePage],
[IsNullable],
[StringCompareOptions],
[ns1:NullCount],
[IsExact27],
[ProfileRequestID28],
[ns1:DataSourceID29],
[DataSource30],
[Database31],
[Schema32],
[Table33],
[RowCount34],
[Name35],
[SqlDbType36],
[MaxLength37],
[Precision38],
[Scale39],
[LCID40],
[CodePage41],
[IsNullable42],
[StringCompareOptions43],
[ns1:MinValue],
[ns1:MaxValue],
[ns1:Mean],
[ns1:StdDev],
[ProfileRequestID44],
[IsExact45],
[ns1:DataSourceID46],
[DataSource47],
[Database48],
[Schema49],
[Table50],
[RowCount51],
[Name52],
[SqlDbType53],
[MaxLength54],
[Precision55],
[Scale56],
[LCID57],
[CodePage58],
[IsNullable59],
[StringCompareOptions60],
[ns1:IgnoreLeadingSpace61],
[ns1:IgnoreTrailingSpace62],
[ns1:MinLength],
[ns1:MaxLength],
[ns1:Length],
[ns1:Count],
[IsExact63],
[ProfileRequestID64],
[ns1:DataSourceID65],
[DataSource66],
[Database67],
[Schema68],
[Table69],
[RowCount70],
[Name71],
[SqlDbType72],
[MaxLength73],
[Precision74],
[Scale75],
[LCID76],
[CodePage77],
[IsNullable78],
[StringCompareOptions79],
[ns1:NumberOfDistinctValues],
[ns1:Value],
[ns1:Count80],
[IsExact81],
[ProfileRequestID82],
[ns1:DataSourceID83],
[DataSource84],
[Database85],
[Schema86],
[Table87],
[RowCount88],
[Name89],
[SqlDbType90],
[MaxLength91],
[Precision92],
[Scale93],
[LCID94],
[CodePage95],
[IsNullable96],
[StringCompareOptions97],
[ns1:IsExactKey]
FROM [dbo].[WF_PF_SupplierMaster] where ProfileRequestid82 = 'KeyReq' ORDER BY Name89
-- 2






[dbo].[WF_PF_AGM_Fact_Full]
[dbo].[WF_PF_BusinessUnit]
[dbo].[WF_PF_Category]
[dbo].[WF_PF_InvoiceHeader]
[dbo].[WF_PF_SupplierMaster]


