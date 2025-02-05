SELECT
    TIENDA,
    DIVISION,
    SUPERVISOR,
    SUBADMINISTRADOR,
    ISNULL([010101], 0) AS [COMBO 1],
    ISNULL([010208], 0) AS [COMBO 2 (bollo)],
    ISNULL([010209], 0) AS [COMBO 3 (bollo)],
    ISNULL([010210], 0) AS [COMBO FAMILIAR (bollo)],
    ISNULL([010211], 0) AS [SUPER COMBO]
FROM
    (
        SELECT
            tda.nombre_tienda AS TIENDA,
            tda.division AS DIVISION,
            tda.nombre_administrador AS SUPERVISOR,
            tda.nombre_subadministrador AS SUBADMINISTRADOR,
            det.sku,
            SUM(det.cantidad * det.precio) AS sku_total
        FROM
            tFactura AS cab
            JOIN tFacturaDetalle AS det ON cab.idFactura = det.idFactura
            JOIN vwTiendas AS tda ON cab.empresa = tda.codigo_empresa
            AND cab.tienda = tda.codigo_tienda
        WHERE
            cab.anulada = 0
            AND CAST(cab.fechaHora AS DATE) BETWEEN '2022-05-02'
            AND '2022-05-29'
        GROUP BY
            tda.nombre_tienda,
            tda.division,
            tda.nombre_administrador,
            tda.nombre_subadministrador,
            det.sku
    ) AS SourceData PIVOT(
        SUM(sku_total) FOR sku IN (
            [010101],
            [010208],
            [010209],
            [010210],
            [010211]
        )
    ) AS PivotTable