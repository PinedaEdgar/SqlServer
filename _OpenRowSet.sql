-- ===========================================================
-- New SQL script
-- Author: E.Pineda
-- ===========================================================
SELECT * FROM calc.SpendPerVendorPerDiscountRate
SELECT * FROM calc.VendorMargin
SELECT * FROM calc.VendorPaymentMethodRatio
SELECT * FROM Config.Sprocs
SELECT * FROM Config.SprocsDependancy
SELECT * FROM dbo.APHist
SELECT * FROM dbo.APHist_InvToBLSummary
SELECT * FROM dbo.aphist_Stage1
SELECT * FROM dbo.aphist_Stage1_batch
SELECT * FROM dbo.aphist_Stage2

SELECT * FROM dbo.APHist_Summary
SELECT * FROM dbo.APHist_Summary_PriorToOverride
SELECT * FROM dbo.aphist_summary_UnknownCategoryPriorToSplit
SELECT * FROM dbo.aphistStage1Key_spend
SELECT * FROM dbo.BI_REP_DPO_CategoryBenchmarks_table
SELECT * FROM dbo.BI_REP_DPO_CategorySummary_table
SELECT * FROM dbo.BI_REP_DPO_CategorySupplierBenchmarksDPO_table
SELECT * FROM dbo.BI_REP_DPO_CategorySupplierBenchmarksDSO_table
SELECT * FROM dbo.BI_REP_DPO_CategoryTargetTerms_input
SELECT * FROM dbo.BI_REP_DPO_CategoryTerms_table 

SELECT * FROM dbo.BI_REP_DPO_SupplierCategory_table
SELECT * FROM dbo.BI_REP_DPO_SupplierDashboard_table
SELECT * FROM dbo.BI_REP_DPO_SupplierSegmentation_table
SELECT * FROM dbo.CategoryDPOMetric
SELECT * FROM dbo.Company
SELECT * FROM dbo.CompanyDPOMetric
SELECT * FROM dbo.CompanyParentTerm_Target
SELECT * FROM dbo.CompanyVendorSCDKSpend
SELECT * FROM dbo.CompanyVendorSCSpend
SELECT * FROM dbo.CompanyVendorSpend

SELECT * FROM dbo.DIM_date
SELECT * FROM dbo.dim_Date_Days
SELECT * FROM dbo.DiscountRate
SELECT * FROM dbo.DiscountType
SELECT * FROM dbo.FuzzyVendorName
SELECT * FROM dbo.Holiday
SELECT * FROM dbo.missingPOTerm_table
SELECT * FROM dbo.ParentVendor
SELECT * FROM dbo.PaymentPolicy
SELECT * FROM dbo.PaymentProcessingMethod

SELECT * FROM dbo.PaymentProcessingMethodDays
SELECT * FROM dbo.PBI_v4_Terms
SELECT * FROM dbo.PlaybookResults
SELECT * FROM dbo.PPMScenario
SELECT * FROM dbo.PPMScenarioCompanyVendor
SELECT * FROM dbo.PPMScenarioConfig
SELECT * FROM dbo.SBU_Dimension
SELECT * FROM dbo.Simulation
SELECT * FROM dbo.spendCategoryCode
SELECT * FROM dbo.T

SELECT * FROM dbo.t2
SELECT * FROM dbo.TEMP
SELECT * FROM dbo.Temp_APHistSimulation
SELECT * FROM dbo.TEMP_aphs1
SELECT * FROM dbo.temp_DatesToAddToDimDate
SELECT * FROM dbo.Temp_Simulation
SELECT * FROM dbo.TEMP_TargetDays
SELECT * FROM dbo.TEMPaphist_ahs1kFix
SELECT * FROM dbo.TEMPaphist_ahs1kFix_batch
SELECT * FROM dbo.TEMPaphist_batch

SELECT * FROM dbo.tempDELETE
SELECT * FROM dbo.TempDELETE2
SELECT * FROM dbo.tempdiscountKeyBLOVerrideUpdate
SELECT * FROM dbo.TempEbertResults20170714
SELECT * FROM dbo.Tempp
SELECT * FROM dbo.TempPOToInv
SELECT * FROM dbo.temppp
SELECT * FROM dbo.tempppp
SELECT * FROM dbo.TempS2
SELECT * FROM dbo.TempS3

