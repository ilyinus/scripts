SELECT
	*
FROM
	master.dbo.sysmessages 
where
	(msglangid = 1033 or msglangid = 1049) -- ����
	and error = 1088 -- ��� ������
order by
	error

