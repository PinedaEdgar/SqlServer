--/*********************************************************************
--/* Client: Atlantic Co-Op
--/*         PSQL04\sql2k      - Client Data
--/*         PSQL04\sql2k Atlantic_co_op_ca_2003_AP_W  - Processing db
--/* Data Type: SKU
--/* Audit Period: all data
--/*		 
--/* Input Tables:	C_STRINVOICEHDR
--/*				C_STRINVOICEDTL
--/*				C_STORES
--/*				C_DCD
--/*				C_VENDOR_CSV
--/*				C_PRODUCTS
--/*				C_FORMATS
--/*		 		P_ALWNC_RFRNC_ND
--/*
--/* Output Table: PRSTD_SKU
--/* Author: Christine Brady
--/* Date Created:  09/07/2004
--/* Date Modified: 10/07/2005 by Nellie Eyfa
--/* Date Modified: 12/05/2007 by E.Pineda
--/**********************************************************************



use ATLANTIC_CO_OP_CA_2007_C

--------------------------------------------------
-- Step 1 - Make sure records are unique 
--------------------------------------------------

-- STRINVOICEHDR
select count(*) from dbo.c_strinvoicehdr_20071023 -- 243,538

sp_prggetcollist c_strinvoicehdr_20071023 

-- * ---------------------------------------------------------------------------------------------------------------------------
--	Note: (E.Pineda)
--	Due to different layout column names, I did comment the below statement and created a new one 
--          tryin to keep the column names consistency
-- * ---------------------------------------------------------------------------------------------------------------------------
/*SELECT DISTINCT [HDRKEY], [HDRDATE], [INVNBR], [SHIP2PNTID], [DCDID], [SHIPDATE], [INVTOTAMT]
INTO DBO.P_STRINVOICEHDR_ND
FROM DBO.C_STRINVOICEHDR_20071023
*/

SELECT DISTINCT
 [HDRKEY] = [INVC_HDR_KEY], 
 [HDRDATE] = [INVC_DATE], 
 [INVNBR] = [INVC_NMBR], 
 [SHIP2PNTID] = [SHIP_TO_PNT_ID], 
 [DCDID] = [DCD_ID], 
[SHIPDATE] = [SHIP_DATE], 
[INVTOTAMT] = [INVC_TOT_AMT]
INTO DBO.P_STRINVOICEHDR_ND
FROM DBO.C_STRINVOICEHDR_20071023

-- (516864 row(s) affected)
-- (495502 row(s) affected)  10/05/2005 ne
--(264107 row(s) affected)  12/20/06  dbm  time:  :08
-- (243583 row(s) affected)  12-05-2007



--------------------------------------------------
-- STRINVOICEDTL
--------------------------------------------------
select count(*) from dbo.c_strinvoicedtl_20071023 -- 5,066,798


sp_prggetcollist c_strinvoicedtl

/* SELECT DISTINCT 
	[HDRKEY], [PRDLVLNBR], [POID], [RCPTID], [UNITQTY], [UNITPRC], [UNITUOM], 
	[HISTAMT], [PSTAMT], [QSTAMT], [TBCTAXAMT], [DSCNTAMT], [CARTLRATIO], [QTYPERSTORECST] 
INTO DBO.P_STRINVOICEDTL_ND
FROM DBO.C_STRINVOICEDTL
*/

SELECT DISTINCT 
[HDRKEY] = INVC_HDR_KEY, 
[PRDLVLNBR] = PRD_LVL_NUMBER, 
[POID] = PO_ID, 
[RCPTID] = RCPT_ID, 
[UNITQTY] = UNIT_QTY, 
[UNITPRC] = UNIT_PRC,
 [UNITUOM] = UNIT_UOM, 
[HISTAMT] = HST_AMT, 
[PSTAMT] = PST_AMT,
 [QSTAMT] = QST_AMT, 
[TBCTAXAMT] = TBC_TAX_AMT, 
[DSCNTAMT] = DSCNT_AMT, 
[CARTLRATIO] = CA_RTL_RATIO,
 [QTYPERSTORECST] =  QTY_PER_STORE_COST
INTO DBO.P_STRINVOICEDTL_ND
FROM DBO.C_STRINVOICEDTL_20071023


-- (11640650 row(s) affected)
-- (10994160 row(s) affected)  10/05/2005 ne
--(5581613 row(s) affected)  12/21/06  dbm  time:  3:13
-- (5,063,898 row(s) affected) 12-05-2007 


--------------------------------------------------
-- STORES
--------------------------------------------------
select count(*) from dbo.c_stores_20071023 -- 1,953

sp_prggetcollist c_stores


SELECT DISTINCT [SHIP2POINTID], [STORENAME], [LVLCHILD]
INTO DBO.C_STORES_ND
FROM DBO.C_STORES_20071023
-- (1421 row(s) affected)
-- (1586 row(s) affected) -- no duplicate records, drop table just built
-- (1884 row(s) affected) -- no duplicate records, drop table just built
-- (1,953 row(s) affected) -- no duplicate records, drop table just built - 12-05-2007 


DROP TABLE DBO.C_STORES_ND
--The command(s) completed successfully.  10/06/2005 ne
--The command(s) completed successfully.  12/21/06  dbm



