-- ============================================================
-- Name: _@@ConfigurationVariables
-- Author: E.Pineda
-- Comments: Gets ServerName
-- ============================================================

-- =========================================================
--	USING EXCEPT/INTERSECT
-- =========================================================

select @@ServerName
select db_name() -- master

select @@CONNECTIONS
select @@MAX_CONNECTIONS
select @@CPU_BUSY
select @@ERROR  
select @@IDENTITY
select @@IDLE
select @@IO_BUSY
select @@LANGID  
select @@LANGUAGE
select @@MAXCHARLEN
select @@PACK_RECEIVED  
select @@PACK_SENT
select @@PACKET_ERRORS
select @@ROWCOUNT  		-- 
select @@SERVERNAME 	-- 
select @@SPID			-- Session ID
select @@TEXTSIZE 		-- Current value of TextSize
select @@TIMETICKS		-- Microseconds per tick
select @@TOTAL_ERRORS	-- Total disk write errors (sp_monitor)
select @@TOTAL_READ  	-- Total Read  (sp_monitor)
select @@TOTAL_WRITE 	-- Total write (sp_monitor)
select @@TRANCOUNT		-- Returns the number of BEGIN TRANSACTION
select @@VERSION    
SELECT @@REMSERVER; 	-- Returns the name of remote SQL Server 
SELECT @@DateFirst  	-- Sets first day of the week (7 = Sunday).
