
--==========СТАТИСТИКА ПО ОЖИДАНИЯМ MSSQL==========--

WITH [Waits] AS
    (SELECT
        [wait_type],
        [wait_time_ms] / 1000.0 AS [WaitS],
        ([wait_time_ms] - [signal_wait_time_ms]) / 1000.0 AS [ResourceS],
        [signal_wait_time_ms] / 1000.0 AS [SignalS],
        [waiting_tasks_count] AS [WaitCount],
        100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage],
        ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [RowNum]
    FROM sys.dm_os_wait_stats
    WHERE [wait_type] NOT IN (
        -- These wait types are almost 100% never a problem and so they are
        -- filtered out to avoid them skewing the results. Click on the URL
        -- for more information.
        N'BROKER_EVENTHANDLER', -- https://www.sqlskills.com/help/waits/BROKER_EVENTHANDLER
        N'BROKER_RECEIVE_WAITFOR', -- https://www.sqlskills.com/help/waits/BROKER_RECEIVE_WAITFOR
        N'BROKER_TASK_STOP', -- https://www.sqlskills.com/help/waits/BROKER_TASK_STOP
        N'BROKER_TO_FLUSH', -- https://www.sqlskills.com/help/waits/BROKER_TO_FLUSH
        N'BROKER_TRANSMITTER', -- https://www.sqlskills.com/help/waits/BROKER_TRANSMITTER
        N'CHECKPOINT_QUEUE', -- https://www.sqlskills.com/help/waits/CHECKPOINT_QUEUE
        N'CHKPT', -- https://www.sqlskills.com/help/waits/CHKPT
        N'CLR_AUTO_EVENT', -- https://www.sqlskills.com/help/waits/CLR_AUTO_EVENT
        N'CLR_MANUAL_EVENT', -- https://www.sqlskills.com/help/waits/CLR_MANUAL_EVENT
        N'CLR_SEMAPHORE', -- https://www.sqlskills.com/help/waits/CLR_SEMAPHORE
        N'CXCONSUMER', -- https://www.sqlskills.com/help/waits/CXCONSUMER
 
        -- Maybe comment these four out if you have mirroring issues
        N'DBMIRROR_DBM_EVENT', -- https://www.sqlskills.com/help/waits/DBMIRROR_DBM_EVENT
        N'DBMIRROR_EVENTS_QUEUE', -- https://www.sqlskills.com/help/waits/DBMIRROR_EVENTS_QUEUE
        N'DBMIRROR_WORKER_QUEUE', -- https://www.sqlskills.com/help/waits/DBMIRROR_WORKER_QUEUE
        N'DBMIRRORING_CMD', -- https://www.sqlskills.com/help/waits/DBMIRRORING_CMD
 
        N'DIRTY_PAGE_POLL', -- https://www.sqlskills.com/help/waits/DIRTY_PAGE_POLL
        N'DISPATCHER_QUEUE_SEMAPHORE', -- https://www.sqlskills.com/help/waits/DISPATCHER_QUEUE_SEMAPHORE
        N'EXECSYNC', -- https://www.sqlskills.com/help/waits/EXECSYNC
        N'FSAGENT', -- https://www.sqlskills.com/help/waits/FSAGENT
        N'FT_IFTS_SCHEDULER_IDLE_WAIT', -- https://www.sqlskills.com/help/waits/FT_IFTS_SCHEDULER_IDLE_WAIT
        N'FT_IFTSHC_MUTEX', -- https://www.sqlskills.com/help/waits/FT_IFTSHC_MUTEX
 
        -- Maybe comment these six out if you have AG issues
        N'HADR_CLUSAPI_CALL', -- https://www.sqlskills.com/help/waits/HADR_CLUSAPI_CALL
        N'HADR_FILESTREAM_IOMGR_IOCOMPLETION', -- https://www.sqlskills.com/help/waits/HADR_FILESTREAM_IOMGR_IOCOMPLETION
        N'HADR_LOGCAPTURE_WAIT', -- https://www.sqlskills.com/help/waits/HADR_LOGCAPTURE_WAIT
        N'HADR_NOTIFICATION_DEQUEUE', -- https://www.sqlskills.com/help/waits/HADR_NOTIFICATION_DEQUEUE
        N'HADR_TIMER_TASK', -- https://www.sqlskills.com/help/waits/HADR_TIMER_TASK
        N'HADR_WORK_QUEUE', -- https://www.sqlskills.com/help/waits/HADR_WORK_QUEUE
 
        N'KSOURCE_WAKEUP', -- https://www.sqlskills.com/help/waits/KSOURCE_WAKEUP
        N'LAZYWRITER_SLEEP', -- https://www.sqlskills.com/help/waits/LAZYWRITER_SLEEP
        N'LOGMGR_QUEUE', -- https://www.sqlskills.com/help/waits/LOGMGR_QUEUE
        N'MEMORY_ALLOCATION_EXT', -- https://www.sqlskills.com/help/waits/MEMORY_ALLOCATION_EXT
        N'ONDEMAND_TASK_QUEUE', -- https://www.sqlskills.com/help/waits/ONDEMAND_TASK_QUEUE
        N'PARALLEL_REDO_DRAIN_WORKER', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_DRAIN_WORKER
        N'PARALLEL_REDO_LOG_CACHE', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_LOG_CACHE
        N'PARALLEL_REDO_TRAN_LIST', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_TRAN_LIST
        N'PARALLEL_REDO_WORKER_SYNC', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_WORKER_SYNC
        N'PARALLEL_REDO_WORKER_WAIT_WORK', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_WORKER_WAIT_WORK
        N'PREEMPTIVE_XE_GETTARGETSTATE', -- https://www.sqlskills.com/help/waits/PREEMPTIVE_XE_GETTARGETSTATE
        N'PWAIT_ALL_COMPONENTS_INITIALIZED', -- https://www.sqlskills.com/help/waits/PWAIT_ALL_COMPONENTS_INITIALIZED
        N'PWAIT_DIRECTLOGCONSUMER_GETNEXT', -- https://www.sqlskills.com/help/waits/PWAIT_DIRECTLOGCONSUMER_GETNEXT
        N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP', -- https://www.sqlskills.com/help/waits/QDS_PERSIST_TASK_MAIN_LOOP_SLEEP
        N'QDS_ASYNC_QUEUE', -- https://www.sqlskills.com/help/waits/QDS_ASYNC_QUEUE
        N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP',
            -- https://www.sqlskills.com/help/waits/QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP
        N'QDS_SHUTDOWN_QUEUE', -- https://www.sqlskills.com/help/waits/QDS_SHUTDOWN_QUEUE
        N'REDO_THREAD_PENDING_WORK', -- https://www.sqlskills.com/help/waits/REDO_THREAD_PENDING_WORK
        N'REQUEST_FOR_DEADLOCK_SEARCH', -- https://www.sqlskills.com/help/waits/REQUEST_FOR_DEADLOCK_SEARCH
        N'RESOURCE_QUEUE', -- https://www.sqlskills.com/help/waits/RESOURCE_QUEUE
        N'SERVER_IDLE_CHECK', -- https://www.sqlskills.com/help/waits/SERVER_IDLE_CHECK
        N'SLEEP_BPOOL_FLUSH', -- https://www.sqlskills.com/help/waits/SLEEP_BPOOL_FLUSH
        N'SLEEP_DBSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_DBSTARTUP
        N'SLEEP_DCOMSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_DCOMSTARTUP
        N'SLEEP_MASTERDBREADY', -- https://www.sqlskills.com/help/waits/SLEEP_MASTERDBREADY
        N'SLEEP_MASTERMDREADY', -- https://www.sqlskills.com/help/waits/SLEEP_MASTERMDREADY
        N'SLEEP_MASTERUPGRADED', -- https://www.sqlskills.com/help/waits/SLEEP_MASTERUPGRADED
        N'SLEEP_MSDBSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_MSDBSTARTUP
        N'SLEEP_SYSTEMTASK', -- https://www.sqlskills.com/help/waits/SLEEP_SYSTEMTASK
        N'SLEEP_TASK', -- https://www.sqlskills.com/help/waits/SLEEP_TASK
        N'SLEEP_TEMPDBSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_TEMPDBSTARTUP
        N'SNI_HTTP_ACCEPT', -- https://www.sqlskills.com/help/waits/SNI_HTTP_ACCEPT
        N'SOS_WORK_DISPATCHER', -- https://www.sqlskills.com/help/waits/SOS_WORK_DISPATCHER
        N'SP_SERVER_DIAGNOSTICS_SLEEP', -- https://www.sqlskills.com/help/waits/SP_SERVER_DIAGNOSTICS_SLEEP
        N'SQLTRACE_BUFFER_FLUSH', -- https://www.sqlskills.com/help/waits/SQLTRACE_BUFFER_FLUSH
        N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP', -- https://www.sqlskills.com/help/waits/SQLTRACE_INCREMENTAL_FLUSH_SLEEP
        N'SQLTRACE_WAIT_ENTRIES', -- https://www.sqlskills.com/help/waits/SQLTRACE_WAIT_ENTRIES
        N'WAIT_FOR_RESULTS', -- https://www.sqlskills.com/help/waits/WAIT_FOR_RESULTS
        N'WAITFOR', -- https://www.sqlskills.com/help/waits/WAITFOR
        N'WAITFOR_TASKSHUTDOWN', -- https://www.sqlskills.com/help/waits/WAITFOR_TASKSHUTDOWN
        N'WAIT_XTP_RECOVERY', -- https://www.sqlskills.com/help/waits/WAIT_XTP_RECOVERY
        N'WAIT_XTP_HOST_WAIT', -- https://www.sqlskills.com/help/waits/WAIT_XTP_HOST_WAIT
        N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG', -- https://www.sqlskills.com/help/waits/WAIT_XTP_OFFLINE_CKPT_NEW_LOG
        N'WAIT_XTP_CKPT_CLOSE', -- https://www.sqlskills.com/help/waits/WAIT_XTP_CKPT_CLOSE
        N'XE_DISPATCHER_JOIN', -- https://www.sqlskills.com/help/waits/XE_DISPATCHER_JOIN
        N'XE_DISPATCHER_WAIT', -- https://www.sqlskills.com/help/waits/XE_DISPATCHER_WAIT
        N'XE_TIMER_EVENT' -- https://www.sqlskills.com/help/waits/XE_TIMER_EVENT
        )
    AND [waiting_tasks_count] > 0
    )
