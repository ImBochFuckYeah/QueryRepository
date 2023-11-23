ALTER FUNCTION dbo.get_prestamo(@codEmpleado INT, @idPeriodo INT) RETURNS DECIMAL(18, 2) AS BEGIN DECLARE @monto DECIMAL(18, 2)
SELECT
    TOP 1 @monto = montoDescuento
FROM
    tDescuento
WHERE
    codEmpleado = @codEmpleado
    AND idPeriodo = @idPeriodo
    AND vigente = 1
    AND idTipoDescuento = 30
ORDER BY
    idTipoDescuento;

RETURN @monto;

END;