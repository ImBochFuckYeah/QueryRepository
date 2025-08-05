USE PINULITO_NOMINA;
-- 
DECLARE @codigo INT = 6365;
-- 
UPDATE tDescuento
SET vigente = 1, idPeriodo = (
    SELECT MAX(idPeriodo) FROM tDescuento
    WHERE idTipoDescuento = 30 AND vigente = 1 AND codEmpleado = @codigo
)
WHERE idDescuento = (
    SELECT d.idDescuento
    FROM tDescuento AS d
    JOIN tPeriodo AS p ON d.idPeriodo = p.idPeriodo
    WHERE GETDATE() BETWEEN p.fechaInicio AND p.fechaFin AND d.idTipoDescuento = 30 AND d.codEmpleado = @codigo
);