SELECT
    MAX ([W1].[wait_type]) AS [WaitType],
    CAST (MAX ([W1].[WaitS]) AS DECIMAL (16,2)) AS [Wait_S],
    CAST (MAX ([W1].[ResourceS]) AS DECIMAL (16,2)) AS [Resource_S],
    CAST (MAX ([W1].[SignalS]) AS DECIMAL (16,2)) AS [Signal_S],
    MAX ([W1].[WaitCount]) AS [WaitCount],
    CAST (MAX ([W1].[Percentage]) AS DECIMAL (5,2)) AS [Percentage],
    CAST ((MAX ([W1].[WaitS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgWait_S],
    CAST ((MAX ([W1].[ResourceS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgRes_S],
    CAST ((MAX ([W1].[SignalS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgSig_S],
    CAST ('https://www.sqlskills.com/help/waits/' + MAX ([W1].[wait_type]) as XML) AS [Help/Info URL]
FROM [Waits] AS [W1]
INNER JOIN [Waits] AS [W2] ON [W2].[RowNum] <= [W1].[RowNum]
GROUP BY [W1].[RowNum]
HAVING SUM ([W2].[Percentage]) - MAX( [W1].[Percentage] ) < 95; -- percentage threshold
GO


--==========ОТКЛИК ФАЙЛОВ БАЗ==========--

SELECT  DB_NAME(vfs.database_id) AS database_name ,
        vfs.database_id ,
        vfs.FILE_ID ,
        io_stall_read_ms / NULLIF(num_of_reads, 0) AS avg_read_latency ,
        io_stall_write_ms / NULLIF(num_of_writes, 0)
                                               AS avg_write_latency ,
        io_stall / NULLIF(num_of_reads + num_of_writes, 0)
                                               AS avg_total_latency ,
        num_of_bytes_read / NULLIF(num_of_reads, 0)
                                               AS avg_bytes_per_read ,
        num_of_bytes_written / NULLIF(num_of_writes, 0)
                                               AS avg_bytes_per_write ,
        vfs.io_stall ,
        vfs.num_of_reads ,
        vfs.num_of_bytes_read ,
        vfs.io_stall_read_ms ,
        vfs.num_of_writes ,
        vfs.num_of_bytes_written ,
        vfs.io_stall_write_ms ,
        size_on_disk_bytes / 1024 / 1024. AS size_on_disk_mbytes ,
        physical_name
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
        JOIN sys.master_files AS mf ON vfs.database_id = mf.database_id
                                       AND vfs.FILE_ID = mf.FILE_ID
ORDER BY avg_total_latency DESC

--ИЛИ

SELECT
    [ReadLatency] =
        CASE WHEN [num_of_reads] = 0
            THEN 0 ELSE ([io_stall_read_ms] / [num_of_reads]) END,
    [WriteLatency] =
        CASE WHEN [num_of_writes] = 0
            THEN 0 ELSE ([io_stall_write_ms] / [num_of_writes]) END,
    [Latency] =
        CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0)
            THEN 0 ELSE ([io_stall] / ([num_of_reads] + [num_of_writes])) END,
    [AvgBPerRead] =
        CASE WHEN [num_of_reads] = 0
            THEN 0 ELSE ([num_of_bytes_read] / [num_of_reads]) END,
    [AvgBPerWrite] =
        CASE WHEN [num_of_writes] = 0
            THEN 0 ELSE ([num_of_bytes_written] / [num_of_writes]) END,
    [AvgBPerTransfer] =
        CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0)
            THEN 0 ELSE
                (([num_of_bytes_read] + [num_of_bytes_written]) /
                ([num_of_reads] + [num_of_writes])) END,
    LEFT ([mf].[physical_name], 2) AS [Drive],
    DB_NAME ([vfs].[database_id]) AS [DB],
    [mf].[physical_name]
FROM
    sys.dm_io_virtual_file_stats (NULL,NULL) AS [vfs]
JOIN sys.master_files AS [mf]
    ON [vfs].[database_id] = [mf].[database_id]
    AND [vfs].[file_id] = [mf].[file_id]
ORDER BY [Latency] DESC


--==========ТЕКУЩИЙ PLE==========--

SELECT  @@servername AS INSTANCE
,[object_name]
,[counter_name]
, UPTIME_MIN = CASE WHEN[counter_name]= 'Page life expectancy'
          THEN (SELECT DATEDIFF(MI, MAX(login_time),GETDATE())
          FROM   master.sys.sysprocesses
          WHERE  cmd='LAZY WRITER')
      ELSE ''
END
,[cntr_value] AS PLE_SECS
,[cntr_value]/ 60 AS PLE_MINS
,[cntr_value]/ 3600 AS PLE_HOURS
,[cntr_value]/ 86400 AS PLE_DAYS
FROM  sys.dm_os_performance_counters
WHERE   [object_name] LIKE '%Manager%'
AND [counter_name] = 'Page life expectancy'


--==========ЗАГРУЗКА ТРАССЫ xEvent==========--

USE [Traces]
GO

IF (OBJECT_ID(N'CL_WMS', 'U') IS NULL) BEGIN

CREATE TABLE [dbo].[CL_WMS](
	[name] [nvarchar](50) NULL,
	[timestamp] [datetime2] NULL,
	[database_name] [nvarchar](50) NULL,
	[cpu_time] [int] NOT NULL,
	[duration] [int] NOT NULL,
	[logical_reads] [int] NOT NULL,
	[physical_reads] [int] NOT NULL,
	[writes] [int] NOT NULL,
	[row_count] [int] NOT NULL,
	[sql_text] [nvarchar](max) NOT NULL,
	[hash] [nvarchar](4000) NULL)
END;

insert into CL_WMS

SELECT 
	object_name,
	event_data_XML.value('(event/@timestamp)[1]'							,'datetime2')	  AS timestamp,
	event_data_XML.value('(event/action[@name="database_name"]/value)[1]'   ,'nvarchar(128)') AS database_name,
	event_data_XML.value('(event/data[@name="cpu_time"]/value)[1]'			,'BIGINT')		  AS cpu_time,
	event_data_XML.value('(event/data[@name="duration"]/value)[1]'			,'BIGINT')		  AS duration,
	event_data_XML.value('(event/data[@name="logical_reads"]/value)[1]'		,'BIGINT')		  AS logical_reads,
	event_data_XML.value('(event/data[@name="physical_reads"]/value)[1]'	,'BIGINT')		  AS physical_reads,
	event_data_XML.value('(event/data[@name="writes"]/value)[1]'			,'BIGINT')		  AS writes,
	event_data_XML.value('(event/data[@name="row_count"]/value)[1]'			,'BIGINT')		  AS row_count,
	case 
		when object_name = 'rpc_completed' then
			event_data_XML.value('(event/data[@name="statement"]/value)[1]', 'VARCHAR(max)')
		else
			event_data_XML.value('(event/data[@name="sql_text"]/value)[1]' ,'VARCHAR(max)')
	end                                                                                       AS sql_text,
	''                                                                                        AS hash
FROM
(SELECT CAST(event_data AS XML) event_data_XML, object_name
FROM sys.fn_xe_file_target_read_file ('C:\Работа\CL\Queries_0_132083914529730000.xel', NULL, NULL, NULL)) T 
where object_name in ('rpc_completed', 'sql_batch_completed') and not
case 
	when object_name = 'rpc_completed' then
		event_data_XML.value('(event/data[@name="statement"]/value)[1]', 'VARCHAR(max)')
	else
		event_data_XML.value('(event/data[@name="sql_text"]/value)[1]' ,'VARCHAR(max)')
end is null
go

create function fn_GetSQLHash(@TSQL nvarchar(max)) returns nvarchar(max) as 
begin 

declare @TmpTableName nvarchar(max) = '' 
declare @pos int = 0 
declare @i int = 0 


set @TSQL = REPLACE (@TSQL , 'exec sp_executesql N''' , '') 
set @pos = CHARINDEX(''',N''', @TSQL)


if @pos > 0 set @TSQL = SUBSTRING(@TSQL, 1, @pos - 1) 


while 1=1 
    begin
    set @pos = CHARINDEX('#', @TSQL) 
        if @pos > 0 
            begin 
                set @i = @i + 1
                set @TmpTableName = SUBSTRING(@TSQL, @pos, 4000) 
                set @pos = CHARINDEX(' ', @TmpTableName)
                if @pos > 0 set @TmpTableName = SUBSTRING(@TmpTableName, 1, @pos - 1) 
                set @TSQL = REPLACE(@TSQL, @TmpTableName, 'tt' + cast(@i as nvarchar)) 
            end 
        else
            break
        end 


return(left(@TSQL, 4000)); 

end;
go

UPDATE CL_WMS SET hash = dbo.fn_GetSQLHash(sql_text) WHERE hash = ''

drop function dbo.fn_GetSQLHash

--Замена GUID в тексте запроса
create function fn_ReplaceGUID(@TSQL nvarchar(max)) returns nvarchar(max) as 
begin 
 
declare @pos int = 0

while 1=1 
    begin
    set @pos = PATINDEX('%[a-z0-9][a-z0-9][a-z0-9][a-z0-9][a-z0-9][a-z0-9][a-z0-9][a-z0-9]-[a-z0-9][a-z0-9][a-z0-9][a-z0-9]%', @TSQL) 
        if @pos > 0 
            begin 
				SET @TSQL = REPLACE(@TSQL, SUBSTRING(@TSQL, @pos, 37), '<GUID>')
            end 
        else
            break
        end 


return(@TSQL); 

end;

--Нагрузка в разрезе баз

with CTE (database_name, duration, cpu_time, logical_reads, writes, physical_reads, row_count, hash)
AS (SELECT database_name, duration, cast(cpu_time as bigint), logical_reads, writes, physical_reads, row_count, hash FROM NESTRO_Queries)

SELECT
database_name,
cast(cast(sum(Logical_reads/128) as decimal(15, 2)) / iq.TotalReads * 100 as decimal(15, 2)) [Reads (%)],
cast(cast(sum(cpu_time) as decimal(15, 2)) / iq.TotalCpu * 100 as decimal(15, 2)) [Cpu (%)],
cast(cast(sum(physical_reads) as decimal(15, 2)) / iq.TotalPhysical_reads * 100 as decimal(15, 2)) [Physical Reads (%)],
cast(cast(sum(writes) as decimal(15, 2)) / iq.TotalWrites * 100 as decimal(15, 2)) [Writes (%)]
FROM CTE
join (select sum(logical_reads/128) TotalReads, sum(cpu_time) TotalCpu, sum(physical_reads) TotalPhysical_reads, sum(writes) TotalWrites from CTE) iq on 1=1
group by database_name, iq.TotalCpu, iq.TotalReads, iq.TotalPhysical_reads, iq.TotalWrites
order by [Reads (%)] desc

--Просмотреть таблицу можно например так

with CTE (database_name, duration, cpu_time, logical_reads, writes, physical_reads, row_count, hash)
AS (SELECT database_name, duration, cpu_time, logical_reads, writes, physical_reads, row_count, hash FROM NESTRO_Queries)

SELECT TOP 20
database_name DB,
Count(*) Count,
cast(sum(cast(duration as decimal(15, 3)))/1000000 as decimal(15, 3)) [Dur (sec)],
cast(sum(cast(duration as decimal(15, 3)))/Count(*)/1000000 as decimal(15, 3)) [Avg Dur (sec)],
cast(max(cast(duration as decimal(15, 3))/1000000) as decimal(15, 3)) [Max Dur (sec)],
cast(min(cast(duration as decimal(15, 3))/1000000) as decimal(15, 3)) [Min Dur (sec)],
sum(cpu_time/1000000) [Cpu (sec)],
sum(logical_reads/128) [Reads (Mb)],
sum(logical_reads/128)/Count(*) [Avg Reads (Mb)],
cast(cast(sum(Logical_reads/128) as decimal(15, 2)) / iq.TotalReads * 100 as decimal(15, 2)) [Reads (%)],
sum(writes/128) [Writes (Mb)],
sum(physical_reads/128) [Ph Reads (Mb)],
sum(row_count) Rows,
cast('' as xml).query('sql:column("hash")') SqlText
FROM CTE
join (select sum(logical_reads/128) TotalReads from CTE) iq on 1=1
group by Hash, database_name, iq.TotalReads order by [Reads (%)] desc

--ЗАГРУЗКА ТРАССЫ xEvent (для statement)

USE [Traces]
GO

insert into Prototype_statements

SELECT 
	object_name,
	event_data_XML.value('(event/@timestamp)[1]'							       ,'datetime2'     ) AS timestamp,
	event_data_XML.value('(event/@timestamp)[1]'							       ,'datetime2'     ) AS timestampUTC,
	event_data_XML.value('(event/data[@name="source_database_id"]/value)[1]'       ,'BIGINT'        ) AS source_database_id,
	event_data_XML.value('(event/data[@name="object_id"]/value)[1]'                ,'INT'           ) AS object_id,
	event_data_XML.value('(event/data[@name="object_type"]/value)[1]'              ,'nvarchar(max)' ) AS object_type,
	event_data_XML.value('(event/data[@name="duration"]/value)[1]'			       ,'BIGINT'        ) AS duration,
	event_data_XML.value('(event/data[@name="cpu_time"]/value)[1]'			       ,'decimal(20,0)' ) AS cpu_time,
	event_data_XML.value('(event/data[@name="physical_reads"]/value)[1]'	       ,'decimal(20,0)' ) AS physical_reads,
	event_data_XML.value('(event/data[@name="logical_reads"]/value)[1]'		       ,'decimal(20,0)' ) AS logical_reads,
	event_data_XML.value('(event/data[@name="writes"]/value)[1]'			       ,'decimal(20,0)' ) AS writes,
	event_data_XML.value('(event/data[@name="spills"]/value)[1]'			       ,'decimal(20,0)' ) AS spills,
	event_data_XML.value('(event/data[@name="row_count"]/value)[1]'			       ,'decimal(20,0)' ) AS row_count,
	event_data_XML.value('(event/data[@name="last_row_count"]/value)[1]'		   ,'decimal(20,0)' ) AS last_row_count,
	event_data_XML.value('(event/data[@name="nest_level"]/value)[1]'			   ,'INT'           ) AS nest_level,
	event_data_XML.value('(event/data[@name="line_number"]/value)[1]'			   ,'INT'           ) AS line_number,
	event_data_XML.value('(event/data[@name="offset"]/value)[1]'			       ,'INT'           ) AS offset,
	event_data_XML.value('(event/data[@name="offset_end"]/value)[1]'			   ,'INT'           ) AS offset_end,
	event_data_XML.value('(event/data[@name="object_name"]/value)[1]'			   ,'nvarchar(max)' ) AS object_name,
	event_data_XML.value('(event/data[@name="statement"]/value)[1]'			       ,'nvarchar(max)' ) AS statement,
	event_data_XML.value('(event/action[@name="database_name"]/value)[1]'          ,'nvarchar(128)' ) AS database_name,
	event_data_XML.value('(event/data[@name="parameterized_plan_handle"]/value)[1]','varbinary(max)') AS parameterized_plan_handle,
	event_data_XML.value('(event/action[@name="session_id"]/value)[1]'             ,'INT'           ) AS session_id,
	event_data_XML.value('(event/action[@name="database_id"]/value)[1]'            ,'INT'           ) AS database_id
	
	FROM
(SELECT CAST(event_data AS XML) event_data_XML, object_name
FROM sys.fn_xe_file_target_read_file ('D:\Разработка\ИАА\prototype\Statements_0*', NULL, NULL, NULL)) T 
where object_name in ('sp_statement_completed', 'sql_statement_completed') and not
event_data_XML.value('(event/data[@name="statement"]/value)[1]', 'VARCHAR(max)')
is null
go

--==========СТАТИСТИКА==========--

--Обновить статистику для всех таблиц базы
sp_msforeschtable N'UPDATE STATISTICS ? WITH FULLSCAN'	

--Обновить статистику для определенной таблицы
UPDATE STATISTICS _AccumRg7865 WITH FULLSCAN

--Обновление только статистики по колонкам

use BMP

declare @Command varchar(500);
declare @Cursor cursor;

set @Cursor = cursor scroll for
select 
'UPDATE STATISTICS ' + tb.name + '(' + st.name + ') WITH FULLSCAN'
from sys.tables tb
inner join sys.stats st
on tb.object_id = st.object_id
where st.auto_created = 1

open @Cursor

fetch next from @Cursor into @Command

while @@FETCH_STATUS = 0
begin

exec (@Command)

fetch next from @Cursor into @Command

end

close @Cursor


--==========ИНДЕКСЫ==========--

--Информация по использованию индексов

SELECT   OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME], 
         I.[NAME] AS [INDEX NAME], 
         USER_SEEKS, 
         USER_SCANS, 
         USER_LOOKUPS, 
         USER_UPDATES 
FROM     SYS.DM_DB_INDEX_USAGE_STATS AS S 
         INNER JOIN SYS.INDEXES AS I 
           ON I.[OBJECT_ID] = S.[OBJECT_ID] 
              AND I.INDEX_ID = S.INDEX_ID 
WHERE    OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1 

SELECT OBJECT_NAME(A.[OBJECT_ID]) AS [OBJECT NAME], 
       I.[NAME] AS [INDEX NAME], 
       A.LEAF_INSERT_COUNT, 
       A.LEAF_UPDATE_COUNT, 
       A.LEAF_DELETE_COUNT 
FROM   SYS.DM_DB_INDEX_OPERATIONAL_STATS (NULL,NULL,NULL,NULL ) A 
       INNER JOIN SYS.INDEXES AS I 
         ON I.[OBJECT_ID] = A.[OBJECT_ID] 
            AND I.INDEX_ID = A.INDEX_ID 
WHERE  OBJECTPROPERTY(A.[OBJECT_ID],'IsUserTable') = 1

--Или так

select 
db_name(us.database_id) [Base],
object_name(ob.object_id) [Table],
ix.name [Index],
ix.type_desc [Type],
us.user_seeks [Seeks],
us.user_scans [Scans],
us.user_updates [Updates]
from sys.indexes ix
join sys.objects ob
on ix.object_id = ob.object_id
join sys.dm_db_index_usage_stats us
on us.index_id = ix.index_id and us.object_id = ob.object_id
where ix.name in ('IX_OrderUID', 'IX_UIDFTL')
