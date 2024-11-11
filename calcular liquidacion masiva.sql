USE PINULITO_NOMINA
DECLARE @codEmpresa INT = 8
DECLARE @fechaCalculo DATE = '2024-12-31'
DECLARE @fechaCalculoInicial DATE = @fechaCalculo 

DELETE tCabeceraEmpresaMasi 
DELETE tCabeceraEmpleadoMasi 
DELETE tSalariosEmpleadoMasi 
DELETE tdescuentotemporalliqui 
DELETE tbonoAguinaldoLiqui

INSERT INTO	tCabeceraEmpresaMasi
	SELECT
		codEmpresa,
		nombre,
		nombreComercial,
		nit,
		nombreCorto,
		YEAR(GETDATE()) AS anioActual
	FROM
		tEmpresa
	WHERE
		codEmpresa = @codEmpresa

INSERT INTO tCabeceraEmpleadoMasi
	SELECT
		t1.codEmpleado,
		T1.codigo,
		t4.nombreEmpleado,
		t4.segundoNombre,
		t4.apellidoEmpleado,
		t4.segundoApellido,
		t4.apellidoCasada,
		t3.nomPuesto,
		CONVERT(date, t3.fechaIngreso) as fechaIngreso,
		CONVERT(date, @fechaCalculoInicial) as finContract,
		(t1.salarioMensual / 2) AS salarioOrdinario,
		t3.bonifDecreto,
		t3.motivRetiro,
		periodoAguinaldo = CASE
			WHEN (MONTH(@fechaCalculo) = 12) THEN CASE
				WHEN DATEFROMPARTS(YEAR(@fechaCalculo), 12, 1) > t3.fechaIngreso THEN CONVERT(date, DATEFROMPARTS(YEAR(@fechaCalculo), 12, 1))
				ELSE CONVERT(date, t3.fechaIngreso)
			END
			ELSE CASE
				WHEN DATEFROMPARTS(YEAR(@fechaCalculo) - 1, 12, 1) > t3.fechaIngreso THEN CONVERT(
					date,
					DATEFROMPARTS(YEAR(@fechaCalculo) - 1, 12, 1)
				)
				ELSE CONVERT(date, t3.fechaIngreso)
			END
		END,
		periodoBono = CASE
			WHEN (MONTH(@fechaCalculo) > 6) THEN CASE
				WHEN DATEFROMPARTS(YEAR(@fechaCalculo), 7, 1) > t3.fechaIngreso THEN CONVERT(date, DATEFROMPARTS(YEAR(@fechaCalculo), 7, 1))
				ELSE CONVERT(date, t3.fechaIngreso)
			END
			ELSE CASE
				WHEN DATEFROMPARTS(YEAR(@fechaCalculo) - 1, 7, 1) > t3.fechaIngreso THEN CONVERT(
					date,
					DATEFROMPARTS(YEAR(@fechaCalculo) - 1, 7, 1)
				)
				ELSE CONVERT(varchar, t3.fechaIngreso)
			END
		END,
		t4.nombreEmpleado + ' ' + ISNULL(t4.segundoNombre, '') + ' ' + ISNULL(t4.apellidoEmpleado, '') + ' ' + ISNULL(t4.segundoApellido, '') + ' ' + ISNULL(t4.apellidoCasada, '') AS empleado,
		t5.nombre as centroCosto,
		DATEDIFF (
			DAY,
			t3.fechaIngreso,
			DATEADD(DAY, 1, @fechaCalculoInicial)
		) as diasIndenmizacion,
		null,
		null,
		null,
		null,
		t3.noContract
	FROM
		tPlanilla T1
		INNER JOIN tPeriodo T2 ON T1.idPeriodo = T2.idPeriodo
		INNER JOIN tContrato T3 ON T1.codEmpleado = T3.codEmpleado
		AND @fechaCalculoInicial BETWEEN T3.fechaIngreso
		AND CASE
			WHEN T3.finContract IS NULL
			OR T3.finContract = '1900-01-01' THEN @fechaCalculoInicial
			ELSE T3.finContract
		END
		INNER JOIN tEmpleado t4 ON t3.codEmpleado = t4.codEmpleado
		INNER JOIN tDepartamento t5 ON t3.codDepto = t5.codDepto
	WHERE
		T1.idEmpresa = @codEmpresa
		AND @fechaCalculoInicial BETWEEN T2.fechaInicio
		AND T2.fechaFin
	GROUP BY
		t1.codEmpleado,
		T1.codigo,
		t4.nombreEmpleado,
		t4.segundoNombre,
		t4.apellidoEmpleado,
		t4.segundoApellido,
		t4.apellidoCasada,
		t3.noContract,
		t3.nomPuesto,
		t3.fechaIngreso,
		t1.salarioMensual,
		t3.bonifDecreto,
		t3.motivRetiro,
		t5.nombre,
		t4.nombreEmpleado,
		t4.segundoNombre,
		t4.apellidoEmpleado,
		t4.segundoApellido,
		t4.apellidoCasada 

