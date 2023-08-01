SELECT
    T5.codigoProveedor,
    CONVERT(nvarchar, t2.fechaDetalle, 23) AS fechaDetalle,
    T6.CardName as proveedor,
    ISNULL(T5.docEntry, '') as docEntry
FROM
    tSolicitudBodega T1
    INNER JOIN tSolicitudDetalleBodega t2 ON t2.idSolicitud = T1.idSolicitud
    LEFT JOIN tAsignarProveedor T5 ON t2.idDetalle = T5.idDetalle AND t5.vigencia = 1
    LEFT JOIN DB_22_CORPORACION..OCRD T6 ON T5.codigoProveedor = T6.CardCode COLLATE DATABASE_DEFAULT
WHERE
    t1.idSolicitud = 341
GROUP BY
    T5.codigoProveedor,
    t2.fechaDetalle,
    T5.docEntry,
    T6.CardName