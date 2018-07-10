-- ============================================
-- Name: _Subqueries
-- Author: E.Pineda
-- Comments: Gets the Size for each database
-- ============================================

-- ===========================================================================
select * from Information_Schema.Tables  order by table_type, table_name
select * from Information_Schema.Columns 
select * from Information_Schema.Views 
select * from Information_Schema.View_Table_Usage
select * from Information_Schema.View_Column_Usage 
select * from Information_Schema.Routines 
select * from Information_Schema.Parameters 
-- ===========================================================================
-- MULTIPLE DELETED --
-- ===================
a) 
DELETE FROM dbo.Employee WHERE DepartmentId IN ( SELECT DepartmentId 
												 FROM dbo.Department 
												 WHERE LocationId = 95 ); 
												 
DELETE FROM dbo.Department WHERE LocationId = 95;

b) this option does the same as (a)
MERGE dbo.Employee 
USING dbo.Department 
ON Employee.DepartmentId = Department.DepartmentId 
WHEN MATCHED AND LocationId = 95 THEN DELETE;


-- =========================================================
--	USING MERGE to Insert rows that not exist one one file
-- =========================================================
-- SAMPLE:
select * 
Into dbo.tst_Countries_1
from dbo.VW_Countries
where countryid < 330

-- select * from tst_Countries_1 -- 8 rows

select * 
Into dbo.tst_Countries_2
from dbo.VW_Countries
where countryid > 330
-- select * from tst_Countries_2 -- 8 rows


MERGE dbo.tst_Countries_1 AS T
USING dbo.tst_Countries_2 AS S
ON (T.countryid = S.countryid)
WHEN NOT MATCHED THEN
    INSERT (CountryID, CountryName, CountryCode, CountryCode_ISO3, Region, Division, ISO_Code_3166_2)
        VALUES (S.CountryID, S.CountryName, S.CountryCode, S.CountryCode_ISO3, S.Region, S.Division, S.ISO_Code_3166_2);
-- select count(*) from tst_Countries_1 -- 16 rows after the count

-- =========================================================
--	USING EXCEPT/INTERSECT
-- =========================================================

select * from dbo.SupplierCategory_EDI -- 1709 rows
select * from dbo.SupplierCategory_PO  -- 1911 rows

-- ---------------------------------------------------------
-- Intersec (Rows that belongs to both data sets)
-- ---------------------------------------------------------

select VENDOR from dbo.SupplierCategory_EDI
INTERSECT
select VENDOR from dbo.SupplierCategory_PO
-- 1508

select * from dbo.SupplierCategory_EDI where VENDOR = '92445'
select * from dbo.SupplierCategory_PO  where VENDOR = '92445'

VENDOR	SupplierName		Spend		NewDPOCategory	rnk
92445	HIGH TIME PRODUCTS	199324.53	SHAVNG NDS		1
92445	HIGH TIME PRODUCTS	316619.04	SHAVNG NDS		1
* The spend is different

select * from dbo.SupplierCategory_EDI
INTERSECT
select * from dbo.SupplierCategory_PO
-- 47

select * from dbo.SupplierCategory_EDI where VENDOR = '1133518'
select * from dbo.SupplierCategory_PO  where VENDOR = '1133518'
VENDOR	SupplierName			Spend		NewDPOCategory	rnk
1133518	FRESH WATER SYSTEMS INC	54100.00	NOT IN SCOPE	1
1133518	FRESH WATER SYSTEMS INC	54100.00	NOT IN SCOPE	1

-- ---------------------------------------------------------
-- Except - Rows (A-B), rows that belongs to A but not to B
-- ---------------------------------------------------------

select VENDOR from dbo.SupplierCategory_EDI
EXCEPT
select VENDOR from dbo.SupplierCategory_PO
-- 199

select * from dbo.SupplierCategory_EDI where VENDOR = '105049'
VENDOR	SupplierName	Spend		NewDPOCategory	rnk
105049	CHOICE BOOKS	517575.44	N/A				1

select * from dbo.SupplierCategory_PO  where VENDOR = '105049'
-- Not found

-- The opposite table
select VENDOR from dbo.SupplierCategory_PO
EXCEPT
select VENDOR from dbo.SupplierCategory_EDI
-- 402


select * from dbo.SupplierCategory_EDI where VENDOR = '103598'
-- Not found

select * from dbo.SupplierCategory_PO  where VENDOR = '103598'
VENDOR	SupplierName		Spend		NewDPOCategory		rnk
103598	EMPRESAS LA FAMOSA	9273.60		GENERAL MERCHANDISE	1





EDI Invoice HDR 
EDI Invoice DTL

Payment Invoices
Payment AP

PO Hdr
PO Dtl

Vendor Master


use RITE_AID_CORP_QTRLY_2015_APR_C_COMP
select * from Information_Schema.Tables
where left(table_name,2) = 'SL'



