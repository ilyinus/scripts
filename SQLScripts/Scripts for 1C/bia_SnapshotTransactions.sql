-- truncate table softpoint.dbo.bia_SnapshotCurTrunsactions

DECLARE @curr_date as DATETIME
SET @curr_date = GETDATE()


INSERT INTO softpoint.dbo.bia_SnapshotCurTrunsactions(snapshot_time, session_id, transaction_id, transaction_begin_time, duration, transaction_type, transaction_state, connect_time, num_reads, num_writes,
last_read, last_write, client_net_address, most_recent_sql_handle, dbid, ib_name, text, start_time, status, command, wait_type, wait_time, query_plan,username)

select
	@curr_date,
	SESSION_TRAN.session_id AS connectID, -- "Соединение с СУБД" в консоли кластера 1С
	SESSION_TRAN.transaction_id,
	TRAN_INFO.transaction_begin_time,
	DateDiff(MINUTE, TRAN_INFO.transaction_begin_time, @curr_date) AS Duration, -- Длительность в минутах
	TRAN_INFO.transaction_type, -- 1 = транзакция чтения-записи; 2 = транзакция только для чтения; 3 = системная транзакция; 4 = распределенная транзакция.
	TRAN_INFO.transaction_state,
	CONN_INFO.connect_time,
	CONN_INFO.num_reads,
	CONN_INFO.num_writes,
	CONN_INFO.last_read,
	CONN_INFO.last_write,
	CONN_INFO.client_net_address,
	CONN_INFO.most_recent_sql_handle,
	SQL_TEXT.dbid,
	db_name(SQL_TEXT.dbid) AS IB_NAME,
	SQL_TEXT.text,
	QUERIES_INFO.start_time,
	QUERIES_INFO.status,
	QUERIES_INFO.command,
	QUERIES_INFO.wait_type,
	QUERIES_INFO.wait_time,
	PLAN_INFO.query_plan,
	sfp_sessioninfo.username
FROM
	sys.dm_tran_session_transactions AS SESSION_TRAN
		JOIN sys.dm_tran_active_transactions AS TRAN_INFO
		ON SESSION_TRAN.transaction_id = TRAN_INFO.transaction_id
		LEFT JOIN sys.dm_exec_connections AS CONN_INFO
		ON SESSION_TRAN.session_id = CONN_INFO.session_id
		CROSS APPLY sys.dm_exec_sql_text(CONN_INFO.most_recent_sql_handle) AS SQL_TEXT
		LEFT JOIN sys.dm_exec_requests AS QUERIES_INFO
		ON SESSION_TRAN.session_id = QUERIES_INFO.session_id
		LEFT JOIN (SELECT
			VL_SESSION_TRAN.session_id AS session_id,
			VL_PLAN_INFO.query_plan AS query_plan
		FROM
			sys.dm_tran_session_transactions AS VL_SESSION_TRAN
				INNER JOIN sys.dm_exec_requests AS VL_QUERIES_INFO
				ON VL_SESSION_TRAN.session_id = VL_QUERIES_INFO.session_id
				CROSS APPLY sys.dm_exec_text_query_plan(VL_QUERIES_INFO.plan_handle, VL_QUERIES_INFO.statement_start_offset, VL_QUERIES_INFO.statement_end_offset) AS VL_PLAN_INFO
		) AS PLAN_INFO
		ON SESSION_TRAN.session_id = PLAN_INFO.session_id
		-- треубется наличие соответствующей базы и таблицы (см. сервер m1-gp-db)
		LEFT JOIN [softpoint].[dbo].[sfp_sessioninfo]  AS sfp_sessioninfo with (nolock)
		ON SESSION_TRAN.session_id = sfp_sessioninfo.[spid]
ORDER BY
	transaction_begin_time ASC
;

WAITFOR DELAY '00:00:01'

;

go 1800

/*
USE [softpoint]
GO

/****** Object:  Table [dbo].[bia_SnapshotCurTrunsactions]    Script Date: 19.05.2016 10:44:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[bia_SnapshotCurTrunsactions](
	[snapshot_time] [datetime] NOT NULL,
	[session_id] [int] NOT NULL,
	[transaction_id] [bigint] NOT NULL,
	[transaction_begin_time] [datetime] NOT NULL,
	[duration] [int] NOT NULL,
	[transaction_type] [int] NOT NULL,
	[transaction_state] [int] NOT NULL,
	[connect_time] [datetime] NOT NULL,
	[num_reads] [int] NULL,
	[num_writes] [int] NULL,
	[last_read] [datetime] NULL,
	[last_write] [datetime] NULL,
	[client_net_address] [varchar](100) NULL,
	[most_recent_sql_handle] [varbinary](max) NULL,
	[dbid] [smallint] NULL,
	[ib_name] [varchar](150) NULL,
	[text] [varchar](max) NULL,
	[start_time] [datetime] NULL,
	[status] [varchar](100) NULL,
	[command] [varchar](100) NULL,
	[wait_type] [varchar](100) NULL,
	[wait_time] [int] NULL,
	[query_plan] [xml] NULL,
	[username] [nchar] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
*/
