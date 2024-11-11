-- use pinulito_pdv

select
a.empresa, count(*) as facturas, sum(a.total) as efectivo
from tFacturaSemanal as a
left join tFacturaDetalleSemanal as b on a.idFactura = b.idFactura
where cast(fechahora as date) between '20240901' and '20240920' and anulada = 0 and uuidFactura is null and b.idFacturaDetalle is null -- and a.nit <> 'CF'
group by a.empresa