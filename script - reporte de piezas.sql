USE PINULITO_PDV;
-- 
-- REPORTE: POR DIA
SELECT *
FROM (
    SELECT tienda = tda.tda_nombre, dia = FORMAT(tfs.fechaHora, 'dd'), pollos = (SUM(tfds.cantidad * artp.Quantity) / 7)
    FROM tFacturaSemanal AS tfs
    JOIN tFacturaDetalleSemanal AS tfds ON tfs.idFactura = tfds.idFactura
    JOIN tProductoPiezas AS artp ON tfds.sku = artp.FatherItemCode
    JOIN tTienda AS tda ON tfs.empresa = tda.empresa AND tfs.tienda = tda.tienda
    WHERE tda.reporteVentaPollos = 1 AND tfs.anulada = 0 AND CAST(tfs.fechaHora AS DATE) >= '20250817' AND CAST(tfs.fechaHora AS DATE) <= '20250824'
    GROUP BY tda.tda_nombre, FORMAT(tfs.fechaHora, 'dd')
) AS SourceData
PIVOT (
    SUM (pollos)
    FOR dia IN ([17], [18], [19], [20], [21], [22], [23], [24])
) AS PivotTable;
-- 
-- REPORTE: POR DÍA E INTEVERLOS DE HORAS
SELECT *
FROM (
    SELECT 
        tienda = tda.tda_nombre,
        dia = FORMAT(tfs.fechaHora, 'dd'),
        intervalo = CONCAT(
            RIGHT('00' + CAST((DATEPART(HOUR, tfs.fechaHora) / 2) * 2 AS VARCHAR), 2),
            ':00-',
            RIGHT('00' + CAST(((DATEPART(HOUR, tfs.fechaHora) / 2) * 2) + 2 AS VARCHAR), 2),
            ':00'
        ),
        pollos = (SUM(tfds.cantidad * artp.Quantity) / 7)
    FROM tFacturaSemanal AS tfs
    JOIN tFacturaDetalleSemanal AS tfds ON tfs.idFactura = tfds.idFactura
    JOIN tProductoPiezas AS artp ON tfds.sku = artp.FatherItemCode
    JOIN tTienda AS tda ON tfs.empresa = tda.empresa AND tfs.tienda = tda.tienda
    WHERE tda.reporteVentaPollos = 1 
      AND tfs.anulada = 0 
      AND CAST(tfs.fechaHora AS DATE) >= '20250817' 
      AND CAST(tfs.fechaHora AS DATE) <= '20250824'
    GROUP BY 
        tda.tda_nombre, 
        FORMAT(tfs.fechaHora, 'dd'),
        (DATEPART(HOUR, tfs.fechaHora) / 2)
) AS SourceData
PIVOT (
    SUM (pollos)
    FOR dia IN ([17], [18], [19], [20], [21], [22], [23], [24])
) AS PivotTable
ORDER BY tienda, intervalo;