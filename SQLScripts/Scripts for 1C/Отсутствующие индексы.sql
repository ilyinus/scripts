SELECT TOP 100

	[����������] 						= OBJECT_NAME(sys_indexes.object_id),
	[������������������]  				= ROUND(migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans),0),
	[����������������������] 			= migs.avg_user_impact,
	[�����] 							= migs.user_seeks,
	[��������] 							= migs.user_scans,
	[�������������] 					= (migs.user_seeks + migs.user_scans),
	[��������������������] 				= ISNULL(migs.last_user_seek, CAST('1900-01-01 00:0:00' AS datetime)),
	[�����������������������] 			= ISNULL(migs.last_user_scan, CAST('1900-01-01 00:0:00' AS datetime)),
	[���������������] 					= migs.unique_compiles,
	[����������������] 					= migs.avg_total_user_cost,
	[EQUALITY]							= ISNULL(sys_indexes.equality_columns,''),
	[INEQUALITY]						= ISNULL(sys_indexes.inequality_columns,''),
	[INCLUDE]							= ISNULL(sys_indexes.included_columns,'')
		
FROM sys.dm_db_missing_index_groups AS mig
	
	JOIN sys.dm_db_missing_index_group_stats AS migs
	ON migs.group_handle = mig.index_group_handle
		
	JOIN sys.dm_db_missing_index_details AS sys_indexes
	ON mig.index_handle = sys_indexes.index_handle
	
ORDER BY 
		[������������������] Desc
		--[���������������] Desc
