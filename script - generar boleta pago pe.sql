USE PINULITO_PDV;
-- 
DECLARE @aliasCodigo NVARCHAR(6) = 'PE1987';
DECLARE @idMarcajeExtra INT = 1117420;
DECLARE @idPagoPersonaExtra INT;
DECLARE @fecha DATE;
DECLARE @empresa NVARCHAR(5), @tienda NVARCHAR(5);
-- 
SELECT
	@fecha = fecha,
	@idPagoPersonaExtra = ISNULL(idPagoPersonaExtra, 0),
	@empresa = empresa,
	@tienda = tienda
FROM  tMarcaje
WHERE idMarcajeExtra = @idMarcajeExtra 
-- 
IF @idPagoPersonaExtra > 0 BEGIN
	SELECT 0;
	SELECT 1;
	SELECT 2;
	-- 
	SELECT *, autorizado2 = ISNULL(autorizado, 0), fechaStr = CONVERT(nvarchar, fechaHora, 103)
	FROM tPagoPersonaExtra
	WHERE idPagoPersonaExtra = @idPagoPersonaExtra
	-- 
	SELECT *, horaI = CONVERT(nvarchar, horaEntrada, 8), horaF = CONVERT(nvarchar, horaSalida, 8)
	FROM tPagoPersonaExtraDetalle
	WHERE idPagoPersonaExtra = @idPagoPersonaExtra
	-- 