--------------------------------------------------
-- DCD
--------------------------------------------------
select count(*) from dbo.c_dcd_20071023 --35

sp_prggetcollist c_dcd


SELECT DISTINCT [DCDID], [DCDDSCR]
INTO DBO.C_DCD_ND
FROM DBO.C_DCD_20071023
-- (31 row(s) affected) -- no duplicate records, drop table just built
-- (35 row(s) affected) -- no duplicate records, drop table just built


DROP TABLE DBO.C_DCD_ND
--The command(s) completed successfully.  12/21/06  dbm
-- The command(s) completed successfully. 12-05-2007



--------------------------------------------------
-- VENDOR_CSV
--------------------------------------------------
select count(*) from dbo.C_VNDR_20071023 --25,567
select count(*) from  DBO.T_VENDOR -- 25,523

-- build unique Vendors file
SELECT DISTINCT 
    VND_NBR=LTRIM(RTRIM(VENDORID)), 
    VND_NAME=LTRIM(RTRIM(REMITTONAM))
INTO DBO.T_VENDOR
FROM DBO.C_VNDR_20071023
-- (24301 row(s) affected)


--------------------------------------------------
-- PRODUCTS
--------------------------------------------------
select count(*) from dbo.c_products_20071023 -- 22,472

sp_prggetcollist c_products

SELECT DISTINCT[VNDRNBR], [PRDLVLNBR], [PRDNMEFULL], [CAGETPRIM], [VNDRPRDNBR] 
INTO DBO.C_PRODUCTS_ND
FROM DBO.C_PRODUCTS_20071023
--(33047 row(s) affected)
--(33513 row(s) affected)  10/06/2005 ne
--(23802 row(s) affected)  12/21/06  dbm  time:  :17
--(22456 row(s) affected)  12-05-2007

DROP TABLE DBO.C_PRODUCTS_ND  --10/06/2005 NE
-- The command(s) completed successfully.
-- there were dups so didnt DROP the table ...dbm  12/21/06 
-- there were dups so didnt DROP the table ...dbm 12-05-2007

--------------------------------------------------
-- FORMATS
--------------------------------------------------
select count(*) from dbo.c_formats_20071023 -- 32

sp_prggetcollist c_formats

SELECT DISTINCT [LVLCHILD], [LVLPARENT], [LVLID], [NAMEFULL]
INTO DBO.C_FORMATS_ND
FROM DBO.C_FORMATS_20071023
--(31 row(s) affected)
--(32 row(s) affected) 10/06/2005 ne
--(32 row(s) affected) 12/21/06  dbm  time:  :00
--(32 row(s) affected) 12-05-2007

DROP TABLE DBO.C_FORMATS_ND
-- The command(s) completed successfully. 10/06/2005 ne
-- The command(s) completed successfully. 12/21/06  dbm

--------------------------------------------------
-- P_ALWNC_RFRNC_ND
--------------------------------------------------
-- get mapping fields
DROP TABLE DBO.ALWNC_RFRNC_SKU

SELECT DISTINCT 
	SRCID, PRDLVLNBR, CLAIMKEY, AMT, ALWNCKEY
INTO DBO.ALWNC_RFRNC_SKU
FROM DBO.C_ALWNC_RFRNC_20071023
WHERE TYPE=7
-- (115690 row(s) affected)  10/06/2005 ne
--(80342 row(s) affected)  12/21/06  dbm  time:  :08
--(270,264 row(s) affected) 12-05-2007

-----------------------------------------------------------
-- STEP 2 - Check for Dup Keys 
-----------------------------------------------------------

-----------------------------------------------------------
-- Vendor table
-----------------------------------------------------------
SELECT VND_NBR, COUNT(*)
FROM DBO.T_VENDOR
GROUP BY VND_NBR
HAVING COUNT(*) > 1
-- 2
--(3 row(s) affected)  12/21/06  dbm  time:  :00
-- 3,  12-05-2007

VND_NBR             
------- ----------- 
101820	2
103813	2
100882	2


(2 row(s) affected)

-- RUN SAMPLE 
select * from dbo.t_vendor where vnd_nbr='103813'

vnd_nbr vnd_name                                 
------- ---------------------------------------- 
103813  PHILIPS ELECTRONICS IND
103813  PHILIPS LIGHTING CANADA

(2 row(s) affected)



-- get unique records
select distinct
    vnd_nbr,
    vnd_name=max(vnd_name)
into dbo.p_vendor
from dbo.t_vendor
group by vnd_nbr
-- (24299 row(s) affected)
-- table already created from AP  12/21/06  dbm
-- There is already an object named 'p_vendor' in the database. 12-05-2007

-- re-check dups key
SELECT VND_NBR, COUNT(*)
FROM DBO.P_VENDOR
GROUP BY VND_NBR
HAVING COUNT(*) > 1 
-- (0 row(s) affected)
-- (0 row(s) affected)  12/21/06  dbm  time:  :00
-- 0


-----------------------------------------------------------
-- DCD table
-----------------------------------------------------------
SELECT DCDID, COUNT(*)
FROM DBO.C_DCD_20071023
GROUP BY DCDID
HAVING COUNT(*) > 1
-- none
-- (0 row(s) affected)  12/21/06  dbm  time:  :00
-- 0, 12-05-2007

