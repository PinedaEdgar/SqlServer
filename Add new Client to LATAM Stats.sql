
-- ==========================================================
--	Insert a new Account into [dbo].[WF_Clients]
-- ==========================================================

select @@SERVERNAME -- ATL20DS8000SQ34

use [LATAM_Statistics]

select [ClientID] from [dbo].[WF_Clients] order by [ClientID] DESC

WITH cte_LastClient
AS
(
select 
 ClientID = max([ClientID]) 
,[ClientName] = 'Company Name'
,[ModClientName] = 'Company_Name'
,[ClientCode_CDMS] = 'COMP'
,[CountryID] = 139
,[CountryCode] = 'MX'
,[Region] = '001'
,[Division] = '001'
from [dbo].[WF_Clients]
)
INSERT INTO [dbo].[WF_Clients]
SELECT 
  [ClientID] + 1
 ,[ClientName]
 ,[ModClientName]
 ,[ClientCode_CDMS]
 ,[CountryID]
 ,[CountryCode]
 ,[Region]
 ,[Division]
FROM cte_LastClient




   VALUES
           (<ClientID, int,>
           ,<ClientName, varchar(50),>
           ,<ModClientName, varchar(50),>
           ,<ClientCode_CDMS, varchar(5),>
           ,<CountryID, int,>
           ,<CountryCode, varchar(4),>
           ,<Region, varchar(15),>
           ,<Division, varchar(15),>)
GO