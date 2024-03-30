UPDATE tFacturaDetalleSemanal
SET sku = 'CB0004', descripcion = 'MAXXIMA PREMIUM'
WHERE idFactura IN (
    SELECT cab.idFactura
    FROM tFacturaSemanal cab
    WHERE empresa = '00015' AND tienda = '00004' AND sku = 'CB0001'
);

UPDATE tFacturaDetalleSemanal
SET sku = 'CB0005', descripcion = 'MAXXIMA REGULAR'
WHERE idFactura IN (
    SELECT cab.idFactura
    FROM tFacturaSemanal cab
    WHERE empresa = '00015' AND tienda = '00004' AND sku = 'CB0002'
);

UPDATE tFacturaDetalleSemanal
SET sku = 'CB0006', descripcion = 'DIESEL ADITIVADO'
WHERE idFactura IN (
    SELECT cab.idFactura
    FROM tFacturaSemanal cab
    WHERE empresa = '00015' AND tienda = '00004' AND sku = 'CB0003'
);