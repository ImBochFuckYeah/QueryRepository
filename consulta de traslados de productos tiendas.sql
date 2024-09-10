-- use pinulito_pdv

select
-- top 100 
env.idEnvioTienda as numero_envio, env.fecha, tda.nombre_empresa as empresa, tda.nombre_tienda as tienda, envd.itemCode as codigo_producto, envd.itemName as nombre_producto, envd.quantity as cantidad, envd.unidad
from tEnvioTienda as env
join tEnvioTiendaDetalle as envd on env.idEnvioTienda = envd.idEnvioTienda
join vwTiendas as tda on env.empresa = tda.codigo_empresa and env.tienda = tda.codigo_tienda
where (tda.id_tienda in (226,357,465,498,555,574,577,644)) and (env.fecha between '2024-07-01' and '2024-08-11')