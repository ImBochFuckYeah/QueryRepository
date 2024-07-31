/* SELECT COUNT(*) FROM tfacturaSapTemporal WHERE vigente = 0

SELECT COUNT(*) FROM tFacturaSapMensual */

/* SELECT 
    COUNT(*)
FROM 
    tFacturaSemanal t1 
    JOIN tFacturaSapTemporal t2 ON t1.uuidFactura = t2.uuid
WHERE
    t1.anulada = 0 */

/* SELECT 
    CONVERT(date, fechaHora, 103) fecha,
    SUM(t1.total) / 1.12 total
FROM 
    tFacturaSemanal t1 
    JOIN tFacturaSapTemporal t2 ON t1.uuidFactura = t2.uuid
WHERE
    t1.anulada = 0
GROUP BY
    CONVERT(date, fechaHora, 103)
ORDER BY
    fecha; */

/* SELECT 
    t1.*
FROM 
    tFacturaSemanal t1 
    JOIN tFacturaSapTemporal t2 ON t1.uuidFactura = t2.uuid
WHERE
    YEAR(t1.fechaHora) = 2024
    AND MONTH(t1.fechaHora) = 2 */

/* SELECT COUNT(*) FROM tfacturaSapTemporal */

-- UPDATE
--     tFacturaSapMensual 
-- SET
--     fechaHora = DATEADD(DAY, -5, CAST(fechaCertificacion AS DATE))
-- WHERE 
--     empresa = '00005'
--     AND anulada = 0
--     AND DATEDIFF(DAY, CAST(fechaHora AS DATE), CAST(fechaCertificacion AS DATE)) > 5

-- SELECT
--     COUNT(*)
-- FROM
--     tFacturaSapMensual 
-- WHERE
--     empresa = '00005'
--     AND anulada = 0
--     AND DATEDIFF(DAY, CAST(fechaHora AS DATE), CAST(fechaCertificacion AS DATE)) > 5

-- SELECT 
--     -- TOP 100 
--     DATEADD(DAY, -5, CAST(fechaCertificacion AS DATE)) fecha_certificacion,
--     uuidFactura,
--     *
-- FROM 
--     tFacturaSapMensual 
-- WHERE 
--     empresa = '00004'
--     AND anulada = 0
--     AND DATEDIFF(DAY, CAST(fechaHora AS DATE), CAST(fechaCertificacion AS DATE)) > 5

SELECT
    idFactura,
    uuidFactura,
    CAST(fechaHora AS DATE) fecha,
    t1.total total_cabecera,
    (
        SELECT
            SUM(cantidad * precio)
        FROM
            tFacturaDetalleSapMensual t2
        WHERE
            t1.idFactura = t2.idFactura
    ) total_detalle
FROM
    tFacturaSapMensual t1
WHERE
    t1.total < (
        SELECT
            SUM(cantidad * precio)
        FROM
            tFacturaDetalleSapMensual t2
        WHERE
            t1.idFactura = t2.idFactura
    )
    AND empresa = '00005'
    AND cast(fechahora AS DATE) BETWEEN '2024-06-01' AND '2024-06-30'
    AND anulada = 0
    AND detallePago not like '%cupon%'
ORDER BY
    total_cabecera DESC;