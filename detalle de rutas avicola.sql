-- use grupopinulito

select 
rts.nombre as ruta,
rte.idenvio as numero_pedido,
fecha,
serie,
tda.division,
tda.codigo_empresa,
tda.nombre_empresa,
tda.codigo_tienda,
tda.nombre_tienda,
[PTV-001] AS pollo_grande_tradicional,
[PTV-002] AS pollo_grande_picante,
[PTV-003] AS pollo_estandar_tradicional,
[PTV-004] AS pollo_estandar_picante,
[PTV-005] AS pollo_estandar_artesando_libras,
[PTV-006] AS higado_cortesia,
[PTV-007] AS molleja,
[PTV-008] AS higado,
[PTV-009] AS patitas,
[PTV-010] AS pescuezos,
[PTV-011] AS cuadrilitos,
[PTV-012] AS cuadrilitos_cortesia,
[PTV-013] AS alitas,
[P010171] AS lasaña_precocida,
[PTV-015] AS pechuga_sin_ala,
[PTV-041] AS libra_de_patitas_cortesia,
[PTV-042] AS libra_de_pescuezos_cortesia,
[PTV-016] AS pollo_crudo_partido
from tRutasEnvio as rte
join tRutas as rts on rte.idruta = rts.idruta and rte.empresa = rts.empresa and rte.tienda = rts.tienda
join [pinulito_pdv].[dbo].[vwTiendas] as tda on rte.empresa = tda.codigo_empresa and rte.tienda = tda.codigo_tienda
where rte.idruta = 22 and rte.fecha = '2024-08-22'