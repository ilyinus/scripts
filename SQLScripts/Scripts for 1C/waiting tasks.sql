SELECT * FROM sys.dm_os_waiting_tasks
--WHERE wait_type = 'THREADPOOL'
GO

-- ���������� �������� ��������
select SUM(current_workers_count) as [Current worker thread] FROM sys.dm_os_schedulers