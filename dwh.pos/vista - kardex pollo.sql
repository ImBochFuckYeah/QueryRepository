-- View: pos.vw_kardex_pollo

-- DROP VIEW pos.vw_kardex_pollo;

CREATE OR REPLACE VIEW pos.vw_kardex_pollo
 AS
 WITH RECURSIVE kardex_base AS (
         SELECT tda.division,
            tda.nombre AS nombre_tienda,
            em.fecha_entrada,
            sum(em.cantidad_entrada) AS cantidad_entrada,
            sum(sm.cantidad) AS cantidad_salida
           FROM pos.entrada_mercancia em
             JOIN pos.tienda tda ON em.codigo_empresa::text = tda.codigo_empresa::text AND em.codigo_tienda::text = tda.codigo_tienda::text
             JOIN dwh.datos sm ON em.codigo_empresa::integer = sm.codemp AND em.codigo_tienda::integer = sm.codtda AND em.fecha_entrada::date = sm.fecha
          WHERE em.sku_producto_equivalente::text = '010154'::text AND sm.coditem::text = 'MP0006'::text AND em.codigo_empresa::text <> 'null'::text AND em.codigo_tienda::text <> 'null'::text
          GROUP BY tda.division, tda.nombre, em.fecha_entrada
        ), ordenado AS (
         SELECT kardex_base.division,
            kardex_base.nombre_tienda,
            kardex_base.fecha_entrada,
            kardex_base.cantidad_entrada,
            kardex_base.cantidad_salida,
            row_number() OVER (PARTITION BY kardex_base.division, kardex_base.nombre_tienda ORDER BY kardex_base.fecha_entrada) AS rn
           FROM kardex_base
        ), kardex_recursivo AS (
         SELECT ordenado.division,
            ordenado.nombre_tienda,
            ordenado.fecha_entrada,
            ordenado.cantidad_entrada,
            ordenado.cantidad_salida,
            100::numeric AS inicio,
            100::numeric + (ordenado.cantidad_entrada - ordenado.cantidad_salida) AS inventario,
            ordenado.rn
           FROM ordenado
          WHERE ordenado.rn = 1
        UNION ALL
         SELECT o.division,
            o.nombre_tienda,
            o.fecha_entrada,
            o.cantidad_entrada,
            o.cantidad_salida,
            k.inventario AS inicio,
            k.inventario + o.cantidad_entrada - o.cantidad_salida AS inventario,
            o.rn
           FROM ordenado o
             JOIN kardex_recursivo k ON o.division = k.division AND o.nombre_tienda::text = k.nombre_tienda::text AND o.rn = (k.rn + 1)
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

ALTER TABLE pos.vw_kardex_pollo
    OWNER TO "DWHA";

GRANT ALL ON TABLE pos.vw_kardex_pollo TO "DWHA";
GRANT SELECT ON TABLE pos.vw_kardex_pollo TO powerbi;

