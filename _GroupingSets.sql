-- ============================================================
-- Name: _GroupingSets
-- Author: E.Pineda
-- Comments: GROUPING samples
-- ============================================================

-- =========================================================
--	GROUPING
-- =========================================================

use [RITE_AID_CORP_QTRLY_2016_APR_C]

-- GROUPING SETS
select [VendorID], [CheckNumber], SUM([PaymentAmountLOC]) as [PaymentAmountLOC]
FROM [dbo].[Tst_Payments]
WHERE VendorID IN  (43700, 44507, 44133)
GROUP by 
           GROUPING Sets
		   (
		   ([VendorID], [CheckNumber]),
		   ([VendorID]) ,
		   ([CheckNumber]),
		   ()
		   )
ORDER BY VendorID

-- CUBE
select [VendorID], [CheckNumber], SUM([PaymentAmountLOC]) as [PaymentAmountLOC]
FROM [dbo].[Tst_Payments]
WHERE VendorID IN  (43700, 44507, 44133)
GROUP BY [VendorID], [CheckNumber]
WITH CUBE;

-- ROLLUP
select [VendorID], [CheckNumber], SUM([PaymentAmountLOC]) as [PaymentAmountLOC]
FROM [dbo].[Tst_Payments]
WHERE VendorID IN  (43700, 44507, 44133)
GROUP BY ROLLUP ( [VendorID], [CheckNumber] )


-- GROUPING_ID
select
Grouping_ID ( VendorID, CheckNumber) as GroupingSet, 
 VendorID, CheckNumber , SUM(PaymentAmountLOC) as PaymentAmountLOC
FROM [dbo].[Tst_Payments]
WHERE VendorID IN  (43700, 44507, 44133)
GROUP BY CUBE ( VendorID, CheckNumber ) ;

