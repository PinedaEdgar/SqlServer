-- ============================================
-- Name: _Merge
-- Author: E.Pineda
-- Comments: How to MERGE tables
-- ============================================

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
