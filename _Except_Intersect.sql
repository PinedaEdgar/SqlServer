-- ============================================================
-- Name: _Except And Itersect
-- Author: E.Pineda
-- Comments: Gets Common and Non-common rows between datasets
-- ============================================================

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

