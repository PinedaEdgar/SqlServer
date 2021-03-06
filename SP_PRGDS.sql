SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE dbo.SP_PRGDS
  @FROMTABLE   SYSNAME,
  @DEBITCOLUMN SYSNAME = NULL,
  @COLUMNS     VARCHAR(8000) = NULL,
  @DIVISION    SYSNAME = NULL,
  @MAXDOP      SYSNAME = '1'
WITH RECOMPILE AS
SET NOCOUNT ON
DECLARE @SQL VARCHAR(8000)
DECLARE @CR CHAR(1)

SET @CR = CHAR(10)

-- CREATE THE PRGSTATS TABLE IF IT DOES NOT EXIST.
--
SELECT @SQL = @CR
  + @CR + 'IF NOT EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID(N''[DBO].[PRGDATESTATS]'') AND OBJECTPROPERTY(ID, N''ISUSERTABLE'') = 1)'
  + @CR + 'BEGIN'
  + @CR + '  CREATE TABLE [DBO].[PRGDATESTATS] '
  + @CR + '  ('
  + @CR + '    [TABLENAME] [CHAR] (30) NOT NULL ,'
  + @CR + '    [SEQ] [SMALLINT] NOT NULL ,'
  + @CR + '    [FIELD] [CHAR] (30) NOT NULL ,'
  + @CR + '    [YYYY] [CHAR] (4) NOT NULL ,'
  + @CR + '    [YYMM] [CHAR] (7) NOT NULL ,'
  + @CR + '    [LOWDATE] [CHAR] (10) NOT NULL ,'
  + @CR + '    [HIGHDATE] [CHAR] (10) NOT NULL ,'
  + @CR + '    [TOTALTRANS] [INT] NOT NULL ,'
  + @CR + '    [DEBITTRANS] [INT] NOT NULL ,'
  + @CR + '    CONSTRAINT [PK_prgDateStats_TableName_Seq_yymm] PRIMARY KEY  NONCLUSTERED '
  + @CR + '	   ('
  + @CR + '      [TableName],'
  + @CR + '      [Seq],'
  + @CR + '      [yymm]'
  + @CR + '    ) WITH  FILLFACTOR = 100  ON [PRIMARY] '
  + @CR + '  ) ON [PRIMARY]'
  + @CR + 'END'
EXEC (@SQL)

SELECT @SQL = @CR
  + @CR + 'IF NOT EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID(N''[DBO].[PRGNUMERICSTATS]'') AND OBJECTPROPERTY(ID, N''ISUSERTABLE'') = 1)'
  + @CR + 'BEGIN'
  + @CR + '  CREATE TABLE [DBO].[PRGNUMERICSTATS] '
  + @CR + '  ('
  + @CR + '    [TABLENAME] [CHAR] (30) NOT NULL ,'
  + @CR + '    [SEQ] [SMALLINT] NOT NULL ,'
  + @CR + '    [FIELD] [CHAR] (30) NOT NULL ,'
  + @CR + '    [NEGPOS] [SMALLINT] NOT NULL ,'
  + @CR + '    [LOG10] [SMALLINT] NOT NULL ,'
  + @CR + '    [DATASCALE] [SMALLINT] NOT NULL ,'
  + @CR + '    [LOWNUMBER] [CHAR] (28) NOT NULL ,'
  + @CR + '    [HIGHNUMBER] [CHAR] (28) NOT NULL ,'
  + @CR + '    [TOTALTRANS] [INT] NOT NULL ,'
  + @CR + '    [DEBITTRANS] [INT] NOT NULL ,'
  + @CR + '    CONSTRAINT [PK_prgNumericStats_TableName_Seq_NegPos_Log10] PRIMARY KEY  NONCLUSTERED '
  + @CR + '    ('
  + @CR + '      [TableName],'
  + @CR + '      [Seq],'
  + @CR + '      [NegPos],'
  + @CR + '      [Log10]'
  + @CR + '    ) WITH  FILLFACTOR = 100  ON [PRIMARY] '
  + @CR + '  ) ON [PRIMARY]'
  + @CR + 'END'
EXEC (@SQL)

SELECT @SQL = @CR
  + @CR + 'IF NOT EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID(N''[DBO].[PRGSTATS]'') AND OBJECTPROPERTY(ID, N''ISUSERTABLE'') = 1)'
  + @CR + 'BEGIN'
  + @CR + '  CREATE TABLE [DBO].[PRGSTATS] '
  + @CR + '  ('
  + @CR + '    [TABLENAME] [CHAR] (30) NOT NULL ,'
  + @CR + '    [SEQ] [SMALLINT] NOT NULL ,'
  + @CR + '    [FIELD] [CHAR] (30) NOT NULL ,'
  + @CR + '    [TEXT] [CHAR] (20) NOT NULL ,'
  + @CR + '    [LEN] [SMALLINT] NOT NULL ,'
  + @CR + '    [PRECIS] [SMALLINT] NOT NULL ,'
  + @CR + '    [DEC] [SMALLINT] NOT NULL ,'
  + @CR + '    [TYPE] [CHAR] (1) NOT NULL ,'
  + @CR + '    [TOTALCOUNT] [INT] NOT NULL ,'
  + @CR + '    [POPULATED] [INT] NOT NULL ,'
  + @CR + '    [PERPOP] [CHAR] (6) NOT NULL ,'
  + @CR + '    [NULLVALUES] [INT] NOT NULL ,'
  + @CR + '    [SPACES] [INT] NOT NULL ,'
  + @CR + '    [ZEROS] [INT] NOT NULL ,'
  + @CR + '    [POSITIVETOTAL] [INT] NOT NULL ,'
  + @CR + '    [NEGATIVETOTAL] [INT] NOT NULL ,'
  + @CR + '    [MINLENGTH] [INT] NOT NULL ,'
  + @CR + '    [MAXLENGTH] [INT] NOT NULL ,'
  + @CR + '    [MINIMUMVALUE] [CHAR] (30) NOT NULL ,'
  + @CR + '    [MAXIMUMVALUE] [CHAR] (30) NOT NULL ,'
  + @CR + '    CONSTRAINT [PK_prgStats_TableName_Seq] PRIMARY KEY  NONCLUSTERED '
  + @CR + '    ('
  + @CR + '      [TableName],'
  + @CR + '      [Seq]'
  + @CR + '    ) WITH  FILLFACTOR = 100  ON [PRIMARY] '
  + @CR + '  ) ON [PRIMARY]'
  + @CR + 'END'
