/*
-- stop  the trace
 DECLARE @TraceID INT ;
 SET @TraceID = 2 ; -- specify value from sp_trace_create
 EXEC sp_trace_setstatus
    @traceid = @TraceID
    ,@STATUS = 0 ;-- stop trace
 -- delete the trace
 EXEC sp_trace_setstatus
    @traceid = @TraceID
  ,@STATUS = 2 ;-- delete trace
*/

SELECT *
FROM   sys.traces;
