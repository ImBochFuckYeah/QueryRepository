USE PINULITO_PDV;
-- 
SET DATEFIRST 1;
DECLARE @date AS DATE = '20241226';
-- 
SELECT tda.codigo_empresa, tda.codigo_tienda, tda.nombre_tienda, tda.nombre_administrador AS nombre_supervisor, tda.nombre_subadministrador, tda.division
FROM vwTiendas AS tda
LEFT JOIN tSolicitudSupervisorTienda AS spd ON CONCAT(tda.codigo_empresa, '-', tda.codigo_tienda) = spd.codigoTienda AND CAST(spd.fechaPedido AS DATE) = @date
JOIN tRutasBodegasTiendas AS rbt ON tda.codigo_empresa = rbt.empresa AND tda.codigo_tienda = rbt.tienda AND DATEPART(WEEKDAY, @date) = rbt.idSemana AND rbt.vigencia = 1
WHERE CAST(tda.codigo_empresa AS INT) IN (1, 2, 3, 4, 5, 7)
AND spd.idSolicitud IS NULL;
-- 
SELECT tda.codigo_empresa, tda.codigo_tienda, tda.nombre_tienda, tda.nombre_administrador AS nombre_supervisor, tda.nombre_subadministrador, tda.division
FROM vwTiendas AS [tda]
LEFT JOIN [DB_PALADIN].[dbo].[ORDR] AS [odv]
ON LEFT(odv.U_Cod_tienda, 5) COLLATE SQL_Latin1_General_CP1_CI_AS = tda.codigo_empresa COLLATE SQL_Latin1_General_CP1_CI_AS
AND RIGHT(odv.U_Cod_tienda, 5) COLLATE SQL_Latin1_General_CP1_CI_AS = tda.codigo_tienda COLLATE SQL_Latin1_General_CP1_CI_AS
AND CAST(odv.DocDueDate AS DATE) = @date AND odv.DocStatus = 'O'
WHERE tda.pedidoPaladin = 1 AND odv.DocEntry IS NULL;