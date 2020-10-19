USE [dm_dump_1C_131029]
GO


CREATE TABLE [dbo].[ПолнаяТрасса_Запросы_СДС_20180719](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[timestamp] [datetime2] NULL,
	[database_name] [nvarchar](25) NULL,
	[session_id] [int] NOT NULL,
	[transaction_id] [bigint] NULL,
	[cpu_time] [int] NOT NULL,
	[duration] [int] NOT NULL,
	[logical_reads] [int] NOT NULL,
	[physical_reads] [int] NOT NULL,
	[writes] [int] NOT NULL,
	[row_count] [int] NOT NULL,
	[sql_text] [nvarchar](max) NOT NULL,
	[batch_text] [nvarchar](max) NOT NULL,
	[sql_text_univers] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


insert into ПолнаяТрасса_Запросы_СДС_20180719 with (tablock)

SELECT 

	event_data_XML.value('(event/@timestamp)[1]'							,'datetime2')	AS timestamp,
	event_data_XML.value('(event/action[@name="database_name"]/value)[1]'	,'VARCHAR(25)') AS database_name,
	event_data_XML.value('(event/action[@name="session_id"]/value)[1]'		,'INT')			AS session_id ,
	event_data_XML.value('(event/action[@name="transaction_id"]/value)[1]'	,'VARCHAR(14)')	AS transaction_id ,
	event_data_XML.value('(event/data[@name="cpu_time"]/value)[1]'			,'INT')		    AS cpu_time,
	event_data_XML.value('(event/data[@name="duration"]/value)[1]'			,'INT')		    AS duration,
	event_data_XML.value('(event/data[@name="logical_reads"]/value)[1]'		,'INT')		    AS logical_reads,
	event_data_XML.value('(event/data[@name="physical_reads"]/value)[1]'	,'INT')			AS physical_reads,
	event_data_XML.value('(event/data[@name="writes"]/value)[1]'			,'INT')		    AS writes,
	event_data_XML.value('(event/data[@name="row_count"]/value)[1]'			,'INT')		    AS row_count,
	case 
		when event_data_XML.value('(event/action[@name="sql_text"]/value)[1]'		,'VARCHAR(max)') is Null
			then event_data_XML.value('(event/data[@name="statement"]/value)[1]'	,'VARCHAR(max)')
			else
				event_data_XML.value('(event/action[@name="sql_text"]/value)[1]'	,'VARCHAR(max)')
	end                                                                                     AS sql_text,
	case 
		when object_name = 'rpc_completed'
			then event_data_XML.value('(event/data[@name="statement"]/value)[1]'	,'VARCHAR(max)')
		else
			event_data_XML.value('(event/data[@name="batch_text"]/value)[1]'		,'VARCHAR(max)')
	end                                                                                     AS batch_text,
	REPLACE(
		event_data_XML.value('(event/action[@name="sql_text"]/value)[1]'			,'VARCHAR(max)')
		,' WITH(NOLOCK)','')																AS sql_text_univers
--select *	
FROM
(
SELECT /*top 100*/ CAST(event_data AS XML) event_data_XML, object_name
FROM sys.fn_xe_file_target_read_file ('F:\Трассы\m1-cdc-db4\allque_0_131764570514420000.xel', NULL, NULL, NULL)) T 
where object_name in ('rpc_completed', 'sql_batch_completed')
go

/*
allque_0_131764593461320000
allque_0_131764617063500000
allque_0_131764641317270000
*/
