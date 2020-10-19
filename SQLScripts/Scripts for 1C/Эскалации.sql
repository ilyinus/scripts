SELECT lock_escalation, lock_escalation_desc, name FROM sys.tables WHERE lock_escalation_desc = 'DISABLE'

--ALTER TABLE _AccumRg19699 SET (LOCK_ESCALATION = DISABLE)