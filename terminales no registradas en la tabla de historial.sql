/* BUSCAR POR TIENDA */

SELECT
    idTienda,
    tda_nombre nombre_tienda,
    empresa,
    tienda,
    terminalCredomatic
FROM
    tTienda
WHERE
    idTienda NOT IN (
        SELECT T2.idTienda FROM tTerminalCredomaticTienda T1 JOIN tTienda T2 ON T1.empresa = T2.empresa AND T1.tienda = T2.tienda GROUP BY T2.idTienda
    ) AND inactiva = 0
    AND terminalCredomatic IS NOT NULL
    AND terminalCredomatic <> ''

/* BUSCAR POR TERMINAL */

SELECT 
    tda_nombre nombre_tienda,
    empresa,
    tienda,
    terminalCredomatic
FROM
    tTienda
WHERE
    terminalCredomatic NOT IN (
        SELECT terminalCredomatic FROM tTerminalCredomaticTienda
    )
    AND inactiva = 0