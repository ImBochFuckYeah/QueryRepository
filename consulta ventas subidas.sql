USE PINULITO_PDV;

SELECT
    CONVERT(nvarchar, t0.fechaHora, 103) as fecha,
    SUM(t1.cantidad * t1.precio) as total
    --SUM(t1.cantidad * t1.precio) / 1.12 as iva
FROM
    tFacturaSapMensual t0
    inner join tFacturaDetalleSapMensual t1 on t1.idFactura = t0.idFactura
WHERE
    CONVERT(date, t0.fechaHora) BETWEEN '2024-01-01'
    AND '2024-01-31'
    and t0.empresa = '00005'
    AND t0.anulada = 0
GROUP BY
    CONVERT(nvarchar, t0.fechaHora, 103)
ORDER BY
    fecha ASC;
-----------------------------------------------------------------------------------------
USE PINULITO_PDV;

SELECT
    fecha as dia,
    t2.dbSAP,
    t0.empresa,
    t0.tienda,
    itemCode as sku,
    sku_base,
    itemName,
    cantidad,
    total,  
    total / cantidad as precioProm,
    t1.tda_nombre,
    t1.clienteSAP,
    t1.whsCode,
    t1.costingCode,
    t2.serieVentaSap
FROM
    vwResumenDiaSemanal t0
    INNER JOIN tTienda t1 ON t0.empresa = t1.empresa
    AND t0.tienda = t1.tienda
    INNER JOIN tEmpresa t2 ON t0.empresa = t2.empresa
WHERE
    fecha = '2024-06-26'
    -- fecha BETWEEN '2024-03-01' AND '2024-03-31'
    AND t0.empresa = '00002' -- AND t0.tienda = '$tienda'-- AND itemCode is not null
ORDER BY
    t0.fecha,
    empresa,
    tienda,
    t0.itemName