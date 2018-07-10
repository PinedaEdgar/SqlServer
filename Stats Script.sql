use [WALMART_GT_2017_AP_F]

DECLARE @DataType as varchar(1)
SET @DataType = 'A'
-- =============================
SELECT 
		RowsCt ,
		NULLS ,
		[SPACES] ,
		[ZEROS] , 
		[NULLS] ,
		[MINLENGTH]  ,
		[MAXLENGTH] ,
		[MINIMUMVALUE]  ,
		[MAXIMUMVALUE]  ,
		[xBlanks]  ,
		[xNulls]  ,
		[xZeros]
FROM (
		SELECT top (1)
		RowsCt = (SELECT COUNT(*) FROM  [WALMART_GT_2017_AP_F].dbo.P_AP_CAM),
		NULLS = ( SELECT COUNT(*) FROM  [WALMART_GT_2017_AP_F].dbo.P_AP_CAM where PONbr is null),
		SPACES = ( SELECT COUNT(*) FROM  [WALMART_GT_2017_AP_F].dbo.P_AP_CAM where PONbr = '' ),
		ZEROS = ( SELECT COUNT(*) FROM  [WALMART_GT_2017_AP_F].dbo.P_AP_CAM where IsNumeric(PONbr) = 1 ), -- 1 = Numeric
		[MINLENGTH] = (SELECT MIN(LEN(PONbr)) FROM  [WALMART_GT_2017_AP_F].dbo.P_AP_CAM ) ,
		[MAXLENGTH] = (SELECT MAX(LEN(PONbr)) FROM  [WALMART_GT_2017_AP_F].dbo.P_AP_CAM ) ,
		[MINIMUMVALUE] = ( SELECT MIN(PONbr) FROM  [WALMART_GT_2017_AP_F].dbo.P_AP_CAM ) ,
		[MAXIMUMVALUE] = ( SELECT MAX(PONbr) FROM  [WALMART_GT_2017_AP_F].dbo.P_AP_CAM ) ,
		-- 
		CASE @DataType
              WHEN 'D' THEN (select count(*) from P_AP_CAM where CAST(InvDt as varchar(8)) = '' )   
              WHEN 'A' THEN (select count(*) from P_AP_CAM where PONbr = '' ) 
              WHEN 'N' THEN (select count(*) from P_AP_CAM where CAST(GrsInvAmt as varchar(30)) = '' )   
        END as xBlanks,

		CASE @DataType
              WHEN 'D' THEN (select count(*) from P_AP_CAM where InvDt is Null   )     
              WHEN 'A' THEN (select count(*) from P_AP_CAM where PONbr is Null ) 
              WHEN 'N' THEN (select count(*) from P_AP_CAM where GrsInvAmt is Null )  
        END as xNulls,

		CASE @DataType
              WHEN 'D' THEN (select count(*) from P_AP_CAM where InvDt = 0   )     
              WHEN 'N' THEN (select count(*) from P_AP_CAM where GrsInvAmt = 0 )  
			  WHEN 'A' THEN (SELECT COUNT(*) from (	SELECT PONbr1 = CASE WHEN IsNumeric( PONbr ) = 1 Then CAST(PONbr as float) Else Null end FROM [WALMART_GT_2017_AP_F].dbo.P_AP_CAM  
	                                           WHERE PATINDEX( '%[^0-9]%', PONbr ) = 0 AND PONbr NOT LIKE ''  ) a
                                               WHERE PONbr1 = 0 ) 
        END as xZeros