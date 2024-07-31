-- use pinulito_pdv;

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
    and cab.empresa = '00003'
    and cast(fechaHora as date) between '2024-06-16' and '2024-06-30'
group by
    cast(fechaHora as date)
order by fecha;

-- select uuidFactura, count(*) from tFacturaSapMensual where anulada = 0 and empresa = '00003' group by uuidFactura having count(uuidFactura) > 1;

-- select * from tFacturaSapMensual where uuidFactura in (
-- '01B814C9-45E3-4617-9D0B-056C65130145',
-- 'CD6C762D-DC8C-4409-8E0A-B2D46E841FD8'
-- );

-- update tFacturaSapMensual set anulada = 1 where idFactura in (
-- 494641,
-- 381154
-- );

-- select * from tFacturaSapMensual where idFactura = 528075
-- select * from tFacturaDetalleSapMensual where idFactura = 528075
-- delete from tFacturaDetalleSapMensual where idFacturaDetalle in (
-- 845197
-- )