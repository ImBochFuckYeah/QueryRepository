use pinulito_pdv

declare @empresa int = '00003', @fecha date = '2024-09-15';

with facturas_pos as (
    select cab.numsap, sum((det.cantidad * det.precio) - det.descuento) as total
    from tfacturasapmensual as cab
    join tfacturadetallesapmensual as det on cab.idfactura = det.idfactura
    where cab.empresa = @empresa and cast(cab.fechahora as date) = @fecha and cab.anulada = 0 and cab.numSAP is not null
    group by numsap
)

select 
docnum,
cardcode,
doctotal,
(table_1.doctotal - table_2.total) as diferencia
from [db_22_piconcito].[dbo].[oinv] as table_1
join facturas_pos as table_2 on table_1.docnum = table_2.numsap
order by diferencia desc