EXEC (@SQL)

SELECT @SQL = @CR
  + @CR + 'IF NOT EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID(N''[DBO].[PRGSTATS_ALL]'') AND OBJECTPROPERTY(ID, N''ISUSERTABLE'') = 1)'
  + @CR + 'BEGIN'
  + @CR + '  CREATE TABLE [DBO].[PRGSTATS_ALL] '
  + @CR + '  ('
  + @CR + '    [TABLENAME] [CHAR] (30) NOT NULL ,'
  + @CR + '    [SEQ] [SMALLINT] NOT NULL ,'
  + @CR + '    [FIELD] [CHAR] (30) NOT NULL ,'
  + @CR + '    [TEXT] [CHAR] (20) NOT NULL ,'
  + @CR + '    [LEN] [SMALLINT] NOT NULL ,'
  + @CR + '    [PRECIS] [SMALLINT] NOT NULL ,'
  + @CR + '    [DEC] [SMALLINT] NOT NULL ,'
  + @CR + '    [TYPE] [CHAR] (1) NOT NULL ,'
  + @CR + '    [TOTALCOUNT] [INT] NOT NULL ,'
  + @CR + '    [POPULATED] [INT] NOT NULL ,'
  + @CR + '    [PERPOP] [CHAR] (6) NOT NULL ,'
  + @CR + '    [NULLVALUES] [INT] NOT NULL ,'
  + @CR + '    [SPACES] [INT] NOT NULL ,'
  + @CR + '    [ZEROS] [INT] NOT NULL ,'
  + @CR + '    [POSITIVETOTAL] [INT] NOT NULL ,'
  + @CR + '    [NEGATIVETOTAL] [INT] NOT NULL ,'
  + @CR + '    [MINLENGTH] [INT] NOT NULL ,'
  + @CR + '    [MAXLENGTH] [INT] NOT NULL ,'
  + @CR + '    [MINIMUMVALUE] [CHAR] (30) NOT NULL ,'
  + @CR + '    [MAXIMUMVALUE] [CHAR] (30) NOT NULL ,'
  + @CR + '    [YYYY] [CHAR] (4) NOT NULL ,'
  + @CR + '    [YYMM] [CHAR] (7) NOT NULL ,'
  + @CR + '    [LOWDATE] [CHAR] (10) NOT NULL ,'
  + @CR + '    [HIGHDATE] [CHAR] (10) NOT NULL ,'
  + @CR + '    [DATE_TOTALTRANS] [INT] NOT NULL ,'
  + @CR + '    [DATE_DEBITTRANS] [INT] NOT NULL ,'
  + @CR + '    [NEGPOS] [SMALLINT] NOT NULL ,'
  + @CR + '    [LOG10] [SMALLINT] NOT NULL ,'
  + @CR + '    [DATASCALE] [SMALLINT] NOT NULL ,'
  + @CR + '    [LOWNUMBER] [CHAR] (28) NOT NULL ,'
  + @CR + '    [HIGHNUMBER] [CHAR] (28) NOT NULL ,'
  + @CR + '    [NUM_TOTALTRANS] [INT] NOT NULL ,'
  + @CR + '    [NUM_DEBITTRANS] [INT] NOT NULL,'
  + @CR + '    [DIVISION] VARCHAR(255) NULL'
  + @CR + '  )'
  + @CR + 'END'
  + @CR + 'ELSE'
  + @CR + 'BEGIN'
  + @CR + '  IF NOT EXISTS (SELECT * FROM [INFORMATION_SCHEMA].[COLUMNS] WHERE [TABLE_NAME] = ''PRGSTATS_ALL'' AND [COLUMN_NAME] = ''DIVISION'')'
  + @CR + '  BEGIN'
  + @CR + '    ALTER TABLE [DBO].[PRGSTATS_ALL]'
  + @CR + '    ADD [DIVISION] VARCHAR(255) NULL'
  + @CR + '  END'
  + @CR + 'END'
EXEC (@SQL)

