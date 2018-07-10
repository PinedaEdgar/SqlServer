IF OBJECT_ID('tempdb..#TempDatabasePath') IS NOT NULL DROP TABLE #TempDatabasePath

CREATE TABLE #TempDatabasePath(dbname nvarchar(255), fileid int, filename nvarchar(255), filegroup nvarchar(255), size nvarchar(255), maxsize nvarchar(255), growth nvarchar(255), usage nvarchar(255)) 
exec sp_msforeachdb ' use ? exec sp_helpfile'
select dbname, Left(Filename,1) as Drive, FileName, FileGroup, Size_GB = (CAST(REPLACE(size, 'KB','') as Numeric(19,0)) / 8388608), maxsize , growth, usage = LEFT(usage,4) FROM #TempDatabasePath
Select * from #TempDatabasePath


