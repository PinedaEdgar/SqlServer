-- =========================================================
-- _CONCAT_FORMAT_CHOOSE
-- =========================================================

■■■■■■■■■■■■■■■■■■■■■■■■■■
--	CONCAT
■■■■■■■■■■■■■■■■■■■■■■■■■■

select  Vendornumber, vendorname, vendoraddr1, newname = Concat( vendorname, ', ' + vendoraddr1) from [dbo].[VendorMaster]
where  vendorkey < 15

■■■■■■■■■■■■■■■■■■■■■■■■■■
--	FORMAT DATES
■■■■■■■■■■■■■■■■■■■■■■■■■■

SELECT FORMAT(GETDATE(), 'd', 'en-US') AS us, FORMAT(GETDATE(), 'd', 'ja-JP') AS jp
-- 7/20/2017	2017/07/20
SELECT FORMAT(GETDATE(), 'd', 'en-US') AS us, FORMAT(GETDATE(), 's', 'ja-JP') AS jp
-- 7/20/2017	2017-07-20T10:56:44
SELECT FORMAT(GETDATE(), 'd', 'en-US') AS us, FORMAT(GETDATE(), 's') AS jp
-- 7/20/2017	2017-07-20T10:57:26
SELECT FORMAT(GETDATE(), 'd', 'en-US') AS us, FORMAT(GETDATE(), 'yyyy-MM-dd') AS ISO -- Without time
-- 7/20/2017	2017-07-20'
SELECT FORMAT(GETDATE(), 'd', 'en-US') AS us, FORMAT(GETDATE(), 'yyyy-MM-dd HH:mm:ss') AS ISO -- With time
-- 7/20/2017	2017-07-20 11:03:53


■■■■■■■■■■■■■■■■■■■■■■■■■■
--	FORMAT VALUES (Leading zeros)
■■■■■■■■■■■■■■■■■■■■■■■■■■


select top 100   [VendorID], FmtVendorId = FORMAT(CAST(VendorID as bigint),'0000000000'),  [OrigVendorName] from [dbo].[VendorMaster]
323972	0000323972	$20 CYCLE FILE PURGE
13244	0000013244	0706342 B.C. LTD.
43045	0000043045	0754170 BC LTD

select top 100   [VendorID], FmtVendorId = FORMAT(CAST(VendorID as bigint),'#-#####'),  [OrigVendorName] from [dbo].[VendorMaster]
323972	3-23972	$20 CYCLE FILE PURGE
13244	-13244	0706342 B.C. LTD.
43045	-43045	0754170 BC LTD

■■■■■■■■■■■■■■■■■■■■■■■■■■
--	CHOOSE
■■■■■■■■■■■■■■■■■■■■■■■■■■

SELECT  CHOOSE(MONTH(GETDATE()),'1Q','1Q', '1Q','1Q','2Q','2Q','2Q', '2Q',   
                                                   '3Q','3Q', '3Q','3Q','4Q','4Q','4Q', '4Q') AS Quart