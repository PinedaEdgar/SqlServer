 PRINT '========= BEGIN ========='

	
 	:setvar Variables "\\amer.prgx.com\DataServices\Production\Intl Info\EPineda\00 VariablesEPineda.sql"
--	:setvar workfile  "\ ResultsEPineda_Test.sql"

	PRINT CHAR(5)
go
:on error exit
go

-- :r is a SQLCMD command that parses additional Transact-SQL statements and sqlcmd commands from the file specified by <filename> into the statement cache.
:r $(Variables)
go

USE $(InputDatabase)
GO
SELECT top 10 * from $(InputDatabase).[dbo].[C_BKPF_201801]
GO

--DECLARE @email as char(30)
--SET @email = 'edgardo.pineda@prgx.com'
--GO
PRINT $(email)

BEGIN TRY
			EXEC msdb.dbo.sp_send_dbmail
					@recipients = $(email), -- 'edgardo.Pineda@prgx.com',
					@subject = 'Test - Scripting - Automated email',
					@body = 'Test - Scripting - Automated email', 
					@importance=  'High' ;
		END TRY
		BEGIN CATCH
			SELECT 
				ERROR_LINE() AS ErrorLine,
				ERROR_PROCEDURE() AS ErrorProcedure,
				ERROR_NUMBER() AS ErrorNumber,
				ERROR_MESSAGE() AS ErrorMessage;
			EXEC msdb.dbo.sp_send_dbmail
					@recipients = $(email),
					@subject = 'Test - Scripting - Automated email',
					@body = 'Test - Scripting failed - Automated email', 
					@importance=  'High' ;
END CATCH;
SET NOCOUNT OFF;

    PRINT '========= END ========='

	