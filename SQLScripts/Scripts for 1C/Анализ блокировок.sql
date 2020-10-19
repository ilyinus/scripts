/*запрос для анализа блокировок*/
select 
isnull(sp.object_id, sdtl.resource_associated_entity_id) object_id, 
rtrim(object_name(isnull(sp.object_id, sdtl.resource_associated_entity_id))) object_name, 
rtrim(sdtl.resource_type) resource_type, rtrim(si.name) index_name, rtrim(sdtl.request_session_id) request_session_id,
rtrim(sdtl.resource_description) resource_description,rtrim(resource_associated_entity_id) resource_associated_entity_id,
rtrim(request_mode) request_mode,rtrim(request_status) request_status 

from 
Sys.dm_tran_locks sdtl 
	INNER JOIN sys.dm_os_waiting_tasks as sdowt
        ON sdtl.lock_owner_address = sdowt.resource_address
    left join sys.partitions sp 
		on sdtl.resource_associated_entity_id = sp.hobt_id
	left join sys.indexes si 
		on sp.object_id = si.object_id and sp.index_id = si.index_id 
where 
	resource_database_id = db_id('sklad') 
	--sdtl.resource_associated_entity_id)))
order by 
	resource_associated_entity_id, 
	sdtl.request_session_id, 
	sdtl.resource_type