END
ELSE BEGIN
	SET DATEFIRST 1;
	DECLARE @autorizado AS BIT = 0;
	DECLARE @codEmpleado INT = (
		SELECT
			TOP 1 codEmpleado
		FROM
			vwValidacionUsuario
		WHERE
			aliasCodigo = @aliasCodigo
	);
	DECLARE @semana INT = DATEPART(WEEK, @fecha);
	DECLARE @tipoPersona INT, @frecuenciaPago INT;
	DECLARE @diasTrabajados INT;
	DECLARE @pagoHora DECIMAL(8, 2);
	DECLARE @idInsertado INT = 0;
	DECLARE @factor INT = 1
	-- 
	SELECT @pagoHora = pagoPorHora, @tipoPersona = tipoPersonaExtra, @frecuenciaPago = frecuenciaPagoPE
	FROM [PINULITO_NOMINA].[dbo].[tPersonaExtra]
	WHERE codigoPersonaExtra = @aliasCodigo
	SET @autorizado = (
		SELECT
			CASE
				WHEN COUNT(*) > 4
				AND @tipoPersona = 1 THEN NULL
				ELSE 1
			END
		FROM
			tMarcaje
		WHERE
			codEmpleado = @codEmpleado
			AND DATEPART(WEEK, fecha) = @semana
			AND vigente = 1
			AND fecha <= @fecha
	) 
	-- 
	INSERT INTO tPagoPersonaExtra (empresa, tienda, fechaHora, fechaBoleta, codEmpleado, monto, autorizado, vigente)
	VALUES (@empresa, @tienda, GETDATE(), @fecha, @aliasCodigo, 0, @autorizado, 1);
 	SELECT @idInsertado = SCOPE_IDENTITY();
	
	-- FRECUENCIA DE PAGO DIARIA
	IF (@frecuenciaPago = 1) BEGIN
	INSERT INTO tPagoPersonaExtraDetalle
	SELECT @idInsertado, idMarcajeExtra, horaEntrada, horaSalida, horasPago, @pagoHora as pagoHora, horasPago * @pagoHora as totalDia, 1
	FROM
	(
		SELECT
			*,
			CASE
				WHEN @pagoHora = 10 THEN CASE
					WHEN horas > 12 THEN 12
					ELSE horas
				END
				ELSE CASE
					WHEN horas > 8 THEN 8
					ELSE horas
				END
			END as horasPago
		FROM
			(
				SELECT
					idMarcajeExtra,
					horaEntrada,
					isnull(horaSalida, horaEntrada) as horaSalida,
					ISNULL(
						FLOOR((DATEDIFF(MINUTE, horaEntrada, horaSalida)) / 60),
						0
					) as horas
				FROM
					tMarcaje
				WHERE
					fecha = @fecha
					AND vigente = 1
					AND idPagoPersonaExtra is null
					AND alias = @aliasCodigo
			) x
	) y
	END
	ELSE IF (@frecuenciaPago = 2) BEGIN
		INSERT INTO tPagoPersonaExtraDetalle
		SELECT @idInsertado, idMarcajeExtra, horaEntrada, horaSalida, horasPago, @pagoHora as pagoHora, horasPago * @pagoHora as totalDia, 1
		FROM
		(
			SELECT
				*,
				CASE
					WHEN @pagoHora = 10 THEN CASE
						WHEN horas > 12 THEN 12
						ELSE horas
					END
					ELSE CASE
						WHEN horas > 8 THEN 8
						ELSE horas
					END
				END as horasPago
			FROM
				(
					SELECT
						idMarcajeExtra,
						horaEntrada,
						isnull(horaSalida, horaEntrada) as horaSalida,
						ISNULL(
							FLOOR((DATEDIFF(MINUTE, horaEntrada, horaSalida)) / 60),
							0
						) as horas
					FROM
						tMarcaje
					WHERE
						DATEPART(WEEK, fecha) = @semana
						AND vigente = 1
						AND idPagoPersonaExtra is null
						AND fecha <= @fecha
						AND alias = @aliasCodigo
				) x
		) y
	END
	ELSE IF (@frecuenciaPago = 3) BEGIN 
			DECLARE @iniQuincena DATE, @finQuincena DATE;
			IF DAY(@fecha) <= 15 
			BEGIN
				SET @iniQuincena = DATEFROMPARTS(YEAR(@fecha), MONTH(@fecha), 1)
				SET @finQuincena = DATEFROMPARTS(YEAR(@fecha), MONTH(@fecha), 15)
			END
			ELSE BEGIN
				SET @iniQuincena = DATEFROMPARTS(YEAR(@fecha), MONTH(@fecha), 16) IF (MONTH(@fecha) = 12) BEGIN
				SET @finQuincena = DATEFROMPARTS(YEAR(@fecha), MONTH(@fecha), 31)
			END
		ELSE BEGIN
		SET
			@finQuincena = DATEADD(
				DAY,
				-1,
				DATEFROMPARTS(YEAR(@fecha), MONTH(@fecha) + 1, 01)
			)
		END
	END --SELECT @iniQuincena, @finQuincena
	INSERT INTO tPagoPersonaExtraDetalle
	SELECT @idInsertado, idMarcajeExtra, horaEntrada, horaSalida, horasPago, @pagoHora as pagoHora, horasPago * @pagoHora as totalDia, 1
	FROM
		(
			SELECT
				*,
				CASE
					WHEN @pagoHora = 10 THEN CASE
						WHEN horas > 12 THEN 12
						ELSE horas
					END
					ELSE CASE
						WHEN horas > 8 THEN 8
						ELSE horas
					END
				END as horasPago
			FROM
				(
					SELECT
						idMarcajeExtra,
						horaEntrada,
						isnull(horaSalida, horaEntrada) as horaSalida,
						ISNULL(
							FLOOR((DATEDIFF(MINUTE, horaEntrada, horaSalida)) / 60),
							0
						) as horas
					FROM
						tMarcaje
					WHERE
						fecha BETWEEN @iniQuincena
						AND @finQuincena
						AND vigente = 1
						AND idPagoPersonaExtra is null
						AND fecha <= @fecha
						AND alias = @aliasCodigo
				) x
		) y
	END
	UPDATE tPagoPersonaExtra
	SET monto = (
			SELECT
				SUM(totalDia)
			FROM
				tPagoPersonaExtraDetalle
			WHERE
				idPagoPersonaExtra = tPagoPersonaExtra.idPagoPersonaExtra
		)
	WHERE idPagoPersonaExtra = @idInsertado;
	-- 
	SELECT *, autorizado2 = ISNULL(autorizado, 0), fechaStr = CONVERT(nvarchar, fechaBoleta, 103)
	FROM tPagoPersonaExtra
	WHERE idPagoPersonaExtra = @idInsertado
	-- 
	SELECT *, horaI = CONVERT(nvarchar, horaEntrada, 8), horaF = CONVERT(nvarchar, horaSalida, 8)
	FROM tPagoPersonaExtraDetalle
	WHERE idPagoPersonaExtra = @idInsertado
	-- 
	UPDATE tMarcaje
	SET idPagoPersonaExtra = @idInsertado
	WHERE idMarcajeExtra in (
		SELECT
			idMarcaje
		FROM
			tPagoPersonaExtraDetalle
		WHERE
			idPagoPersonaExtra = @idInsertado
	)
END