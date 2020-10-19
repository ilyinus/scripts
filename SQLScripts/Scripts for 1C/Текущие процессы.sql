/* все текущие запросы, не только выполняемые */
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
    OUTER APPLY sys.dm_exec_sql_text(p.sql_handle) AS st
 ORDER BY
       p.spid DESC
--p.blocked > 0

--kill 254 --