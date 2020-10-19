--kill 272

SELECT
 	db.name,
	a.session_id,
	a.blocking_session_id,
	a.command,
	a.transaction_id,
    a.cpu_time,
	cast(a.total_elapsed_time / 60000.0 as numeric(15,3)) total_time_Min,
    a.reads,
    a.writes,
    a.logical_reads,
	a.row_count,
    a.start_time,
    a.[status],
	case a.transaction_isolation_level
		when 1 then 'ReadUncomitted'
		when 2 then 'ReadCommitted'
		when 3 then 'Repeatable'
		when 4 then 'Serializable'
		when 5 then 'Snapshot'
	end IsolationLevel,
    a.wait_time,
    a.wait_type,
    a.last_wait_type,
    a.wait_resource,
	cast(a.granted_query_memory / 128.0 as numeric(15,3)) granted_query_memory_Mb,
	cast(mg.requested_memory_kb / 1024.0 as numeric(15,3)) requested_memory_Mb,
	cast(mg.max_used_memory_kb / 1024.0 as numeric(15,3)) max_used_memory_Mb,
	ISNULL(mg.wait_time_ms, CAST(DATEDIFF(MILLISECOND, mg.request_time, mg.grant_time) AS NUMERIC(15))) wait_time_memory_ms,
	(su.user_objects_alloc_page_count + su.internal_objects_alloc_page_count)*1.0/128 alloc_space_tempdb,
	(su.user_objects_alloc_page_count + su.internal_objects_alloc_page_count - su.user_objects_dealloc_page_count - su.internal_objects_dealloc_page_count)*1.0/128 current_space_tempdb,
	sy.loginame,
    st.text,
	SUBSTRING(st.text, (statement_start_offset/2)+1, 
		((CASE statement_end_offset 
        	WHEN -1 THEN DATALENGTH(st.text)
    	  ELSE statement_end_offset
		  END  - statement_start_offset)/2) + 1) AS [Выполняющаяся часть запроса],
    qp.query_plan,
	p.loginame [loginame сессии вызвавшей блокировку],
	p.program_name [Приложение сессии вызвавшей блокировку],
	p.login_time [Время входа сессии вызвавшей блокировку],
	p.last_batch [Время последнего запроса сессии вызвавшей блокировку],
	p.hostname [Host Name сессии вызвавшей блокировку],
	stblock.text [Текущий(!) запрос сессии вызвавшей блокировку]

FROM sys.dm_exec_requests a
    OUTER APPLY sys.dm_exec_sql_text(a.sql_handle) AS st
	OUTER APPLY sys.dm_exec_query_plan(a.plan_handle) AS qp
	LEFT JOIN sys.sysprocesses p
		OUTER APPLY sys.dm_exec_sql_text(p.sql_handle) AS stblock
		on a.blocking_session_id > 0 and a.blocking_session_id = p.spid
	LEFT JOIN sys.databases db
		ON a.database_id = db.database_id
	LEFT JOIN sys.dm_exec_query_memory_grants mg
		ON a.session_id = mg.session_id
			and a.sql_handle = mg.sql_handle
	LEFT JOIN sys.dm_db_session_space_usage su
		ON a.session_id = su.session_id
	LEFT JOIN sys.sysprocesses sy
		ON a.session_id = sy.spid

WHERE	not a.status in ('background', 'sleeping')
		and a.last_wait_type <> 'SP_SERVER_DIAGNOSTICS_SLEEP'
	--blocking_session_id <> 0
	--and st.text like '%987632495763956%'

ORDER BY
       a.total_elapsed_time DESC

--Транзакции с последними запросами
SELECT
    [s_tst].[session_id],
    [s_es].[login_name] AS [Login Name],
    DB_NAME (s_tdt.database_id) AS [Database],
    [s_tdt].[database_transaction_begin_time] AS [Begin Time],
    [s_tdt].[database_transaction_log_bytes_used] AS [Log Bytes],
    [s_tdt].[database_transaction_log_bytes_reserved] AS [Log Rsvd],
    [s_est].text AS [Last T-SQL Text],
    [s_eqp].[query_plan] AS [Last Plan]
FROM
    sys.dm_tran_database_transactions [s_tdt]
JOIN
    sys.dm_tran_session_transactions [s_tst]
ON
    [s_tst].[transaction_id] = [s_tdt].[transaction_id]
