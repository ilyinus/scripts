select
                o.[name] [objectname]
                , p.rows rowcounts
                , case
                               when o.[type] = 'u' then 'table'
                               when o.[type] = 'v' then 'view'
                               end [objecttype]
                , i.[index_id] [indexid]
                , isnull(i.[name], 'n/a') [indexname]
                , format(a.total_pages/128, '# ### ### ###') total_mb
                , case
                               when i.[type] = 0 then 'heap'
                               when i.[type] = 1 then 'clustered'
                               when i.[type] = 2 then 'nonclustered'
                               when i.[type] = 3 then 'xml'
                               when i.[type] = 4 then 'spatial'
                               when i.[type] = 5 then 'reserved for future use'
                               when i.[type] = 6 then 'nonclustered columnstore index'
                               end [indextype]
                , lower(p.data_compression_desc) data_compression
from
                [sys].[indexes] i with (nolock)
                join [sys].[objects] o with (nolock)
                               on i.[object_id] = o.[object_id]
                join sys.partitions p with (nolock)
                               on i.object_id = p.object_id and i.index_id = p.index_id
                join sys.allocation_units a with (nolock)
                               on p.partition_id = a.container_id
where
                o.[type] in ('u','v') -- look in tables & views
                and o.[is_ms_shipped] = 0x0 -- exclude system generated objects
                and i.[is_disabled] = 0x0 -- exclude disabled indexes
                and a.type = 1
                
order by 
                i.object_id, i.index_id