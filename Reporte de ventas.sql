-- CONSULTA POR DETALLE COMPLETO
SELECT
  t3.nombre AS empresa,
  t4.tda_nombre AS tienda,
  (
    SELECT
      STUFF(
        (SELECT ', ' + t5.descripcion
         FROM pinulito_pdv..tfacturadetalle AS t5
         WHERE t1.idfactura = t5.idfactura
         FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),
        1,
        2,
        ''
      )
  ) AS descripcion,
  (
    SELECT SUM(cantidad)
    FROM pinulito_pdv..tfacturadetalle AS t6
    WHERE t1.idfactura = t6.idfactura
  ) AS cantidad,
  t1.total,
  t1.nit,
  t1.nombre,
  CONVERT(VARCHAR, t1.fechaHora, 103) as fecha,
  t1.serie,
  t1.numero,
  t1.uuidFactura,
  t1.detallePago
FROM
  pinulito_pdv..tfactura AS t1
  INNER JOIN pinulito_pdv..tfacturadetalle AS t2 ON t1.idfactura = t2.idfactura
  INNER JOIN pinulito_pdv..tempresa AS t3 ON t1.empresa = t3.empresa
  INNER JOIN pinulito_pdv..ttienda AS t4 ON t1.tienda = t4.tienda and t4.inactiva = 0
WHERE
  t2.sku = '010303'
  AND CONVERT(DATE, t1.fechaHora) BETWEEN '2023-06-19' AND '2023-06-25'
  AND t1.anulada = 0
  AND t1.uuidFactura != '';

-- CONSULTA POR UN PRODUCTO ESPECIFICO
SELECT
  t3.nombre AS empresa,
  t4.tda_nombre AS tienda,
  (
    SELECT t5.descripcion
         FROM pinulito_pdv..tfacturadetalle AS t5
         WHERE t1.idfactura = t5.idfactura and t5.sku = '010303'
  ) AS descripcion,
  (
    SELECT SUM(t6.cantidad)
    FROM pinulito_pdv..tfacturadetalle AS t6
    WHERE t1.idfactura = t6.idfactura and t6.sku = '010303'
  ) AS cantidad,
  (
    SELECT SUM(t7.total)
    FROM pinulito_pdv..tfacturadetalle AS t7
    WHERE t1.idfactura = t7.idfactura and t7.sku = '010303'
  ) AS cantidad,
  t1.nit,
  t1.nombre,
  CONVERT(VARCHAR, t1.fechaHora, 103) as fecha,
  t1.serie,
  t1.numero,
  t1.uuidFactura,
  t1.detallePago
FROM
  pinulito_pdv..tfactura AS t1
  INNER JOIN pinulito_pdv..tfacturadetalle AS t2 ON t1.idfactura = t2.idfactura
  INNER JOIN pinulito_pdv..tempresa AS t3 ON t1.empresa = t3.empresa
  INNER JOIN pinulito_pdv..ttienda AS t4 ON t1.tienda = t4.tienda and t4.inactiva = 0
WHERE
  t2.sku = '010303'
  AND CONVERT(DATE, t1.fechaHora) BETWEEN '2023-06-19' AND '2023-06-25'
  AND t1.anulada = 0
  AND t1.uuidFactura != '';