DECLARE @planillas as TABLE (
		id int identity(1, 1),
		[año] int,
		mes int,
		fechaIngreso date,
		codEmpleado int,
		nombreEmpleado nvarchar(256),
		segundoNombre nvarchar(256),
		apellidoEmpleado nvarchar(256),
		segundoApellido nvarchar(256),
		apellidoCasada nvarchar(256),
		salarioMensual decimal(10, 2),
		sSimples decimal(10, 2),
		sDobles decimal(10, 2),
		diasReal int,
		diasLiquidacion int,
		devengado decimal(10, 2)
	);

DECLARE @salariosTemporal as TABLE (
	id int identity(1, 1),
	[año] int,
	mes int,
	fechaIngreso date,
	codEmpleado int,
	nombreEmpleado nvarchar(256),
	segundoNombre nvarchar(256),
	apellidoEmpleado nvarchar(256),
	segundoApellido nvarchar(256),
	apellidoCasada nvarchar(256),
	salarioMensual decimal(10, 2),
	sSimples decimal(10, 2),
	sDobles decimal(10, 2),
	diasReal int,
	diasLiquidacion int,
	devengado decimal(10, 2)
);

DECLARE @salarios as TABLE (
	id int identity(1, 1),
	[año] int,
	mes int,
	fechaIngreso date,
	codEmpleado int,
	nombreEmpleado nvarchar(256),
	segundoNombre nvarchar(256),
	apellidoEmpleado nvarchar(256),
	segundoApellido nvarchar(256),
	apellidoCasada nvarchar(256),
	salarioMensual decimal(10, 2),
	sSimples decimal(10, 2),
	sDobles decimal(10, 2),
	diasReal int,
	diasLiquidacion int,
	devengado decimal(10, 2)
);

DECLARE @anioBono int DECLARE @anioAguinaldo int DECLARE @fechaIngreso int DECLARE @empleadoCodigo int DECLARE @noContract int DECLARE C21 CURSOR FOR
SELECT
	codEmpleado,
	YEAR(periodoAguinaldo),
	YEAR(periodoBono),
	YEAR(fechaIngreso),
	noContrato
FROM
	tCabeceraEmpleadoMasi
WHERE
	codEmpleado IN (
		SELECT
			CODEMPLEADO
		FROM
			tContrato
		WHERE
			codEmpresa = @codEmpresa
	)
order by
	codEmpleado 

OPEN C21 FETCH C21 INTO @empleadoCodigo,
	@anioAguinaldo,
	@anioBono,
	@fechaIngreso,
	@noContract while(@@fetch_status = 0) 
