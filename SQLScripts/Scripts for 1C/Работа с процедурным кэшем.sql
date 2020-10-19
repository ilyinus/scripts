/* ����� ����� �� ������ �������. ��� ����������� ��������� �� ����, �������� � �����, ����� ����� ��������� ����� ��������� ��� ������*/
SELECT distinct --TOP 10
	--cp.cacheobjtype,
	--cp.objtype,
	'DBCC FREEPROCCACHE(',
	cp.plan_handle,
	')'
	--t.text,
	--qp.query_plan
FROM
	sys.dm_exec_cached_plans cp
		CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) t
		CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
WHERE
	--t.text LIKE '%WHERE %_Fld17680 LIKE %'
	t.text LIKE '%UPDATE%FROM%_AccumRgChngR13601%WHERE%T1._RecorderTRef%T1._RecorderRRef%'
	AND t.dbid = DB_ID('gp_work')

-- ������ ����� � ����
select distinct
	'DBCC FREEPROCCACHE(',
	plan_handle,
	')'
from sys.dm_exec_query_stats s
where 
	creation_time <= '2018-03-13 23:00:00'

--DBCC FREEPROCCACHE(0x06000500C056243640416822100000004B00000000000000) - ������� ����

/*

-- !!!
-- ��� ������ ������ ���������� �� ���������, � ���� ������ ���������� NULL ����������
-- !!!
-- convert(date, l.last_updated),

SELECT distinct
	--obj.*,
	--s.*,
	--sp.*,
	--sc.*,
	--c.*,
	'update statistics ',
	obj.name,
	' with fullscan'
FROM
	sys.stats AS s
		JOIN sys.objects AS obj
		ON s.object_id = obj.object_id
		
		CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
		
		JOIN (SELECT
			object_id,
			min(rows) r
		FROM
			sys.partitions
		GROUP BY
			object_id
		HAVING
			min(rows) > 0) p
		on p.object_id = obj.object_id

		--JOIN sys.stats_columns AS sc
		--ON s.object_id = sc.object_id
		--	AND s.stats_id = sc.stats_id
		--
		--JOIN sys.columns AS c
		--ON sc.object_id = c.object_id
		--	AND c.column_id = sc.column_id
WHERE
	--s.object_id = OBJECT_ID('HumanResources.Employee');
	s.auto_created = 0
	and sp.last_updated <= '2018-03-13 23:00:00'
	and obj.type = 'u' -- type_desc = 'USER_TABLE'

*/


DBCC FREEPROCCACHE(	0x06000600EF338127903B52BE3400000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x06000600796AEA04E00FC16A1901000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x06000100C778350200D1DAB42600000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x0600060022C62A2F103285117C00000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x060006008CFB4624E0DE9BA6FD00000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x0600060031E6601EF00B070DC401000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x060006001DC61E0CD01D2F278700000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x06000600043BEA2EF0DE0430BF01000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x0600060068B2B302B07CC2A4ED01000001000000360000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x06000600F5C7BD0500F6C290E700000001000000360000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x06000600CE1D6217701A85DF3F02000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x06000600CE5E6A0620770ECCEE00000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x0600060025E58D05203C87752C01000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x0600010018424833207C85245101000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x06000600AC9B4A0B605EC2FDCD01000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x060006005C28AC2210FBD1C13000000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x06000600F9E49F35802C0B540101000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x0600060067BC4300705E862FC401000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x06000600F67C8807E039C4931001000001000000360000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x0600060068AAA11AD01DC2996301000001000000360000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x06000600F550B428605E417E9000000001000000360000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x0600060018424833F0DEC1AF3702000001000000000000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x06000600FD8FF40A40C085C6BD01000001000000360000000000000000000000000000000000000000000000	)
DBCC FREEPROCCACHE(	0x06000600FDD0140C00FB2AC52500000001000000360000000000000000000000000000000000000000000000	)