JOIN
    sys.[dm_exec_sessions] [s_es]
ON
    [s_es].[session_id] = [s_tst].[session_id]
JOIN
    sys.dm_exec_connections [s_ec]
ON
    [s_ec].[session_id] = [s_tst].[session_id]
LEFT OUTER JOIN
    sys.dm_exec_requests [s_er]
ON
    [s_er].[session_id] = [s_tst].[session_id]
CROSS APPLY
    sys.dm_exec_sql_text ([s_ec].[most_recent_sql_handle]) AS [s_est]
OUTER APPLY
    sys.dm_exec_query_plan ([s_er].[plan_handle]) AS [s_eqp]

--Where [s_tst].[session_id] = 461

ORDER BY
    session_id ASC;
GO


--активные транзакции
SELECT
    trans.session_id AS [SESSION ID],
    ESes.host_name AS [HOST NAME],login_name AS [Login NAME],
    trans.transaction_id AS [TRANSACTION ID],
    tas.name AS [TRANSACTION NAME],tas.transaction_begin_time AS [TRANSACTION BEGIN TIME],
    tds.database_id AS [DATABASE ID],DBs.name AS [DATABASE NAME]
FROM sys.dm_tran_active_transactions tas
JOIN sys.dm_tran_session_transactions trans
ON (trans.transaction_id=tas.transaction_id)
LEFT OUTER JOIN sys.dm_tran_database_transactions tds
ON (tas.transaction_id = tds.transaction_id )
LEFT OUTER JOIN sys.databases AS DBs
ON tds.database_id = DBs.database_id
LEFT OUTER JOIN sys.dm_exec_sessions AS ESes
ON trans.session_id = ESes.session_id
WHERE ESes.session_id IS NOT NULL
and tas.transaction_begin_time < DATEADD (s , -90 , GETDATE())
ORDER BY
    tas.transaction_begin_time ASC;

--kill 174
/*

SELECT 
	p.spid,
	p.blocked,
	p.loginame,
	p.waittime,
	p.lastwaittype,
	p.waitresource,
	p.cpu,
	p.physical_io,
	p.memusage,
	p.login_time,
	p.last_batch,
	p.status,
	p.hostname,
	p.cmd,
	st.text
FROM
	sys.sysprocesses p
		OUTER APPLY sys.dm_exec_sql_text(p.sql_handle) AS st --order by p.spid
WHERE
	p.spid in (SELECT blocked FROM  sys.sysprocesses WHERE blocked > 0)

union

SELECT 
	p.spid,
	p.blocked,
	p.loginame,
	p.waittime,
	p.lastwaittype,
	p.waitresource,
	p.cpu,
	p.physical_io,
	p.memusage,
	p.login_time,
	p.last_batch,
	p.status,
	p.hostname,
	p.cmd,
	st.text
FROM
	sys.sysprocesses p
		OUTER APPLY sys.dm_exec_sql_text(p.sql_handle) AS st
WHERE
	p.blocked > 0

*/



