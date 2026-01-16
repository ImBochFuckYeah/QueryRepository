-- 2024-06-10
-- Vista que une la tabla de ruta de envio de avigua con la tabla de entrada de mercancia
-- para mostrar los productos que han sido enviados y recibidos en las tiendas
DROP VIEW IF EXISTS pos.vw_ruta_envio_entrada;
-- 
CREATE OR REPLACE VIEW pos.vw_ruta_envio_entrada AS
SELECT ra.id_ruta_avigua,
    ra.fecha_ruta_avigua,
    ra.numero_ticket_avigua,
	ra.placa_vehiculo AS placa_vehiculo_avigua,
    ra.conductor_vehiculo AS conductor_vehiculo_avigua,
    ra.sku_producto AS sku_producto_avigua,
    ra.cantidad_producto AS cantidad_producto_avigua,
    tdae.division AS division_tienda_envio,
    tdae.nombre AS nombre_tienda_envio,
    em.fecha_entrada AS fecha_recepcion,
    tdar.division AS division_tienda_recepcion,
    tdar.nombre AS nombre_tienda_recepcion,
    em.sku_producto_entrada AS sku_producto_recepcion,
	em.descripcion_producto_entrada AS descripcion_producto_recepcion,
    em.cantidad_entrada AS cantidad_producto_recepcion
FROM infocorp.ruta_avigua AS ra
JOIN pos.tienda AS tdae
    ON ra.codigo_empresa = tdae.codigo_empresa
    AND ra.codigo_tienda = tdae.codigo_tienda
LEFT JOIN pos.entrada_mercancia AS em
    -- ON ra.codigo_empresa = em.codigo_empresa
    -- AND ra.codigo_tienda = em.codigo_tienda
    ON ra.numero_ticket_avigua = em.numero_ticket
    AND ra.sku_producto = em.sku_producto_entrada
JOIN pos.tienda AS tdar
    ON em.codigo_empresa = tdar.codigo_empresa
    AND em.codigo_tienda = tdar.codigo_tienda;
-- 
-- 2024-06-10
-- Vista de kardex de pollo
-- Se asume un inventario inicial de 100 unidades
DROP VIEW IF EXISTS pos.vw_kardex_pollo;
-- 
CREATE OR REPLACE VIEW pos.vw_kardex_pollo AS
WITH RECURSIVE kardex_base AS (
    -- datos base por día
    SELECT tda.division,
           tda.nombre AS nombre_tienda,
           em.fecha_entrada,
           SUM(em.cantidad_entrada) AS cantidad_entrada,
           SUM(sm.cantidad) AS cantidad_salida
    FROM pos.entrada_mercancia AS em
    JOIN pos.tienda AS tda
         ON em.codigo_empresa = tda.codigo_empresa
        AND em.codigo_tienda = tda.codigo_tienda
    JOIN dwh.datos AS sm
         ON CAST(em.codigo_empresa AS INT) = sm.codemp
        AND CAST(em.codigo_tienda AS INT) = sm.codtda
        AND CAST(em.fecha_entrada AS DATE) = sm.fecha
    WHERE em.sku_producto_equivalente = '010154'
      AND sm.coditem = 'MP0006'
    GROUP BY tda.division, tda.nombre, em.fecha_entrada
),
ordenado AS (
    -- ordenamos por fecha para que la recursividad funcione
    SELECT division,
           nombre_tienda,
           fecha_entrada,
           cantidad_entrada,
           cantidad_salida,
           ROW_NUMBER() OVER (PARTITION BY division, nombre_tienda ORDER BY fecha_entrada) AS rn
    FROM kardex_base
),
kardex_recursivo AS (
    -- caso base (primer día): inicio = 0
    SELECT division,
           nombre_tienda,
           fecha_entrada,
           cantidad_entrada,
           cantidad_salida,
           100::NUMERIC AS inicio,
           (100 + cantidad_entrada - cantidad_salida)::NUMERIC AS inventario,
           rn
    FROM ordenado
    WHERE rn = 1

    UNION ALL

    -- caso recursivo: inicio = inventario del día anterior
    SELECT o.division,
           o.nombre_tienda,
           o.fecha_entrada,
           o.cantidad_entrada,
           o.cantidad_salida,
           k.inventario AS inicio,
           (k.inventario + o.cantidad_entrada - o.cantidad_salida)::NUMERIC AS inventario,
           o.rn
    FROM ordenado o
    JOIN kardex_recursivo k
      ON o.division = k.division
     AND o.nombre_tienda = k.nombre_tienda
     AND o.rn = k.rn + 1
)
SELECT division,
       nombre_tienda,
       fecha_entrada,
       inicio,
       cantidad_entrada,
       cantidad_salida,
       inventario
FROM kardex_recursivo
ORDER BY division, nombre_tienda, fecha_entrada;