-- ============================================
-- Name: RowCounts
-- Author: E.Pineda
-- Comments: Counts records on each database
-- ============================================


use OPERADORA_DE_CIUDAD_JUAREZ_MX_2012_C

create table dbo.Table_RowCount (TableName varchar(128), RowCnt int, reserverd varchar(128), data varchar(128), Index_size varchar(128), unused varchar(128) )
exec sp_msForEachTable
@command1 = 'Insert Into dbo.Table_RowCount exec sp_spaceused ''?'' ' -- ,
-- @whereand = 'and [name] like ''P_%'' '
Select TableName, RowCnt from dbo.Table_RowCount 
			Where TableName like 'P[_]%'
			Order by TableName
Drop table dbo.Table_RowCount 
