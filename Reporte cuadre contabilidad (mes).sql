USE PINULITO_PDV 

DECLARE @FechaIni DATE 
DECLARE @FechaFin DATE

SET
    @FechaIni = '2024-02-01'
SET
    @FechaFin = '2024-02-01' 
    
SELECT
    T1.idFactura llave_registro,
    T1.empresa codigo_empresa,
    T1.tienda codigo_tienda,
    T2.tda_nombre nombre_tienda,
    CONVERT(DATE, T1.fechahora) fecha,
    T1.nit,
    T1.nombre nombre_receptor,
    T1.serie,
    T1.numero,
    SUM(T1.total / 1.12) base,
    SUM(T1.total - (T1.total / 1.12)) iva,
    T1.total,
    T1.uuidFactura uuid_factura,
    T1.anulada estado,
    T1.fechaCertificacion fecha_certificacion 
FROM
    tFacturaSemanal T1
    JOIN tTienda T2 ON T1.tienda = T2.tienda AND T1.empresa = T2.empresa
WHERE
    CONVERT(DATE, T1.fechahora) >= @FechaIni AND CONVERT(DATE, T1.fechahora) <= @FechaFin
    AND (
        SELECT
            COUNT(*)
        FROM
            tFacturaDetalleSemanal
        WHERE
            idFactura = T1.idFactura
    ) >= 1
    AND T1.empresa = '00005'
    AND T2.inactiva = 0
GROUP BY
    T1.idFactura,
    T1.empresa,
    T1.tienda,
    T2.tda_nombre,
    T1.fechahora,
    T1.serie,
    T1.numero,
    T1.total,
    T1.uuidFactura,
    T1.anulada,
    T1.fechaCertificacion,
    T1.nit,
    T1.nombre