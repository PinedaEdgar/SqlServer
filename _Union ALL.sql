-- ============================================
-- Name: _Union All
-- Author: E.Pineda
-- Comments: How to MERGE tables
-- ============================================

-- =========================================================
--	USING MERGE to Insert rows that not exist one one file
-- =========================================================
-- SAMPLE #1 - Using CTE
DROP table REGUH
with cte as
(
SELECT * FROM [dbo].[REGUH_03]
UNION ALL
Select * FROM [dbo].[REGUH_04]
UNION ALL
Select * FROM [dbo].[REGUH_05]
UNION ALL
Select * FROM [dbo].[REGUH_06]
UNION ALL
Select * FROM [dbo].[REGUH_07]
UNION ALL
Select * FROM [dbo].[REGUH_08]
UNION ALL
Select * FROM [dbo].[REGUH_09]
UNION ALL
Select * FROM [dbo].[REGUH_10]
UNION ALL
Select * FROM [dbo].[REGUH_11]
UNION ALL
Select * FROM [dbo].[REGUH_12]
UNION ALL
Select * FROM [dbo].[REGUH_13]
)
Select * INTO dbo.REGUH FROM cte
(3,356,926 row(s) affected)


-- SAMPLE #2 - Using SELECT
Select * INTO dbo.REGUH
FROM (
SELECT * FROM [dbo].[REGUH_03]
UNION ALL
Select * FROM [dbo].[REGUH_04]
UNION ALL
Select * FROM [dbo].[REGUH_05]
UNION ALL
Select * FROM [dbo].[REGUH_06]
UNION ALL
Select * FROM [dbo].[REGUH_07]
UNION ALL
Select * FROM [dbo].[REGUH_08]
UNION ALL
Select * FROM [dbo].[REGUH_09]
UNION ALL
Select * FROM [dbo].[REGUH_10]
UNION ALL
Select * FROM [dbo].[REGUH_11]
UNION ALL
Select * FROM [dbo].[REGUH_12]
UNION ALL
Select * FROM [dbo].[REGUH_13]
) as Joined
(3,356,926 row(s) affected)