BEGIN
	UPDATE
		tCabeceraEmpleadoMasi
	SET
		diasAguinaldo = DATEDIFF (
			DAY,
			periodoAguinaldo,
			DATEADD(DAY, 1, @fechaCalculoInicial)
		),
		diasBono14 = DATEDIFF (
			DAY,
			periodoBono,
			DATEADD(DAY, 1, @fechaCalculoInicial)
		),
		diasVacaPropo =(
			SELECT
				CASE
					WHEN diasVacacionesProporcionales > 364 THEN 0
					ELSE diasVacacionesProporcionales
				END as vacacionesProporcionales
			FROM
				(
					SELECT
						*,
						DATEDIFF(DAY, ultimoPeriodo, @fechaCalculoInicial) + 1 as diasVacacionesProporcionales
					FROM
						(
							SELECT
								codEmpleado,
								fechaIngreso,
								CASE
									WHEN DATEFROMPARTS(
										YEAR(@fechaCalculoInicial),
										MONTH(fechaIngreso),
										DAY(fechaIngreso)
									) < @fechaCalculoInicial THEN DATEFROMPARTS(
										YEAR(@fechaCalculoInicial),
										MONTH(fechaIngreso),
										DAY(fechaIngreso)
									)
									ELSE DATEFROMPARTS(
										YEAR(@fechaCalculoInicial) - 1,
										MONTH(fechaIngreso),
										DAY(fechaIngreso)
									)
								END ultimoPeriodo
							FROM
								tContrato
							WHERE
								codEmpresa = @codEmpresa
								AND noContract = @noContract
						) x
				) k
		),
		diasVacaPendiente =(
			SELECT
				periodosPagar = (
					CASE
						WHEN periodosPendientes > 5 THEN 5
						ELSE periodosPendientes
					END
				) * 365
			FROM
				(
					SELECT
						*,
						DATEDIFF(DAY, UltimasVacaciones, @fechaCalculoInicial) / 364 as periodosPendientes
					FROM
						(
							SELECT
								TOP 1 t0.codEmpleado,
								t0.fechaIngreso,
								ISNULL(
									DATEADD(YEAR, 1, DATEADD(DAY, 1, t1.ultimasVacaciones)),
									t0.fechaIngreso
								) as UltimasVacaciones,
								ISNULL(
									(DATEADD(DAY, 1, t1.ultimasVacaciones)),
									t0.fechaIngreso
								) as UltimasVacacionesGozadas
							FROM
								tContrato t0
								LEFT OUTER JOIN tVacacion t1 ON t0.codEmpleado = t1.codEmpleado
								AND t1.vigente = 1
								AND DATEADD(YEAR, 1, t1.ultimasVacaciones) > t0.fechaIngreso
							WHERE
								codEmpresa = @codEmpresa
								AND noContract = @noContract
							order by
								t1.ultimasVacaciones desc
						) x
				) k
		)
	where
		codEmpleado = @empleadoCodigo

DELETE @planillas

INSERT INTO @planillas
	SELECT
		YEAR(t3.fechaInicio) as [año],
		MONTH(t3.fechaInicio) as mes,
		t2.fechaIngreso,
		t1.codEmpleado,
		t1.nombreEmpleado,
		t1.segundoNombre,
		t1.apellidoEmpleado,
		t1.segundoApellido,
		t1.apellidoCasada,
		AVG(t0.salarioMensual) as salarioMensual,
		SUM(otrosIngresos) + SUM(sSimples) as sSimples,
		SUM(sDobles) as sDobles,
		CASE
			WHEN t2.fechaIngreso <= DATEFROMPARTS(YEAR(t3.fechaInicio), MONTH(t3.fechaInicio), 01) THEN 30
			ELSE 31 - DAY(fechaIngreso)
		END as diasReal,
		NULL,
		NULL
	FROM
		tPlanilla t0
		INNER JOIN tEmpleado t1 ON t0.codEmpleado = t1.codEmpleado
		INNER JOIN tContrato t2 ON t0.codEmpleado = t2.codEmpleado
		AND (
			finContract >= DATEADD(DAY, -1, @fechaCalculo)
			OR finContract IS NULL
			OR finContract = '1900-01-01'
		)
		INNER JOIN tPeriodo t3 ON t0.idPeriodo = t3.idPeriodo
	WHERE
		t0.idEmpresa = @codEmpresa
		AND t0.codEmpleado = @empleadoCodigo
		AND t3.fechaInicio >= DATEADD(YEAR, -1, @fechaCalculo)
		AND t2.fechaIngreso <= t3.fechaFin
		AND (
			YEAR(t3.fechaInicio) <= YEAR(@fechaCalculo)
			OR MONTH(t3.fechaInicio) <= MONTH(@fechaCalculo)
		)
		AND t3.fechaInicio <= @fechaCalculo
	GROUP BY
		t1.codEmpleado,
		t1.nombreEmpleado,
		t1.segundoNombre,
		t1.apellidoEmpleado,
		t1.segundoApellido,
		t1.apellidoCasada,
		YEAR(t3.fechaInicio),
		MONTH(t3.fechaInicio),
		t2.fechaIngreso 

