USE PINULITO_PDV;
-- 
DECLARE @id INT = 29502;
-- 
WITH CTE_PT_PALADIN AS (
    SELECT T4.Code AS ItemCode, (T4.Quantity * T2.Quantity) AS Quantity
    FROM tSolicitudSupervisorTienda AS T1
    JOIN [DB_PRUEBA_22CORPO].[dbo].[WTR1] AS T2 ON T1.DocEntry = T2.DocEntry
    JOIN [DB_PRUEBA_22CORPO].[dbo].[OITT] AS T3 ON T2.ItemCode = T3.Code
    JOIN [DB_PRUEBA_22CORPO].[dbo].[ITT1] AS T4 ON T3.Code = T4.Father
    WHERE T1.idSolicitud = @id AND ISNULL(T2.Quantity, 0) > 0
)
-- 
SELECT T2.SWW AS itemCode, T2.ItemCode AS itemCode1, T2.ItemName AS dscription, CAST((T1.Quantity / T2.NumInSale) AS DECIMAL(10, 0)) AS quantity, T2.SalUnitMsr AS unitMsr, T2.SalUnitMsr AS uomCode, T1.Quantity AS quantityEntrada, 1 AS cantidadInventario, T2.U_Presentacion
FROM CTE_PT_PALADIN AS T1
JOIN [DB_PRUEBA_22CORPO].[dbo].[OITM] AS T2 ON T1.ItemCode = T2.ItemCode
ORDER BY T2.SWW;