/*

WITH [Blocking]
AS (SELECT w.[session_id]
   ,s.[original_login_name]
   ,s.[login_name]
   ,w.[wait_duration_ms]
   ,w.[wait_type]
   ,r.[status]
   ,r.[wait_resource]
   ,w.[resource_description]
   ,s.[program_name]
   ,w.[blocking_session_id]
   ,s.[host_name]
   ,r.[command]
   ,r.[percent_complete]
   ,r.[cpu_time]
   ,r.[total_elapsed_time]
   ,r.[reads]
   ,r.[writes]
   ,r.[logical_reads]
   ,r.[row_count]
   ,q.[text]
   ,q.[dbid]
   ,p.[query_plan]
   ,r.[plan_handle]
FROM [sys].[dm_os_waiting_tasks] w
INNER JOIN [sys].[dm_exec_sessions] s ON w.[session_id] = s.[session_id]
INNER JOIN [sys].[dm_exec_requests] r ON s.[session_id] = r.[session_id]
CROSS APPLY [sys].[dm_exec_sql_text](r.[plan_handle]) q
CROSS APPLY [sys].[dm_exec_query_plan](r.[plan_handle]) p
WHERE w.[session_id] > 50
  AND w.[wait_type] NOT IN ('DBMIRROR_DBM_EVENT'
     ,'ASYNC_NETWORK_IO'))
SELECT b.[session_id] AS [WaitingSessionID]
      ,b.[blocking_session_id] AS [BlockingSessionID]
      ,b.[login_name] AS [WaitingUserSessionLogin]
      ,s1.[login_name] AS [BlockingUserSessionLogin]
      ,b.[original_login_name] AS [WaitingUserConnectionLogin] 
      ,s1.[original_login_name] AS [BlockingSessionConnectionLogin]
      ,b.[wait_duration_ms] AS [WaitDuration]
      ,b.[wait_type] AS [WaitType]
      ,t.[request_mode] AS [WaitRequestMode]
      ,UPPER(b.[status]) AS [WaitingProcessStatus]
      ,UPPER(s1.[status]) AS [BlockingSessionStatus]
      ,b.[wait_resource] AS [WaitResource]
      ,t.[resource_type] AS [WaitResourceType]
      ,t.[resource_database_id] AS [WaitResourceDatabaseID]
      ,DB_NAME(t.[resource_database_id]) AS [WaitResourceDatabaseName]
      ,b.[resource_description] AS [WaitResourceDescription]
      ,b.[program_name] AS [WaitingSessionProgramName]
      ,s1.[program_name] AS [BlockingSessionProgramName]
      ,b.[host_name] AS [WaitingHost]
      ,s1.[host_name] AS [BlockingHost]
      ,b.[command] AS [WaitingCommandType]
      ,b.[text] AS [WaitingCommandText]
      ,b.[row_count] AS [WaitingCommandRowCount]
      ,b.[percent_complete] AS [WaitingCommandPercentComplete]
      ,b.[cpu_time] AS [WaitingCommandCPUTime]
      ,b.[total_elapsed_time] AS [WaitingCommandTotalElapsedTime]
      ,b.[reads] AS [WaitingCommandReads]
      ,b.[writes] AS [WaitingCommandWrites]
      ,b.[logical_reads] AS [WaitingCommandLogicalReads]
      ,b.[query_plan] AS [WaitingCommandQueryPlan]
      ,b.[plan_handle] AS [WaitingCommandPlanHandle]
FROM [Blocking] b
INNER JOIN [sys].[dm_exec_sessions] s1
ON b.[blocking_session_id] = s1.[session_id]
INNER JOIN [sys].[dm_tran_locks] t
ON t.[request_session_id] = b.[session_id]
WHERE t.[request_status] = 'WAIT'
GO

*/

--kill 533
--sp_who

/*
SELECT 
    CASE locks.resource_type
		WHEN N'OBJECT' THEN OBJECT_NAME(locks.resource_associated_entity_id)
		WHEN N'KEY'THEN (SELECT OBJECT_NAME(object_id) FROM sys.partitions WHERE hobt_id = locks.resource_associated_entity_id)
		WHEN N'PAGE' THEN (SELECT OBJECT_NAME(object_id) FROM sys.partitions WHERE hobt_id = locks.resource_associated_entity_id)
		WHEN N'HOBT' THEN (SELECT OBJECT_NAME(object_id) FROM sys.partitions WHERE hobt_id = locks.resource_associated_entity_id)
		WHEN N'RID' THEN (SELECT OBJECT_NAME(object_id) FROM sys.partitions WHERE hobt_id = locks.resource_associated_entity_id)
		ELSE N'Unknown'
    END AS objectName,
    CASE locks.resource_type
		WHEN N'KEY' THEN (SELECT indexes.name 
							FROM sys.partitions JOIN sys.indexes 
								ON partitions.object_id = indexes.object_id AND partitions.index_id = indexes.index_id
							WHERE partitions.hobt_id = locks.resource_associated_entity_id)
		ELSE N'Unknown'
    END AS IndexName,
    locks.resource_type,
	DB_NAME(locks.resource_database_id) AS database_name,
	locks.resource_description,
	locks.resource_associated_entity_id,
	locks.request_mode
FROM sys.dm_tran_locks AS locks
	--WHERE locks.resource_database_id = DB_ID(N'database_name')
*/

--db_name(10)
/*
DBCC TRACEON(3604)
DBCC PAGE('mobile_srt', 10, 1908410068, 0) WITH TABLERESULTS

DBCC TRACEOFF(3604)
--select OBJECT_NAME(53575229)
*/
