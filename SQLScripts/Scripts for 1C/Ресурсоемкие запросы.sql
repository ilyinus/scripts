SELECT TOP 100
	db.name,
	SUBSTRING(text, (statement_start_offset/2)+1, 
		((CASE statement_end_offset 
        	WHEN -1 THEN DATALENGTH(text)
    	  ELSE statement_end_offset
		  END  - statement_start_offset)/2) + 1) AS [Текст запроса],
	execution_count [Количество выполнений],
	total_elapsed_time/1000000 [Длительность, сек], 
	total_worker_time/1000000 [Процессорное время, сек], 
	total_logical_reads [Логических чтений], 
	total_physical_reads [Физических чтений], 
	qp.query_plan [XML план запроса]
FROM sys.dm_exec_query_stats
	OUTER APPLY sys.dm_exec_sql_text(sql_handle) dm_text
	OUTER APPLY sys.dm_exec_query_plan(plan_handle) AS qp
		left join sys.databases db on qp.dbid = db.database_id
WHERE
	last_execution_time>=DATEADD(minute, -30, getdate())
ORDER BY
	total_worker_time DESC --сортировка по нагрузке на процессор
	--total_logical_reads DESC --сортировка по логическим чтениям
	 


/*

SELECT  TOP 10 
        [Total Cost]  = ROUND(avg_total_user_cost * avg_user_impact * (user_seeks + user_scans),0) 
		, [used] = user_seeks + user_scans
        , avg_user_impact
        , TableName = statement
        , [EqualityUsage] = equality_columns 
        , [InequalityUsage] = inequality_columns
        , [Include Cloumns] = included_columns
FROM        sys.dm_db_missing_index_groups g 
INNER JOIN    sys.dm_db_missing_index_group_stats s 
       ON s.group_handle = g.index_group_handle 
INNER JOIN    sys.dm_db_missing_index_details d 
       ON d.index_handle = g.index_handle
ORDER BY 
	--[used] DESC,
	[Total Cost] DESC;

*/


