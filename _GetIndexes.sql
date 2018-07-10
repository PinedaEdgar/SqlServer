use CHEDRAUI_MX_2014_FHALF_C

select * from sys.indexes
select * from sys.index_columns


DROP table #DatabaseIndexes
GO
SELECT 
     TableName = t.name,
     IndexType = ind.type_desc,
     IndexName = ind.name,
--     IndexId = ind.index_id,
     ColumnId = ic.index_column_id,
     ColumnName = col.name
--     ic.*,
--     col.* 
Into #DatabaseIndexes
FROM 
     sys.indexes ind 
INNER JOIN 
     sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN 
     sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN 
     sys.tables t ON ind.object_id = t.object_id 
WHERE 
     ind.is_primary_key = 0 
     AND ind.is_unique = 0 
     AND ind.is_unique_constraint = 0 
     AND t.is_ms_shipped = 0 
ORDER BY 
     t.name, ind.name, ind.index_id, ic.index_column_id 
-- ============================================================== >>>
select TableName, IndexType, IndexName,  ColumnId, ColumnName
from #DatabaseIndexes


     
     
     
     
 
 
