-- ==========================================
--	Script Name: UsingRankedResults
-- ==========================================

use CHOCOLATES_TURIN_S_A_DE_CV_TEST_MX_2010_C

-- ==========================
--		A and B are the same.
-- ==========================

-- A)
DECLARE @maxId as INT
SET @maxId = (SELECT max(AN8) from dbo.C_F0411_DATOS_20110708) -- 1041058
select count(*) from dbo.C_F0411_DATOS_20110708 WHERE an8 = @maxId

-- B)
select count(*) from dbo.C_F0411_DATOS_20110708 
WHERE AN8 = (SELECT max(AN8) from dbo.C_F0411_DATOS_20110708)


-- ==========================
--		C and D are the same.
-- ==========================

-- C)
DECLARE @maxId as INT
DECLARE @minId as INT
SET @maxId = (SELECT max(AN8) from dbo.C_F0411_DATOS_20110708) -- 1041058
SET @minId = (SELECT min(AN8) from dbo.C_F0411_DATOS_20110708) -- 403
select count(*) from dbo.C_F0411_DATOS_20110708 WHERE an8 Between @minId and @maxid
-- 8,601

-- D)
select count(*) from dbo.C_F0411_DATOS_20110708 
WHERE AN8 BETWEEN (SELECT min(AN8) from dbo.C_F0411_DATOS_20110708) AND (SELECT max(AN8) from dbo.C_F0411_DATOS_20110708)


-- ==========================
--		Assign Row_Number
-- ==========================

Select an8, RecCnt = ROW_Number() OVER (ORDER by count(*) DESC)
Into dbo.Tst_RANK
FROM dbo.C_F0411_DATOS_20110708
group by AN8
order by count(*) DESC
50004	1
3201	2
201092	3
3063	4


select an8, count(*) from C_F0411_DATOS_20110708 group by an8 order by count(*) DESC
50004	539
3201	167
        ==== 
	+	706

Select count(*) from C_F0411_DATOS_20110708
WHERE AN8 IN (SELECT top 2 AN8 FROM Tst_RANK )
-- 706

-- F4311 (PO Detail)
Select AN8, DOCO, POLines = count(*) 
Into dbo.Tst_PONbrs
from dbo.C_F4311_DATOS_20110708
Group by AN8, DOCO
Order by AN8, DOCO, count(*) DESC
-- 5,697

Select top 1000 * from Tst_PONbrs ORDER by AN8, POLines DESC

AN8	DOCO	POLines
1	299	149
1	292	100
1	294	100
1	295	100
1	303	38
1	296	18
1	282	14
1	287	11
1	290	4
1	286	3

AN8	DOCO	POLines
10	24280	26
10	24233	25
10	24281	21
10	23638	21
10	24231	20
10	24232	18
10	23785	14
10	23931	13
10	23521	13
10	23176	13

AN8	DOCO	POLines
14	1111	156
14	22618	104
14	22565	97
14	23342	96
14	22828	92
14	22895	87
14	22573	86
14	24176	81
14	22377	79
14	23299	75

AN8	DOCO	POLines
15	23584	9
15	24418	6
15	23129	5
15	24146	4
15	23347	3
15	23310	2
15	23309	1
15	23080	1
15	23625	1

16	23967	9
16	22689	4
16	24252	3
16	1171	2
16	23825	2
16	22568	1
16	22745	1
16	23163	1
16	24113	1

17	23753	11
17	24393	9
17	22520	7
17	24506	3
17	23731	3
17	22917	2
17	1091	2
17	1057	2
17	1090	1
17	1128	1


Select * from C_F43121_DATOS_20110708 where DOCO = 24503

-- I Like This one .. pulls the TOP PONumbers having more record details.
Select AN8, DOCO, TopPONbrs = ROW_Number() OVER (ORDER BY POLines DESC) 
FROM Tst_PONbrs

AN8	DOCO	TopPONbrs
50004	1395	1
24117	23119	2
24117	24044	3
50004	1483	4
24117	23841	5
24117	23462	6
24117	22488	7
14		1111	8
1		299		9
24117	23971	10

-- This one is pretty much (Select top 1000 * from Tst_PONbrs ORDER by AN8, POLines DESC).
Select AN8, DOCO, POLines, TopPONbrs = ROW_Number() OVER (Partition BY AN8 ORDER BY POLines DESC)
FROM Tst_PONbrs

-- This one keeps the same value (TopPONbrs) when POLines values are equal. 
Select AN8, DOCO, POLines, TopPONbrs = RANK() over (ORDER BY POLines DESC)
FROM  Tst_PONbrs

