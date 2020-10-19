SELECT OBJ.name, sum(AU.total_pages / 128) AS TotalSizeMB, sum(AU.used_pages / 128) AS UsedSizeMB, sum(AU.data_pages / 128) AS DataSizeMB
FROM sys.data_spaces AS DS 
     INNER JOIN sys.allocation_units AS AU 
         ON DS.data_space_id = AU.data_space_id 
     INNER JOIN sys.partitions AS PA 
         ON (AU.type IN (1, 3)  
             AND AU.container_id = PA.hobt_id) 
            OR 
            (AU.type = 2 
             AND AU.container_id = PA.partition_id) 
     INNER JOIN sys.objects AS OBJ 
         ON PA.object_id = OBJ.object_id 
     INNER JOIN sys.schemas AS SCH 
         ON OBJ.schema_id = SCH.schema_id 
     LEFT JOIN sys.indexes AS IDX 
         ON PA.object_id = IDX.object_id 
            AND PA.index_id = IDX.index_id
where DS.name = 'tmp'
group BY OBJ.name
order by (2) desc
