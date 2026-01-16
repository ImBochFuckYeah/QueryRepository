USE PINULITO_PDV;
GO 

-- SALIDAS DE INVENTARIO (POLLO CRUDO)
SELECT pt.codigoPrestamo AS serie,
	CONCAT(TRY_CAST(pt.empresaEnvio AS INT), TRY_CAST(pt.tiendaEnvio AS INT)) AS numero,
	pt.empresa,
	pt.tienda,
	pt.fechaPrestamo,
	NULL AS docNum,
	ISNULL(ae.SkuBase, pt.codigoSap) AS SkuBase,
	ISNULL(ae.DescripcionBase, pt.itemName) AS DescripcionBase,
	pt.SalUnitMsr AS uomCode,
	pt.cantidad AS quantity,
	ISNULL(ae.SkuEqv, pt.itemCode) AS SkuEqv,
	ISNULL(ae.DescripcionEqv, pt.itemName) AS DescripcionEqv,
	ISNULL(ae.UMedidaEqv, pt.SalUnitMsr)AS UMedidaEqv,
	ISNULL(ae.Paquete, pt.SalUnitMsr) AS Paquete,
	ISNULL(ae.precio, 0.00) AS precio
FROM tPrestamosTienda pt
LEFT JOIN tArticuloEqv ae ON pt.codigoSap = ae.SkuEqv
	AND ae.SkuBase LIKE 'PTV%'
	AND ae.DescripcionBase NOT LIKE '%CORTESIA%'
	AND ae.DescripcionBase NOT LIKE '%GRANDE%'
	AND ae.DescripcionBase NOT LIKE '%PICANTE%'
	AND ae.DescripcionBase NOT LIKE '%PARTIDO%'
WHERE fechaPrestamo = CAST(GETDATE() - 1 AS DATE)
	AND estado = 1
GROUP BY pt.codigoPrestamo,
	pt.empresaEnvio,
	pt.tiendaEnvio,
	pt.empresa,
	pt.tienda,
	pt.fechaPrestamo,
	ae.SkuBase,
	pt.codigoSap,
	ae.DescripcionBase,
	pt.itemName,
	pt.SalUnitMsr,
	pt.cantidad,
	ae.SkuEqv,
	pt.itemCode,
	ae.DescripcionEqv,
	ae.UMedidaEqv,
	ae.Paquete,
	ae.precio
ORDER BY serie;

-- ENTRADAS DE INVENTARIO (POLLO CRUDO)
--SELECT pt.codigoPrestamo AS serie,
--	CONCAT(TRY_CAST(pt.empresa AS INT), TRY_CAST(pt.tienda AS INT)) AS numero,
--	pt.empresa,
--	pt.tienda,
--	pt.fechaRecepcion,
--	NULL AS docNum,
--	ae.SkuBase,
--	ae.DescripcionBase,
--	pt.SalUnitMsr AS uomCode,
--	pt.cantidad AS quantity,
--	ae.SkuEqv,
--	ae.DescripcionEqv,
--	ae.UMedidaEqv,
--	ae.Paquete,
--	MIN(ae.precio) AS precio
--FROM tPrestamosTienda pt
--JOIN tArticuloEqv ae ON pt.codigoSap = ae.SkuEqv
--	AND ae.SkuBase LIKE 'PTV%'
--	AND ae.DescripcionBase NOT LIKE '%CORTESIA%'
--	AND ae.DescripcionBase NOT LIKE '%GRANDE%'
--	AND ae.DescripcionBase NOT LIKE '%PICANTE%'
--	AND ae.DescripcionBase NOT LIKE '%PARTIDO%'
--WHERE fechaRecepcion = CAST(GETDATE() AS DATE)
--	AND estado = 2
--GROUP BY pt.codigoPrestamo,
--	pt.empresa,
--	pt.tienda,
--	pt.fechaRecepcion,
--	ae.SkuBase,
--	ae.DescripcionBase,
--	pt.SalUnitMsr,
--	pt.cantidad,
--	ae.SkuEqv,
--	ae.DescripcionEqv,
--	ae.UMedidaEqv,
--	ae.Paquete
--ORDER BY serie;