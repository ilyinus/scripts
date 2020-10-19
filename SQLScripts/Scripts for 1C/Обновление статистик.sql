/*обновление стастистики*/
USE [»м€Ѕазы];
GO
UPDATE STATISTICS [»м€“аблицы] -- та таблица по которой идет запрос
††††WITH FULLSCAN;
GO
--затем обновление кэша - дл€ очистки неправильного плана
DBCC FREEPROCCACHE;


/*
--ребилд индексов
ALTER INDEX [_AccumR6991_ByDims_TRRRR] ON [dbo].[_AccumRgT6991] 
REBUILD WITH (ONLINE=on);
*/