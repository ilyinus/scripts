declare @t table (SPID INT, Status VARCHAR(1000) NULL, Login SYSNAME NULL, HostName SYSNAME NULL, BlkBy SYSNAME NULL, DBName SYSNAME NULL, Command VARCHAR(1000) NULL, CPUTime bigINT NULL, DiskIO bigINT NULL, LastBatch VARCHAR(1000) NULL, ProgramName VARCHAR(1000) NULL, SPID2 INT, requestid sysname); 

insert @t exec sp_who2; 
select * from @t 
where 1=1 
and spid > 50 
--and hostname = N'm1-ibaze' 
--and status <> 'sleeping' 
--and dbname like N'%gp_work%' 
and login like '%user1c%' 
--and HostName like N'%sdc%' 
order by LastBatch desc 
go 

-------------------------------------------
--sp_WhoIsActive