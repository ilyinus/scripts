/*���������� �����������*/
USE [�������];
GO
UPDATE STATISTICS [����������] -- �� ������� �� ������� ���� ������
����WITH FULLSCAN;
GO
--����� ���������� ���� - ��� ������� ������������� �����
DBCC FREEPROCCACHE;


/*
--������ ��������
ALTER INDEX [_AccumR6991_ByDims_TRRRR] ON [dbo].[_AccumRgT6991] 
REBUILD WITH (ONLINE=on);
*/