------------------------------------------------------------------
-- Возвращает статистику ввода-вывода для данных и файлов журнала.
-- https://msdn.microsoft.com/ru-ru/library/ms190326(v=sql.120).aspx
------------------------------------------------------------------

SELECT

DB_Name(VFS.Database_id) AS DataBaseName

,[mf].Physical_Name AS FileName
,VFS.Sample_Ms
,VFS.Num_Of_Reads
,VFS.Num_Of_Bytes_Read
,VFS.IO_Stall_Read_ms
,VFS.Num_Of_Writes
,VFS.Num_Of_Bytes_Written
,VFS.IO_Stall_Write_ms
,VFS.IO_Stall
,GETDATE() AS CurrentDate
,VFS.FILE_ID

FROM sys.Dm_io_virtual_file_stats(NULL, NULL) VFS

JOIN [sys].[master_files] [mf] 
    ON [vfs].[database_id] = [mf].[database_id] 
    AND [vfs].[file_id] = [mf].[file_id]