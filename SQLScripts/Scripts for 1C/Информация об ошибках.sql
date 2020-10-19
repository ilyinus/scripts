SELECT
	*
FROM
	master.dbo.sysmessages 
where
	(msglangid = 1033 or msglangid = 1049) -- язык
	and error = 1088 -- код ошибки
order by
	error

