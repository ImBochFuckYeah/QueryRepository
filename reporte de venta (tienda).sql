SELECT
        cab.idFactura,
        cab.canal,
        cab.nit,
        cab.nombre,
        cab.serie,
        cab.numero,
        cab.uuidFactura,
        CONVERT(varchar, cab.fechaHora,103) AS fecha,
        cab.total,
        cab.detallePago
    FROM
        tfacturasemanal AS cab
    WHERE
        cab.idfactura IN (
            SELECT
                subdet.idfactura
            FROM
                tfacturadetallesemanal AS subdet
            WHERE
                subdet.sku = '010101'
        )
        AND cab.anulada = 0 AND cab.uuidFactura IS NOT NULL
        AND cab.empresa = '00005' 
        AND cab.tienda = '00002' 
        AND CONVERT(DATE, cab.fechaHora) = '2023-08-03'