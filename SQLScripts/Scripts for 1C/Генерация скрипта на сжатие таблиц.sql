SELECT 
'ALTER INDEX',
isnull(x.name,'') AS [Index_Name],
'ON',

o.name AS [Table_Name], 
'REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)'
 
FROM sys.objects o 
JOIN sys.indexes x ON x.object_id = o.object_id 
WHERE 

(o.name LIKE ('_Reference128%')
)

order by [Table_Name]