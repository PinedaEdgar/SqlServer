-- =================================================================
--	_Count number_of_tables
-- =================================================================
select Table_Schema, Table_name , count(*) AS TableCounts
from information_schema.tables WHERE table_type = 'BASE TABLE'
GROUP BY  Table_Schema, Table_name with ROLLUP
ORDER BY Table_Schema, Table_name


-- =================================================================
--	Get tables and it's columns
-- =================================================================
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

