CREATE TABLE #ttSize([��� �������] varchar(255), [�����] varchar(255), [���������������] varchar(255), [����� ������] varchar(255), [������ ��������] varchar(255), [��������] varchar(255))
;

-- ������� ������
INSERT INTO #ttSize
EXEC sp_msforeachtable N'exec sp_spaceused ''?'''
;

-- ������� ��� ����������� �������
SELECT
	idx.object_id
INTO #tt1
FROM
	sys.indexes AS idx

GROUP BY
	idx.object_id

HAVING
	SUM(CASE
		WHEN type = 1 -- ����������������
			THEN 1
		ELSE 0
	END) = 0
;

SELECT
	idx.object_id,
	obj.name,
	obj.create_date,
	obj.modify_date,
	tSize.[�����],
	tSize.[���������������],
	tSize.[����� ������],
	tSize.[������ ��������],
	tSize.[��������]
FROM
	#tt1 AS idx
		LEFT OUTER JOIN sys.objects AS obj
		ON idx.object_id = obj.object_id
		
		LEFT OUTER JOIN #ttSize AS tSize
		ON obj.name = tSize.[��� �������]
WHERE
	obj.type = 'U' -- ������ ���������������� �������

ORDER BY
	CONVERT(bigint, REPLACE(tSize.[����� ������], ' KB', '')) DESC
;

DROP TABLE #tt1;
DROP TABLE #ttSize
