-- ������ ���������� ������������� ����� �� ������
USE PerfMon

--SELECT * FROM _Document25 ����� Where  �����._Number = '000004353'

-- �������� �������������� ������ ������, 0xADEB6CAE8B1D099A11E20D33DBE4FD47

--SELECT * FROM _InfoRg267 �������� Where  ��������._RecorderRRef = 0xADEB6CAE8B1D099A11E20D33DBE4FD47
--SELECT TOP (500) * FROM _InfoRg319 WHERE _InfoRg319._RecorderRRef = 0xADEB6CAE8B1D099A11E20D33DBE4FD47
--SELECT COUNT (*) FROM _InfoRg267 �������� Where  ��������._RecorderRRef = 0xADEB6CAE8B1D099A11E20D33DBE4FD47

--_InfoRg319 = ��������������� ������
--_InfoRg267 = ��������

-- �������� ������ ���������� ������� �� �������� ���������������������
DELETE TOP (100000) FROM _InfoRg319 WHERE _RecorderRRef = 0xB0036EAE8B24DD6911E2A65465810D3B
go 10

SELECT COUNT(*) FROM _InfoRg319 WHERE _RecorderRRef = 0xB0036EAE8B24DD6911E2A65465810D3B
go
-- �������� ������ ���������� ������� �� �������� ��������
DELETE TOP (50000) FROM _InfoRg267 WHERE _RecorderRRef = 0xB0036EAE8B24DD6911E2A65465810D3B
go 5

SELECT COUNT(*) FROM _InfoRg267 WHERE _RecorderRRef = 0xB0036EAE8B24DD6911E2A65465810D3B