DECLARE @columns NVARCHAR(MAX)
DECLARE @sql NVARCHAR(MAX)

-- Obtener la lista de columnas dinámicamente
SELECT @columns = COALESCE(@columns + ', ', '') + QUOTENAME(ItemName)
FROM (
    SELECT DISTINCT t3.ItemName
    FROM tInventarioTienda t1
    JOIN tInventarioTiendaDetalle t2 ON t1.idInventarioTienda = t2.idInventarioTienda
    JOIN [db_22_corporacion].[dbo].[oitm] t3 ON t2.itemcode = t3.sww COLLATE SQL_Latin1_General_CP850_CI_AS
    WHERE t1.fecha BETWEEN '2024-01-01' AND '2024-03-31' AND t1.empresa = '00001'
) AS ItemNames

-- Construir la consulta dinámica de PIVOT
SET @sql = '
SELECT 
    tienda, ' + @columns + '
FROM 
    (
        SELECT
            t4.tda_nombre AS tienda,
            t3.ItemName,
            SUM(t2.cantidad) AS cantidad
        FROM 
            tInventarioTienda t1
            JOIN tInventarioTiendaDetalle t2 ON t1.idInventarioTienda = t2.idInventarioTienda
            JOIN [DB_CORPORACION_21].[dbo].[OITM] t3 ON t2.itemcode = t3.itemcode COLLATE SQL_Latin1_General_CP850_CI_AS
            JOIN tTienda t4 ON t1.empresa = t4.empresa AND t1.tienda = t4.tienda
        WHERE 
            t1.fecha BETWEEN ''2024-01-01'' AND ''2024-03-31'' AND t1.empresa = ''00001''
        GROUP BY
            t4.tda_nombre,
            t3.ItemName
    ) AS SourceTable
PIVOT
(
    SUM(cantidad)
    FOR ItemName IN (' + @columns + ')
) AS PivotTable'

-- Ejecutar la consulta dinámica
EXEC sp_executesql @sql