SELECT * FROM dbo.TempS4
SELECT * FROM dbo.tempSAMS2016po_vendorDepartment
SELECT * FROM dbo.TEmpSpend
SELECT * FROM dbo.TempTop75Fix
SELECT * FROM dbo.TempVendors
SELECT * FROM dbo.tempVendorsAffectedbyMissingPOterms
SELECT * FROM dbo.tempWMT2015po_vendorDepartment
SELECT * FROM dbo.tempWMT2016po_vendorDepartment
SELECT * FROM dbo.Ticker
SELECT * FROM dbo.TickerMetric

SELECT * FROM dbo.TopVendors
SELECT * FROM dbo.ttt
SELECT * FROM dbo.VendorCategoryWeight
SELECT * FROM dbo.VendorCategoryWeight20170127
SELECT * FROM dbo.VendorCompanyDPOMetric
SELECT * FROM dbo.VendorCompanyDPOMetric_history
SELECT * FROM dbo.VendorDimension
SELECT * FROM dbo.VendorDimensionTemp
SELECT * FROM dbo.VendorDiscountTerm
SELECT * FROM dbo.VendorDiscountTermOverride

SELECT * FROM dbo.VendorDiscountTermSimulation
SELECT * FROM dbo.VendorDPOMetric
SELECT * FROM dbo.VendorDPOMetric_HISTORY
SELECT * FROM dbo.VendorMaster
SELECT * FROM dbo.VendorNameDimension
SELECT * FROM dbo.VendorToParent
SELECT * FROM dbo.WMX_Opportunity_table
SELECT * FROM input.AdditionalDOH
SELECT * FROM input.AdelantoPagoVendors20170223
SELECT * FROM input.categoryDPOMetric_input

SELECT * FROM input.CategoryTARGETS
SELECT * FROM input.FactoringVendors
SELECT * FROM input.ManualTermsToAdd
SELECT * FROM input.normalisationUpdate201701018
SELECT * FROM input.ProntoPagoVendors20170223
SELECT * FROM input.SAMS Vendor By Category (Copia de Ventas por proveedor) - Receipts
SELECT * FROM input.SAMS Vendor By Category (Copia de Ventas por proveedor) - Sales
SELECT * FROM input.SAMScategories
SELECT * FROM input.SupplierMargin
SELECT * FROM input.SupplierRevenue

SELECT * FROM input.topVendorFromsPune20170105
SELECT * FROM input.topVendorsFromPune20161216
SELECT * FROM input.VEndorComapnyTreasuryTarget
SELECT * FROM input.VendorCompanyDPOMetric_input
SELECT * FROM input.VendorCompanyMetric
SELECT * FROM input.VendorDPOMetric_input
SELECT * FROM input.VendorMetric
SELECT * FROM input.VendorPlayBookRank20170209
SELECT * FROM input.WMTExtracategories
SELECT * FROM input.WMX Vendor By Category (Supplier__Dep)

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

USE [DollarGeneralOptix]
GO

use [WalmartProductOptixStaging]


select top 1000 * from [Staging].[Ledger]


use [WalmartProductOptixStaging]

DECLARE @myfile varchar(800)

SET @myfile = 'C:\Users\epined01\Documents\openrowset.xls;'

EXEC ('
insert into OPENROWSET(''Microsoft.Jet.OLEDB.4.0'', 
''Excel 8.0;Database=' + @myfile + ';'', 
''SELECT * FROM [SheetName$]'') 
select top 100 * FROM  [Reference].[Country]
')

insert into OPENROWSET('Microsoft.Jet.OLEDB.4.0', 
'Excel 8.0;Database=C:\Users\epined01\openrowset.xls;', 
'SELECT * FROM [SheetName$]') 
select top 100 * FROM  [Reference].[Country]

SELECT * FROM OPENROWSET('MICROSOFT.JET.OLEDB.4.0','Text;Database=C:\Users\epined01\Documents\;','SELECT * FROM [openrowset.xls]')

select @@VERSION

