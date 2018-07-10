SELECT  
	[Schema Name] = SCHEMA_NAME(TB.schema_id),
	[Table Name] = TB.name,
	[Column Name] = CL.name, 
	[Column Type] = TP.name,  
	[Precision] = CL.precision, 
	[Scale] = CL.scale, 
	[Length] = CL.max_length
 FROM sys.tables AS TB
 INNER JOIN sys.columns CL ON TB.OBJECT_ID      = CL.OBJECT_ID
 INNER JOIN sys.types   TP ON CL.system_type_id = TP.system_type_id
 WHERE CL.name LIKE '%saida%'
 ORDER BY [Schema Name], [Table Name], CL.name ; 
