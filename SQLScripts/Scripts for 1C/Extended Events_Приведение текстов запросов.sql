USE [dm_dump_1C_131029]
GO

DECLARE @p1 varchar(65)
SET @p1='%#tt[0123456789]%';
DECLARE @p2 varchar(65)
SET @p2='%#tt[0123456789][0123456789]%';
DECLARE @p3 varchar(65)
SET @p3='%#tt[0123456789][0123456789][0123456789]%';
DECLARE @p4 varchar(65)
SET @p4='%#tt[0123456789][0123456789][0123456789][0123456789]%';
DECLARE @p5 varchar(65)
SET @p5='% WITH(NOLOCK)%';

while @@ROWCOUNT>0
begin

	--SELECT 
	update ПолнаяТрасса_Запросы_GP_20161128 with (tablock) set [sql_text_univers] = 
			REPLACE([sql_text_univers]
				,case 
					when PATINDEX(@p4, sql_text_univers)>0 
						then SUBSTRING(sql_text_univers, PATINDEX(@p4, sql_text_univers), 7)

					when PATINDEX(@p3, sql_text_univers)>0 
						then SUBSTRING(sql_text_univers, PATINDEX(@p3, sql_text_univers), 6)

					when PATINDEX(@p2, sql_text_univers)>0 
						then SUBSTRING(sql_text_univers, PATINDEX(@p2, sql_text_univers), 5)

					when PATINDEX(@p1, sql_text_univers)>0 
						then SUBSTRING(sql_text_univers, PATINDEX(@p1, sql_text_univers), 4)

					else ''
				end, '#tt'
			)
			/*
			STUFF(sql_text_univers, PATINDEX('%#tt[0123456789]%',sql_text_univers)+3,
				case 
					when PATINDEX(@p4,sql_text_univers)>0 
						then 4

					when PATINDEX(@p3,sql_text_univers)>0 
						then 3

					when PATINDEX(@p2,sql_text_univers)>0 
						then 2
						
					else 1
				end
				, ''
			)*/
		  --,[sql_text]
	  FROM ПолнаяТрасса_Запросы_GP_20161128-- with(nolock)
	  WHERE
  		not sql_text is null
		AND PATINDEX('%#tt[0123456789]%',sql_text_univers)>0
	-- ID = 1398612--1026717

end


--/*********************************************
--/**** группировка по тексту запроса
--drop table ПолнаяТрасса_Запросы_GP_20161128_group
CREATE TABLE [dbo].[ПолнаяТрасса_Запросы_GP_20161128_group](
	[database_name] [nvarchar](25) NULL,
	[sql_text]		[nvarchar](max) NULL,
	[_count]		[bigint] NOT NULL,
	[_countSpid]	[bigint] NOT NULL,
	[cpu_time]		[bigint] NOT NULL,
	[duration]		[bigint] NOT NULL,
	[logical_reads] [bigint] NOT NULL,
	[physical_reads][bigint] NOT NULL,
	[writes]		[bigint] NOT NULL,
	[row_count]		[bigint] NOT NULL,
	[cpu_time_max]	[bigint] NOT NULL,
	[duration_max]	[bigint] NOT NULL,
	[logical_reads_max] [bigint] NOT NULL,
	[physical_reads_max][bigint] NOT NULL,
	[writes_max]	[bigint] NOT NULL,
	[row_count_max] [bigint] NOT NULL,
	[cpu_time_min]	[bigint] NOT NULL,
	[duration_min]	[bigint] NOT NULL,
	[logical_reads_min] [bigint] NOT NULL,
	[physical_reads_min][bigint] NOT NULL,
	[writes_min]		[bigint] NOT NULL,
	[row_count_min]		[bigint] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

--truncate table ПолнаяТрасса_Запросы_GP_20161128_group
insert into [dbo].[ПолнаяТрасса_Запросы_GP_20161128_group] with (tablock)
select --top 100
	database_name as database_name,
	sql_text_univers as sql_text,
	count(*) _count,
	count(distinct session_id) _countSpid,
	sum(cast(cpu_time as bigint)) cpu_time,
	sum(cast(duration as bigint)) duration,
	sum(cast(logical_reads as bigint)) logical_reads,
	sum(cast(physical_reads as bigint)) physical_reads,
	sum(cast(writes as bigint)) writes,
	sum(cast(row_count as bigint)) row_count,

	max(cast(cpu_time as bigint)) cpu_time_max,
	max(cast(duration as bigint)) duration_max,
	max(cast(logical_reads as bigint)) logical_reads_max,
	max(cast(physical_reads as bigint)) physical_reads_max,
	max(cast(writes as bigint)) writes_max,
	max(cast(row_count as bigint)) row_count_max,

	min(cpu_time) cpu_time_min,
	min(duration) duration_min,
	min(logical_reads) logical_reads_min,
	min(physical_reads) physical_reads_min,
	min(writes) writes_min,
	min(row_count) row_count_min

from ПолнаяТрасса_Запросы_GP_20161128
group by database_name, sql_text_univers
GO
--*/


--/*********************************************
--/**** выборка результатов

--DECLARE @p1 nvarchar(12)
--SET @p1='%_FROM_[_]%';

SELECT TOP 100 
	case when _total.cpu_time_total=0 then 0 else (cpu_time*100)/_total.cpu_time_total end as percent_cpu_time, 
	case when _total.logical_reads_total=0 then 0 else (logical_reads*100)/_total.logical_reads_total end percent_logical_reads, 
	(_count*100)/_total._count_total percent_count, 
	/*case 
		when PATINDEX(@p1, ПолнаяТрасса.sql_text)<=0 
			or PATINDEX('% T[0123456789]%', SUBSTRING(ПолнаяТрасса.sql_text, PATINDEX(@p1, ПолнаяТрасса.sql_text)+6, 100))<=0 then ''
		else
			SUBSTRING(ПолнаяТрасса.sql_text, 
						PATINDEX(@p1, ПолнаяТрасса.sql_text)+6, 
						case 
							when PATINDEX('%[_]VT[0123456789]%', SUBSTRING(ПолнаяТрасса.sql_text, PATINDEX(@p1, ПолнаяТрасса.sql_text)+6, 100))>0 then
								PATINDEX('%[_]VT[0123456789]%', SUBSTRING(ПолнаяТрасса.sql_text, PATINDEX(@p1, ПолнаяТрасса.sql_text)+6, 100))
							else PATINDEX('% T[0123456789]%', SUBSTRING(ПолнаяТрасса.sql_text, PATINDEX(@p1, ПолнаяТрасса.sql_text)+6, 100))
						end
					   -1)
	end ИмяОсновнойТаблицы,*/
	*
FROM [dbo].[ПолнаяТрасса_Запросы_GP_20161128_group] ПолнаяТрасса
left join (select cast(sum(cpu_time) as numeric(15,3)) cpu_time_total, cast(sum(logical_reads) as numeric(15,3)) logical_reads_total, cast(sum(physical_reads) as numeric(15,3)) physical_reads_total, cast(sum(_count) as numeric(15,3)) _count_total from  [dbo].[ПолнаяТрасса_Запросы_GP_20161128_group]) _total
on 1=1--ПолнаяТрасса.database_name = _total.database_name
ORDER BY 
--cpu_time desc

--percent_logical_reads desc
--percent_cpu_time desc

percent_count desc
--_count desc
--writes desc
