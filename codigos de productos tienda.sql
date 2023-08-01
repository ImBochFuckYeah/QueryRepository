use pinulito_pdv

select
	det.descripcion,
	det.sku
from
	tfacturasemanal as cab
	inner join tfacturadetallesemanal as det on cab.idfactura = det.idfactura
where
	cab.empresa in ('00001', '00002', '00003', '00004', '00005')
	and cab.uuidFactura is not null
	and cab.anulada = 0
	and det.sku <> ''
group by
	det.descripcion, det.sku