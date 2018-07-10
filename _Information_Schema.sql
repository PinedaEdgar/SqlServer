-- ============================================
-- Name: _Information_Schema
-- Author: E.Pineda
-- Comments: Gets DB schema info.
-- ============================================

-- ===========================================================================
select * from Information_Schema.Tables  order by table_type, table_name
select * from Information_Schema.Columns 
select * from Information_Schema.Views 
select * from Information_Schema.View_Table_Usage
select * from Information_Schema.View_Column_Usage 
select * from Information_Schema.Routines 
select * from Information_Schema.Parameters 
-- ===========================================================================

select * from sys.objects where type = 'U'
select * from sys.indexes 
select * from sys.columns
select * from sys.all_Views
select * from sys.system_Views
select * from sys.system_columns
select * from sys.synonyms
select * from sys.identity_columns
select * from sys.computed_columns
select * from sys.Types
select * from sys.Partitions
select * from sys.Master_files
select * from sys.allocation_units
select * from sys.databases
select * from sys.data_spaces

select * from sys.Schemas
select * from sys.stats_columns
select * from sys.index_columns
select * from sys.data_spaces
select * from sys.data_spaces

SELECT fqn = CONCAT(
   QUOTENAME(@@SERVERNAME), '.',
   QUOTENAME(DB_NAME()), '.',
   QUOTENAME(SCHEMA_NAME([schema_id])),'.',
   QUOTENAME([name])
  ), *
    from sys.objects where type = 'U'

-- ===========================================================================
--  Get tables and it's columns
-- ===========================================================================
WITH cte_Tables AS 
(
	select * from sys.tables where type = 'U' and name = 'VendorMaster'
),
cte_Columns AS
(
	select * from sys.columns 
)
Select 
SqlServer = @@SERVERNAME,
[Database] = db_name(),
[schema] = SCHEMA_NAME(TBL.schema_id), 
TableName = TBL.name,  
TBL.type, 
TableCreated = TBL.create_date, 
TableUpdated = TBL.modify_date, 
#Columns = TBL.max_Column_id_used, 
ColumnName = CLM.name, 
ColumnId = CLM.column_id, 
-- DataType = CLM.system_type_id, 
DataType = TYPE_NAME(CLM.system_type_id) ,
[Length] = columnproperty(CLM.object_id, CLM.name, 'charmaxlen') ,
LenghtInBytes_UNICODE = CLM.max_length, 
[Precision] = CLM.precision, 
[Decimals] = CLM.scale, 
Collation = CLM.collation_name, 
is_nullable = IIF ( CLM.is_nullable = 1, 'YES', 'NO' ) ,
[Is_LargeValueDataType(max)] =  IIF ( CLM.max_length = -1, 'YES', 'NO' ),
is_computed = IIF ( CLM.is_computed = 1, 'YES', 'NO' ),
is_sparse   = IIF ( CLM.is_sparse   = 1, 'YES', 'NO' ),
TBL.object_id 
from cte_Tables TBL
INNER JOIN cte_Columns CLM
ON	TBL.object_id = CLM.object_id
--WHERE CLM.max_length <> columnproperty(CLM.object_id, CLM.name, 'charmaxlen') 
ORDER BY  TBL.schema_id,  TBL.name, CLM.column_id

