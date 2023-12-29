ALTER PROCEDURE HistorialAhorro_Empleado @CodigoEmpleado INT AS BEGIN
SELECT
    ISNULL(
        (
            SELECT
                nombreperiodo
            FROM
                tPeriodo
            WHERE
                tDescuento.idPeriodo = tPeriodo.idPeriodo
        ),
        ''
    ) periodo,
    ISNULL(
        (
            SELECT
                CASE
                    WHEN tDescuento.idtipodescuento = 6
                    AND montoDescuento IN (125, 250) THEN 'Aportacion (cootragua)'
                    ELSE nombreTipoDescuento
                END
            FROM
                tTipoDescuento
            WHERE
                tDescuento.idTipoDescuento = tTipoDescuento.idTipoDescuento
        ),
        ''
    ) tipo_descuento,
    CASE
        WHEN montoDescuento IN (125) THEN 50
        WHEN montoDescuento IN (250) THEN 100
        ELSE montoDescuento
    END descuento
FROM
    tDescuento
WHERE
    codempleado = @CodigoEmpleado
    AND idTipoDescuento IN (6, 17, 29, 30)
    AND vigente = 1
ORDER BY
    idPeriodo ASC
END;