-----------------------------------------------------------
-- Format table
-----------------------------------------------------------
SELECT LVLCHILD, COUNT(*)
FROM DBO.C_FORMATS_20071023
GROUP BY LVLCHILD
HAVING COUNT(*) > 1
-- none
-- (0 row(s) affected)  12/21/06  dbm  time:  :00
-- -- 0, 12-05-2007
-----------------------------------------------------------
-- Invoice Header table
-----------------------------------------------------------
SELECT HDRKEY, COUNT(*)
FROM DBO.P_STRINVOICEHDR_ND
GROUP BY HDRKEY
HAVING COUNT(*) > 1
-- none
-- (0 row(s) affected)  12/21/06  dbm  time:  :00


--Email from Tony Dexter on 10/21/2005
--Hi
--Here is a listing on the Vendors that actually have deals associated with the data.  
--I had meant to give this to you last week but I overlooked this with travel and budget preps.....
--I would only run the total output on these vendors as the others will not be reviewed.
--get only vendors from this list


-----------------------------------------------------------
-- build file based of mapping fields from Products table
-- matching to driving file and Vendors_list provided
-----------------------------------------------------------
drop table dbo.SKU_DEAL_VENDORS_LIST

select * into dbo.SKU_DEAL_VENDORS_LIST from ATLANTIC_CO_OP_CA_2004_C.[AMER\neyfa01].SKU_Deal_Vendors_List

drop table dbo.p_products_gb

SELECT 
	VNDRNBR, PRDLVLNBR, PRDNMEFULL,VNDRPRDNBR
INTO DBO.P_PRODUCTS_GB
FROM DBO.C_PRODUCTS_20071023
WHERE VNDRNBR IN (SELECT VNDRNBR FROM dbo.[SKU_DEAL_VENDORS_LIST])  
AND PRDLVLNBR IN 
		(SELECT PRDLVLNBR 
				FROM DBO.C_STRINVOICEDTL_20071023 A INNER JOIN DBO.C_STRINVOICEHDR_20071023 B ON
						    A.INVC_HDR_KEY=B.INVC_HDR_KEY)
--						    A.HDRKEY=B.HDRKEY)
-- (3743 row(s) affected) 10/21/2005 ne
-- (2443 row(s) affected) 12/21/06  dbm  time:  1:41
-- (3,070 row(s) affected) 12-05-2007 E.Pineda

-- * --------------------------------------------------------------------------
-- * Notes:
-- The below Vendor Numbers  have not match on year 2007
-- 100004.0
-- 123779.0
-- * --------------------------------------------------------------------------

select VNDRPRDNBR from DBO.C_PRODUCTS_20071023
group by VNDRPRDNBR order by VNDRPRDNBR

-- check dups key by prdlvlnbr- link to STRINVOICEDTL file
DROP TABLE DBO.PRDLVLNBR_COUNT
SELECT PRDLVLNBR, COUNT(*) AS COUNT
INTO DBO.PRDLVLNBR_COUNT
FROM DBO.P_PRODUCTS_GB 
GROUP BY PRDLVLNBR   
-- (3708 row(s) affected)  10/21/2005 ne
--(2443 row(s) affected)  01/03/07  dbm  time:  :03
-- (3,063 row(s) affected) 12-05-2007

select sum(count) from dbo.prdlvlnbr_count -- 3070
select * from dbo.prdlvlnbr_count where [count]=1 --3056
select * from dbo.prdlvlnbr_count where [count]>1 --7
select * from dbo.prdlvlnbr_count where [count]>1 --7
prdlvlnbr       [count]       
--------------- ----------- 
3061108	2
2808822	2
68544		2
2363190	2

-- run sample
select * from dbo.p_products_gb where prdlvlnbr = 1060557       

/*
VNDRNBR        PRDLVLNBR       PRDNMEFULL                                         VNDRPRDNBR      
-------------- --------------- -------------------------------------------------- --------------- 
100450    	1060557        	KNORR CLASSIC SCE WHITE BECHAMEL 50.00GM	10068400096624 
100450    	1060557        	KNORR CLASSIC SCE WHITE BECHAMEL 50.00GM	10055220080025 

(2 row(s) affected)  -- same items have different vendors and UPC  */





-- make file for the field
DROP TABLE DBO.PRODUCTS_DUP
SELECT DISTINCT A.*, B.[COUNT]
INTO DBO.PRODUCTS_DUP
FROM DBO.P_PRODUCTS_GB A 

INNER JOIN DBO.PRDLVLNBR_COUNT B 
	ON A.PRDLVLNBR=B.PRDLVLNBR
WHERE B.[COUNT]>1
ORDER BY A.PRDLVLNBR
--(70 row(s) affected) 10/21/2005 ne
--(0 row(s) affected)  01/03/07  dbm  time:  :03
-- --(12 row(s) affected) 12-06-2007


-- build file with unique records
DROP TABLE DBO.PRODUCTS_UNIQUE
SELECT DISTINCT A.*
INTO DBO.PRODUCTS_UNIQUE
FROM DBO.P_PRODUCTS_GB A INNER JOIN DBO.PRDLVLNBR_COUNT B ON
    A.PRDLVLNBR=B.PRDLVLNBR
