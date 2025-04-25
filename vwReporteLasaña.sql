SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER VIEW [dbo].[vwReporteLasaña] as 
SELECT x.fecha, z.nombre as empresa, w.tda_nombre as tienda, x.Cantidad as quantityRastro, ISNULL(y.quantity,0) as quantityTienda, x.Cantidad - ISNULL(y.quantity,0) as diferencia,
CASE 
WHEN y.quantity IS NULL THEN 'Tienda No Ingreso Recepcion'
ELSE ''
END as comentario,
ISNULL(y.quantity, x.Cantidad) as CantidadCobro  
	FROM  (
	SELECT convert(date, t0.fecha) as fecha, empresa, tienda, t0.serie, t0.idEnvio, sku, Descripcion, cantidad, UMedida FROM tEnvio t0
	INNER JOIN tEnvioDetalle t1 ON t0.idEnvio = t1.idEnvio AND t0.idRuta = t1.idRuta
	WHERE t1.Sku = 'P010171' 
	UNION ALL
	SELECT fecha, empresa, tienda, serie, idEnvio, 'P010171' as sku, 'LASAÑA PRECOCIDA' as Descripcion , P010171 as cantidad,  'UNIDAD' UMedida
FROM [10.238.57.39].[grupopinulito].[dbo].[tRutasEnvio] WHERE impreso = 1 AND fecha >= '2022-09-05'
) x

LEFT OUTER JOIN (

	SELECT convert(date, fecha) as fecha, empresa, tienda, serie, numero, t1.itemCode, quantity FROM tEntradaInventario t0
	INNER JOIN tEntradaInventarioDetalle t1 ON t0.idEntradaInventario = t1.idEntradaInventario
	WHERE t1.itemCode = 'P010171' AND anulado = 0) y ON x.fecha = y.fecha AND x.Serie = y.serie AND x.idEnvio = y.numero

INNER JOIN tEmpresa z ON x.Empresa = z.empresa
INNER JOIN tTienda w ON x.Empresa = w.empresa AND x.Tienda = w.tienda

	






GO
