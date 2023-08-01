SELECT
    uuidFactura,
    COUNT(uuidFactura) AS vecesRegistrada
FROM
    pinulito_pdv..tFacturaSemanal
WHERE
	anulada = 0
GROUP BY
    uuidFactura
HAVING
    COUNT(uuidFactura) > 1
ORDER BY vecesRegistrada DESC