SELECT @SQL = @CR
  + @CR + '-- Create the Stats Description Table'
  + @CR + '--'
  + @CR + 'if NOT exists'
  + @CR + '  ('
  + @CR + '    select * from sysobjects where id = object_id(N''[DBO].[PRGStatsDescriptions]'')'
  + @CR + '    and OBJECTPROPERTY(id, N''IsUserTable'') = 1'
  + @CR + '  )'
  + @CR + '  CREATE TABLE [DBO].[PRGStatsDescriptions]'
  + @CR + '  ('
  + @CR + '    [TableName] [char] (30) NOT NULL,'
  + @CR + '    [Field] [char] (30) NOT NULL,'
  + @CR + '    [Text] [char] (20) NOT NULL'
  + @CR + '     CONSTRAINT [PK_prgStatsDescriptions] PRIMARY KEY CLUSTERED ([TableName], [Field])'
  + @CR + '  ) ON [PRIMARY]'
  + @CR + ''
  + @CR + '-- REMOVE THE ROWS THAT WILL BE INSERTED THAT MIGHT ALREADY EXIST.'
  + @CR + '-- THAT WAY WE ALWAYS GET THE LATEST DESCRITION.'
  + @CR + '--'
  + @CR + 'DELETE [DBO].[PRGSTATSDESCRIPTIONS]'
  + @CR + 'FROM [DBO].[PRGSTATSDESCRIPTIONS] [A]'
  + @CR + 'JOIN [DBO].[PRGSTATS] [B]'
  + @CR + 'ON [A].[TABLENAME] = [B].[TABLENAME]'
  + @CR + 'AND [A].[FIELD] = [B].[FIELD]'
  + @CR + 'WHERE RTRIM([B].[TEXT]) > '''''
  + @CR + ''
  + @CR + '-- INSERT THE DESCRIPTIONS INTO THE STATS DESCRIPTION TABLE FOR SAFE KEEPING'
  + @CR + '--'
  + @CR + 'INSERT INTO [DBO].[PRGSTATSDESCRIPTIONS]'
  + @CR + '('
  + @CR + '  [TABLENAME],'
  + @CR + '  [FIELD],'
  + @CR + '  [TEXT]'
  + @CR + ')'
  + @CR + 'SELECT'
  + @CR + '  [A].[TABLENAME],'
  + @CR + '  [A].[FIELD],'
  + @CR + '  [A].[TEXT]'
  + @CR + 'FROM [DBO].[PRGSTATS] [A]'
  + @CR + 'LEFT OUTER JOIN [DBO].[PRGSTATSDESCRIPTIONS] [B]'
  + @CR + 'ON [A].[TABLENAME] = [B].[TABLENAME]'
  + @CR + 'AND [A].[FIELD] = [B].[FIELD]'
  + @CR + 'WHERE [B].[TABLENAME] IS NULL'
  + @CR + ''
EXEC (@SQL)

DECLARE @TABLE         SYSNAME
DECLARE @QUOTETABLE    SYSNAME
DECLARE @COLUMN        SYSNAME
DECLARE @STAT_TYPE     SYSNAME
DECLARE @EXEC_SQL      VARCHAR(8000)
DECLARE @COLID         SMALLINT
DECLARE @LEN           SMALLINT
DECLARE @DEC           SMALLINT
DECLARE @PRECIS        SMALLINT
DECLARE @PROGRESS_MSG  VARCHAR(8000)

SELECT @TABLE = ISNULL(QUOTENAME(PARSENAME(@FROMTABLE, 2)) + '.', '') + QUOTENAME(PARSENAME(@FROMTABLE, 1)) -- PUT INTO [OWNER].[TABLE] FORMAT
SELECT @QUOTETABLE = QUOTENAME(PARSENAME(@TABLE, 1), CHAR(39)) -- PUT INTO [OWNER].[TABLE] FORMAT WITH QUOTES

-- CHECK FOR THE TABLE
--
IF NOT EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID(@TABLE) AND (OBJECTPROPERTY(ID, N'ISUSERTABLE') = 1 OR OBJECTPROPERTY(ID, N'ISVIEW') = 1))
BEGIN
  SELECT @PROGRESS_MSG = CONVERT(VARCHAR, GETDATE()) + ' PROCESSING STATISTICS FOR ' + @TABLE + ' TABLE IS NOT FOUND' RAISERROR(@PROGRESS_MSG,0,1)   WITH NOWAIT
  RETURN
END
ELSE
BEGIN
  SELECT @PROGRESS_MSG = CONVERT(VARCHAR, GETDATE()) + ' PROCESSING STATISTICS FOR ' + @TABLE  RAISERROR(@PROGRESS_MSG,0,1)   WITH NOWAIT
END

-- CHECK FOR DEBIT FIELD
--
IF LEN(ISNULL(@DEBITCOLUMN, '')) > 0
BEGIN
  SELECT @SQL = 'DECLARE @JUNK INT SELECT @JUNK = COUNT(*) FROM [INFORMATION_SCHEMA].[COLUMNS] WHERE [TABLE_NAME] = ''' + PARSENAME(@TABLE, 1) + ''' AND [COLUMN_NAME] = ''' + @DEBITCOLUMN + ''''
  EXEC (@SQL)
  IF @@ROWCOUNT = 0
  BEGIN
    SELECT @PROGRESS_MSG = CONVERT(VARCHAR, GETDATE()) + ' DEBIT COLUMN: ' + QUOTENAME(@DEBITCOLUMN) + ' NOT FOUND IN ' + @TABLE RAISERROR(@PROGRESS_MSG,0,1)   WITH NOWAIT
    RETURN
  END
  ELSE
  BEGIN
    SELECT @PROGRESS_MSG = CONVERT(VARCHAR, GETDATE()) + ' DEBIT COLUMN: ' + QUOTENAME(@DEBITCOLUMN) + ' USED IN ' + @TABLE RAISERROR(@PROGRESS_MSG,0,1)   WITH NOWAIT
  END
END
ELSE
BEGIN
  SELECT @DEBITCOLUMN = NULL
END

-- CHECK FOR DEBIT FIELD
--
IF LEN(ISNULL(@DIVISION, '')) > 0
BEGIN
  SELECT @SQL = 'DECLARE @JUNK INT SELECT @JUNK = COUNT(*) FROM [INFORMATION_SCHEMA].[COLUMNS] WHERE [TABLE_NAME] = ''' + PARSENAME(@TABLE, 1) + ''' AND [COLUMN_NAME] = ''' + @DIVISION + ''''
  EXEC (@SQL)
  IF @@ROWCOUNT = 0
  BEGIN
    SELECT @PROGRESS_MSG = CONVERT(VARCHAR, GETDATE()) + ' DIVISION COLUMN: ' + QUOTENAME(@DIVISION) + ' NOT FOUND IN ' + @TABLE RAISERROR(@PROGRESS_MSG,0,1)   WITH NOWAIT
    RETURN
  END
  ELSE
  BEGIN
    SELECT @PROGRESS_MSG = CONVERT(VARCHAR, GETDATE()) + ' DIVISION COLUMN: ' + QUOTENAME(@DIVISION) + ' USED IN ' + @TABLE RAISERROR(@PROGRESS_MSG,0,1)   WITH NOWAIT
  END
END
ELSE
BEGIN
  SELECT @DIVISION = NULL
END

IF LEN(ISNULL(@COLUMNS,'')) = 0
BEGIN
  SELECT @SQL = @CR
    + @CR + 'DELETE [DBO].[PRGDATESTATS] WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''''
    + @CR + 'DELETE [DBO].[PRGNUMERICSTATS] WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''''
    + @CR + 'DELETE [DBO].[PRGSTATS] WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''''
    + @CR + 'DELETE [DBO].[PRGSTATS_ALL] WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''''
  EXEC (@SQL)

  DECLARE [TABLE_COLUMNS_CURSOR] CURSOR FOR
    SELECT
      CASE [XTYPE]
        WHEN  34 THEN 'B' -- IMAGE
        WHEN  35 THEN 'B' -- TEXT
        WHEN  36 THEN 'B' -- UNIQUEIDENTIFIER
        WHEN  48 THEN 'N' -- TINYINT
        WHEN  52 THEN 'N' -- SMALLINT IDENTITY
        WHEN  56 THEN 'N' -- INT
        WHEN  58 THEN 'D' -- SMALLDATETIME
        WHEN  59 THEN 'N' -- REAL
        WHEN  60 THEN 'N' -- MONEY
        WHEN  61 THEN 'D' -- DATETIME
        WHEN  62 THEN 'N' -- FLOAT
        WHEN  99 THEN 'A' -- NTEXT
        WHEN 104 THEN 'B' -- BIT
        WHEN 106 THEN 'N' -- DECIMAL
        WHEN 108 THEN 'N' -- NUMERIC
        WHEN 122 THEN 'N' -- SMALLMONEY
        WHEN 165 THEN 'B' -- VARBINARY
        WHEN 167 THEN 'A' -- VARCHAR
--        WHEN 173 THEN 'B' -- BINARY
        WHEN 173 THEN 'A' -- BINARY
        WHEN 175 THEN 'A' -- CHAR
        WHEN 189 THEN 'B' -- TIMESTAMP
        WHEN 231 THEN 'A' -- NVARCHAR
        WHEN 239 THEN 'A' -- NCHAR
        ELSE 'B' -- TREAT LIKE BINARY
      END AS [STAT_TYPE],
      QUOTENAME([NAME]),
      [COLID],
      [LENGTH],
      [XPREC],
      [XSCALE]
    FROM SYSCOLUMNS
    WHERE [ID] = OBJECT_ID(@TABLE)
    ORDER BY [COLID]
END
ELSE
BEGIN
  SELECT @SQL = @CR
    + @CR + 'DELETE [DBO].[PRGDATESTATS] WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''' AND PATINDEX(''%'' + RTRIM([FIELD]) + ''%'', ''' + @COLUMNS + ''') > 0 '
    + @CR + 'DELETE [DBO].[PRGNUMERICSTATS] WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''' AND PATINDEX(''%'' + RTRIM([FIELD]) + ''%'', ''' + @COLUMNS + ''') > 0 '
    + @CR + 'DELETE [DBO].[PRGSTATS] WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''' AND PATINDEX(''%'' + RTRIM([FIELD]) + ''%'', ''' + @COLUMNS + ''') > 0 '
    + @CR + 'DELETE [DBO].[PRGSTATS_ALL] WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''''
  EXEC (@SQL)
-- PRINT @SQL
  DECLARE [TABLE_COLUMNS_CURSOR] CURSOR FOR
    SELECT
      CASE [XTYPE]
        WHEN  34 THEN 'B' -- IMAGE
        WHEN  35 THEN 'B' -- TEXT
        WHEN  36 THEN 'B' -- UNIQUEIDENTIFIER
        WHEN  48 THEN 'N' -- TINYINT
        WHEN  52 THEN 'N' -- SMALLINT IDENTITY
        WHEN  56 THEN 'N' -- INT
        WHEN  58 THEN 'D' -- SMALLDATETIME
        WHEN  59 THEN 'N' -- REAL
        WHEN  60 THEN 'N' -- MONEY
        WHEN  61 THEN 'D' -- DATETIME
        WHEN  62 THEN 'N' -- FLOAT
        WHEN  99 THEN 'A' -- NTEXT
        WHEN 104 THEN 'B' -- BIT
        WHEN 106 THEN 'N' -- DECIMAL
        WHEN 108 THEN 'N' -- NUMERIC
        WHEN 122 THEN 'N' -- SMALLMONEY
        WHEN 165 THEN 'B' -- VARBINARY
        WHEN 167 THEN 'A' -- VARCHAR
        WHEN 173 THEN 'B' -- BINARY
        WHEN 175 THEN 'A' -- CHAR
        WHEN 189 THEN 'B' -- TIMESTAMP
        WHEN 231 THEN 'A' -- NVARCHAR
        WHEN 239 THEN 'A' -- NCHAR
        ELSE 'B' -- TREAT LIKE BINARY
      END AS [STAT_TYPE],
      QUOTENAME([NAME]),
      [COLID],
      [LENGTH],
      [XPREC],
      [XSCALE]
    FROM SYSCOLUMNS
    WHERE [ID] = OBJECT_ID(@TABLE)
    AND PATINDEX('%' + RTRIM([NAME]) + '%', @COLUMNS) > 0
    ORDER BY [COLID]
END

OPEN [TABLE_COLUMNS_CURSOR]

FETCH NEXT FROM [TABLE_COLUMNS_CURSOR] INTO @STAT_TYPE, @COLUMN, @COLID, @LEN, @PRECIS, @DEC

WHILE @@FETCH_STATUS = 0
BEGIN
  -- PROGRESS MESSAGE
  --
  SELECT @PROGRESS_MSG = CONVERT(VARCHAR, GETDATE()) + ' PROCESSING STATISTICS FOR ' + @TABLE + ' COLUMN ' + @COLUMN RAISERROR(@PROGRESS_MSG,0,1) WITH NOWAIT

  SELECT @EXEC_SQL = 'INSERT INTO [DBO].[PRGSTATS_ALL]'
    + @CR + '('
    + @CR + '  [TABLENAME], [SEQ], [FIELD], [TEXT], [LEN], [PRECIS], [DEC], [TYPE], [TOTALCOUNT], [POPULATED], [PERPOP],'
    + @CR + '  [SPACES], [ZEROS], [NULLVALUES], [POSITIVETOTAL], [NEGATIVETOTAL], [MINLENGTH], [MAXLENGTH],'
    + @CR + '  [MINIMUMVALUE], [MAXIMUMVALUE], [YYYY], [YYMM], [LOWDATE], [HIGHDATE], [DATE_TOTALTRANS], [DATE_DEBITTRANS],'
    + @CR + '  [NEGPOS], [LOG10], [DATASCALE], [LOWNUMBER], [HIGHNUMBER], [NUM_TOTALTRANS], [NUM_DEBITTRANS], [DIVISION]'
    + @CR + ')'
    + @CR + 'SELECT'
    + @CR + '  ' + @QUOTETABLE + ' AS [TABLE],'
    + @CR + '  ' + CONVERT(VARCHAR, @COLID) + ' AS [SEQ],'
    + @CR + '  ' + QUOTENAME(CONVERT(VARCHAR(30), PARSENAME(@COLUMN,1)), CHAR(39)) + ' AS [FIELD],'
    + @CR + '  ' + QUOTENAME(CONVERT(VARCHAR(20), PARSENAME(@COLUMN,1)), CHAR(39)) + ' AS [TEXT],'
    + @CR + '  ' + CONVERT(VARCHAR, @LEN) + ' AS [LEN],'
    + @CR + '  ' + CONVERT(VARCHAR, @PRECIS) + ' AS [PRECIS],'
    + @CR + '  ' + CONVERT(VARCHAR, @DEC) + ' AS [DEC],'
    + @CR + '  ' + QUOTENAME(@STAT_TYPE, CHAR(39)) + ' AS [TYPE],'
    + @CR + '  COUNT(*) AS [TOTALCOUNT],'
    + @CR + CASE @STAT_TYPE
--              WHEN 'A' THEN '  SUM(CASE WHEN DATALENGTH(RTRIM(' + CONVERT(VARCHAR, @COLUMN) + ')) > 0 THEN 1 ELSE 0 END)'
              WHEN 'A' THEN '  SUM(CASE WHEN PATINDEX(''%[^ 0]%'', ' + CONVERT(VARCHAR, @COLUMN) + ') > 0 THEN 1 ELSE 0 END)'
              WHEN 'B' THEN '  SUM(CASE WHEN DATALENGTH(' + CONVERT(VARCHAR, @COLUMN) + ') > 0 THEN 1 ELSE 0 END)'
              WHEN 'D' THEN '  SUM(CASE WHEN ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', ''01/01/1900'') = ''01/01/1900'' THEN 0 ELSE 1 END)'
              WHEN 'N' THEN '  SUM(CASE WHEN ' + CONVERT(VARCHAR, @COLUMN) + ' <> 0.0 THEN 1 ELSE 0 END)'
              ELSE QUOTENAME('0', CHAR(39))
            END + ' AS [POPULATED],'
    + @CR + '  LEFT(CONVERT(VARCHAR,' + CASE @STAT_TYPE
--              WHEN 'A' THEN '  SUM(CASE WHEN DATALENGTH(RTRIM(' + CONVERT(VARCHAR, @COLUMN) + ')) > 0 THEN 1 ELSE 0 END)'
              WHEN 'A' THEN '  SUM(CASE WHEN PATINDEX(''%[^ 0]%'', ' + CONVERT(VARCHAR, @COLUMN) + ') > 0 THEN 1 ELSE 0 END)'
              WHEN 'B' THEN '  SUM(CASE WHEN DATALENGTH(' + CONVERT(VARCHAR, @COLUMN) + ') > 0 THEN 1 ELSE 0 END)'
              WHEN 'D' THEN '  SUM(CASE WHEN ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', ''01/01/1900'') = ''01/01/1900'' THEN 0 ELSE 1 END)'
              WHEN 'N' THEN '  SUM(CASE WHEN ' + CONVERT(VARCHAR, @COLUMN) + ' <> 0.0 THEN 1 ELSE 0 END)'
              ELSE QUOTENAME('0', CHAR(39))
            END + ' * 100.0 / COUNT(*)), 6) AS [PERPOP],'
    + @CR + CASE @STAT_TYPE
              WHEN 'A' THEN '  SUM(CASE WHEN RTRIM(' + CONVERT(VARCHAR, @COLUMN) + ') = '''' THEN 1 ELSE 0 END)'
              ELSE '  ' + QUOTENAME('0', CHAR(39))
            END + ' AS [SPACES],'
    + @CR + CASE @STAT_TYPE
              WHEN 'A' THEN '  SUM(CASE WHEN PATINDEX(''%[^ 0]%'', ' + CONVERT(VARCHAR, @COLUMN) + ') = 0 AND PATINDEX(''%0%'', ' + CONVERT(VARCHAR, @COLUMN) + ') > 0 THEN 1 ELSE 0 END)'
              WHEN 'N' THEN '  SUM(CASE WHEN ' + CONVERT(VARCHAR, @COLUMN) + ' = 0 THEN 1 ELSE 0 END)'
              WHEN 'D' THEN '  SUM(CASE ' + CONVERT(VARCHAR, @COLUMN) + ' WHEN ''01/01/1900'' THEN 1 ELSE 0 END)'
              ELSE '  ' + QUOTENAME('0', CHAR(39))
            END + ' AS [ZEROS],'
    + @CR + '  SUM(CASE WHEN ' + CONVERT(VARCHAR, @COLUMN) + ' IS NULL THEN 1 ELSE 0 END) AS [NULLVALUES],'
    + @CR + CASE @STAT_TYPE
              WHEN 'N' THEN '  SUM(CASE WHEN ' + CONVERT(VARCHAR, @COLUMN) + ' > 0 THEN 1 ELSE 0 END)'
              ELSE '  ' + QUOTENAME('0', CHAR(39))
            END + ' AS [POSITIVETOTAL],'
    + @CR + CASE @STAT_TYPE
              WHEN 'N' THEN '  SUM(CASE WHEN ' + CONVERT(VARCHAR, @COLUMN) + ' < 0 THEN 1 ELSE 0 END)'
              ELSE '  ' + QUOTENAME('0', CHAR(39))
            END + ' AS [NEGATIVETOTAL],'
    + @CR + '  MIN(ISNULL(' 
          + CASE @STAT_TYPE
              WHEN 'A' THEN 'DATALENGTH(RTRIM(LTRIM(ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', ''''))))'
              WHEN 'D' THEN '8'
              ELSE 'DATALENGTH(ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', 0))'
            END + ', 0)) AS [MINLENGTH],'
    + @CR + '  MAX(ISNULL(' 
          + CASE @STAT_TYPE
              WHEN 'A' THEN 'DATALENGTH(RTRIM(LTRIM(ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', ''''))))'
              WHEN 'D' THEN '29'
              ELSE 'DATALENGTH(ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', 0))'
            END + ', 0)) AS [MAXLENGTH],'
    + @CR + CASE @STAT_TYPE
              WHEN 'N' THEN '  LEFT(STR(MIN(ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', 0)), 28, 10), 30)'
              WHEN 'D' THEN '  LEFT(CONVERT(VARCHAR, MIN(ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', ''2079/06/06'')), 111), 30)'
              ELSE '  LEFT(CONVERT(VARCHAR, MIN(LTRIM(RTRIM(ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', '''')))), 111), 30)'
            END + ' AS [MINIMUMVALUE],'
    + @CR + CASE @STAT_TYPE
              WHEN 'N' THEN '  LEFT(STR(MAX(ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', 0)), 28, 10), 30)'
              WHEN 'D' THEN '  LEFT(CONVERT(VARCHAR, MAX(ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', ''1900/01/01'')), 111), 30)'
              ELSE '  LEFT(CONVERT(VARCHAR, MAX(LTRIM(RTRIM(ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', '''')))), 111), 30)'
            END + ' AS [MAXIMUMVALUE],'
    + @CR + CASE @STAT_TYPE
              WHEN 'D' THEN '  LEFT(ISNULL(CONVERT(VARCHAR, ' + CONVERT(VARCHAR, @COLUMN) + ', 111), ''1900/01/01''), 4)'
              ELSE '  ' + QUOTENAME('', CHAR(39))
            END + ' AS [YYYY],'
    + @CR + CASE @STAT_TYPE
              WHEN 'D' THEN '  LEFT(ISNULL(CONVERT(VARCHAR, ' + CONVERT(VARCHAR, @COLUMN) + ', 111), ''1900/01/01''), 7)'
              ELSE '  ' + QUOTENAME('', CHAR(39))
            END + ' AS [YYMM],'
    + @CR + CASE @STAT_TYPE
              WHEN 'D' THEN '  MIN(ISNULL(CONVERT(VARCHAR, ' + CONVERT(VARCHAR, @COLUMN) + ', 111), ''2079/06/06''))'
              ELSE '  ' + QUOTENAME('', CHAR(39))
            END + ' AS [LOWDATE],'
    + @CR + CASE @STAT_TYPE
              WHEN 'D' THEN '  MAX(ISNULL(CONVERT(VARCHAR, ' + CONVERT(VARCHAR, @COLUMN) + ', 111), ''1900/01/01''))'
              ELSE '  ' + QUOTENAME('', CHAR(39))
            END + ' AS [HIGHDATE],'
    + @CR + CASE @STAT_TYPE
              WHEN 'D' THEN '  COUNT(*)'
              ELSE '  ' + QUOTENAME('', CHAR(39))
            END + ' AS [DATE_TOTALTRANS],'
    + @CR + CASE @STAT_TYPE
              WHEN 'D' THEN 
                CASE WHEN @DEBITCOLUMN IS NOT NULL 
                  THEN '  SUM(CASE WHEN ' + QUOTENAME(@DEBITCOLUMN) + ' < 0 THEN 1 ELSE 0 END)' 
                  ELSE '  0' 
                END
              ELSE '  0'
            END + ' AS [DATE_DEBITTRANS],'
    + @CR + CASE @STAT_TYPE
              WHEN 'N' THEN '  CASE WHEN ' + CONVERT(VARCHAR, @COLUMN) + ' < 0 THEN 0 ELSE 1 END'
              ELSE '  0' 
            END + ' AS [NEGPOS],'
    + @CR + CASE @STAT_TYPE
              WHEN 'N' THEN '  CASE WHEN ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', 0) = 0 THEN 0 ELSE CONVERT(INT, LOG10(ABS(' + CONVERT(VARCHAR, @COLUMN) + '))) END'
              ELSE '  0' 
            END + ' AS [LOG10],'
    + @CR + '  0 AS [DATASCALE],'
    + @CR + CASE @STAT_TYPE
              WHEN 'N' THEN '  STR(MIN(ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', 0)), 28, 10)'
              ELSE '  ''''' 
            END + ' AS [LOWNUMBER],'
    + @CR + CASE @STAT_TYPE
              WHEN 'N' THEN '  STR(MAX(ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', 0)), 28, 10)'
              ELSE '  ''''' 
            END + ' AS [HIGHNUMBER],'
    + @CR + CASE @STAT_TYPE
              WHEN 'N' THEN '  COUNT(*)'
              ELSE '  0' 
            END + ' AS [NUM_TOTALTRANS],'
    + @CR + CASE @STAT_TYPE
              WHEN 'N' THEN 
                CASE WHEN @DEBITCOLUMN IS NOT NULL 
                  THEN '  SUM(CASE WHEN ' + QUOTENAME(@DEBITCOLUMN) + ' < 0 THEN 1 ELSE 0 END)' 
                  ELSE '  0' 
                END
              ELSE '  0' 
            END + ' AS [NUM_DEBITTRANS],'
    + @CR + CASE WHEN LEN(ISNULL(@DIVISION,'')) > 0 THEN '  CONVERT(VARCHAR(255), ' + QUOTENAME(@DIVISION) + ') ' ELSE '  NULL' 
          END + ' AS [DIVISION]'
    + @CR + 'FROM ' + @TABLE
    + @CR + CASE @STAT_TYPE 
        WHEN 'D' THEN 'GROUP BY'
          + CASE WHEN LEN(ISNULL(@DIVISION,'')) > 0 THEN '  ' + QUOTENAME(@DIVISION) + ', ' ELSE '' END
          + @CR + '  LEFT(ISNULL(CONVERT(VARCHAR, ' + CONVERT(VARCHAR, @COLUMN) + ', 111), ''1900/01/01''), 4),'
          + @CR + '  LEFT(ISNULL(CONVERT(VARCHAR, ' + CONVERT(VARCHAR, @COLUMN) + ', 111), ''1900/01/01''), 7)' 
        WHEN 'N' THEN 'GROUP BY'
          + CASE WHEN LEN(ISNULL(@DIVISION,'')) > 0 THEN '  ' + QUOTENAME(@DIVISION) + ', ' ELSE '' END
          + @CR + '  CASE WHEN ' + CONVERT(VARCHAR, @COLUMN) + ' < 0 THEN 0 ELSE 1 END,'
          + @CR + '  CASE WHEN ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', 0) = 0 THEN 0 ELSE 1 END,'
          + @CR + '  CASE WHEN ISNULL(' + CONVERT(VARCHAR, @COLUMN) + ', 0) = 0 THEN 0 ELSE CONVERT(INT, LOG10(ABS(' + CONVERT(VARCHAR, @COLUMN) + '))) END'
        ELSE CASE WHEN LEN(ISNULL(@DIVISION,'')) > 0 THEN '  GROUP BY ' + QUOTENAME(@DIVISION) ELSE '' END
      END
    + @CR + CASE WHEN @MAXDOP BETWEEN '1' AND '9' THEN 'OPTION(MAXDOP ' + @MAXDOP + ')' ELSE 'OPTION(MAXDOP 1)' END
    + @CR + ''

