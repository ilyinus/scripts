/* 
���������� ������ � ���� ��� ���������� ��������
https://www.brentozar.com/blitzcache/multiple-plans/
https://support.microsoft.com/ru-ru/help/3026083/fix-sos-cachestore-spinlock-contention-on-ad-hoc-sql-server-plan-cache
*/
SELECT top 1000 q.PlanCount,
q.DistinctPlanCount,
st.text AS QueryText,
qp.query_plan AS QueryPlan
FROM ( 
SELECT query_hash,
COUNT(DISTINCT(query_hash)) AS DistinctPlanCount,
COUNT(query_hash) AS PlanCount
 
FROM sys.dm_exec_query_stats
GROUP BY query_hash
) AS q
JOIN sys.dm_exec_query_stats qs ON q.query_hash = qs.query_hash
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE PlanCount > 1
ORDER BY q.PlanCount DESC
