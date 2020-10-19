-- truncate table softpoint.dbo.bia_SnapshotExecRequests

INSERT INTO softpoint.dbo.bia_SnapshotExecRequests(snapshot_time, dbname, session_id, blocking_session_id, transaction_id, cpu_time, reads, writes, logical_reads,
start_time, status, isolation_level, wait_time, wait_type, last_wait_type, wait_resource, total_elapsed_time, query_text, query_plan)

SELECT
	GETDATE(),
 	db.name,
	a.session_id,
	a.blocking_session_id,
	a.transaction_id,
    a.cpu_time,
    a.reads,
    a.writes,
    a.logical_reads,
    a.start_time,
    a.[status],
	case a.transaction_isolation_level
		when 1 then 'ReadUncomitted'
		when 2 then 'ReadCommitted'
		when 3 then 'Repeatable'
		when 4 then 'Serializable'
		when 5 then 'Snapshot'
	end ”ровень»зол€ции,
    a.wait_time,
    a.wait_type,
    a.last_wait_type,
    a.wait_resource,
    a.total_elapsed_time,
    st.text,
    qp.query_plan
FROM
	sys.dm_exec_requests a
		OUTER APPLY sys.dm_exec_sql_text(a.sql_handle) AS st
		OUTER APPLY sys.dm_exec_query_plan(a.plan_handle) AS qp
		LEFT JOIN sys.databases db
		ON a.database_id = db.database_id
WHERE
	not a.status in ('background', 'sleeping')
;

WAITFOR DELAY '00:00:01'

;

go 3600

/*

USE [softpoint]
GO

/****** Object:  Table [dbo].[bia_SnapshotExecRequests]    Script Date: 17.05.2016 19:39:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[bia_SnapshotExecRequests](
	[snapshot_time] [datetime] NOT NULL,
	[dbname] [varchar](20) NOT NULL,
	[session_id] [smallint] NOT NULL,
	[blocking_session_id] [smallint] NULL,
	[transaction_id] [bigint] NOT NULL,
	[cpu_time] [int] NOT NULL,
	[reads] [bigint] NOT NULL,
	[writes] [bigint] NOT NULL,
	[logical_reads] [bigint] NOT NULL,
	[start_time] [datetime] NOT NULL,
	[status] [varchar](20) NOT NULL,
	[isolation_level] [varchar](15) NOT NULL,
	[wait_time] [int] NOT NULL,
	[wait_type] [varchar](150) NULL,
	[last_wait_type] [varchar](150) NOT NULL,
	[wait_resource] [varchar](150) NOT NULL,
	[total_elapsed_time] [int] NOT NULL,
	[query_text] [varchar](max) NULL,
	[query_plan] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

*/