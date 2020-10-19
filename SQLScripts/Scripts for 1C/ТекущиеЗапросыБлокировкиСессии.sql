----------------------------
--рейсыхе гюопняш
----------------------------

SELECT 
	a.session_id,
	a.blocking_session_id,
    a.start_time,
    a.[status],
    a.wait_time,
    a.wait_type,
    a.last_wait_type,
    a.wait_resource,
    a.cpu_time,
    a.total_elapsed_time,
    a.reads,
    a.writes,
    a.logical_reads,
    st.text,
    qp.query_plan
FROM   sys.dm_exec_requests a
      CROSS APPLY sys.dm_exec_sql_text(a.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(a.plan_handle) AS
qp
ORDER BY
       a.cpu_time DESC
;
----------------------------
--рейсыхе акнйхпнбйх
----------------------------

SELECT 
        t1.resource_type,
        t1.resource_database_id,
        t1.resource_associated_entity_id,
        t1.request_mode,
        t1.request_session_id,
        t2.blocking_session_id
    FROM sys.dm_tran_locks as t1
    INNER JOIN sys.dm_os_waiting_tasks as t2
        ON t1.lock_owner_address = t2.resource_address;

----------------------------
--бяе йнммейрш
----------------------------

--

--exec sp_who

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

FROM  sys.sysprocesses p
    CROSS APPLY sys.dm_exec_sql_text(p.sql_handle) AS st
 ORDER BY
       p.spid DESC

*/
