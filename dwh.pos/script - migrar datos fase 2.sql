USE PINULITO_PDV;
--
--SELECT serie, COUNT(*) num
--FROM tEntradaInventario
--WHERE CAST(fecha AS DATE) >= '20250901' AND CAST(fecha AS DATE) <= '20250903'
--GROUP BY serie;
--
SELECT ei.serie,
	ei.numero,
	ei.empresa,
	ei.tienda,
    FORMAT(ei.fecha, 'yyyy-MM-dd') AS fecha,
	ei.docNum,
	ae.SkuBase,
	ae.DescripcionBase,
	eid.uomCode,
	eid.quantity,
	ae.SkuEqv,
	ae.DescripcionEqv,
	ae.UMedidaEqv,
	ae.Paquete,
	ae.precio
FROM tEntradaInventario ei
JOIN tEntradaInventarioDetalle eid ON ei.idEntradaInventario = eid.idEntradaInventario
JOIN tArticuloEqv ae ON eid.itemCode = ae.SkuBase
WHERE CAST(fecha AS DATE) = '20250901'
	AND ei.serie IN ('AG2', 'AG3', 'AG4')
	AND anulado = 0;
-- 
USE grupopinulito;
-- 
SELECT idruta,
empresa,
tienda,
fecha,
Origen,
Serie,
IdVehiculo,
Piloto,
Despachador,
idenvio,
numSAP,
sku,
cantidad
FROM [grupopinulito].[dbo].[tRutasEnvio]
UNPIVOT (
    cantidad FOR sku IN (
        [PTV-001],
        [PTV-002],
        [PTV-003],
        [PTV-004],
        [PTV-005],
        [PTV-006],
        [PTV-007],
        [PTV-008],
        [PTV-009],
        [PTV-010],
        [PTV-011],
        [PTV-012],
        [PTV-013],
        [P010171],
        [PTV-015],
        [PTV-016],
        [PTV-041],
        [PTV-042]
    )
) AS unpvt
WHERE fecha = '20250901' AND cantidad > 0;