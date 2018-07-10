-- ============================================================
-- Name: _PIVOT
-- Author: E.Pineda
-- Comments: PIVOT/UNPIVOT samples
-- ============================================================

-- =========================================================
--	PIVOT
-- =========================================================

use [RITE_AID_CORP_QTRLY_2016_APR_C]


-- SAMPLE #1
select Stat_CDE, RowCnt = count(*) from  [dbo].[VNGEN] 
Group by Stat_CDE
Stat_CDE	RowCnt
3				8,187
2				501
1				40,510
0				3,521

select Stat_CDE,
		 CASE WHEN Stat_CDE = '0' THEN count(*)  END as A,
		 CASE WHEN Stat_CDE = '1' THEN count(*)  END as B,
		 CASE WHEN Stat_CDE = '2' THEN count(*)  END as C,
		 CASE WHEN Stat_CDE = '3' THEN count(*)  END as D
FROM   [dbo].[VNGEN] 
GROUP BY Stat_CDE

Stat_CDE	A			B			C			D
3				NULL	NULL	NULL	8187
2				NULL	NULL	501		NULL
1				NULL	40510	NULL	NULL
0				3521		NULL	NULL	NULL

-- Using Pivot
-- Note: Use "[]" when Identifiers are irregular(for example, when they start with a digit).
SELECT  [0], [1], [2], [3], [4]
FROM (SELECT Stat_CDE  FROM  [dbo].[VNGEN] ) AS VND
PIVOT (count(Stat_CDE)  FOR Stat_CDE IN (  [0], [1], [2], [3], [4]) ) AS PVT;
0		1			2		3
3521	40510	501	8187

SELECT distinct PAY_CDE  FROM  [dbo].[VNGEN] -- M, V

SELECT  'Status: ', M, V
FROM (SELECT  PAY_CDE  FROM  [dbo].[VNGEN] ) AS VND
PIVOT (count(PAY_CDE)  FOR PAY_CDE IN ( M, V ) ) AS PVT;
(No column name)		M		V
Status:					194	25545

-- SAMPLE #2
select [VendorID], 
		 SUM(CASE WHEN VendorID = '44582' THEN [PaymentAmountLOC]  END ) as A,
		 SUM(CASE WHEN VendorID = '44593' THEN [PaymentAmountLOC]  END ) as B,
		 SUM(CASE WHEN VendorID = '44635' THEN [PaymentAmountLOC]  END ) as C,
		 SUM(CASE WHEN VendorID = '45042' THEN [PaymentAmountLOC]  END ) as D
FROM (SELECT VendorID, PaymentAmountLOC FROM  [dbo].[Tst_Payments] WHERE VendorID IN ('44582', '44593', '44635', '45042') ) PY
GROUP BY  [VendorID]
VendorID	A				B			C				D
44582		973633.32	NULL	NULL		NULL
44593		NULL	831225.30	NULL		NULL
44635		NULL	NULL		228916.49	NULL
45042		NULL	NULL		NULL		1017566.79

-- Using Pivot
SELECT  'Vendors:',   [44582], [44593], [44635], [45042] 
FROM (SELECT VendorID, PaymentAmountLOC FROM  [dbo].[Tst_Payments] WHERE VendorID IN ('44582', '44593', '44635', '45042') ) PY
PIVOT (SUM(PaymentAmountLOC)  FOR VendorID IN ( [44582], [44593], [44635], [45042] ) ) AS PVT;

(No column name)	44582		44593		44635		45042
Vendors:			973633.32	831225.30	228916.49	1017566.79

-- =========================================================
--	UNPIVOT
-- =========================================================

