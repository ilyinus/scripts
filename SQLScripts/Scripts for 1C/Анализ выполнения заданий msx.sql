Select top 100
*

from index_log

Where database_name like 'sklad%'
--and (table_name like '%6981%' or table_name like '%6991%')
and duration > 10 

Order by action_date desc, action_time desc