--  PRINT (@EXEC_SQL)
  EXEC (@EXEC_SQL)
  -- GET THE NEXT COLUMN TO CRUNCH
  --
  FETCH NEXT FROM [TABLE_COLUMNS_CURSOR] INTO @STAT_TYPE, @COLUMN, @COLID, @LEN, @PRECIS, @DEC
END

CLOSE [TABLE_COLUMNS_CURSOR]
DEALLOCATE [TABLE_COLUMNS_CURSOR]

SELECT @SQL = @CR
  + @CR + 'INSERT INTO [DBO].[PRGSTATS]'
  + @CR + '('
  + @CR + '  [TABLENAME], [SEQ], [FIELD], [TEXT], [LEN], [PRECIS], [DEC], [TYPE],'
  + @CR + '  [TOTALCOUNT], [POPULATED], [PERPOP], [NULLVALUES], [SPACES], [ZEROS], [POSITIVETOTAL], [NEGATIVETOTAL],'
  + @CR + '  [MINLENGTH], [MAXLENGTH], [MINIMUMVALUE], [MAXIMUMVALUE]'
  + @CR + ')'
  + @CR + '  SELECT'
  + @CR + '    [TABLENAME],'
  + @CR + '    [SEQ],'
  + @CR + '    [FIELD],'
  + @CR + '    [TEXT],'
  + @CR + '    [LEN],'
  + @CR + '    [PRECIS],'
  + @CR + '    [DEC],'
  + @CR + '    [TYPE],'
  + @CR + '    SUM([TOTALCOUNT]) AS [TOTALCOUNT],'
  + @CR + '    SUM([POPULATED]) AS [POPULATED],'
  + @CR + '    LEFT(CONVERT(VARCHAR, (SUM([POPULATED]) * 100.0 / SUM([TOTALCOUNT]))), 6) AS [PERPOP],'
  + @CR + '    SUM([NULLVALUES]),'
  + @CR + '    SUM([SPACES]),'
  + @CR + '    SUM([ZEROS]),'
  + @CR + '    SUM([POSITIVETOTAL]),'
  + @CR + '    SUM([NEGATIVETOTAL]),'
  + @CR + '    MIN([MINLENGTH]),'
  + @CR + '    MAX([MAXLENGTH]),'
  + @CR + '    MIN(CONVERT(NUMERIC(28,5), MINIMUMVALUE)) AS [MINIMUMVALUE],'
  + @CR + '    MAX(CONVERT(NUMERIC(28,5), MAXIMUMVALUE)) AS [MAXIMUMVALUE]'
  + @CR + '  FROM [DBO].[PRGSTATS_ALL]'
  + @CR + '  WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''' AND [TYPE] = ''N'''
  + @CR + '  GROUP BY'
  + @CR + '    [TABLENAME],'
  + @CR + '    [SEQ],'
  + @CR + '    [FIELD],'
  + @CR + '    [TEXT],'
  + @CR + '    [LEN],'
  + @CR + '    [PRECIS],'
  + @CR + '    [DEC],'
  + @CR + '    [TYPE]'
  + @CR + CASE WHEN @MAXDOP BETWEEN '1' AND '9' THEN 'OPTION(MAXDOP ' + @MAXDOP + ')' ELSE 'OPTION(MAXDOP 1)' END
  + @CR + ''

EXEC (@SQL)

SELECT @SQL = @CR
  + @CR + 'INSERT INTO [DBO].[PRGSTATS]'
  + @CR + '('
  + @CR + '  [TABLENAME], [SEQ], [FIELD], [TEXT], [LEN], [PRECIS], [DEC], [TYPE],'
  + @CR + '  [TOTALCOUNT], [POPULATED], [PERPOP], [NULLVALUES], [SPACES], [ZEROS], [POSITIVETOTAL], [NEGATIVETOTAL],'
  + @CR + '  [MINLENGTH], [MAXLENGTH], [MINIMUMVALUE], [MAXIMUMVALUE]'
  + @CR + ')'
  + @CR + '  SELECT'
  + @CR + '    [TABLENAME],'
  + @CR + '    [SEQ],'
  + @CR + '    [FIELD],'
  + @CR + '    [TEXT],'
  + @CR + '    [LEN],'
  + @CR + '    [PRECIS],'
  + @CR + '    [DEC],'
  + @CR + '    [TYPE],'
  + @CR + '    SUM([TOTALCOUNT]),'
  + @CR + '    SUM([POPULATED]),'
  + @CR + '    LEFT(CONVERT(VARCHAR, (SUM([POPULATED]) * 100.0 / SUM([TOTALCOUNT]))), 6),'
  + @CR + '    SUM([NULLVALUES]),'
  + @CR + '    SUM([SPACES]),'
  + @CR + '    SUM([ZEROS]),'
  + @CR + '    SUM([POSITIVETOTAL]),'
  + @CR + '    SUM([NEGATIVETOTAL]),'
  + @CR + '    MIN([MINLENGTH]),'
  + @CR + '    MAX([MAXLENGTH]),'
  + @CR + '    MIN([MINIMUMVALUE]),'
  + @CR + '    MAX([MAXIMUMVALUE])'
  + @CR + '  FROM [DBO].[PRGSTATS_ALL]'
--  + @CR + '  WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''' AND [TYPE] NOT IN (''N'', ''D'')'
  + @CR + '  WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''' AND [TYPE] NOT IN (''N'')'
  + @CR + '  GROUP BY'
  + @CR + '    [TABLENAME],'
  + @CR + '    [SEQ],'
  + @CR + '    [FIELD],'
  + @CR + '    [TEXT],'
  + @CR + '    [LEN],'
  + @CR + '    [PRECIS],'
  + @CR + '    [DEC],'
  + @CR + '    [TYPE]'
  + @CR + CASE WHEN @MAXDOP BETWEEN '1' AND '9' THEN 'OPTION(MAXDOP ' + @MAXDOP + ')' ELSE 'OPTION(MAXDOP 1)' END
  + @CR + ''

