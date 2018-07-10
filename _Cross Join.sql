/* ===========================================================
	Script Name: _CrossJoin
	Description: Union two table without keys or column joins
	a) Union all
	b) Cross Join
   =========================================================== */
-- ======================================
-- (A)	Union all
-- ======================================
IF OBJECT_ID('dbo.WF_PmtTrms', 'U') IS NOT NULL
DROP TABLE dbo.WF_PmtTrms;

WITH cte_terms AS
(
	SELECT Distinct CAST(1 as int) AS Ledgerid, [PmtTrms], [PmtTrmsDesc] FROM [CircleKProjectStaging].[dbo].[STDPMT]
)
SELECT * 
INTO [CircleKProjectStaging].dbo.WF_PmtTrms
FROM (
  -- GL
		SELECT a.[Ledgerid], a.[CompanyREF], a.[CompanyDescription], b.[PmtTrms], b.[PmtTrmsDesc]
		FROM [CircleKOptixStaging].[Staging].[Company] a
		FULL OUTER JOIN cte_terms b 
		ON a.Ledgerid = b.Ledgerid
		WHERE a.[CompanyREF] = 'GL'
UNION
-- HLD
		SELECT a.[Ledgerid], a.[CompanyREF], a.[CompanyDescription], b.[PmtTrms], b.[PmtTrmsDesc]
		FROM [CircleKOptixStaging].[Staging].[Company] a
		FULL OUTER JOIN cte_terms b 
		ON a.Ledgerid = b.Ledgerid
		WHERE a.[CompanyREF] = 'HLD'
UNION
-- MW
		SELECT a.[Ledgerid], a.[CompanyREF], a.[CompanyDescription], b.[PmtTrms], b.[PmtTrmsDesc]
		FROM [CircleKOptixStaging].[Staging].[Company] a
		FULL OUTER JOIN cte_terms b 
		ON a.Ledgerid = b.Ledgerid
		WHERE a.[CompanyREF] = 'MW'
UNION
-- N A
		SELECT a.[Ledgerid], a.[CompanyREF], a.[CompanyDescription], b.[PmtTrms], b.[PmtTrmsDesc]
		FROM [CircleKOptixStaging].[Staging].[Company] a
		FULL OUTER JOIN cte_terms b 
		ON a.Ledgerid = b.Ledgerid
		WHERE a.[CompanyREF] = 'N A'
UNION
-- NE
		SELECT a.[Ledgerid], a.[CompanyREF], a.[CompanyDescription], b.[PmtTrms], b.[PmtTrmsDesc]
		FROM [CircleKOptixStaging].[Staging].[Company] a
		FULL OUTER JOIN cte_terms b 
		ON a.Ledgerid = b.Ledgerid
		WHERE a.[CompanyREF] = 'NE'
UNION
-- RDK
		SELECT a.[Ledgerid], a.[CompanyREF], a.[CompanyDescription], b.[PmtTrms], b.[PmtTrmsDesc]
		FROM [CircleKOptixStaging].[Staging].[Company] a
		FULL OUTER JOIN cte_terms b 
		ON a.Ledgerid = b.Ledgerid
		WHERE a.[CompanyREF] = 'RDK'
) as JoinTables

-- select * from [CircleKProjectStaging].dbo.WF_PmtTrms

-- ======================================
-- (B)
-- ======================================
SELECT DISTINCT [Ledgerid] = CAST(1 as int), a.[CompanyREF], a.[CompanyDescription], b.[PmtTrms], b.[PmtTrmsDesc]
FROM [CircleKOptixStaging].[Staging].[Company] a
CROSS JOIN [CircleKProjectStaging].[dbo].[STDPMT] b
ORDER BY a.CompanyREF;
-- =======================================

