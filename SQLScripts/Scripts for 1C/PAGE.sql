--по номеру страницы
DBCC PAGE(2,14,218281) WITH TABLERESULTS

-- в параметре передаем Metadata: ObjectId
select object_name(0)

----------------------------------
--по ключу
--waitresource="KEY: 5:72057752825036800 (22a5b306eb75)"
SELECT 
    sc.name as schema_name, 
    so.name as object_name, 
    si.name as index_name
FROM sys.partitions AS p
JOIN sys.objects as so on 
    p.object_id=so.object_id
JOIN sys.indexes as si on 
    p.index_id=si.index_id and 
    p.object_id=si.object_id
JOIN sys.schemas AS sc on 
    so.schema_id=sc.schema_id
WHERE hobt_id = 72057752825036800

------------
SELECT
    *
FROM _ReferenceChngR13167 (NOLOCK) -- имя таблицы берем из object_name
WHERE %%lockres%% = '(22a5b306eb75)';
GO