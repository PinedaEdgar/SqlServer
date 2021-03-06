USE [FARMACIAS_BENAVIDES_MEXICO_MX_2011_FHALF_C]
GO
/****** Object:  UserDefinedFunction [AMER\EPine01].[Benavides_fn_GetVoucherNbr]    Script Date: 02/24/2012 09:41:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET CONCAT_NULL_YIELDS_NULL ON;
GO
	CREATE FUNCTION [AMER\EPine01].[fn_concatenateVouchers]
	-- [Function: fn_concatenateVouchers ]
	-- [Author  : Edgar Pineda           ]
	-- [Comments: Concatenate Vouchers   ]
    (@VndNbr as varchar(10), @InvNbr as varchar(16), @InvDt as smalldatetime) RETURNS VARCHAR(MAX)
    AS
    BEGIN
            
            DECLARE @ListOfVouchers as VarChar(MAX);
            SET   @ListOfVouchers = '' ;

            SET @ListOfVouchers = (SELECT VOUCHER_NBR + ',' AS [data()] 
            FROM  Syn_ListOf_AP_Vouchers_Grp -- Pointing to a temp table (#)
            WHERE VndNbr = @VndNbr AND InvNbr =  @InvNbr AND InvDt = @InvDt
            FOR XML PATH('') );
           
            RETURN @ListOfVouchers;
   END