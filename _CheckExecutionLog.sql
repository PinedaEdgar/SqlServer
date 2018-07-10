-- ============================================================
-- Script: _CheckExecutionLog
-- ============================================================

-- #1
SELECT  dest.text
FROM    sys.dm_exec_query_stats AS deqs
        CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
WHERE   deqs.last_execution_time > '8/1/2017' --  '5/19/2011 11:00'
        AND dest.text LIKE '%PAO_DE_ACUCAR_LI_OUTPUT_BR_2016_C%';

-- #2
SELECT      c.session_id, s.host_name, s.login_name, s.status, st.text, s.login_time, s.program_name, *
FROM        sys.dm_exec_connections c
INNER JOIN  sys.dm_exec_sessions s ON c.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS st
WHERE s.login_name = 'AMER\jdiaz02'
ORDER BY    s.login_time -- c.session_id


-- #3
SELECT  d.plan_handle , d.sql_handle , e.text
FROM    sys.dm_exec_query_stats d
        CROSS APPLY sys.dm_exec_sql_text(d.plan_handle) AS e

-- #4 
SELECT t.[text]
FROM sys.dm_exec_cached_plans AS p
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) AS t
WHERE t.[text] LIKE N'%PAO_DE_ACUCAR_LI