AN8	DOCO	POLines	TopPONbrs
50004	1395	483	1
24117	23119	411	2
24117	24044	271	3
50004	1483	253	4
....
AN8	DOCO	POLines	TopPONbrs
50	23283	65	60
22	23484	65	60
50	23208	64	62
14	22644	64	62
14	22376	64	62
24117	23693	64	62
50	22841	62	66
50	22587	62	66
14	24386	62	66
50	22791	61	69
50	23241	60	70
24117	22754	60	70
14	22571	59	72
14	23142	59	72
14	22643	58	74
14	24380	58	74
50	24138	58	74
24117	24070	58	74
50	22523	57	78
50	23592	56	79
50	24129	55	80
50	23030	55	80
14	23371	55	80
50	22924	54	83
50	22462	53	84
22	22615	53	84

Select AN8, DOCO, POLines, Quartile = NTILE(1000) OVER (Order by POLines DESC)
FROM Tst_PONbrs
AN8	DOCO	POLines	Quartile
50004	1395	483	1
24117	23119	411	1
24117	24044	271	1
50004	1483	253	1
24117	23841	229	1
24117	23462	187	1
24117	22488	158	2
14		1111	156	2
1		299		149	2
24117	23971	129	2
24117	24141	124	2
24117	23987	123	2
24117	22652	118	3
24117	23483	110	3
24117	22447	105	3

-- =============================================================
--	WHERE EXISTS
--  Select records that exists on both files
-- =============================================================

Select Distinct a.AN8, a.DOCO
FROM dbo.C_F4311_DATOS_20110708 AS a
WHERE EXISTS (select b.AN8, b.DOCO FROM dbo.C_F43121_DATOS_20110708 AS b WHERE b.AN8 = a.AN8 and b.DOCO = a.DOCO)
-- 3642

AN8		DOCO
--------------
201398	15630
50447	15393
24117	23034

select a.AN8, a.DOCO
FROM dbo.C_F4311_DATOS_20110708 AS a
WHERE a.AN8 = 201398 and a.DOCO = 15630

AN8		DOCO
201398	15630
201398	15630

select a.AN8, a.DOCO
FROM dbo.C_F43121_DATOS_20110708 AS a
WHERE a.AN8 = 201398 and a.DOCO = 15630

AN8	DOCO
201398	15630
201398	15630
201398	15630
201398	15630

-- =============================================================
--	WHERE NOT EXISTS
--  Select records on Driver files that not exists on subquery
-- =============================================================

Select Distinct a.AN8, a.DOCO
FROM dbo.C_F4311_DATOS_20110708 AS a
WHERE NOT EXISTS (select b.AN8, b.DOCO FROM dbo.C_F43121_DATOS_20110708 AS b WHERE b.AN8 = a.AN8 and b.DOCO = a.DOCO)
-- 2,055
AN8		DOCO
--------------
200611	22330
4221	16004
1789	3944
1789	12013
200990	22429

select a.AN8, a.DOCO
FROM dbo.C_F4311_DATOS_20110708 AS a
WHERE a.AN8 = 200611 and a.DOCO = 22330

AN8	DOCO
200611	22330
200611	22330

select a.AN8, a.DOCO
FROM dbo.C_F43121_DATOS_20110708 AS a
WHERE a.AN8 = 200611 and a.DOCO = 22330
-- 0

sp_mstablespace 'dbo.C_F4311_DATOS_20110708' -- 40,000
sp_mstablespace 'dbo.C_F43121_DATOS_20110708' -- 60,000

Select distinct AN8, DOCO, PrevPONbr = (select max(b.DOCO) from C_F4311_DATOS_20110708 b
					Where b.DOCO < a.DOCO)  
From C_F4311_DATOS_20110708 a 
ORDER by AN8, DOCO

AN8	DOCO	PrevPONbr
1	290		289
1	291		290
1	292		291
1	294		292	*****	No hay PONbr 293
1	295		294
1	296		295

-- =============================================================
--	Getting a count of VndNbr
--  Select records on Driver files that not exists on subquery
-- =============================================================

-- Summary
select Year(JEINVD), COUNT(Distinct JEVEND) from dbo.X_DATOS where JEINV_NO like N'%Ñ%'
Group by Year(JEINVD)
order by Year(JEINVD)
(No column name)	(No column name)
2009	3
2010	15
2011	6

-- Detail
select Year(JEINVD), JEVEND, COUNT(*) from dbo.X_DATOS where JEINV_NO like N'%Ñ%'
Group by Year(JEINVD),JEVEND
order by Year(JEINVD), JEVEND

(No column name)	JEVEND	(No column name)
2009	31073	20
2009	50031	82
2009	53882	4

2010	31073	594
2010	33803	144
2010	50031	102
2010	50541	4
2010	53882	56
2010	55013	4
2010	55309	6
2010	55454	14
2010	55891	8
2010	56093	20
2010	56100	4
2010	56160	8
2010	56578	4
2010	56662	4
2010	56766	8

2011	31073	153
2011	50232	2
2011	56100	4
2011	56200	12
2011	56766	4
2011	56802	8