DELETE @salariosTemporal

INSERT INTO @salariosTemporal
	SELECT
		YEAR(t3.fechaInicio) as [año],
		MONTH(t3.fechaInicio) as mes,
		t2.fechaIngreso,
		t1.codEmpleado,
		t1.nombreEmpleado,
		t1.segundoNombre,
		t1.apellidoEmpleado,
		t1.segundoApellido,
		t1.apellidoCasada,
		AVG(t0.salarioMensual) as salarioMensual,
		SUM(otrosIngresos) + SUM(sSimples) as sSimples,
		SUM(sDobles) as sDobles,
		CASE
			WHEN t2.fechaIngreso <= DATEFROMPARTS(YEAR(t3.fechaInicio), MONTH(t3.fechaInicio), 01) THEN 30
			ELSE 31 - DAY(fechaIngreso)
		END as diasReal,
		NULL,
		NULL
	FROM
		tPlanillaTemporal t0
		INNER JOIN tEmpleado t1 ON t0.codEmpleado = t1.codEmpleado
		INNER JOIN tContrato t2 ON t0.codEmpleado = t2.codEmpleado
		AND t2.noContract = @noContract
		INNER JOIN tPeriodo t3 ON t0.idPeriodo = t3.idPeriodo
	WHERE
		t0.idEmpresa = @codEmpresa
		AND t0.codEmpleado = @empleadoCodigo
		AND t3.fechaInicio >= DATEADD(YEAR, -1, @fechaCalculo)
		AND t2.fechaIngreso <= t3.fechaFin
		AND (
			YEAR(t3.fechaInicio) <= YEAR(@fechaCalculo)
			OR MONTH(t3.fechaInicio) <= MONTH(@fechaCalculo)
		)
		AND t3.fechaInicio <= @fechaCalculo
	GROUP BY
		t1.codEmpleado,
		t1.nombreEmpleado,
		t1.segundoNombre,
		t1.apellidoEmpleado,
		t1.segundoApellido,
		t1.apellidoCasada,
		YEAR(t3.fechaInicio),
		MONTH(t3.fechaInicio),
		t2.fechaIngreso

DELETE @salarios

INSERT INTO @salarios
	SELECT
		año,
		mes,
		fechaIngreso,
		codEmpleado,
		nombreEmpleado,
		segundoNombre,
		apellidoEmpleado,
		segundoApellido,
		apellidoCasada,
		salarioMensual,
		sSimples,
		sDobles,
		diasReal,
		diasLiquidacion,
		devengado
	FROM
		@planillas
	UNION ALL
	SELECT
		año,
		mes,
		fechaIngreso,
		codEmpleado,
		nombreEmpleado,
		segundoNombre,
		apellidoEmpleado,
		segundoApellido,
		apellidoCasada,
		salarioMensual,
		sSimples,
		sDobles,
		diasReal,
		diasLiquidacion,
		devengado
	FROM
		@salariosTemporal
	WHERE
		año =(
			SELECT
				TOP 1 año
			FROM
				@planillas
			ORDER BY
				id DESC
		)
		and mes >(
			SELECT
				TOP 1 mes
			FROM
				@planillas
			ORDER BY
				id DESC
		) 

DECLARE @dias180 INT = 180 DECLARE @diaMesCalculo INT = 0 

IF(DAY(@fechaCalculoInicial) > 30) 
BEGIN
	SET @diaMesCalculo = 30
END
ELSE BEGIN
	SET @diaMesCalculo = DAY(@fechaCalculoInicial)
END

UPDATE @salarios SET diasReal = @diaMesCalculo
WHERE
	mes = MONTH(@fechaCalculoInicial)
	AND año = YEAR(@fechaCalculoInicial) 

