-- =======================================
--	_IF EXISTS
-- =======================================

-- Note: IF EXISTS has a better performance than 'SELECT COUNT(*)'


IF EXISTS(SELECT * FROM dbo.P_PRODUCT WHERE BUYER_NAME = 'CYNDI MOUNT')
  SELECT Buyer_name, brand_type
  FROM dbo.P_PRODUCT
  WHERE BUYER_NAME = 'CYNDI MOUNT';
-- 4 times faster that sample below

IF ( SELECT COUNT(*) FROM dbo.P_PRODUCT WHERE BUYER_NAME = 'CYNDI MOUNT') > 0
  SELECT Buyer_name, brand_type
  FROM dbo.P_PRODUCT
  WHERE BUYER_NAME = 'CYNDI MOUNT';
