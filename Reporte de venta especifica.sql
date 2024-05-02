USE PINULITO_PDV;

SELECT
  tienda,
  [010112],
  [010113],
  [010108],
  [010109],
  [010110],
  [010115],  
  [E0013],
  [010157],
  [010220],
  [010205],
  [010263],
  [010262],
  [010207],
  [010111],
  [010228],
  [010101],
  [010208],
  [010209],
  [010210],
  [010211],
  [010106],
  [010117],
  [010107],
  [010332],
  [010333],
  [010279],
  [010280],
  [010281],
  [010282],
  [010271],
  [010331],
  [010330],
  [010346],
  [010347]
FROM
  (
    SELECT
      tda.tda_nombre AS tienda,
      det.sku,
      det.cantidad AS sku_total
    FROM
      tFacturaSemanal AS cab (NOLOCK)
      INNER JOIN tFacturaDetalleSemanal AS det (NOLOCK) ON cab.idFactura = det.idFactura
      INNER JOIN tTienda AS tda (NOLOCK) ON cab.empresa = tda.empresa
      AND cab.tienda = tda.tienda
    WHERE
      cab.anulada = 0
      AND cab.uuidFactura IS NOT NULL
      AND cab.empresa IN ('00001', '00002', '00003', '00004', '00005')
      AND tda.inactiva = 0
      AND CONVERT(DATE, cab.fechaHora) BETWEEN '2024-04-01'
      AND '2024-04-07'
  ) AS SourceData PIVOT (
    SUM(sku_total) FOR sku IN (
      [010112],
      [010113],
      [010108],
      [010109],
      [010110],
      [010115],
      [E0013],
      [010157],
      [010220],
      [010205],
      [010263],
      [010262],
      [010207],
      [010111],
      [010228],
      [010101],
      [010208],
      [010209],
      [010210],
      [010211],
      [010106],
      [010117],
      [010107],
      [010332],
      [010333],
      [010279],
      [010280],
      [010281],
      [010282],
      [010271],
      [010331],
      [010330],
      [010346],
      [010347]
    )
  ) AS PivotTable