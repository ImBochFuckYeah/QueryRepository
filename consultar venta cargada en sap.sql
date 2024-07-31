/* VENTA CARGADA */
-- SELECT empresa, numSAP FROM tFacturaSapMensual WHERE numSAP IS NOT NULL GROUP BY empresa, numSAP

-- SELECT
--     (select tda_nombre from tTienda tda where cab.empresa = tda.empresa and cab.tienda = tda.tienda) nombre_tienda,
--     cab.empresa, 
--     cab.tienda, 
--     cab.numSAP,
--     SUM((det.cantidad * det.precio) - det.descuento) total,
--     SUM(((det.cantidad * det.precio) - det.descuento)/1.12) base
-- FROM 
--     tFacturaSapMensual cab
--     JOIN tFacturaDetalleSapMensual det ON cab.idFactura = det.idFactura
-- WHERE 
--     cab.numSAP IS NOT NULL 
-- GROUP BY 
--     cab.empresa, cab.tienda, cab.numSAP;

/* ANULAR VENTA */

-- UPDATE tFacturaSapMensual SET numSAP = NULL WHERE numSAP IS NOT NULL;

-- SELECT COUNT(*) FROM tanularSapEmpresa WHERE anulado = 0;

-- TRUNCATE TABLE tanularSapEmpresa;

-- INSERT INTO [PINULITO_PDV].[dbo].[tanularSapEmpresa] (empresa, docEntry)
-- SELECT
-- '00001',
-- DocEntry
-- FROM [DB_22_CORPORACION].[dbo].[OINV]
-- WHERE DocNum IN ()