EXEC (@SQL)


SELECT @SQL = @CR
  + @CR + 'INSERT INTO [DBO].[PRGDATESTATS]'
  + @CR + '([TableName], [Seq], [Field], [yyyy], [yymm], [lowDate], [highDate], [totalTrans], [debitTrans])'
  + @CR + '  SELECT'
  + @CR + '    [TABLENAME],'
  + @CR + '    [SEQ],'
  + @CR + '    [FIELD],'
  + @CR + '    [YYYY],'
  + @CR + '    [YYMM],'
  + @CR + '    MIN([LOWDATE]),'
  + @CR + '    MAX([HIGHDATE]),'
  + @CR + '    SUM([DATE_TOTALTRANS]),'
  + @CR + '    SUM([DATE_DEBITTRANS])'
  + @CR + '  FROM [DBO].[PRGSTATS_ALL]'
  + @CR + '  WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''''
  + @CR + '  AND [TYPE] = ''D'''
  + @CR + '  AND [YYYY] <> ''1900'''
  + @CR + '  GROUP BY'
  + @CR + '    [TABLENAME],'
  + @CR + '    [SEQ],'
  + @CR + '    [FIELD],'
  + @CR + '    [YYYY],'
  + @CR + '    [YYMM]'
  + @CR + CASE WHEN @MAXDOP BETWEEN '1' AND '9' THEN 'OPTION(MAXDOP ' + @MAXDOP + ')' ELSE 'OPTION(MAXDOP 1)' END
  + @CR + ''

