--Whats using all the memory?
SELECT count(*) / 128.0 cached_memory_MB
	,CASE database_id
		WHEN 32767
			THEN 'ResourceDb'
		ELSE db_name(database_id)
		END AS Database_name
		,CAST ((100.0 * count(*) / SUM (count(*) ) OVER()) AS DECIMAL(5,2)) AS [Percentage]
FROM sys.dm_os_buffer_descriptors
GROUP BY db_name(database_id)
	,database_id
HAVING count(*) / 128.0 > 10
ORDER BY cached_memory_MB DESC

CREATE TABLE [dbo].[#memory](
	[db_name] [nvarchar](128) NULL,
	[name] [sysname] NOT NULL,
	[object_type_description] [nvarchar](60) NULL,
	[buffer_cache_pages] [int] NULL,
	[buffer_cache_used_MB] [int] NULL,
	[total_number_of_used_pages] [bigint] NULL,
	[total_mb_used_by_object] [bigint] NULL,
	[percent_of_pages_in_memory] [decimal](5, 2) NULL
) ON [PRIMARY]
GO

DECLARE @SQL NVARCHAR(MAX)

SELECT @SQL = STUFF((
			SELECT '
    USE [' + d.NAME + ']
;WITH CTE_BUFFER_CACHE AS (
	SELECT
		objects.name AS object_name,
		objects.type_desc AS object_type_description,
		objects.object_id,
		COUNT(*) AS buffer_cache_pages,
		COUNT(*) * 8 / 1024  AS buffer_cache_used_MB
	FROM sys.dm_os_buffer_descriptors
	INNER JOIN sys.allocation_units
	ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
	INNER JOIN sys.partitions
	ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
	OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
	INNER JOIN sys.objects
	ON partitions.object_id = objects.object_id
	WHERE allocation_units.type IN (1,2,3)
	AND objects.is_ms_shipped = 0
	AND dm_os_buffer_descriptors.database_id = DB_ID()
	GROUP BY objects.name,
			 objects.type_desc,
			 objects.object_id)
			 
INSERT INTO [#memory] ([db_name]
      ,[name]
      ,[object_type_description]
      ,[buffer_cache_pages]
      ,[buffer_cache_used_MB]
      ,[total_number_of_used_pages]
      ,[total_mb_used_by_object]
      ,[percent_of_pages_in_memory])

SELECT
DB_NAME() db_name,
	PARTITION_STATS.name,
	CTE_BUFFER_CACHE.object_type_description,
	CTE_BUFFER_CACHE.buffer_cache_pages,
	CTE_BUFFER_CACHE.buffer_cache_used_MB,
	PARTITION_STATS.total_number_of_used_pages,
	PARTITION_STATS.total_number_of_used_pages * 8 / 1024 AS total_mb_used_by_object,
	CAST((CAST(CTE_BUFFER_CACHE.buffer_cache_pages AS DECIMAL) / CAST(PARTITION_STATS.total_number_of_used_pages AS DECIMAL) * 100) AS DECIMAL(5,2)) AS percent_of_pages_in_memory
	
FROM CTE_BUFFER_CACHE
INNER JOIN (
	SELECT 
		objects.name,
		objects.object_id,
		SUM(used_page_count) AS total_number_of_used_pages
	FROM sys.dm_db_partition_stats
	INNER JOIN sys.objects
	ON objects.object_id = dm_db_partition_stats.object_id
	WHERE objects.is_ms_shipped = 0
	GROUP BY objects.name, objects.object_id) PARTITION_STATS
ON PARTITION_STATS.object_id = CTE_BUFFER_CACHE.object_id
WHERE PARTITION_STATS.total_number_of_used_pages * 8 / 1024 > 100
AND
CTE_BUFFER_CACHE.buffer_cache_pages * 8 / 1024 > 100
ORDER BY CTE_BUFFER_CACHE.buffer_cache_used_MB  DESC;
 '		
FROM sys.databases d
			WHERE d.[state] = 0
			FOR XML PATH('')
				,TYPE
			).value('.', 'NVARCHAR(MAX)'), 1, 2, '')

--	print @SQL
EXEC sys.sp_executesql @SQL

SELECT *
FROM #memory
ORDER BY buffer_cache_used_MB DESC

DROP TABLE [#memory]