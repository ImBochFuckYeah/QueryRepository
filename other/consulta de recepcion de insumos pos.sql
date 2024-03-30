SELECT
    T1.skubase AS itemCode,
    '' AS itemCode1,
    T1.descripcionbase AS dscription,
    SUM(T0.cantidad) quantity,
    T1.UMedidaEqv AS unitMsr,
    T1.UMedidaEqv AS uomCode,
    T0.cantidad AS quantityEntrada,
    1 AS cantidadInventario
FROM
    (
        SELECT
            codigo,
            cantidad
        FROM
            (
                SELECT
                    *
                FROM
                    [grupopinulito].[dbo].[tRutasEnvio] T0
                WHERE
                    T0.idruta = 5
                    AND T0.idenvio = 1288304
            ) p UNPIVOT (
                cantidad FOR codigo IN (
                    [PTV-001],
                    [PTV-002],
                    [PTV-003],
                    [PTV-004],
                    [PTV-005],
                    [PTV-006],
                    [PTV-007],
                    [PTV-008],
                    [PTV-009],
                    [PTV-010],
                    [PTV-011],
                    [PTV-012],
                    [PTV-041],
                    [PTV-042],
                    [PTV-013],
                    [P010171],
                    [PTV-015],
                    [PTV-016]
                )
            ) AS unpvt
    ) [T0]
    LEFT JOIN pinulito_PDV.[dbo].[tArticuloEqv] T1 ON T0.codigo = T1.skubase
WHERE
    ISNULL(T0.cantidad, 0) > 0
GROUP BY
    T0.serie,
    T0.idruta,
    T0.idenvio,
    T1.skubase,
    T1.descripcionbase,
    T1.UMedidaEqv,
    T0.fecha,
    T0.cantidad