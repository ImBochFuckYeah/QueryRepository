USE PINULITO_PDV;
GO

WITH Items AS (
    SELECT d.sku, d.descripcion, o.ItemCode, o.ItemName, o.BuyUnitMsr, CASE WHEN d.sku = 'PROP' THEN 'S' ELSE 'BB' END AS TypeItem, SUM((d.precio * d.cantidad) - d.descuento) AS TotalLine, SUM(d.cantidad) AS Quantity
    FROM tFacturaSemanal AS f
    JOIN tFacturaDetalleSemanal AS d ON f.idFactura = d.idFactura
    LEFT JOIN [DB_SAN_ESTEBAN].[dbo].[OITM] AS o ON d.sku COLLATE SQL_Latin1_General_CP850_CI_AS = o.SWW COLLATE SQL_Latin1_General_CP850_CI_AS
    WHERE f.empresa = '00010' AND f.tienda = '00001' AND f.numSAP IS NULL AND CAST(f.fechaHora AS DATE) >= '2025-10-06' AND CAST(f.fechaHora AS DATE) <= '2025-10-31' AND f.anulada = 0
    GROUP BY d.sku, d.descripcion, o.ItemCode, o.ItemName, d.sku, o.BuyUnitMsr
)
SELECT *, (TotalLine / Quantity) AS Price, 'IVA' AS TaxCode, 'QTZ' AS Currency
FROM Items