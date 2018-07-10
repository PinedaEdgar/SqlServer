-- ============================================
-- SQL Analytic functions
-- ============================================

use [DS_ProjectStatus]

select * from [dbo].[TKT_JobDetail]

SELECT Department, LastName, Rate,   
       CUME_DIST () OVER (PARTITION BY Department ORDER BY Rate) AS CumeDist,   
       PERCENT_RANK() OVER (PARTITION BY Department ORDER BY Rate ) AS PctRank  
FROM HumanResources.vEmployeeDepartmentHistory AS edh  


Select ticketnumber, activityname, resource, percentcomplete,  CUME_DIST() over (partition by resource order by percentcomplete) as Cumedist from [dbo].[TKT_JobDetail]
where ticketnumber = 39


-- FIRST VALUE

-- #1 Gets the first date of transaction - Works
SELECT ticketnumber, activityname, resource, percentcomplete, FIRST_VALUE(DateActivity) OVER (PARTITION BY resource, percentcomplete ORDER BY DateActivity ASC) AS FirstDate
FROM [dbo].[TKT_JobDetail] 
where ticketnumber = 39

39	Comments                                                    	NULL	0	2014-07-16
39	Comments                                                    	NULL	0	2014-07-16
39	Data Load - Completed                                       	ARTHUR RICHARD WHEELER JR     	100	2014-08-11
39	Statistics - Delivered                                      	Edgar Pineda                  	100	2014-05-19	- Looking for 2014-05-19 OK
39	Sample - LI delivered                                       	Edgar Pineda                  	100	2014-05-19	- Looking for 2014-05-19 OK
39	Delivered - Project in SQL Server (Citrix)                  	Edgar Pineda                  	100	2014-05-19	- Looking for 2014-05-19 OK
39	Sample - (NS/DL/Other) delivered                            	Eduardo Sanchez               	100	2014-07-03
39	Data Load - Completed                                       	RUPALI SHANKAR DESAI          	100	2014-05-09


-- #2 Gets the last date of transaction - Works
SELECT ticketnumber, activityname, resource, percentcomplete, FIRST_VALUE(DateActivity) OVER (PARTITION BY resource, percentcomplete ORDER BY DateActivity DESC) AS LastDate
FROM [dbo].[TKT_JobDetail] 
where ticketnumber = 39

39	Comments                                                    	NULL							0	2014-09-05
39	Comments                                                    	NULL							0	2014-09-05
39	Data Load - Completed                                       	ARTHUR RICHARD WHEELER JR     	100	2014-08-11
39	Delivered - Project in SQL Server (Citrix)                  	Edgar Pineda                  	100	2014-09-04	- Looking for 2014-09-04 OK
39	Sample - LI delivered                                       	Edgar Pineda                  	100	2014-09-04	- Looking for 2014-09-04 OK
39	Statistics - Delivered                                      	Edgar Pineda                  	100	2014-09-04	- Looking for 2014-09-04 OK
39	Sample - (NS/DL/Other) delivered                            	Eduardo Sanchez               	100	2014-07-03
39	Data Load - Completed                                       	RUPALI SHANKAR DESAI          	100	2014-05-09

-- SELECT rows from source table for test

select ticketnumber, activityname, resource, percentcomplete, DateActivity  FROM [dbo].[TKT_JobDetail] where ticketnumber = 39 ORDER BY Resource, Percentcomplete, DateActivity
39	Comments                                                    	NULL							0	2014-07-16
39	Comments                                                    	NULL							0	2014-09-05
39	Data Load - Completed                                       	ARTHUR RICHARD WHEELER JR     	100	2014-08-11
39	Statistics - Delivered                                      	Edgar Pineda                  	100	2014-05-19
39	Sample - LI delivered                                       	Edgar Pineda                  	100	2014-08-12
39	Delivered - Project in SQL Server (Citrix)                  	Edgar Pineda                  	100	2014-09-04
39	Sample - (NS/DL/Other) delivered                            	Eduardo Sanchez               	100	2014-07-03
39	Data Load - Completed                                       	RUPALI SHANKAR DESAI          	100	2014-05-09


-- MORE ...

select ticketnumber, count(*) from [dbo].[TKT_JobDetail]  group by ticketnumber order by count(*) DESC

select Resource, min(dateactivity) ,max(dateactivity) from [dbo].[TKT_JobDetail]  where ticketnumber = 213 GROUP BY resource ORDER by Resource

AMRUTA KRISHNA UTTEKAR        	2015-01-20	2015-01-20
CHANDRA SEKHAR REDDY KODURU   	2014-02-12	2015-01-21
Eduardo Sanchez               	2015-02-23	2015-02-23
Joao Moura                    	2015-01-22	2015-01-26
Juan Diaz                     	2014-02-11	2015-03-10

SELECT ticketnumber, activityname, resource, percentcomplete, FIRST_VALUE(DateActivity) OVER (PARTITION BY resource, percentcomplete ORDER BY DateActivity ASC) AS FirstDate
FROM [dbo].[TKT_JobDetail] 
where ticketnumber = 213
-- Tested. It works

-- #2 Gets the last date of transaction - Works
SELECT ticketnumber, activityname, resource, percentcomplete, FIRST_VALUE(DateActivity) OVER (PARTITION BY resource, percentcomplete ORDER BY DateActivity DESC) AS LastDate
FROM [dbo].[TKT_JobDetail] 
where ticketnumber = 213
-- tested. It works


-- LEAD (Gets data from Next row)
--------------
SELECT ticketnumber, activityname, resource, percentcomplete, DateActivity, LEAD(DateActivity)  OVER (PARTITION BY resource ORDER BY DateActivity ASC) AS LEAD
FROM [dbo].[TKT_JobDetail] 
where ticketnumber = 213
-- Works
213	Database - Approve Load requested (SFA)                     	Joao Moura                    	100	2015-01-22	2015-01-26
213	Comments                                                    	Joao Moura                    	100	2015-01-26	NULL
213	Shipment Notification                                       	Juan Diaz                     	100	2014-02-11	2014-02-11
213	Data Load - Data Received                                   	Juan Diaz                     	100	2014-02-11	2014-02-17
213	Comments                                                    	Juan Diaz                     	100	2014-02-17	2014-02-19
213	Comments                                                    	Juan Diaz                     	100	2014-02-19	2014-02-24


-- LAG (Gets data from previous row)
--------------
SELECT ticketnumber, activityname, resource, percentcomplete, DateActivity, LAG(DateActivity)  OVER (PARTITION BY resource ORDER BY DateActivity ASC) AS LAG
FROM [dbo].[TKT_JobDetail] 
where ticketnumber = 213
-- Works
213	Database - Approve Load requested (SFA)                     	Joao Moura                    	100	2015-01-22	NULL
213	Comments                                                    	Joao Moura                    	100	2015-01-26	2015-01-22
213	Shipment Notification                                       	Juan Diaz                     	100	2014-02-11	NULL
213	Data Load - Data Received                                   	Juan Diaz                     	100	2014-02-11	2014-02-11
213	Comments                                                    	Juan Diaz                     	100	2014-02-17	2014-02-11
213	Comments                                                    	Juan Diaz                     	100	2014-02-19	2014-02-17