WHERE B.[COUNT]=1
ORDER BY A.PRDLVLNBR
-- (3673 row(s) affected)  10/21/2005 ne
--(2443 row(s) affected)  01/03/07  dbm  time:  :01
-- (3,056 row(s) affected) 12-06-2007



-- Store table
SELECT DISTINCT SHIP2POINTID, COUNT(*)
FROM DBO.C_STORES_20071023
GROUP BY SHIP2POINTID
HAVING COUNT(*) > 1
-- 7
--(6 row(s) affected)  01/03/07  dbm  time:  :01
--(6 row(s) affected)  12-06-2007

ship2pointid             
------------ ----------- 
257	2
915	2
917	2
9212	2
923	2
9970	2


-- run sample
select * from dbo.c_stores_20071023 where ship2pointid='9970'
SHIP2POINTID STORENAME                                          LVLCHILD       PRGRefNbr             
------------ -------------------------------------------------- -------------- --------------------- 
9970		FOOD BANK			19	523
9970		PETROLEUM INDEPENDENTS	19	538

(2 row(s) affected)
-- different by LVLCHILD field

-- 9/10/04 Per David, pull both records.


--ALWNC_RFRNC_SKU table
SELECT DISTINCT SRCID, PRDLVLNBR, COUNT(*)
FROM dbo.C_ALWNC_RFRNC_20071023
GROUP BY SRCID, PRDLVLNBR
HAVING COUNT(*)>1 
-- 5255
--(1383 row(s) affected)  01/03/07  dbm  time:  :05
-- 225,268  12-06-2007   


SRCID      PRDLVLNBR                   
---------- --------------- ----------- 
2750437    0228650         3
2883481    1021757         2
2886770    1021716         2

SRCID      PRDLVLNBR                 (2007)  
---------- --------------- ----------- 
M92065	2932697        	2
3360429	0163576        	4
D02136		2286557        	2
M99829	0091777        	2
M95259	2122752        	3

-- run sample
select * from ALWNC_RFRNC_SKU where
SRCID =3360429 and PRDLVLNBR=0163576

SRCID      PRDLVLNBR       CLAIMKEY       AMT           ALWNCKEY       
---------- --------------- -------------- ------------- -------------- 
3360429	0163576        	86842	-1.920	91423
3360429	0163576        	86842	-1.920	91422
3360429	0163576        	86795	1.920	91395
3360429	0163576        	86795	1.920	91396


--(4 row(s) affected)  different by field ALWNCKEY - part of mapping


-------------------------------------------------------
-- Step 3 Create PRSTD
-------------------------------------------------------
use ATLANTIC_CO_OP_CA_2007_C

----------------------------------------------------------------------------------
-- Join the Header to the Detail getting only those Headers that have Details.
----------------------------------------------------------------------------------


select count(*) from(select distinct HDRKEY from dbo.p_strinvoicehdr_nd) as a --243,583
select count(*) from(select distinct HDRKEY from dbo.p_strinvoicedtl_nd) as a -- 243,583

-- check number of matching records
SELECT DISTINCT HDRKEY
FROM DBO.P_STRINVOICEHDR_ND A
WHERE EXISTS
(SELECT DISTINCT HDRKEY FROM DBO.P_STRINVOICEDTL_ND B WHERE
    A.HDRKEY=B.HDRKEY)
-- 495205
-- 495205/495502=99.99%
--(264060 row(s) affected)  01/03/07  dbm  time:  3:51
--(243,538 row(s) affected) 12-06-2007

-- Mapping said to make ITM_SHIPPED 3,0 but the values go up to 4,0.
SELECT MAX(UNIT_QTY) FROM DBO.C_STRINVOICEDTL_20071023  
-- 3600.00
--999  1/3/07  dbm
-- --99  12-06-2007

CREATE INDEX I_1 ON DBO.P_STRINVOICEHDR_ND(HDRKEY) WITH FILLFACTOR=100
-- The command(s) completed successfully. 10/06/2005 ne
-- The command(s) completed successfully. 01/03/2007 dbm

CREATE INDEX I_1 ON DBO.P_STRINVOICEDTL_ND (HDRKEY) WITH FILLFACTOR=100
-- The command(s) completed successfully. 10/06/2005 ne
-- The command(s) completed successfully. 01/03/2007 dbm  time:  2:50


--/------------------------------------------------------------------
--/ Build output file
--/------------------------------------------------------------------
DROP TABLE DBO.PRSTD_SKU_A
SELECT DISTINCT
    A.HDRKEY,
    A.INVNBR,
    SHIP_DATE	= A.SHIPDATE,
    STR_NBR    	= CAST(A.SHIP2PNTID AS NUMERIC(4,0)),
    WHS_NBR    	= CAST(A.DCDID AS NUMERIC(6,0)),
    CLT_STYLE  	= B.PRDLVLNBR,
    ITM_SHIPPED = CAST(B.UNITQTY AS NUMERIC(4,0))
INTO DBO.PRSTD_SKU_A
FROM DBO.P_STRINVOICEHDR_ND A

LEFT OUTER JOIN DBO.P_STRINVOICEDTL_ND B
		 ON A.HDRKEY = B.HDRKEY

