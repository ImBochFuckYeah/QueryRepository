-- View: pos.vw_gasto_tienda

-- DROP VIEW pos.vw_gasto_tienda;

CREATE OR REPLACE VIEW pos.vw_gasto_tienda
 AS
 SELECT gt.division_tienda,
    gt.codigo_empresa,
    gt.codigo_tienda,
    gt.nombre_tienda,
    gt.fecha_ingreso,
    gt.fecha_gasto,
    gt.descripcion_tipo_gasto,
    gt.nit_emisor,
    gt.nombre_emisor,
    gt.serie_fel,
    gt.numero_fel,
    gt.uuid_fel,
    gt.descripcion_gasto,
    round(
        CASE
            WHEN gt.descripcion_gasto::text = ppg.descripcion_gasto::text THEN
            CASE
                WHEN gt.precio_unitario >= ppg.precio_minimo AND gt.precio_unitario <= ppg.precio_maximo THEN gt.precio_unitario
                ELSE gt.precio_unitario / gt.cantidad
            END
            ELSE gt.precio_unitario
        END, 2) AS precio_unitario,
    gt.cantidad,
    round(
        CASE
            WHEN gt.descripcion_gasto::text = ppg.descripcion_gasto::text THEN
            CASE
                WHEN gt.precio_unitario >= ppg.precio_minimo AND gt.precio_unitario <= ppg.precio_maximo THEN gt.precio_unitario * gt.cantidad
                ELSE gt.precio_unitario / gt.cantidad * gt.cantidad
            END
            ELSE gt.total
        END, 2) AS total,
    gt.comentario,
    gt.numero_documento_pos,
    gt.numero_documento_sap,
    gt.anulado,
    gt.codigo_usuario_registro,
    gt.nombre_usuario_registro
   FROM pos.gasto_tienda gt
     LEFT JOIN pos.precio_ponderado_tipo_gasto ppg ON gt.descripcion_tipo_gasto::text = ppg.descripcion_tipo_gasto::text AND gt.descripcion_gasto::text = ppg.descripcion_gasto::text
  WHERE gt.anulado = false;

ALTER TABLE pos.vw_gasto_tienda
    OWNER TO "DWHA";

GRANT ALL ON TABLE pos.vw_gasto_tienda TO "DWHA";
GRANT SELECT ON TABLE pos.vw_gasto_tienda TO powerbi;

