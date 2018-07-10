-- ===========================================================
-- Script Name : _SplitValuesToRows
-- Author      : E.Pineda
-- Date        : 2017-06-14
-- Comments    : Split variables data from a column into rows
-- ===========================================================

use [SORIANA_MX_2015_C]

-- STEP 1. Insert a delimiter in order to separate the values.

IF OBJECT_ID ('WF_Discounts', 'U') IS NOT NULL
DROP TABLE WF_Discounts

Select  Id_Num_CondCompDcto, Desc_CondCompDcto = REPLACE(Desc_CondCompDcto , ')' , ')|'), 
Abrev_CondCompDcto, ddPorc_FactorDcto, UserId, Fec_Movto, Negocio
INTO dbo.WF_Discounts
FROM Vw_CondCompDcto_JN 
--

-- STEP 2. Split the multivalues(Multiple Discounts)  into multi-rows.

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

IF OBJECT_ID ('WF_DiscountsInRows', 'U') IS NOT NULL
DROP TABLE WF_DiscountsInRows
GO
WITH cte_Discounts (Id_Num_CondCompDcto, DiscountItem, [Desc_CondCompDcto], Abrev_CondCompDcto, ddPorc_FactorDcto, UserId, Fec_Movto, Negocio)  as
(
  select Id_Num_CondCompDcto,
    cast(left(Desc_CondCompDcto, charindex('|',Desc_CondCompDcto+'|')-1) as varchar(50)) DiscountItem,
         stuff(Desc_CondCompDcto, 1, charindex('|',Desc_CondCompDcto+'|'), '') Desc_CondCompDcto,
		 Abrev_CondCompDcto, ddPorc_FactorDcto, UserId, Fec_Movto, Negocio
  from [dbo].[WF_Discounts]
  union all
  select Id_Num_CondCompDcto,
    cast(left(Desc_CondCompDcto, charindex('|',Desc_CondCompDcto+'|')-1) as varchar(50)) DiscountItem,
    stuff(Desc_CondCompDcto, 1, charindex('|',Desc_CondCompDcto+'|'), '') Desc_CondCompDcto,
	Abrev_CondCompDcto, ddPorc_FactorDcto, UserId, Fec_Movto, Negocio
  from cte_Discounts
  where Desc_CondCompDcto > ''
) 
select Id_Num_CondCompDcto, RTRIM(LTRIM(DiscountItem)) AS DiscountItem, Abrev_CondCompDcto, ddPorc_FactorDcto, UserId, Fec_Movto, Negocio
Into dbo.WF_DiscountsInRows
from cte_Discounts
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
-- -- (81,722 row(s) affected)

STEP 3. Test Q/A results
select * from Vw_CondCompDcto_JN where Id_Num_CondCompDcto = 29113
select * from WF_Discounts where Id_Num_CondCompDcto = 29113
select * from WF_DiscountsInRows where Id_Num_CondCompDcto = 29113

STEP 4. Get the list of Discounts in order to build the CASES or PIVOT table.

Select Distinct DiscountItem from WF_DiscountsInRows order by DiscountItem
-- 16,424 

STEP 5. The world is yours ....
--- Continue with your logic 

