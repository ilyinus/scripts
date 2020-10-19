--анализ состояния пересчета статистик
SELECT OBJECT_NAME(object_id) AS [ObjectName]
      ,[name] AS [StatisticName]
      ,STATS_DATE([object_id], [stats_id]) AS [StatisticUpdateDate]
FROM sys.stats

where OBJECT_NAME(object_id) = '_AccumRg1106'--сюда пишем имя таблицы

Order by STATS_DATE([object_id], [stats_id]) ;