*
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
   Script: Generate Stats for dates
   Author: E.Pineda 
   Updated on: May 2018
   Comments: Create Stats from selected columns.
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
*/

select @@ServerName -- ATL20WS1100SQ10

USE [WALMART_GT_2017_AP_W]

select db_name() -- WALMART_GT_2017_AP_W


-- [Begin]
-- ========================================================
DECLARE @ViewName as sysname, @SourceTableName as sysname, @CurrentDatabase as sysname,  @strPrint VarChar(max)
SET @SourceTableName = 'P_AP'                          -- <<<=== Type Source table name
SET @ViewName = 'Vw_DtStats_' +  @SourceTableName
SET @CurrentDatabase = (SELECT DB_NAME())
-- ========================================================
DECLARE @sTMP varchar(max)
SET @sTMP = 'IF OBJECT_ID (N' + char(39) +  @ViewName + char(39) + ',' + + 'N' + char(39) + 'V' + char(39) + ') IS NOT NULL' + CHAR(13) + 'DROP VIEW ' + @ViewName + CHAR(10) + 'GO ' + CHAR(10) + CHAR(10) + 'CREATE VIEW ' + @ViewName + + CHAR(13) + 'AS SELECT ' 
SELECT @sTMP = @sTMP + char(13) + ',' + QUOTENAME(COLUMN_NAME) FROM  information_schema.columns WHERE TABLE_NAME = @SourceTableName AND DATA_TYPE IN ( 'date' ,  'datetimeoffset' ,  'datetime2' , 'smalldatetime' , 'datetime' , 'time' )
SELECT @sTMP = @sTMP + char(13) + ' FROM ' + @CurrentDatabase + '.' + 'dbo' + '.' + @SourceTableName + char(13) + char(13) + 'sp_prgds ' + char(39) + @ViewName + char(39)
PRINT @sTMP
-- [End]

-- ==> Copy/Paste - Begin  
-- Note: remove the firts comma on first column
IF OBJECT_ID (N'Vw_DtStats_P_AP',N'V') IS NOT NULL
DROP VIEW Vw_DtStats_P_AP
GO 

CREATE VIEW Vw_DtStats_P_AP
AS SELECT 
,[InvDt]
,[ChkDT]
,[ChkClearDt]
,[EntryDt]
,[PostingDt]
,[BaselineDtForDueDtCalc]
,[ChkVoidDt]
 FROM WALMART_GT_2017_AP_W.dbo.P_AP

sp_prgds 'Vw_DtStats_P_AP'
-- ==> Copy/Paste - End  

-- after Stats have been completed then drop the view just created. Replace the view name on script below.
IF OBJECT_ID (N'Vw_DtStats_P_AP',N'V') IS NOT NULL
DROP VIEW Vw_DtStats_P_AP
GO 