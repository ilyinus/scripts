
use BMP

declare @Command varchar(500);
declare @Cursor cursor;

set @Cursor = cursor scroll for
select 
'UPDATE STATISTICS ' + tb.name + '(' + st.name + ') WITH FULLSCAN'
from sys.tables tb
inner join sys.stats st
on tb.object_id = st.object_id
where st.auto_created = 1

open @Cursor

fetch next from @Cursor into @Command

while @@FETCH_STATUS = 0
begin

exec (@Command)

fetch next from @Cursor into @Command

end

close @Cursor