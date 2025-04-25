USE PINULITO_PDV;
SET DATEFIRST 1;
-- PARAMETROS
DECLARE @idMarcajeExtra AS INT = 1140752;
-- VARIABLES
DECLARE @fecha AS DATE;
DECLARE @idPersonaExtra AS INT;
DECLARE @frecuenciaPago AS INT;
DECLARE @empresa NVARCHAR(10), @tienda NVARCHAR(10);
DECLARE @idPagoPersonaExtra AS INT;
-- SETEAR VARIABLES GLOBALES
SELECT
	@fecha = mcj.fecha,
	@idPersonaExtra = pex.idPersonaExtra,
	@frecuenciaPago = pex.frecuenciaPagoPE,
    @empresa = mcj.empresa,
    @tienda = mcj.tienda,
	@idPagoPersonaExtra = mcj.idPagoPersonaExtra
FROM  tMarcaje AS mcj
JOIN [PINULITO_NOMINA].[dbo].[tPersonaExtra] AS pex ON TRY_CAST(RIGHT(codEmpleado, 4) AS INT) = pex.idPersonaExtra
WHERE idMarcajeExtra = @idMarcajeExtra;
-- VALIDAR FRECUENCIA DE PAGO
IF @frecuenciaPago = 1 BEGIN
    IF @idPagoPersonaExtra IS NULL BEGIN
		-- VARIABLES PARA CALCULO DE PAGO
		DECLARE @codigoPersonaExtra AS NVARCHAR(10);
		DECLARE @autorizado AS BIT;
		DECLARE @semana AS INT = DATEPART(WEEK, @fecha);
		DECLARE @tipoPersona AS INT;
		DECLARE @pagoHora AS DECIMAL(8, 2);
		-- 
		SELECT @codigoPersonaExtra = codigoPersonaExtra, @pagoHora = pagoPorHora, @tipoPersona = tipoPersonaExtra
		FROM [PINULITO_NOMINA].[dbo].[tPersonaExtra]
		WHERE idPersonaExtra = @idPersonaExtra;
		-- 
		SET @autorizado = (
			SELECT
				CASE
					WHEN COUNT(*) > 4 AND @tipoPersona = 1 THEN 0
					ELSE 1
				END
			FROM tMarcaje
			WHERE codEmpleado = CONCAT(999, @idPersonaExtra) AND DATEPART(WEEK, fecha) = @semana AND fecha <= @fecha AND vigente = 1
		);
		-- 
		INSERT INTO tPagoPersonaExtra (empresa, tienda, fechaHora, fechaBoleta, codEmpleado, monto, autorizado, vigente)
		VALUES (@empresa, @tienda, GETDATE(), @fecha, @codigoPersonaExtra, 0, @autorizado, 1);
		SET @idPagoPersonaExtra = SCOPE_IDENTITY();
		-- 
		INSERT INTO tPagoPersonaExtraDetalle
		SELECT @idPagoPersonaExtra, idMarcajeExtra, horaEntrada, horaSalida, horasPago, @pagoHora as pagoHora, horasPago * @pagoHora as totalDia, 1
		FROM
		(
			SELECT
				*,
				CASE WHEN @pagoHora = 10 THEN 
						CASE WHEN horasTrabajadas > 12 THEN 12
							ELSE horasTrabajadas
						END
					ELSE CASE
						WHEN horasTrabajadas > 8 THEN 8
						ELSE horasTrabajadas
					END
				END AS horasPago
			FROM
				(
					SELECT
						idMarcajeExtra,
						horaEntrada,
						ISNULL(horaSalida, horaEntrada) AS horaSalida,
						ISNULL(
							FLOOR((DATEDIFF(MINUTE, horaEntrada, horaSalida)) / 60),
							0
						) AS horasTrabajadas
					FROM
						tMarcaje
					WHERE
						idMarcajeExtra = @idMarcajeExtra
				) x
		) y;
		-- 
		UPDATE tPagoPersonaExtra
		SET monto = (
				SELECT
					SUM(totalDia)
				FROM
					tPagoPersonaExtraDetalle
				WHERE
					idPagoPersonaExtra = tPagoPersonaExtra.idPagoPersonaExtra
			)
		WHERE idPagoPersonaExtra = @idPagoPersonaExtra;
		-- 
		UPDATE tMarcaje
		SET idPagoPersonaExtra = @idPagoPersonaExtra
		WHERE idMarcajeExtra = @idMarcajeExtra;
	END
	-- FIN CALCULO PAGO PERSONA EXTRA
	SELECT *, ISNULL(autorizado, 0) AS autorizado, fechaStr = CONVERT(nvarchar, fechaBoleta, 103)
	FROM tPagoPersonaExtra
	WHERE idPagoPersonaExtra = @idPagoPersonaExtra;
	-- 
	SELECT *, CONVERT(nvarchar, horaEntrada, 8) AS horaI, CONVERT(nvarchar, horaSalida, 8) AS horaF
	FROM tPagoPersonaExtraDetalle
	WHERE idPagoPersonaExtra = @idPagoPersonaExtra;
END
ELSE BEGIN
	DECLARE @totalPago AS DECIMAL(10, 2);
	WITH dte_pago_pe AS (
		SELECT mcj.idMarcajeExtra, mcj.horaEntrada, horaSalida = ISNULL(mcj.horaSalida, mcj.horaEntrada),
		horasPago = ISNULL(
			FLOOR((DATEDIFF(MINUTE, mcj.horaEntrada, mcj.horaSalida)) / 60),
			0
		), precioxHora = sld.salarioDiario
		FROM tMarcaje AS mcj
		JOIN tTienda AS tda ON mcj.empresa = tda.empresa AND mcj.tienda = tda.tienda
		JOIN [PINULITO_NOMINA].[dbo].[vwSalarioDepartamento] AS sld ON tda.idDepartamentoGeo = sld.idDepartamentoGeo
		WHERE idMarcajeExtra = @idMarcajeExtra
	)
	SELECT idPagoPersonaExtra = mcj.idMarcajeExtra, idPagoPersonaExtraDetalle = mcj.idMarcajeExtra, idMarcaje = mcj.idMarcajeExtra, mcj.horaEntrada, horaSalida = ISNULL(mcj.horaSalida, mcj.horaEntrada),
	dpe.horasPago, dpe.precioxHora, totalDia = (dpe.horasPago * dpe.precioxHora), mcj.vigente, CONVERT(nvarchar, mcj.horaEntrada, 8) AS horaI, CONVERT(nvarchar, mcj.horaSalida, 8) AS horaF
	FROM tMarcaje AS mcj
	JOIN dte_pago_pe AS dpe ON mcj.idMarcajeExtra = dpe.idMarcajeExtra
	WHERE mcj.idMarcajeExtra = @idMarcajeExtra;
	-- 
	SELECT idPagoPersonaExtra = idMarcajeExtra,	empresa, tienda, fechaHora = GETDATE(),	codEmpleado = alias, monto = 0, autorizado = 0,	vigente, fechaBoleta = fecha, comentario = '', autorizado2 = 0, fechaStr = fecha
	FROM tMarcaje
	WHERE idMarcajeExtra = @idMarcajeExtra;
END