DECLARE @codEmpleado int = 0 
DECLARE @codEmpleadoActual int = 0 
DECLARE @an int 
DECLARE @mes int 
DECLARE @diasAcumulado int = 0 
DECLARE @diasReal int 
DECLARE @diasLiquidacion int = 0 
DECLARE @id INT = 0 
DECLARE @promedioDevengado DECIMAL(10, 2) = 0.00 
DECLARE @promedioTotalDevengado DECIMAL(10, 2) = 0.00 
DECLARE @diasRealesSalarios INT 
DECLARE @fechaAguinaldo INT 

IF @fechaIngreso = YEAR(@fechaCalculoInicial) AND MONTH(@fechaCalculoInicial) < 12 
BEGIN
	SET @fechaAguinaldo = @fechaIngreso
END
ELSE BEGIN
	SET @fechaAguinaldo = @anioAguinaldo + 1
END

DECLARE c1 CURSOR FOR
	SELECT
		id,
		[año],
		mes,
		codEmpleado,
		diasReal
	FROM
		@salarios
	ORDER BY
		codEmpleado ASC,
		[año] DESC,
		mes DESC 

OPEN c1 FETCH c1 INTO @id, @an, @mes, @codEmpleado, @diasReal while(@@fetch_status = 0) BEGIN IF (@dias180 > 0) BEGIN IF (@dias180 <= 30 AND @dias180 > 0) 
BEGIN
	SET
		@diasRealesSalarios =(
			SELECT
				diasReal
			FROM
				@salarios
			WHERE
				id = @id
		) IF @diasRealesSalarios < 30 
BEGIN
	UPDATE
		@salarios
	SET
		diasReal = diasReal
	WHERE
		id = @id
END
ELSE BEGIN
	UPDATE
		@salarios
	SET
		diasReal = @dias180
	WHERE
		id = @id
END
	UPDATE
		@salarios
	SET
		sSimples =(sSimples / 30) * @dias180,
		sDobles =(sDobles / 30) * @dias180
	WHERE
		id = @id
	
	INSERT INTO
		tbonoAguinaldoLiqui
	SELECT
		[año],
		T1.mes,
		T2.nombre,
		T1.codEmpleado,
		CASE
			WHEN (
				[año] = @anioBono
				AND T1.mes >= 7
			)
			OR ([año] = @anioBono + 1) THEN (T1.salarioMensual / 30) * T1.diasReal
			ELSE 0
		END as Bono,
		CASE
			WHEN (
				[año] = @anioAguinaldo
				AND T1.mes >= 12
			)
			OR ([año] = @fechaAguinaldo) THEN (T1.salarioMensual / 30) * T1.diasReal
			ELSE 0
		END as Aguinaldo
	FROM
		@salarios T1
		INNER JOIN tMes T2 ON T1.mes = T2.mes
	WHERE
		T1.id = @id

	INSERT INTO
		tSalariosEmpleadoMasi
	SELECT
		codEmpleado,
		[año],
		t0.mes,
		t1.nombre,
		salarioMensual,
		sSimples,
		sDobles,
		diasReal as diasLiquidacion,
		(salarioMensual / 30) * diasReal as devengado,
		(
			((salarioMensual / 30) * diasReal) + sSimples + sDobles
		) as totalDevengado
	FROM
		@salarios t0
		INNER JOIN tMes t1 ON t0.mes = t1.mes
	where
		id = @id
END
ELSE IF (@dias180 > 30) BEGIN
	INSERT INTO
		tSalariosEmpleadoMasi
	SELECT
		codEmpleado,
		[año],
		t0.mes,
		t1.nombre,
		salarioMensual,
		sSimples,
		sDobles,
		diasReal as diasLiquidacion,
		(salarioMensual / 30) * diasReal as devengado,
		(
			((salarioMensual / 30) * diasReal) + sSimples + sDobles
		) as totalDevengado
	FROM
		@salarios t0
		INNER JOIN tMes t1 ON t0.mes = t1.mes
	WHERE
		id = @id

	INSERT INTO
		tbonoAguinaldoLiqui
	SELECT
		[año],
		T1.mes,
		T2.nombre,
		T1.codEmpleado,
		CASE
			WHEN (
				[año] = @anioBono
				AND T1.mes >= 7
			)
			OR ([año] = @anioBono + 1) THEN (salarioMensual / 30) * diasReal
			ELSE 0
		END as Bono,
		CASE
			WHEN (
				[año] = @anioAguinaldo
				AND T1.mes >= 12
			)
			OR ([año] = @fechaAguinaldo) THEN (salarioMensual / 30) * diasReal
			ELSE 0
		END as Aguinaldo
	FROM
		@salarios T1
		INNER JOIN tMes T2 ON T1.mes = T2.mes
	WHERE
		T1.id = @id
