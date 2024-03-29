SELECT TOP 100 SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,
                          ((CASE statement_end_offset
                            WHEN -1 THEN DATALENGTH(ST.text)
                            ELSE QS.statement_end_offset 
                            END - QS.statement_start_offset)/2) + 1) AS "Statement Text",
                                       total_worker_time/execution_count/1000 AS "Average Worker Time (ms)",
                                       execution_count AS "Execution Count",				-- Количество запусков с момента последней компиляции плана 
                                       total_worker_time/1000 AS "Total Worker Time (ms)", 
                                             total_logical_reads AS "Total Logical Reads", 
                                       total_logical_reads/execution_count AS "Average Logical Reads",
                                             total_elapsed_time/1000 AS "Total Elapsed Time (ms)", 
                                       total_elapsed_time/execution_count/1000 AS "Average Elapsed Time (ms)",
                                       last_elapsed_time/1000 as "Last elapsed time (ms)",	-- Elapsed time, in microseconds, for the most recently completed execution of this plan.
                                       min_elapsed_time/1000 as "Min elapsed time (ms)",	-- Minimum elapsed time, in microseconds, for any completed execution of this plan.
                                       max_elapsed_time/1000 as "Max elapsed time (ms)",	-- Maximum elapsed time, in microseconds, for any completed execution of this plan.
                                       QS.plan_generation_num,								-- Количество компиляций/рекомпиляций плана выполнения
                                       QS.plan_handle 
FROM sys.dm_exec_query_stats QS
            CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) ST
            CROSS APPLY sys.dm_exec_query_plan(QS.plan_handle) QP
--WHERE  QS.execution_count >10 -- ST.dbid = 25
ORDER BY total_elapsed_time/execution_count DESC --*/execution_count DESC

/*
sp_helpdb
*/
/*
SELECT * FROM sys.dm_exec_query_plan(0x0500190035C0CF2640235E56020000000000000000000000)
*/

/*
total_elapsed_time 
 bigint 
 Total elapsed time, in microseconds, for completed executions of this plan.
 */