--(11598800 ROW(S) AFFECTED)
--(10938531 row(s) affected) 10/06/2005 ne 0:09:23
--(5561210 row(s) affected)  01/03/07  dbm  time:  5:38
-- (5,045,170 row(s) affected) 12-06-2007

select top 2000 *  from dbo.prstd_sku_a

SELECT COUNT(*) FROM PRSTD_SKU_A WHERE CLT_STYLE IS NULL 
-- 297
--47  1/3/07  dbm
-- 0	12-06-2007

SELECT * FROM PRSTD_SKU_A WHERE CLT_STYLE IS NULL ORDER BY SHIP_DATE
-- 0	12-06-2007

----------------------------------------------------------------------
-- Take the Invoice file and join with Store and DCD file to get info
----------------------------------------------------------------------
CREATE INDEX I_1 ON DBO.C_DCD_20071023 (DCDID) WITH FILLFACTOR=100
--The command(s) completed successfully.
-- The command(s) completed successfully. 01/03/2007 dbm

CREATE INDEX I_1 ON DBO.C_STORES_20071023 (SHIP2POINTID) WITH FILLFACTOR=100
--The command(s) completed successfully.
-- The command(s) completed successfully. 01/03/2007 dbm
select * from  dbo.C_STORES_20071023 where isnumeric(sHIP2POINTID) <> 1
-- 	10	0	277

select LVLCHILD from DBO.C_STORES_20071023
group by LVLCHILD -- Numeric(12,0)
order by LVLCHILD

select SHIP2POINTID, count(*)  from dbo.C_STORES_20071023
group by SHIP2POINTID -- Numeric(12,0)
order by SHIP2POINTID

select  
SHIP2POINTID =  CASE WHEN SHIP2POINTID = '' then '0' Else SHIP2POINTID end,
STORENAME, LVLCHILD, PRGRefNbr
Into dbo.Tmp_STORES_20071023
from dbo.C_STORES_20071023
-- 1,953 12-06-2007

DROP TABLE DBO.PRSTD_SKU_B
SELECT DISTINCT
    A.*,
            BAN_CODE   	= CAST(ISNULL(C.LVLCHILD,0) AS NUMERIC(12,0)),
	STR_NAME      = CAST(ISNULL(C.STORENAME,'')  AS CHAR(50)),
	WHS_NAME    = ISNULL(D.DCDDSCR,'')
INTO DBO.PRSTD_SKU_B
FROM DBO.PRSTD_SKU_A  A

