USE [dm_dump_1C_131029]
GO


CREATE TABLE [dbo].[ПолнаяТрасса_Lock_acquired_20150515](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[timestamp] [nvarchar](25) NULL,
	[resource_type] [nvarchar](5) NULL,
	[mode] [nvarchar](5) NULL,
	[database_name] [nvarchar](25) NULL,
	[session_id] [int] NOT NULL,
	[transaction_id] [bigint] NULL,
	[associated_object_id] [bigint] NULL,
	[duration] [int] NOT NULL,
	[sql_text] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


insert into [ПолнаяТрасса_Lock_acquired_20150515]

SELECT
	--event_data_XML,
	event_data_XML.value('(event/@timestamp)[1]','VARCHAR(25)') AS timestamp,
	event_data_XML.value('(event/data[1])[1]'	,'VARCHAR(5)')	AS resource_type,
	event_data_XML.value('(event/data[2])[1]'	,'VARCHAR(5)')	AS mode,
	event_data_XML.value('(event/action[2])[1]'	,'VARCHAR(25)')	AS database_name,
	event_data_XML.value('(event/action[3])[1]'	,'INT')			AS session_id,
	event_data_XML.value('(event/data[4])[1]'	,'bigint')		AS transaction_id,
	event_data_XML.value('(event/data[13])[1]'	,'bigint')		AS associated_object_id,
	event_data_XML.value('(event/data[14])[1]'	,'INT')			AS duration,
	event_data_XML.value('(event/action[4])[1]' ,'VARCHAR(max)')AS sql_text
FROM
(
SELECT /*top 300*/ CAST(event_data AS XML) event_data_XML, object_name
FROM sys.fn_xe_file_target_read_file ('C:\Temp\lock_acquired*.xel', NULL, NULL, NULL)) T


--truncate table ПолнаяТрасса_Запросы_MessageNo_ISNULL
/*
select
case 
	when sql_text like '%_MessageNo IS NULL' 
			or sql_text like '%_MessageNo IS NULL AND ((1=0))' 
		then 'X' 
	else 'Y' 
end,
count(*)
,sum(duration)/1000000
from ПолнаяТрасса_Lock_acquired_20150514
group by
case 
	when sql_text like '%_MessageNo IS NULL' 
			or sql_text like '%_MessageNo IS NULL AND ((1=0))' 
		then 'X' 
	else 'Y' 
end
*/