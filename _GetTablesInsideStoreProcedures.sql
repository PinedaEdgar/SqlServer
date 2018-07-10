-- ============================================================
-- Name: _GetTablesInsideStoreProcedures
-- Author: E.Pineda
-- Comments: Geeting the tables used by a store proc
-- ============================================================

-- =========================================================
--	GROUPING
-- =========================================================

use [RITE_AID_CORP_QTRLY_2016_APR_C]

WITH stored_procedures AS (
SELECT 
o.name AS proc_name, oo.name AS table_name,
ROW_NUMBER() OVER(partition by o.name,oo.name ORDER BY o.name,oo.name) AS row
FROM sysdepends d 
INNER JOIN sysobjects o ON o.id=d.id
INNER JOIN sysobjects oo ON oo.id=d.depid
WHERE o.xtype = 'P')
SELECT proc_name, table_name FROM stored_procedures
WHERE row = 1
ORDER BY proc_name,table_name