LEFT OUTER JOIN DBO.Tmp_STORES_20071023 C
	ON A.STR_NBR = C.SHIP2POINTID -- STR_NBR (Num 4,0)  = SHIP2POINTID (VarChar(4)

LEFT OUTER JOIN dbo.C_DCD_20071023 D
	ON A.WHS_NBR = D.DCDID

-- (11610626 row(s) affected)
-- (10938531 row(s) affected)  10/06/2005 
-- table PRSTD_SKU_B did not grow in number of records vs PRSTD_SKU_a

--(5561210 row(s) affected)  01/03/07  dbm  time:  5:38
-- (5,045,243 row(s) affected) 12-06-2007

Drop Table dbo.Tmp_STORES_20071023
 
------------------------------------------------------------------------
-- Get the products and vnd_nbr from the Products file 
------------------------------------------------------------------------
CREATE INDEX I_2 ON DBO.P_PRODUCTS_GB (PRDLVLNBR) WITH FILLFACTOR=100
-- The command(s) completed successfully.
-- The command(s) completed successfully. 01/03/2007 dbm

CREATE INDEX I_CLTSTYLE ON DBO.PRSTD_SKU_B (CLT_STYLE) WITH FILLFACTOR=100
-- The command(s) completed successfully.
-- The command(s) completed successfully. 01/03/2007 dbm


-- check dups key - CLT_STYLE
SELECT DISTINCT CLT_STYLE, COUNT(*)
FROM DBO.PRSTD_SKU_B
GROUP BY CLT_STYLE
HAVING COUNT(*)>1 
--24276
--(19164 row(s) affected)  1/3/07  dbm
-- 18,598 12-06-2007

-- there mostly many-to-many relation between PRODUCTS and PRSTD_SKU_B files
-- mostly for produce items

-- run sample
select * from dbo.prstd_sku_b where clt_style = 3241643 order by ship_date --1 records

select  Count(*)
From dbo.prstd_sku_b  a
inner join  dbo.p_products_gb  b   ON
	a.clt_style =  b.prdlvlnbr
-- 966,361  Matches

select  Count(*)
From dbo.prstd_sku_b  a
Left Outer join  dbo.p_products_gb  b   ON
	a.clt_style =  b.prdlvlnbr
	Where b.prdlvlnbr is Null
-- 4,079,469	Do not mat ch

Select min(cast(clt_style as numeric (15,0)) ),  max(cast(clt_style as numeric (15,0)) ) from prstd_sku_b
-- 42		3244779

Select min(cast(prdlvlnbr as numeric (15,0)) ),  max(cast(prdlvlnbr as numeric (15,0)) ) from p_products_gb
-- 44362	3325388



-- run sample
select top 100  * from dbo.p_products_gb where prdlvlnbr = 3241643  -- 1      

/*
VNDRNBR        PRDLVLNBR       PRDNMEFULL                                         VNDRPRDNBR      
-------------- --------------- -------------------------------------------------- --------------- 
100854    	3241643        	LUNCHMATE BOLOGNA STACKERS COMBO 355GR	10062000304004 

(1 row(s) affected)  -- different by VNDRNBR & VNDRPRDNBR fields  */


-- get at first unique CLT_STYLE
DROP TABLE DBO.PRSTD_UPC1
SELECT DISTINCT
    A.*,
	VND_NBR		= CAST(E.VNDRNBR AS CHAR(15)),
	CLTSTYLE	= CAST(E.PRDLVLNBR AS CHAR(15)),
	UPC    		= CAST(E.VNDRPRDNBR AS CHAR(15)),
	ITM_DESC   	= CAST(E.PRDNMEFULL AS CHAR(50))
INTO DBO.PRSTD_UPC1
FROM DBO.PRSTD_SKU_B  A

LEFT OUTER  JOIN DBO.PRODUCTS_UNIQUE E ON
    A.CLT_STYLE = E.PRDLVLNBR

-- (10938531 row(s) affected) 10/18/2005 ne 0:11:18
--(5561210 row(s) affected)  01/03/07  dbm  time:  17:32
-- (5,045,243 row(s) affected)  12-06-2007

SELECT COUNT(*) FROM ATLANTIC_CO_OP_CA_2004_C.dbo.PRSTD_UPC1 WHERE UPC IS NULL
-- 8,269,404

SELECT COUNT(*) FROM PRSTD_UPC1 WHERE UPC IS NULL
-- 4,080,056 

-- aqui..

select * from dbo.P_PRODUCTS_PO where clt_style in 
(select PRDLVLNBR from PRODUCTS_UNIQUE)
-- (0 row(s) affected)

select * from dbo.P_PRODUCTS_PO where clt_style in 
(select PRDLVLNBR from PRODUCTS_UNIQUE)
-- (0 row(s) affected)




--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- GET UPC, ITMDESC FROM PO AND EDI FILES
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


-- VND_NBR in PRODUCTDS file is not unique to CLT_STYLE, mostly for Produce items

-- P_EDI is created in the EDI.SQL script

-- GET FIELDS FROM EDI FILE
DROP TABLE DBO.P_PRODUCTS_EDI
SELECT DISTINCT 
	B.VND_NBR, 
	B.CLT_STYLE, 
	ITMDESC	= MAX(B.ITMDESC),
	UPC		= MAX(B.UPC)
INTO DBO.P_PRODUCTS_EDI
FROM DBO.PRODUCTS_DUP A 
	INNER JOIN DBO.P_EDI B ON
		A.PRDLVLNBR=B.CLT_STYLE
WHERE B.INVQTY<>0
GROUP BY B.VND_NBR, B.CLT_STYLE
-- (0 row(s) affected)  10/18/2005 NE
--(0 row(s) affected)  1/3/07  dbm  time:  :01
--(0 row(s) affected) 12-06-2007


-- check for dups key
SELECT DISTINCT CLT_STYLE, COUNT(*)
FROM DBO.P_PRODUCTS_EDI
GROUP BY CLT_STYLE
HAVING COUNT(*)>1 
--22
--(0 row(s) affected)  1/3/07  dbm
-- 0 12-14-2007
CLT_STYLE                   
--------------- ----------- 

-- SELECT * FROM P_PRODUCTS_EDI WHERE CLT_STYLE=1014349 AND INVDT='2007-11-15'

/*
VND_NBR CLT_STYLE       ITMDESC                                                                     UPC            
------- --------------- --------------------------------------------------------------------------- -------------- 
100174  1014349         CHR MILK LUNCH 12x300G                                                      006672101167  
101047  1014349         CHR MILK LUNCH 12x300G                                                      006672101167  

(2 row(s) affected) -- different VND_NBR for the same proroducts  */

                                                         

--GET FIELDS FROM PO FILE
DROP TABLE DBO.P_PRODUCTS_PO
SELECT DISTINCT
	A.VND_NBR,
	CLT_STYLE=A.CLTSTYLE,
	A.ITMDESC
--	A.VND_STYLE
INTO DBO.P_PRODUCTS_PO
FROM DBO.PRSTD_PO A 

INNER JOIN DBO.PRODUCTS_DUP B ON
	A.CLTSTYLE=B.PRDLVLNBR

WHERE A.CLTSTYLE NOT IN 
	(SELECT CLT_STYLE FROM DBO.P_PRODUCTS_EDI) AND RCVDT >= '9/1/2004'
-- (2199 row(s) affected)  10/24/2005 NE
--(0 row(s) affected)  1/3/07  dbm
-- 0 12-06-2007



SELECT DISTINCT CLT_STYLE, COUNT(*)
FROM DBO.P_PRODUCTS_PO
GROUP BY CLT_STYLE
HAVING COUNT(*)>1 -- 21


CLT_STYLE                   
--------------- ----------- 


SELECT * FROM P_PRODUCTS_PO WHERE CLT_STYLE='0123315'
/*
VND_NBR        CLT_STYLE       ITMDESC                                                      VND_STYLE       
-------------- --------------- ------------------------------------------------------------ --------------- 
                                     

(2 row(s) affected)   */



--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


-- CREATE WORKING INDEXES
CREATE INDEX I_1 ON DBO.PRSTD_UPC1 (CLT_STYLE) WITH FILLFACTOR=100
--The command(s) completed successfully.
--The command(s) completed successfully.  1/3/07  dbm  time:  2:44 

CREATE INDEX I_1 ON DBO.P_PRODUCTS_PO (CLT_STYLE) WITH FILLFACTOR=100
-- The command(s) completed successfully.
--The command(s) completed successfully.  1/3/07  dbm  time:  :01



-- GET FIELDS
SP_PRGGETCOLLIST PRSTD_UPC1, DOWN



-- GET UPC, ITMDESC, FROM 
DROP TABLE DBO.PRSTD_UPC2
SELECT DISTINCT
    A.[HDRKEY],
    A.[INVNBR],
    A.[SHIP_DATE],
    A.[STR_NBR],
    A.[WHS_NBR],
    A.[CLT_STYLE],
    A.[ITM_SHIPPED],
    A.[BAN_CODE],
    A.[STR_NAME],
    A.[WHS_NAME],
    VND_NBR	= CASE WHEN A.VND_NBR IS NULL THEN CAST(F.VND_NBR AS CHAR(15)) ELSE A.VND_NBR END,
    CLTSTYLE = CASE WHEN A.CLTSTYLE IS NULL THEN CAST(F.CLT_STYLE AS CHAR(15)) ELSE A.CLTSTYLE END,
    UPC =  CASE WHEN A.UPC IS NULL THEN CAST('' AS CHAR(15)) ELSE A.UPC END,
--    UPC =  CASE WHEN A.UPC IS NULL THEN CAST(F.VND_STYLE AS CHAR(15)) ELSE A.UPC END,
    ITM_DESC = CASE WHEN A.ITM_DESC IS NULL THEN CAST(F.ITMDESC AS CHAR(15)) ELSE A.ITM_DESC END
INTO DBO.PRSTD_UPC2
FROM DBO.PRSTD_UPC1  A
LEFT OUTER JOIN DBO.P_PRODUCTS_PO F ON
    A.CLT_STYLE = F.CLT_STYLE
-- (10966810 row(s) affected)  10/24/2005 NE 0:07:13
--  10938531

--(5561210 row(s) affected)  1/3/07  dbm
-- (5,045,243 row(s) affected) 12-06-2007


select count(*) from prstd_upc2 where upc is null -- 0  1/3/07  dbm
select count(*) from prstd_upc2 where cltstyle is null --8236394
select count(*) from prstd_upc2 where cltstyle is null -- 4,080,056	12-06-2007

select distinct cltstyle from dbo.PRSTD_UPC2 where cltstyle is null and cltstyle in
(select CLT_STYLE from dbo.P_PRODUCTS_EDI) -- (0 row(s) affected)

sp_prggetcollist PRSTD_UPC2, down


CREATE INDEX I_1 ON DBO.PRSTD_UPC2 (VND_NBR) WITH FILLFACTOR=100
--The command(s) completed successfully.

CREATE INDEX I_2 ON DBO.PRSTD_UPC2 (BAN_CODE) WITH FILLFACTOR=100
--The command(s) completed successfully.

CREATE INDEX I_1 ON DBO.P_VENDOR (VND_NBR) WITH FILLFACTOR=100
--The command(s) completed successfully.




DROP TABLE DBO.PRSTD_SKU_C
SELECT DISTINCT 
    F.VND_NBR, 
    F.VND_NAME,
    A.[INVNBR],
    A.[SHIP_DATE],
    A.[STR_NBR],
    A.[WHS_NBR],
    A.[CLT_STYLE],
    A.[ITM_SHIPPED],
    A.[BAN_CODE],
    BAN_NAME   	 = CAST(G.NAMEFULL AS CHAR(50)),
    A.[STR_NAME],
    A.[WHS_NAME],
    A.[UPC],
    A.[ITM_DESC]
INTO DBO.PRSTD_SKU_C
FROM DBO.PRSTD_UPC2 A

LEFT OUTER JOIN DBO.P_VENDOR F ON
    LTRIM(RTRIM(A.VND_NBR))=LTRIM(RTRIM(F.VND_NBR))

LEFT OUTER JOIN DBO.C_FORMATS_20071023 G ON
    A.BAN_CODE = G.LVLCHILD

WHERE LTRIM(RTRIM(F.VND_NBR)) IN
(SELECT VNDRNBR FROM dbo.[SKU_Deal_Vendors_List])
--(2702991 row(s) affected)  10/24/2005 ne 0:05:12

--(1005807 row(s) affected)  1/3/07  dbm  time:  1:55


select count(*) from prstd_sku_c where vnd_nbr is null-- 0
select count(*) from prstd_sku_c where UPC is null-- 0




--------------------------------------------------------------
-- Step 4 - Create sample Audit Pro
--------------------------------------------------------------


DROP TABLE DBO.PRSTD_SKU
SELECT DISTINCT 
    VND_NAME	= ISNULL(VND_NAME,''),
    VND_NBR		= ISNULL(VND_NBR,''),
    SHIP_DATE,
    BAN_CODE	= ISNULL(BAN_CODE,0),
    BAN_NAME	= ISNULL(BAN_NAME,''),
    STR_NBR		= ISNULL(STR_NBR,0),
    STR_NAME	= ISNULL(STR_NAME,''),
    WHS_NBR		= ISNULL(WHS_NBR,0),
    WHS_NAME	= ISNULL(WHS_NAME,''),
    CLT_STYLE	= ISNULL(CLT_STYLE,''),
    UPC			= ISNULL(UPC,''),
    ITM_DESC	= ISNULL(ITM_DESC,''),
    ITM_SHIPPED	= ISNULL(ITM_SHIPPED,0)
INTO DBO.PRSTD_SKU
FROM DBO.PRSTD_SKU_C
WHERE VND_NBR IN ('116759','100735')
-- (116782 row(s) affected) 10/24/2005 ne 0:01:32

--(59180 row(s) affected)  1/4/07  dbm  time:  :04 sample data
--(998428 row(s) affected)  1/5/07  dbm  time:  :52  all date
-- (60,982 row(s) affected) 12-07-2007


-- check for dups
select distinct clt_style, ship_date, str_nbr,  count(*)
from prstd_sku
group by clt_style, ship_date, str_nbr
having count(*)>1 -- 526



CLT_STYLE       ship_date                                              str_nbr             
--------------- ------------------------------------------------------ ------- ----------- 
0341891        	2006-08-18 00:00:00	211	2
2762235        	2006-04-21 00:00:00	183	2
0341891        	2006-01-17 00:00:00	9174	3
0149336        	2006-04-12 00:00:00	198	2
0138396        	2006-12-08 00:00:00	34	2


select * 
from prstd_sku where CLT_STYLE= '0341891' and ship_date ='2006-08-18'and  str_nbr = 211

/*
VND_NAME                                 VND_NBR SHIP_DATE                                              BAN_CODE       BAN_NAME                                           STR_NBR STR_NAME                                           WHS_NBR  WHS_NAME    CLT_STYLE       UPC             ITM_DESC                                           ITM_SHIPPED 
---------------------------------------- ------- ------------------------------------------------------ -------------- -------------------------------------------------- ------- -------------------------------------------------- -------- ----------- --------------- --------------- -------------------------------------------------- ----------- 
MARS CANADA INC.	100735	2006-08-18 00:00:00	7	Conventional                                      	211	Magasin Coop LEveil                               	5	PS-GROCERY	0341891        	10058496704015 	PEDIGREE HEALTHY VITALITY MEALTIME 02.00KG        	1
MARS CANADA INC.	100735	2006-08-18 00:00:00	7	Conventional                                      	211	Magasin Coop LEveil                               	5	PS-GROCERY	0341891        	10058496704015 	PEDIGREE HEALTHY VITALITY MEALTIME 02.00KG        	3

(2 row(s) affected) */



select distinct CLT_STYLE, ship_date, str_nbr,itm_shipped, count(*)
from prstd_sku
group by CLT_STYLE, ship_date, str_nbr, itm_shipped
having count(*)>1
--(0 row(s) affected)
--------------------------------------------------------------
-- Step 5 - Create real Audit Pro - 9/21/2004
--------------------------------------------------------------


DROP TABLE DBO.PRSTD_SKU
SELECT DISTINCT 
    VND_NAME	=ISNULL(VND_NAME,''),
    VND_NBR		=ISNULL(VND_NBR,''),
    SHIP_DATE,
    BAN_CODE	=ISNULL(BAN_CODE,0),
    BAN_NAME	=ISNULL(BAN_NAME,''),
    STR_NBR		=ISNULL(STR_NBR,0),
    STR_NAME	=ISNULL(STR_NAME,''),
    WHS_NBR		=ISNULL(WHS_NBR,0),
    WHS_NAME	=ISNULL(WHS_NAME,''),
    CLT_STYLE	=ISNULL(CLT_STYLE,''),
    UPC			=ISNULL(UPC,''),
    ITM_DESC	=ISNULL(ITM_DESC,''),
    ITM_SHIPPED	=ISNULL(ITM_SHIPPED,0)
INTO DBO.PRSTD_SKU
FROM DBO.PRSTD_SKU_C
-- (2684409 row(s) affected) 10/25/2005 ne 0:01:59
-- (957,632 row(s) affected)  12-11-2007 E.Pineda

select Vnd_Nbr, count(*) from  DBO.PRSTD_SKU
group by Vnd_Nbr order by Vnd_Nbr
-- 18 

SP_PRGDS PRSTD_SKU
SP_PRGDSREPORT PRSTD_SKU
-- R:\ATLANTIC_CO_OP\CA\2004\STATS\PRSTD_SKU.txt 8527 bytes  10/25/2005 ne


SELECT DISTINCT VND_NBR FROM PRSTD_SKU WHERE VND_NBR NOT IN(
SELECT VNDRNBR FROM [AMER\neyfa01].[SKU_Deal_Vendors_List])
--(0 row(s) affected)

select top 1000 * from ATLANTIC_CO_OP_CA_2007_5650_F.dbo.PRSTD_PO

