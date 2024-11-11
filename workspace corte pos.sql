-- use pinulito_pdv

-- cabecera
select nombre_empresa, nombre_tienda, direccion_tienda, format(getdate(), 'dd/MM/yyyy hh:mm tt') as fecha_hora_sistema from vwTiendas where codigo_empresa = '00005' and codigo_tienda = '00002'

-- resumen
exec spResumenSemanal @empresa = '00005', @tienda = '00002', @fecha = '2024-09-10'

-- venta
select b.descripcion, sum(b.cantidad) as cantidad, sum((b.cantidad * b.precio) - b.descuento) as total
from tFacturaSemanal as a
join tFacturaDetalleSemanal as b on a.idFactura = b.idFactura
where a.empresa = '00005' and a.tienda = '00002' and a.anulada = 0 and cast(a.fechaHora as date) = '2024-08-24' and a.canal ='POS-TIENDA'
group by b.descripcion order by b.descripcion

-- cupones
select b.descripcion, sum(b.cantidad) as cantidad, sum((b.cantidad * b.precio) - b.descuento) as total
from tFacturaSemanal as a
join tFacturaDetalleSemanal as b on a.idFactura = b.idFactura
where a.empresa = '00005' and a.tienda = '00002' and a.anulada = 0 and cast(a.fechaHora as date) = '2024-08-24' and a.canal ='CUPONES'
group by b.descripcion order by b.descripcion