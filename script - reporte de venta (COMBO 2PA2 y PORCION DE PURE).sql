USE PINULITO_PDV;
--
GO
--
SELECT division AS [DIVISION],
	tda_nombre AS [TIENDA],
	fecha_venta AS [FECHA],
	ISNULL([010349], 0) AS [PORCION DE PURE],
	ISNULL([010397], 0) AS [COMBO 2PA2]
FROM ( 
	SELECT td.division,
		td.tda_nombre,
		CAST(fs.fechaHora AS DATE) AS fecha_venta,
		fds.sku,
		SUM(fds.total) AS total
	FROM tFacturaSemanal fs
	JOIN tTienda td ON fs.empresa = td.empresa
		AND fs.tienda = td.tienda
	JOIN tFacturaDetalleSemanal fds ON fs.idFactura = fds.idFactura
	WHERE fs.anulada = 0
		AND TRY_CAST(fs.empresa AS INT) BETWEEN 1 AND 7
		AND TRY_CAST(fechaHora AS DATE) >= '2025-01-01'
		AND TRY_CAST(fechaHora AS DATE) <= '2025-10-12'
		AND fds.sku IN ('010349', '010397')
	GROUP BY td.division,
		td.tda_nombre,
		CAST(fs.fechaHora AS DATE),
		fds.sku
) AS sourceData
PIVOT (
	SUM(total) FOR sku IN ([010349], [010397])
) AS pivotTable
ORDER BY fecha_venta, tda_nombre;