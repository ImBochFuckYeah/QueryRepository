-- use grupopinulito

select
lrt.idlruta AS numero_ruta,
lrt.cede,
lrt.nombre AS nombre_ruta,
SUM(ISNULL([PTV-001], 0)) AS pollo_grande_tradicional,
SUM(ISNULL([PTV-002], 0)) AS pollo_grande_picante,
SUM(ISNULL([PTV-003], 0)) AS pollo_estandar_tradicional,
SUM(ISNULL([PTV-004], 0)) AS pollo_estandar_picante,
SUM(ISNULL([PTV-005], 0)) AS pollo_estandar_artesando_libras,
SUM(ISNULL([PTV-006], 0)) AS higados_cortesia,
SUM(ISNULL([PTV-007], 0)) AS mollejas,
SUM(ISNULL([PTV-008], 0)) AS higados,
SUM(ISNULL([PTV-009], 0)) AS patitas,
SUM(ISNULL([PTV-010], 0)) AS pescuezos,
SUM(ISNULL([PTV-011], 0)) AS cuadrilitos,
SUM(ISNULL([PTV-012], 0)) AS cuadrilitos_cortesia,
SUM(ISNULL([PTV-013], 0)) AS alitas,
SUM(ISNULL([P010171], 0)) AS lasañas_precocida
from tRutasEnvio as rte
join tListaRutas as lrt on rte.idruta = lrt.idlruta
where (fecha between '2024-08-19' and '2024-08-23') and (impresoRastro = 1)
group by lrt.idlruta, lrt.nombre, lrt.cede