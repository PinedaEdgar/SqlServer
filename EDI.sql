--/*********************************************************************
--/* Client: Atlantic Co-op
--/* Data Type: EDI
--/* Audit Period:
--/* Input Tables: dbo.C_VIRINVCHDR
--/*               dbo.C_VIRINVCDTL
--/*               dbo.C_VIRINVCADDDTL
--/*               dbo.C_VNDR
--/*
--/*
--/* Output Tables: P_EDI
--/* Description:
--/* Author: Gregg Brown
--/* Date Created: 09/12/05
--/*
--/* Script Execution Information:
--/*     Date                  BIA                     Run Time
--/*    09/12/05            Gregg Brown

/* -----------------------------------------------------------------------------------------------------------------------------
	Comments:
	Project:    PO 2007
	BIA:         Edgardo Pineda
	Database: ATLANTIC_CO_OP_CA_2007_C
    ---------------------------------------------------------------------------------------------------------------------------- */

--/**********************************************************************

Select count(*) from dbo.C_VIRINVCHDR_20071023 -- 108,371

drop table DBO.P_VIRINVCHDR
SELECT distinct
	EDIHDRKEY, VNDRID, INVCNBR, INVCDT, CUSTID, INVTTLAMT, DSCNTDUEDT, NETDUEDT, CRTDDT,
 	DSCNTBSAMT, INVTTLLSDS, VNDRDSCAMT, PONBR, PODT, INDDIRECT, ORGDSCDUDT, ORGNETDUDT, PSTINVNBR,
 	ORGDSCTAMT
INTO DBO.P_VIRINVCHDR
FROM dbo.C_VIRINVCHDR_20071023
WHERE INDDIRECT = 'Y'

--(92,950 row(s) affected)  121/4/07  dbm  time:  :05


--/*******************************************************************
--/ TEST FOR DUP KEY VALUES
--/*******************************************************************
SELECT DISTINCT EDIHDRKEY, COUNT(*) AS CNT
FROM dbo.C_VIRINVCDTL_20071023
GROUP BY EDIHDRKEY
HAVING COUNT(*) > 1
--(113651 row(s) affected) 9/12/05 GB TIME:  0:37
--(89575 row(s) affected)  1/3/07  dbm  time:  1:37
-- --(94,644 row(s) affected)  12/4/07  dbm  time:  0:16

SELECT DISTINCT EDIDTLKEY, COUNT(*) AS CNT
FROM dbo.C_VIRINVCADDDTL_20071023
GROUP BY EDIDTLKEY
HAVING COUNT(*) > 1
--(36081 row(s) affected) 9/12/05 GB TIME:  0:10
--(60,037 row(s) affected) 12/04/07 GB TIME:  0:10


SELECT DISTINCT VENDORID, COUNT(*) AS CNT
FROM dbo.C_VNDR_20071023
GROUP BY VENDORID
HAVING COUNT(*) > 1
--(30 row(s) affected)  9/12/05 GB TIME:  0:01
--(30 row(s) affected) 12/04/07 GB TIME:  0:00


--/*******************************************************************
--/ REMOVE DUPLICATES FROM FILE
--/*******************************************************************

DROP TABLE DBO.P_VIRINVCDTL_ND
SELECT DISTINCT 
	EDIHDRKEY, EDIDTLKEY, VPCCSPKID, UNTQTY, UNTPRC, UNTUOM, EDIDTLDSC,
 	SHPCNTRCD, PACK, INNERPACK, LINEAMT, UNTQTYDMG, UNTQTYSHRT, UNTQTYOVRS, UNTQTYRFSD,
 	PRDLVLNBR, PRDLBLTYP, INDPAYOVRS, INDCLMSHRT, INDCLMDMG, INDCLMRFSD, CARATIO
INTO DBO.P_VIRINVCDTL_ND
FROM DBO.C_VIRINVCDTL_20071023
--(1674085 row(s) affected) 9/12/05 GB TIME: 0:48
--(1392365 row(s) affected) 1/3/07  dbm  time:  3:28
-- --(1449,006 row(s) affected) 12/4/07  dbm  time:  1:48


DROP TABLE DBO.P_VIRINVCADDDTL_ND
SELECT DISTINCT 
	EDIDTLKEY, EDIADDKEY, EDISACCD, LNAMT, LNPCT, LNRT, LNUOM, LNQTY,
 	APPLYMTHD, ALWCHRGTYP, RFARSNTYP, LNCALCQTY
INTO DBO.P_VIRINVCADDDTL_ND
FROM DBO.C_VIRINVCADDDTL_20071023
--(751739 row(s) affected) 9/12/05 GB TIME: 0:19
--(607896 row(s) affected) 1/3/07  dbm  time:  :58
-- (673,063 row(s) affected) 12/4/07  dbm  time:  :11


DROP TABLE DBO.P_VNDR_ND
SELECT DISTINCT
	VNDALPHA, VENDORID, TAXCODE, COMMENT, REMITTONAM, CONTACTNAM, CONTACTPHO,
 	ADDRESS1, ADDRESS2, CITY, STATE, POSTCODE, COUNTRY, TAXID
INTO DBO.P_VNDR_ND
FROM DBO.C_VNDR_20071023
--(24346 row(s) affected) 9/12/05 GB TIME: 0:03
--(24915 row(s) affected) 1/3/07  dbm  time:  :07
--(25,523 row(s) affected) 12/4/07  dbm  time:  :01

--/*******************************************************************
--/ BUILD THE FILE
--/*******************************************************************
DROP TABLE DBO.P_EDI_STEP1
SELECT 
	VND_NAME 	= CAST(D.REMITTONAM AS CHAR(25)),
	VND_NBR 	= CAST(A.VNDRID AS CHAR(6)),
	INVNBR 		= CAST(A.INVCNBR AS CHAR(22)),
	INVDT 		= CAST(A.INVCDT AS SMALLDATETIME),
	PONBR 		= CAST(A.PONBR AS CHAR(10)),
	INVPODT 	= CAST(A.PODT AS SMALLDATETIME),
	INVDSCAMT 	= CAST(A.VNDRDSCAMT AS DEC(17,2)),
	INVDISCPCT 	= CAST(CASE WHEN A.INVTTLAMT = 0 THEN 0 ELSE
		 				A.VNDRDSCAMT / A.INVTTLAMT END AS DEC(17,4)),
	TOTINVCHG 	= CAST(A.INVTTLAMT AS DEC(17,2)),
	INVQTY 		= CAST(B.UNTQTY AS DEC(11,3)),
	INVITMGRS 	= CAST(B.UNTPRC AS DEC(22,5)),
	VND_STYLE 	= CAST(B.VPCCSPKID AS CHAR(15)),
	CLT_STYLE 	= CAST(B.PRDLVLNBR AS CHAR(15)),
	UPC 		= CAST(B.SHPCNTRCD AS CHAR(14)),
	CSPCK 		= CAST(B.PACK AS DEC(6)),
	ITMDESC 	= CAST(B.EDIDTLDSC AS CHAR(75)),
	INVITMALW 	= CAST(CASE WHEN C.EDISACCD IN ('A400','B320','B720','F670','B950',
					'E065','E720','F800') THEN C.LNRT ELSE 0 END AS DEC(11,3)),
	DSDFLAG 	= CAST(A.INDDIRECT AS CHAR(1)),
	CUSTNBR 	= CAST(A.CUSTID AS CHAR(12)),
	UOM 		= CAST(B.UNTUOM AS CHAR(2)),
	DMG 		= CAST(B.UNTQTYDMG AS DEC(11,3)),
	SHT 		= CAST(B.UNTQTYSHRT AS DEC(11,3)),
	REF 		= CAST(B.UNTQTYRFSD AS DEC(11,3)),
	[OVER] 		= CAST(B.UNTQTYOVRS AS DEC(11,3)),
	INVITMALW2 	= CAST(CASE WHEN C.EDISACCD NOT IN ('A400','B320','B720','F670','B950',
						'E065','E720','F800') THEN C.LNRT ELSE 0 END AS DEC(11,3)),
	EDIALWCD 	= CAST(ISNULL(C.EDISACCD,' ') AS CHAR(4)),
	RFACODE 	= CAST(ISNULL(C.RFARSNTYP,' ') AS CHAR(3)) 
INTO DBO.P_EDI_STEP1
FROM dbo.P_VIRINVCHDR A

LEFT OUTER JOIN dbo.P_VIRINVCDTL_ND B
ON A.EDIHDRKEY = B.EDIHDRKEY

LEFT OUTER JOIN dbo.P_VIRINVCADDDTL_ND C
ON B.EDIDTLKEY = C.EDIDTLKEY

LEFT OUTER JOIN dbo.P_VNDR_ND D
ON A.VNDRID = D.VENDORID
--(1620982 row(s) affected) 9/13/05 GB TIME: 3:17
--(1234401 row(s) affected) 1/3/07  dbm  time:  2:31
--(1,283,616 row(s) affected) 12/4/07  dbm  time:  0:39


DROP TABLE DBO.P_EDI_STEP2
SELECT 
	VND_NAME, VND_NBR, INVNBR, INVDT, PONBR, INVPODT, INVDSCAMT, INVDISCPCT, TOTINVCHG,
 	INVQTY, INVITMGRS, VND_STYLE, CLT_STYLE, UPC, CSPCK, ITMDESC, INVITMALW, 
 	INVITMNET = CAST(INVITMGRS - INVITMALW AS DEC(15,3)), DSDFLAG, CUSTNBR, UOM,
 	DMG, SHT, REF, [OVER], INVITMALW2, EDIALWCD, RFACODE
INTO DBO.P_EDI_STEP2
FROM DBO.P_EDI_STEP1
--(1620982 row(s) affected) 9/13/05 GB TIME: O:32
--(1234401 row(s) affected) 1/3/07  dbm  time:  3:21
--(1,283,616 row(s) affected) 12/4/07  dbm  time:  0:41

DROP TABLE DBO.P_EDI_STEP3
SELECT VND_NAME, VND_NBR, INVNBR, INVDT, PONBR, INVPODT, INVDSCAMT, INVDISCPCT, TOTINVCHG,
 INVQTY, INVITMGRS, VND_STYLE, CLT_STYLE, UPC, CSPCK, ITMDESC, INVITMALW, INVITMNET,
 EXTINVNET = CAST(INVITMNET * INVQTY AS DEC(11,3)), DSDFLAG, CUSTNBR, UOM, DMG, SHT, 
 RF = REF,
 OVR = [OVER], INVITMALW2, EDIALWCD, RFACODE
INTO DBO.P_EDI_STEP3
FROM DBO.P_EDI_STEP2
--(1620982 row(s) affected) 9/13/05 GB TIME: 0:24
--(1234401 row(s) affected) 1/3/07  dbm  time:  :19
--(1,283,616 row(s) affected) 12/4/07  dbm  time:  0:13



DROP TABLE DBO.P_EDI
SELECT DISTINCT *
INTO DBO.P_EDI
FROM DBO.P_EDI_STEP3
WHERE VND_NBR IN (116759,100735,114894,100133,100380) 
--(346091 row(s) affected) 9/13/05 GB TIME: 0:45 SAMPLES
--(1468168 row(s) affected) 9/15/05 GB TIME: 3:40 FULL

--(353,195 row(s) affected) 12/4/07 GB TIME: 0:24 SAMPLES (2007) E.Pineda
--(1,283,478 row(s) affected) 12/5/07  Full Project  (2007) E.Pineda

SP_PRGDS P_EDI
	
SP_PRGDSREPORT P_EDI
--\Intl Info\Canada\ATLANTIC_CO_OP\CA\2004\STATS\P_EDI_SAMPLE_STATS.TXT 14334 bytes  SAMPLES
--\Intl Info\Canada\ATLANTIC_CO_OP\CA\2004\STATS\P_EDI_STATS.TXT 14334 bytes  FULL