EXEC (@SQL)

SELECT @SQL = @CR
  + @CR + 'INSERT INTO [DBO].[PRGNUMERICSTATS]'
  + @CR + '([TableName], [Seq], [Field], [NegPos], [Log10], [DataScale], [lowNumber], [HighNumber], [totalTrans], [debitTrans])'
  + @CR + '  SELECT'
  + @CR + '    [TABLENAME],'
  + @CR + '    [SEQ],'
  + @CR + '    [FIELD],'
  + @CR + '    [NEGPOS],'
  + @CR + '    [LOG10],'
  + @CR + '    [DATASCALE],'
  + @CR + '    MIN([LOWNUMBER]),'
  + @CR + '    MAX([HIGHNUMBER]),'
  + @CR + '    SUM([NUM_TOTALTRANS]),'
  + @CR + '    SUM([NUM_DEBITTRANS]) '
  + @CR + '  FROM [DBO].[PRGSTATS_ALL]'
  + @CR + '  WHERE [TABLENAME] = ''' + PARSENAME(@TABLE, 1) + ''''
  + @CR + '  AND [TYPE] = ''N'''
  + @CR + '  AND [NEGPOS] IN (0, 1)'
  + @CR + '  AND (CONVERT(NUMERIC,[LOWNUMBER]) <> 0 AND CONVERT(NUMERIC,[HIGHNUMBER]) <> 0)'
  + @CR + '  GROUP BY'
  + @CR + '    [TABLENAME],'
  + @CR + '    [SEQ],'
  + @CR + '    [FIELD],'
  + @CR + '    [NEGPOS],'
  + @CR + '    [LOG10],'
  + @CR + '    [DATASCALE]'
  + @CR + CASE WHEN @MAXDOP BETWEEN '1' AND '9' THEN 'OPTION(MAXDOP ' + @MAXDOP + ')' ELSE 'OPTION(MAXDOP 1)' END
  + @CR + ''

EXEC (@SQL)

SELECT @SQL = @CR
  + @CR + '-- MAKE SURE THAT THE STATS TABLE IS UP TO DATE.SELECT'
  + @CR + '--'
  + @CR + 'UPDATE [DBO].[PRGSTATS]'
  + @CR + 'SET [TEXT] = [B].[TEXT]'
  + @CR + 'FROM [DBO].[PRGSTATS] [A]'
  + @CR + 'JOIN [DBO].[PRGSTATSDESCRIPTIONS] [B]'
  + @CR + 'ON [A].[TABLENAME] = [B].[TABLENAME]'
  + @CR + 'AND [A].[FIELD] = [B].[FIELD]'
  + @CR + 'WHERE RTRIM([A].[TEXT]) = '''''
  + @CR + CASE WHEN @MAXDOP BETWEEN '1' AND '9' THEN 'OPTION(MAXDOP ' + @MAXDOP + ')' ELSE 'OPTION(MAXDOP 1)' END
  + @CR + ''

EXEC (@SQL)



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

