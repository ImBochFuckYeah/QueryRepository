SELECT
    t1.empresa,
    t1.tienda,
    CONVERT(DATE, fechaHora) as fecha,
    SUM(salesAmount) as Credomatic
FROM
    tTransaccionCredomatic t0
    INNER JOIN tTienda t1 ON t0.terminalId = t1.terminalCredomatic
WHERE
    t0.responseCode = '00'
    AND totalAmount > 0
    AND salesAmount > 0
GROUP BY
    t1.empresa,
    t1.tienda,
    CONVERT(DATE, fechaHora)