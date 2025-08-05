USE PINULITO_PDV;
-- 
SELECT * FROM (
    SELECT DIVISION = tda.division, TIENDA = tda.tda_nombre, descripcion = aeq.DescripcionBase, cantidad = SUM(denv.quantity)
    FROM tEntradaInventario AS env
    JOIN tEntradaInventarioDetalle AS denv ON env.idEntradaInventario = denv.idEntradaInventario
    JOIN tArticuloEqv AS aeq ON denv.itemCode = aeq.SkuBase
    JOIN tTienda AS tda ON env.empresa = tda.empresa AND env.tienda = tda.tienda
    WHERE anulado = 0 AND CAST(fecha AS DATE) BETWEEN '20250721' AND '20250727' AND serie IN (
        'AG2',
        'AG3',
        'AGPE'
    ) GROUP BY tda.division, tda.tda_nombre, aeq.DescripcionBase
) AS SourceTable
PIVOT (
    SUM(cantidad) FOR descripcion IN (
        [ALITAS],
        [CUADRILITOS],
        [HIGADO],
        [LASAÑA PRECOCIDA],
        [MOLLEJA],
        [PATITAS],
        [PESCUEZOS],
        [POLLO CRUDO PARTIDO],
        [POLLO ESTANDAR ARTESANO (LIBRAS)],
        [POLLO ESTANDAR PICANTE],
        [POLLO ESTANDAR TRADICIONAL.],
        [POLLO GRANDE  PICANTE.],
        [POLLO GRANDE  TRADICIONAL.]
    )
) AS PivotTable;