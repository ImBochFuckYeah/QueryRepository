-- Crear un CTE para calcular las cantidades de combustible y lubricantes por factura
with cte_factura_detalle as (
    select 
        tfd.idFactura,
        sum(case when tfd.sku in ('CB0001', 'CB0002', 'CB0003', 'CB0004', 'CB0005', 'CB0006') then tfd.cantidad else 0 end) as cantidad_combustibles,
        sum(case when tfd.sku not in ('CB0001', 'CB0002', 'CB0003', 'CB0004', 'CB0005', 'CB0006') then tfd.cantidad else 0 end) as cantidad_lubricantes,
        string_agg(tfd.descripcion, ', ') as descripcion_venta
    from tFacturaDetalleSemanal tfd
    group by tfd.idFactura
)

select 
    tfs.idFactura AS [id],
    tfs.empresa AS [codigo_empresa],
    tfs.tienda AS [codigo_tienda],
    tda.establecimiento AS [numero_establecimiento],
    tda.tda_nombre AS [nombre_tienda],
    tfs.nit AS [nit_receptor],
    tfs.nombre AS [nombre_receptor],
    tfs.total AS [gran_total],
    tfs.fechaHora AS [fecha_hora_emision_pos],
    tfs.canal,
    tfs.anulada,
    tfs.contingencia,
    tfs.noContingencia AS [numero_contingencia],
    tfs.serie AS [serie_documento],
    tfs.numero AS [numero_documento],
    tfs.uuidFactura AS [numero_certificacion_documento],
    tfs.fechaCertificacion AS [fecha_hora_certificacion_documento],
    isnull(cte.cantidad_combustibles, 0) AS [cantidad_combustibles],
    isnull(cte.cantidad_lubricantes, 0) AS [cantidad_lubricantes],
    isnull(cte.descripcion_venta, ' - ') AS [descripcion_venta],
    tfs.detallePago AS [descripcion_pago]
from tFacturaSemanal tfs
left join tTienda tda on tda.empresa = tfs.empresa and tda.tienda = tfs.tienda
left join cte_factura_detalle cte on cte.idFactura = tfs.idFactura
where tfs.empresa = '00015' and tfs.anulada = 0 and cast(tfs.fechaHora as date) between '2024-06-01' and '2024-06-15' -- gasolinera
order by tfs.fechaHora, tfs.idFactura;