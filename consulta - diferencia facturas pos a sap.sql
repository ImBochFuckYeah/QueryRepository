USE PINULITO_PDV;
-- 
DECLARE @date DATE = '20241231';
-- 
WITH INVOICES AS (
SELECT head.numSAP, SUM(item.cantidad * item.precio) AS total
FROM tFacturaSAPmensual AS head
JOIN tFacturaDetalleSAPmensual AS item ON head.idFactura = item.idFactura
WHERE head.empresa = '00003' AND CAST(head.fechaHora AS DATE) = @date AND anulada = 0 AND head.numSAP IS NOT NULL
GROUP BY head.numSAP
)
-- 
SELECT onv.DocEntry, onv.docNum, onv.DocTotal, inv.total, (onv.DocTotal - inv.total) AS diferencia
FROM INVOICES AS inv
LEFT JOIN [DB_22_PICONCITO].[dbo].[OINV] AS onv ON onv.docNum = inv.numSAP
-- WHERE onv.DocStatus = 'O';