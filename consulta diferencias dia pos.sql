-- use pinulito_pdv

with cte_detalles as (
    select
    a.idFactura,
    sum((b.cantidad * b.precio) - b.descuento) as total_detalle
    from tFacturaSemanal as a
    join tFacturaDetalleSemanal as b on a.idFactura = b.idFactura
    where empresa = '00005' and tienda = '00091' and cast(fechaHora as date) = '2024-09-08'
    group by a.idFactura
)

select
b.idFactura,
b.uuidFactura,
b.total,
a.total_detalle,
(b.total - a.total_detalle) as diferencia
from cte_detalles as a
join tFacturaSemanal as b on a.idFactura = b.idFactura
group by b.idFactura, b.uuidFactura, b.total, a.total_detalle
order by diferencia desc