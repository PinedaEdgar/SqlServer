-- ============================================
-- Name: _Subqueries
-- Author: E.Pineda
-- Comments: Gets the Size for each database
-- ============================================

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Scalar subquery
-- Note: To be valid, it must return no more than one value. otherwise, it may fail.
--           For multivalue use the "IN" predicate. 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- SAMPLE 1 (Query #1 and Query #2 do the same).

-- Query #1
DECLARE @VendorName as Varchar(50) = (select max(iVend_name) from RITE_AID_CORP_LI_2016_LI_F.dbo.HDR where Apvend = '43745')

SELECT * FROM RITE_AID_CORP_LI_2016_LI_F.dbo.vngen_dbf_16FY where VEND_NAME = @VendorName

-- Query #2
SELECT * 
FROM  RITE_AID_CORP_LI_2016_LI_F.dbo.vngen_dbf_16FY 
where VEND_NAME = (select max(iVend_name) from RITE_AID_CORP_LI_2016_LI_F.dbo.HDR where Apvend = '43745')

-- SAMPLE 2 (Query #3 and Query #4 do the same).

-- Query #3
DECLARE @MaxGross as Decimal(13,2) = (select max(GROSS_AMT) from RITE_AID_CORP_LI_2016_LI_F.dbo.HDR )

SELECT Apvend, iVend_name, Invoice, CHK_TRC_NO, GROSS_AMT, DSC_AMT, NET_AMT, CR_PO_NO 
FROM RITE_AID_CORP_LI_2016_LI_F.dbo.HDR
WHERE GROSS_AMT = @MaxGross;

--- Query #4
SELECT Apvend, iVend_name, Invoice, CHK_TRC_NO, GROSS_AMT, DSC_AMT, NET_AMT, CR_PO_NO 
FROM RITE_AID_CORP_LI_2016_LI_F.dbo.HDR
WHERE GROSS_AMT = (select max(GROSS_AMT) from RITE_AID_CORP_LI_2016_LI_F.dbo.HDR );
-- [End]

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Correlated subquery
-- Note: The subquery is dependent on the outer query
--           For multivalue use the "IN" predicate. 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- SAMPLE 1 (Pulls info from Vendor table where Vendor Number matches with subquery).
Select VEND_NO, VEND_NAME from RITE_AID_CORP_LI_2016_LI_F.dbo.vngen_dbf_16FY
WHERE VEND_NO IN (select distinct Apvend from RITE_AID_CORP_LI_2016_LI_F.dbo.HDR where  PO_NO is not null)

-- SAMPLE 2
select  Vendorid, paymentid, checknumber, PaymentAmountLOC, PaymentAmountDOC from RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_Payments AS PY
WHERE VendorID = '33284' 
AND EXISTS (SELECT * FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_PaymentLink LK
            WHERE PY.PaymentID = LK.PaymentID)
-- 171

-- SAMPLE 3 (Query 3.1 and Query 3.2 do the same)

-- Query 3.1 
select  Vendorid, paymentid, checknumber, PaymentAmountLOC, PaymentAmountDOC from RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_Payments AS PY
WHERE VendorID = '33284' 
AND NOT EXISTS (SELECT * FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_PaymentLink LK
            WHERE PY.PaymentID = LK.PaymentID)
-- 0 00:03:20

-- Query 3.2
select  Vendorid, paymentid, checknumber, PaymentAmountLOC, PaymentAmountDOC from RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_Payments AS PY
WHERE VendorID = '33284' 
AND paymentid NOT IN (SELECT LK.PaymentID FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_PaymentLink LK);
-- 0 00:03:34

-- Other samples:
select * 
FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.VNADD
WHERE VEND_NBR IN (SELECT TOP 10 VEND_NO from RITE_AID_CORP_QTRLY_2016_APR_C.dbo.VNGEN)
ORDER BY VEND_NBR

-- Test If exist
SELECT top 10 *
FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.TST_InvoiceHeader
WHERE EXISTS
    (SELECT * 
     FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_Payments
     WHERE paymentID = paymentID) 
     
     
SELECT *
FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.TST_InvoiceHeader
WHERE EXISTS
    (SELECT * 
     FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_Payments
     WHERE paymentID = '0006524471 44582'  ) 
        
        
SELECT *
FROM  RITE_AID_CORP_QTRLY_2016_APR_C.dbo.APIHR
WHERE INV_ID IN (SELECT INV_ID FROM RITE_AID_CORP_LI_2016_LI_F.dbo.HDR WHERE INV_ID = '07672116057'  )
--ORDER BY SBSY, Apvend, INV_ID

SELECT p.product_id, p.product_name
FROM products p
WHERE p.product_id IN
   (SELECT inv.product_id
    FROM inventory inv
    WHERE inv.quantity > 10);

-- Very Helpful !
SELECT Distinct VEND_NO, VEND_NAME, sbqry.TotAmt
FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.VNGEN VND, 
 (SELECT VendorID, SUM(PaymentAmountLOC) AS TotAmt
  FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_Payments
  GROUP BY VendorID) sbqry
WHERE sbqry.VendorID = VND.VEND_NO;


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- TABLE EXPRESSIONS
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  Derivated tables
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- DERIVATED TABLES
-- ================

select * 
FROM (Select Distinct VendorID FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_Payments) AS PY -- , paymentID

SELECT COUNT(Distinct VendorID) as VndCount 
FROM (Select VendorID, paymentID FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_Payments ) AS PY -- 87,642
ORDER BY VendorID
-- 1450

Select count(VendorID) as VndCount FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_Payments
-- 87,642
Select count(Distinct VendorID) as VndCount FROM RITE_AID_CORP_QTRLY_2016_APR_C.dbo.Tst_Payments
-- 1,450

