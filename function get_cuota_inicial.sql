ALTER FUNCTION dbo.get_couta_inicial(@codEmpleado INT, @idPeriodo INT) RETURNS DECIMAL(18, 2) AS BEGIN DECLARE @monto DECIMAL(18, 2)
SELECT
    --TOP 1 @monto = montoDescuento
    TOP 1 @monto = CASE
        WHEN idTipoDescuento = 6 AND montoDescuento = 125 THEN 75
        WHEN idTipoDescuento = 6 AND montoDescuento = 250 THEN 150
        ELSE montoDescuento
    END
FROM
    tDescuento
WHERE
    codEmpleado = @codEmpleado
    AND idPeriodo = @idPeriodo
    AND vigente = 1
    AND (
        idTipoDescuento = 29
        OR (
            idTipoDescuento = 6
            AND montoDescuento IN (125, 250)
        )
    )
ORDER BY
    idTipoDescuento;

RETURN @monto;

END;