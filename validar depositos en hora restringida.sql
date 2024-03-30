USE PINULITO_PDV;

SELECT 
    tTienda.idTienda,
    tDeposito.empresa, 
    tDeposito.tienda, 
    tTienda.tda_nombre,
    SUM(monto) monto
    --tDeposito.*
FROM 
    tDeposito
    JOIN tTienda ON tTienda.empresa = tDeposito.empresa AND tTienda.tienda = tDeposito.tienda
WHERE 
    /* tTienda.idTienda IN (
        144,
        307,
        408,
        27
    )
    AND */ CAST(fechaCrea AS DATE) = CAST(GETDATE() AS DATE)
    AND CAST(fechaCrea AS TIME) BETWEEN '14:59:59' AND '15:59:59'
    AND [fechaVenta ] = CAST(GETDATE() - 1 AS DATE)
    AND Anulado = 0
GROUP BY
    tTienda.idTienda, tDeposito.empresa, tDeposito.tienda, tTienda.tda_nombre;