SELECT s.*, e.*
FROM sys.tcp_endpoints as e JOIN sys.dm_exec_sessions as s
ON e.endpoint_id = s.endpoint_id
WHERE e.name = 'Dedicated Admin Connection'
