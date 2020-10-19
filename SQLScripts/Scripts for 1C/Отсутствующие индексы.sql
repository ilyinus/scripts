SELECT TOP 100

	[ИмяТаблицы] 						= OBJECT_NAME(sys_indexes.object_id),
	[ИздержкиОтсутствия]  				= ROUND(migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans),0),
	[СреднийПроцентВыигрыша] 			= migs.avg_user_impact,
	[Поиск] 							= migs.user_seeks,
	[Просмотр] 							= migs.user_scans,
	[Использование] 					= (migs.user_seeks + migs.user_scans),
	[ДатаПоследнегоПоиска] 				= ISNULL(migs.last_user_seek, CAST('1900-01-01 00:0:00' AS datetime)),
	[ДатаПоследнегоПросмотра] 			= ISNULL(migs.last_user_scan, CAST('1900-01-01 00:0:00' AS datetime)),
	[ЧислоКомпиляций] 					= migs.unique_compiles,
	[СредняяСтоимость] 					= migs.avg_total_user_cost,
	[EQUALITY]							= ISNULL(sys_indexes.equality_columns,''),
	[INEQUALITY]						= ISNULL(sys_indexes.inequality_columns,''),
	[INCLUDE]							= ISNULL(sys_indexes.included_columns,'')
		
FROM sys.dm_db_missing_index_groups AS mig
	
	JOIN sys.dm_db_missing_index_group_stats AS migs
	ON migs.group_handle = mig.index_group_handle
		
	JOIN sys.dm_db_missing_index_details AS sys_indexes
	ON mig.index_handle = sys_indexes.index_handle
	
ORDER BY 
		[ИздержкиОтсутствия] Desc
		--[ЧислоКомпиляций] Desc
