-- ================================================================
-- _Apply 
-- ================================================================


use [LATAM_Statistics]

select * from sys.tables

exec sys.sp_columns 'PRGSTATS' 
exec sys.sp_helpconstraint 'PRGSTATS' 

select * from [dbo].[WF_Clients]


SELECT 
    soh.SalesOrderID
    ,soh.OrderDate
    ,sod.max_unit_price
FROM AdventureWorks.Sales.SalesOrderHeader AS soh
OUTER APPLY
(
    SELECT 
        max_unit_price = MAX(sod.UnitPrice)
    FROM Sales.SalesOrderDetail AS sod
    WHERE soh.SalesOrderID = sod.SalesOrderID
) sod


select c.CountryName, c.countrycode , jn.ClientName from [dbo].[VW_Countries] AS c
OUTER APPLY
(SELECT clt.ClientID, clt.ClientName FROM [WF_Clients] AS clt
where c.CountryCode = clt.countrycode) AS jn
order by c.CountryName
-- 160 (all rows)

select c.CountryName, c.countrycode , jn.ClientName from [dbo].[VW_Countries] AS c
CROSS APPLY
(SELECT clt.ClientID, clt.ClientName FROM [WF_Clients] AS clt
where c.CountryCode = clt.countrycode) AS jn
order by c.CountryName
-- 156 (only matching rows)

select c.CountryName, c.countrycode , jn.ClientName from [dbo].[VW_Countries] AS c
OUTER APPLY
(SELECT clt.ClientID, clt.ClientName FROM [WF_Clients] AS clt
where c.CountryCode = clt.countrycode) AS jn
order by c.CountryName
-- 160 (all rows)

select count(*) from [dbo].[VW_Countries] AS c
CROSS APPLY
(SELECT clt.ClientID, clt.ClientName FROM [WF_Clients] AS clt
where c.CountryCode = clt.countrycode) AS jn
-- 156 (only matching rows)

select count(*) from [dbo].[VW_Countries] AS c
OUTER APPLY
(SELECT clt.ClientID, clt.ClientName FROM [WF_Clients] AS clt
where c.CountryCode = clt.countrycode) AS jn
-- 160

select count(*) from [dbo].[VW_Countries] AS c
OUTER APPLY
(SELECT clt.ClientID, clt.ClientName FROM [WF_Clients] AS clt
where c.CountryCode <> clt.countrycode) AS jn
-- 2,580

