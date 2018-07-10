-- ============================================
-- Name: Database_Sizes
-- Author: E.Pineda
-- Comments: Gets the Size for each database
-- ============================================

-- ==============
--	2005
-- ==============

select @@SERVERNAME -- ATL20WS1100SQ65

use [WALMART_LOCALEXTRACTS_BR_2015_C]

create table dbo.Table_RowCount (TableName varchar(128), RowCnt int, reserverd varchar(128), data varchar(128), Index_size varchar(128), unused varchar(128) )
exec sp_msForEachTable
@command1 = 'Insert Into dbo.Table_RowCount exec sp_spaceused ''?'' ' -- ,
-- @whereand = 'and [name] like ''P_%'' '
Select TableName, RowCnt from dbo.Table_RowCount 
			Where TableName like 'C[_]%'
			Order by TableName
Drop table dbo.Table_RowCount 
