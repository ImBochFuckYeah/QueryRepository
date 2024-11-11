SELECT
table_1.idRecoleccion AS [id],
CONCAT(table_2.codigo_empresa, ' - ', table_2.nombre_empresa) AS [empresa],
CONCAT(table_2.codigo_tienda, ' - ', table_2.nombre_tienda) AS [tienda],
FORMAT(table_1.fecha, 'dd/MM/yyyy') AS [fecha_recoleccion],
table_1.noBoleta AS [numero_boleta],
table_1.cantidad,
CASE WHEN table_1.anulado = 1 THEN 'ANULADO' ELSE 'VIGENTE' END AS [estado]
FROM [tRecoleccionAceite] AS table_1
JOIN [vwTiendas] AS table_2 ON table_2.codigo_empresa = table_1.empresa AND table_2.codigo_tienda = table_1.tienda
WHERE CAST(table_1.fecha AS date) BETWEEN '20241015' AND '20241018';