END
ELSE IF (@dias180 = 0) BEGIN
	INSERT INTO
		tSalariosEmpleadoMasi
	SELECT
		codEmpleado,
		[año],
		t0.mes,
		t1.nombre,
		salarioMensual,
		sSimples,
		sDobles,
		diasReal as diasLiquidacion,
		(salarioMensual / 30) * diasReal as devengado,
		(
			((salarioMensual / 30) * diasReal) + sSimples + sDobles
		) as totalDevengado
	FROM
		@salarios t0
		INNER JOIN tMes t1 ON t0.mes = t1.mes
	WHERE
		id = @id

	INSERT INTO
		tbonoAguinaldoLiqui
	SELECT
		[año],
		T1.mes,
		T2.nombre,
		T1.codEmpleado,
		CASE
			WHEN (
				[año] = @anioBono
				AND T1.mes >= 7
			)
			OR ([año] = @anioBono + 1) THEN (salarioMensual / 30) * diasReal
			ELSE 0
		END as Bono,
		CASE
			WHEN (
				[año] = @anioAguinaldo
				AND T1.mes >= 12
			)
			OR ([año] = @fechaAguinaldo) THEN (salarioMensual / 30) * diasReal
			ELSE 0
		END as Aguinaldo
	FROM
		@salarios T1
		INNER JOIN tMes T2 ON T1.mes = T2.mes
	WHERE
		T1.id = @id
END
	SET @dias180 = @dias180 - @diasReal
END
ELSE BEGIN
INSERT INTO	tbonoAguinaldoLiqui
	SELECT
		[año],
		T1.mes,
		T2.nombre,
		T1.codEmpleado,
		CASE
			WHEN (
				[año] = @anioBono
				AND T1.mes >= 7
			)
			OR ([año] = @anioBono + 1) THEN (salarioMensual / 30) * diasReal
			ELSE 0
		END as Bono,
		CASE
			WHEN (
				[año] = @anioAguinaldo
				AND T1.mes >= 12
			)
			OR ([año] = @fechaAguinaldo) THEN (salarioMensual / 30) * diasReal
			ELSE 0
		END as Aguinaldo
	FROM
		@salarios T1
		INNER JOIN tMes T2 ON T1.mes = T2.mes
	WHERE
		T1.id = @id
END FETCH c1 INTO @id,
@an,
@mes,
@codEmpleado,
@diasReal
END CLOSE c1 DEALLOCATE c1 

DELETE diasIndemnizacion WHERE codEmpleado = @empleadoCodigo

INSERT INTO
	diasIndemnizacion
    SELECT
        codEmpleado,
        SUM(diasLiquidacion)
    FROM
        tSalariosEmpleadoMasi
    WHERE
        codEmpleado = @empleadoCodigo
    group by
        codEmpleado

INSERT INTO tdescuentotemporalliqui
    SELECT
        t1.codEmpleado,
        SUM(T1.montoDescuento) AS descuento
    FROM
        tDescuento T1
        INNER JOIN tPeriodo T2 ON T1.idPeriodo = T2.idPeriodo
    WHERE
        T2.fechaInicio > @fechaCalculoInicial
        AND T1.codEmpleado = @empleadoCodigo
        and T1.idTipoDescuento not in (23, 6)
        and t1.vigente = 1
    GROUP BY
        T1.codEmpleado FETCH C21 INTO @empleadoCodigo,
        @anioAguinaldo,
        @anioBono,
        @fechaIngreso,
        @noContract
END CLOSE C21 DEALLOCATE C21