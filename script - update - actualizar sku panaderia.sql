USE PINULITO_PDV;
-- 
UPDATE T1
SET T1.sku = T2.SWW
FROM tFacturaDetalleSapMensual AS T1
INNER JOIN [DB_CORPORACION_21].[dbo].[OITM] AS T2 
    ON T1.descripcion COLLATE SQL_Latin1_General_CP1_CI_AS = T2.ItemName COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE T1.sku = '';