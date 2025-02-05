USE PINULITO_PDV;
-- 
WITH CTE_Duplicados AS (
    SELECT 
        idDetalle,
        ROW_NUMBER() OVER(PARTITION BY idDocumento, tipoDocumento, monto ORDER BY fechaCreacion) AS filaDuplicada
    FROM 
        dbo.tDetalleRevisionCuadreSemanal
    WHERE CAST(fechaCreacion AS DATE) BETWEEN '20241201' AND '20241212' AND idEstado IN (1, 2)
)
-- UPDATE dbo.tDetalleRevisionCuadreSemanal
-- SET 
--     idEstado = 3
-- FROM 
--     dbo.tDetalleRevisionCuadreSemanal AS t
-- INNER JOIN 
--     CTE_Duplicados AS d ON t.idDetalle = d.idDetalle
-- WHERE 
--     d.filaDuplicada > 1;  -- Esto excluye el primer registro de cada grupo de duplicados
SELECT * FROM CTE_Duplicados WHERE filaDuplicada > 1