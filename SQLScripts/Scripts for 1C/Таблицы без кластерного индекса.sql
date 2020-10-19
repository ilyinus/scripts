CREATE TABLE #ttSize([имя таблицы] varchar(255), [строк] varchar(255), [зарезервировано] varchar(255), [всего данных] varchar(255), [размер индексов] varchar(255), [свободно] varchar(255))
;

-- размеры таблиц
INSERT INTO #ttSize
EXEC sp_msforeachtable N'exec sp_spaceused ''?'''
;

-- таблицы без кластерного индекса
SELECT
	idx.object_id
INTO #tt1
FROM
	sys.indexes AS idx

GROUP BY
	idx.object_id

HAVING
	SUM(CASE
		WHEN type = 1 -- кластеризованный
			THEN 1
		ELSE 0
	END) = 0
;

SELECT
	idx.object_id,
	obj.name,
	obj.create_date,
	obj.modify_date,
	tSize.[строк],
	tSize.[зарезервировано],
	tSize.[всего данных],
	tSize.[размер индексов],
	tSize.[свободно]
FROM
	#tt1 AS idx
		LEFT OUTER JOIN sys.objects AS obj
		ON idx.object_id = obj.object_id
		
		LEFT OUTER JOIN #ttSize AS tSize
		ON obj.name = tSize.[имя таблицы]
WHERE
	obj.type = 'U' -- только пользовательские таблицы

ORDER BY
	CONVERT(bigint, REPLACE(tSize.[всего данных], ' KB', '')) DESC
;

DROP TABLE #tt1;
DROP TABLE #ttSize
