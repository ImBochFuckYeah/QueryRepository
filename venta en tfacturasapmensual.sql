use pinulito_pdv;

select 
    cast(fechaHora as date) fecha,
    sum(((det.cantidad * det.precio) - det.descuento) / 1.12) base,
    sum((det.cantidad * det.precio) - det.descuento) total
    -- sum((cab.total) / 1.12) base,
    -- sum((cab.total) - det.descuento) total
from
    tFacturaSapMensual cab
    join tFacturaDetalleSapMensual det on det.idFactura = cab.idFactura
where
    cab.anulada = 0
    and cab.empresa = '00002'
    and cast(fechaHora as date) between '2024-10-01' and '2024-10-20'
group by
    cast(fechaHora as date)
order by fecha;

-- select uuidFactura, count(*) from tFacturaSapMensual where anulada = 0 and empresa = '00002' group by uuidFactura having count(uuidFactura) > 1;
-- select * from tFacturaSapMensual where uuidFactura in ();
-- update tFacturaSapMensual set anulada = 1 where idFactura in ();