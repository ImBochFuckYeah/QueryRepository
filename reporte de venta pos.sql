use pinulito_pdv

select 
    -- top 100 
    tfs.idFactura AS [id],
    -- concat(tfs.idFactura, ',') AS [id_concat],
    tfs.empresa AS [codigo_empresa],
    tfs.tienda AS [codigo_tienda],
    tda.establecimiento AS [numero_establecimiento],
    tda.tda_nombre AS [nombre_tienda],
    tfs.nit AS [nit_receptor],
    tfs.nombre AS [nombre_receptor],
    tfs.total AS [gran_total],
    -- (SELECT STRING_AGG(descripcion, ', ') FROM [tFacturaDetalleSemanal] AS tfds WHERE tfds.idFactura = tfs.idFactura) AS [detalle_facturacion],
    -- tfs.fechaHora AS [fecha_hora_emision_pos],
    FORMAT(tfs.fechaHora, 'dd/MM/yyyy hh:mm:ss tt') AS [fecha_hora_emision_pos],
    tfs.canal,
    tfs.anulada,
    tfs.contingencia,
    tfs.noContingencia AS [numero_contingencia],
    tfs.serie AS [serie_documento],
    tfs.numero AS [numero_documento],
    tfs.uuidFactura AS [numero_certificacion_documento],
    tfs.fechaCertificacion AS [fecha_hora_certificacion_documento],
    tfs.uuidAnulacion AS [numero_anulacion_documento],
    tfs.fechaAnulacion AS [fecha_hora_anulacion_documento],
    tfs.detallePago AS [descripcion_pago],
    tfs.indendificador AS [identificador_unico]
from tFacturaSemanal tfs
left join tTienda tda on tda.empresa = tfs.empresa and tda.tienda = tfs.tienda
where tfs.idFactura in (0) -- and tfs.uuidFactura is null -- filtrar por facturas
order by fecha_hora_emision_pos