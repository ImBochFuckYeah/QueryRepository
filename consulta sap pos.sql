-- use pinulito_pdv

select
    fecha as dia,
    t2.dbSAP,
    t0.empresa,
    t0.tienda,
    itemCode as sku,
    sku_base,
    itemName,
    cantidad,
    total,  
    (total / cantidad) as precioProm,
    precio,
    t1.tda_nombre,
    t1.clienteSAP,
    t1.whsCode,
    t1.costingCode,
    t2.serieVentaSap
from
    vwResumenDiaSap t0
    -- vwResumenDiaSemanal t0
    join tTienda t1 on t0.empresa = t1.empresa and t0.tienda = t1.tienda
    join tEmpresa t2 on t0.empresa = t2.empresa
where
    fecha = '2024-07-17'
    and t0.empresa = '00002' and t0.tienda = '00089'
    -- t0.numSAP = 92306
order by
    t0.fecha,
    empresa,
    tienda,
    t0.itemName