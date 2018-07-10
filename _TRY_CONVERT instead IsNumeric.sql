-- =======================================
--	_Instead of IsNumeric
-- =======================================


-- =======================================
-- Sample #1 - TRY_CONVERT in CASE 
-- =======================================
DECLARE @a TABLE(ColA VARCHAR(10));
  INSERT INTO @a VALUES
  ('abc'), ('123'), ('$456'), ('22:35:27');
  SELECT ColA, CASE
    WHEN TRY_CONVERT(int, ColA) IS NOT NULL 
      THEN CAST(colA AS INT)
  END AS TestResults
  FROM @a;
  
-- =======================================
-- Sample #2 - TRY_CONVERT in WHERE
-- =======================================
DECLARE @a TABLE(ColA VARCHAR(10));
  INSERT INTO @a VALUES
  ('abc'), ('123'), ('$456'), ('22:35:27');
  SELECT CAST(colA AS INT)
  FROM @a 
  WHERE TRY_CONVERT(int, ColA) IS NOT NULL 
-- Excelent ... better than IsNumeric
