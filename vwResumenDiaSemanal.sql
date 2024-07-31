SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    ALTER VIEW [dbo].[vwResumenDiaSemanal] AS
SELECT
    CAST(t0.fechaCertificacion AS DATE) as fecha,
    t0.empresa,
    t0.tienda,
    t2.itemCode,
    t1.descripcion as itemName,
    SUM(t1.cantidad) as cantidad,
    SUM(t1.total) as total
FROM
    tFacturaSapMensual t0
    INNER JOIN tFacturaDetalleSapMensual t1 ON t0.idFactura = t1.idFactura
    LEFT OUTER JOIN tCodigoSap t2 ON t1.descripcion = t2.itemName
WHERE
    serie != '00000000'
    AND uuidFactura is not null
    AND anulada = 0
    AND t2.vigente = 1
    AND numSAP is null
GROUP BY
    CAST(t0.fechaCertificacion AS DATE),
    t0.empresa,
    t0.tienda,
    t2.itemCode,
    t1.descripcion
GO