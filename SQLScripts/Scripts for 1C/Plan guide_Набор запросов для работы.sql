--******************************************************************************************
--******************************************************************************************
/* поиск плана запроса по тексту запроса

select execution_count exec_count, total_logical_reads/execution_count, min_logical_reads, max_logical_reads, total_elapsed_time/execution_count, min_elapsed_time, max_elapsed_time, query_plan, * --plan_handle,convert(varchar(64), plan_handle, 1)
from sys.dm_exec_query_stats s
outer apply sys.dm_exec_sql_text (s.sql_handle) t
outer apply sys.dm_exec_query_plan (s.plan_handle) p
where 
	--s.query_plan_hash = 0x9A0B49AF05B9CFC8
	--s.query_hash = 0x2DD096DDE79E3805
	--s.plan_handle = 0x06000500775FC517F0262D6E9401000001000000000000000000000000000000000000000000000000000000
	t.text like N'%UPDATE T1 SET%+ @P1%FROM _AccumRgT207 T1%T1._Splitter = @P6%'

order by exec_count desc --text
*/



--******************************************************************************************
--******************************************************************************************
/* ищем plan_handle зная query_hash (его в свою очередь можно увидеть в XML плана запроса)

select * from sys.dm_exec_query_stats s
outer apply sys.dm_exec_sql_text (s.sql_handle) t
outer apply sys.dm_exec_query_plan (s.plan_handle) p
where s.query_hash = 0xC4E16F366C5D6073 --0xE0880C77F0515016 --
order by max_logical_reads

*/


--DBCC FREEPROCCACHE(0x060006007FDBDF2D10B20308CD00000001000000000000000000000000000000000000000000000000000000) -- очистка кэша 
0x06000600088F1028907B46868501000001000000000000000000000000000000000000000000000000000000
0x06000600C5442A1070BA44AF2901000001000000000000000000000000000000000000000000000000000000
0x060006007FDBDF2D609E85E62502000001000000000000000000000000000000000000000000000000000000
--******************************************************************************************
--******************************************************************************************
/* создание гайда по plan_handle

sp_create_plan_guide_from_handle N'update_AccumRgT207_2'
    , 0x06000600088F1028E01E413A8C00000001000000000000000000000000000000000000000000000000000000
    , NULL

select * from sys.plan_guides order by name--выборка всех гайдов

-- проверка на валидность план гайдов
select *
from sys.plan_guides as pg
cross apply sys.fn_validate_plan_guide(pg.plan_guide_id)
order by pg.name

*/

--******************************************************************************************
--******************************************************************************************
/* удаление план гайда по имени

sp_control_plan_guide N'DROP' , N'update_AccumRgChngR22074_MessageNoISNULL' -- 

/* список возможных параметров
<control_option>::=
{   DROP 
  | DROP ALL
  | DISABLE
  | DISABLE ALL
  | ENABLE 
  | ENABLE ALL
}*/

*/
/* наполнители:

select COUNT(0) From _ReferenceChngR21611
;
INSERT INTO _ReferenceChngR21611 (_NodeTRef,_NodeRRef,_MessageNo,_IDRRef) 
SELECT distinct top 10000 
 0x00000000 
,0x00000000000000000000000000000000 
,NULL 
,_IDRRef 
from _Document15883 
order by _IDRRef
;

alter index [_Refer21611_ByDataKey_RR] on _ReferenceChngR21611 rebuild
;
alter index [_Refer21611_ByNodeMsg_RNR] on _ReferenceChngR21611 rebuild
;

select COUNT(0) From _ReferenceChngR21611

Delete _ReferenceChngR21611 
Where _NodeTRef =  0x00000000 
		and _NodeRRef = 0x00000000000000000000000000000000 
*/

/*
--проверка использования план гайдов по кэшу планов запросов
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 
WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan') 
SELECT  
   dbName, 
   PlanGuideName, 
   SUM(refcounts) AS TotalRefCounts, 
   SUM(usecounts) AS TotalUseCounts 
FROM 
( 
   SELECT  
       query_plan.value('(/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple/@TemplatePlanGuideDB)[1]', 'varchar(128)') AS dbName, 
       query_plan.value('(/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple/@TemplatePlanGuideName)[1]', 'varchar(128)') AS PlanGuideName, 
       refcounts, 
       usecounts 
   FROM sys.dm_exec_cached_plans 
   CROSS APPLY sys.dm_exec_query_plan(plan_handle) 
   WHERE query_plan.exist('(/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple[@TemplatePlanGuideName])[1]')=1 
) AS tab 
GROUP BY dbName, PlanGuideName
*/