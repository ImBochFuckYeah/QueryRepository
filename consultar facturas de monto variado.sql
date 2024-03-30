USE PINULITO_PDV;

SELECT
    idFactura,
    uuidFactura, 
    total AS total_cabecera,
    (
        SELECT SUM(cantidad * precio)
        FROM tFacturaDetalleSemanal AS Detalle
        WHERE Detalle.idFactura = Cabecera.idFactura
    ) AS total_detalle
FROM 
    tFacturaSemanal AS Cabecera
WHERE 
    CONVERT(DATETIME, fechaHora) BETWEEN '2023-12-01' AND '2024-01-03'
    AND uuidFactura IS NULL
    AND contingencia = 1
    --AND empresa IN ('00001', '00002', '00003', '00004', '00005')
    AND empresa IN ('00005')
    AND anulada = 0
    AND total <> (
        SELECT SUM(cantidad * precio)
        FROM tFacturaDetalleSemanal AS Detalle
        WHERE Detalle.idFactura = Cabecera.idFactura
    );