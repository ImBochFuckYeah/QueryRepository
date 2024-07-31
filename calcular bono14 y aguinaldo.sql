DECLARE @fechaCalculo as date = GETDATE();
DECLARE @codEmpresa as int = 8;
DECLARE @incluirBonif int = 0;
DECLARE @codEmpleado int = 4403;
DECLARE @diasMesActual int = DAY(@fechaCalculo);

DECLARE @mesActual as int = MONTH(@fechaCalculo);
DECLARE @mesesCalculo as TABLE ([año] int, mes int, nombreMes nvarchar(10));

INSERT INTO
	@mesesCalculo
SELECT
	CASE
		WHEN mes <= @mesActual THEN YEAR(@fechaCalculo)
		ELSE YEAR(@fechaCalculo) -1
	END AS [año],
	mes,
	nombre as nombreMes
FROM
	tMes 

DECLARE @anBono int = CASE
    WHEN MONTH(@fechaCalculo) <= 6 THEN YEAR(@fechaCalculo) - 1
    ELSE YEAR(@fechaCalculo)
END 

DECLARE @anAguinaldo int = CASE
    WHEN MONTH(@fechaCalculo) <= 11 THEN YEAR(@fechaCalculo) - 1
    ELSE YEAR(@fechaCalculo)
END 

DECLARE @planilla as TABLE (
    id INT IDENTITY(1, 1),
    [año] int,
    mes int,
    nombreMes nvarchar(10),
    codEmpleado int,
    nombreEmpleado nvarchar(256),
    segundoNombre nvarchar(256),
    apellidoEmpleado nvarchar(256),
    segundoApellido nvarchar(256),
    apellidoCasada nvarchar(256),
    salarioMensual decimal(10, 2),
    diasLaborados int,
    fechaIngreso date,
    devengado decimal(10, 2)
);

INSERT INTO
	@planilla
SELECT
	t4.año,
	t4.mes,
	t4.nombreMes,
	t0.codEmpleado,
	t1.nombreEmpleado,
	t1.segundoNombre,
	t1.apellidoEmpleado,
	t1.segundoApellido,
	t1.apellidoCasada,
	AVG(t0.salarioMensual) + (250 * @incluirBonif) as salarioMensual,
	CASE
		WHEN @fechaCalculo >= DATEADD(
			DAY,
			-1,
			DATEFROMPARTS(
				CASE
					WHEN MONTH(MIN(t3.fechaInicio)) = 12 THEN YEAR(MIN(t3.fechafin)) + 1
					ELSE YEAR(MIN(t3.fechafin))
				END,
				CASE
					WHEN MONTH(MIN(t3.fechaInicio)) = 12 THEN 1
					ELSE MONTH(MIN(t3.fechafin)) + 1
				END,
				1
			)
		) THEN CASE
			WHEN t2.fechaIngreso <= DATEFROMPARTS(
				YEAR(MIN(t3.fechaInicio)),
				MONTH(MIN(t3.fechaInicio)),
				01
			) THEN 30
			ELSE 31 - DAY(t2.fechaIngreso)
		END
		ELSE DAY(@fechaCalculo)
	END as diasLaborados,
	t2.fechaIngreso,
	NULL
FROM
	tPlanilla t0
	INNER JOIN tEmpleado t1 ON t0.codEmpleado = t1.codEmpleado
	INNER JOIN tContrato t2 ON t1.codEmpleado = t2.codEmpleado
	INNER JOIN tPeriodo t3 ON t0.idPeriodo = t3.idPeriodo
	INNER JOIN @mesesCalculo t4 ON MONTH(t3.fechaInicio) = t4.mes
	AND YEAR(t3.fechaInicio) = t4.[año]
	AND t0.idEmpresa = @codEmpresa
WHERE
	t2.codEmpresa = @codEmpresa
	AND t2.fechaIngreso <= t3.fechaFin
	AND t0.codEmpleado = @codEmpleado
	AND t2.activo = 1
GROUP BY
	t4.año,
	t4.mes,
	t4.nombreMes,
	t0.codEmpleado,
	t1.nombreEmpleado,
	t1.segundoNombre,
	t1.apellidoEmpleado,
	t1.segundoApellido,
	t1.apellidoCasada,
	t2.fechaIngreso;

DECLARE @planillaTemoral as TABLE (
    id INT IDENTITY(1, 1),
    [año] int,
    mes int,
    nombreMes nvarchar(10),
    codEmpleado int,
    nombreEmpleado nvarchar(256),
    segundoNombre nvarchar(256),
    apellidoEmpleado nvarchar(256),
    segundoApellido nvarchar(256),
    apellidoCasada nvarchar(256),
    salarioMensual decimal(10, 2),
    diasLaborados int,
    fechaIngreso date,
    devengado decimal(10, 2)
);

INSERT INTO
	@planillaTemoral
SELECT
	t4.año,
	t4.mes,
	t4.nombreMes,
	t0.codEmpleado,
	t1.nombreEmpleado,
	t1.segundoNombre,
	t1.apellidoEmpleado,
	t1.segundoApellido,
	t1.apellidoCasada,
	AVG(t0.salarioMensual) + (250 * @incluirBonif) as salarioMensual,
	CASE
		WHEN @fechaCalculo >= DATEADD(
			DAY,
			-1,
			DATEFROMPARTS(
				CASE
					WHEN MONTH(MIN(t3.fechaInicio)) = 12 THEN YEAR(MIN(t3.fechafin)) + 1
					ELSE YEAR(MIN(t3.fechafin))
				END,
				CASE
					WHEN MONTH(MIN(t3.fechaInicio)) = 12 THEN 1
					ELSE MONTH(MIN(t3.fechafin)) + 1
				END,
				1
			)
		) THEN CASE
			WHEN t2.fechaIngreso <= DATEFROMPARTS(
				YEAR(MIN(t3.fechaInicio)),
				MONTH(MIN(t3.fechaInicio)),
				01
			) THEN 30
			ELSE 31 - DAY(t2.fechaIngreso)
		END
		ELSE DAY(@fechaCalculo)
	END as diasLaborados,
	t2.fechaIngreso,
	NULL
FROM
	tPlanillaTemporal t0
	INNER JOIN tEmpleado t1 ON t0.codEmpleado = t1.codEmpleado
	INNER JOIN tContrato t2 ON t1.codEmpleado = t2.codEmpleado
	INNER JOIN tPeriodo t3 ON t0.idPeriodo = t3.idPeriodo
	INNER JOIN @mesesCalculo t4 ON MONTH(t3.fechaInicio) = t4.mes
	AND YEAR(t3.fechaInicio) = t4.[año]
	AND t0.idEmpresa = @codEmpresa
WHERE
	t2.codEmpresa = @codEmpresa
	AND t2.fechaIngreso <= t3.fechaFin
	AND t0.codEmpleado = @codEmpleado
	AND t2.activo = 1
GROUP BY
	t4.año,
	t4.mes,
	t4.nombreMes,
	t0.codEmpleado,
	t1.nombreEmpleado,
	t1.segundoNombre,
	t1.apellidoEmpleado,
	t1.segundoApellido,
	t1.apellidoCasada,
	t2.fechaIngreso;

DECLARE @salarios as TABLE (
    [año] int,
    mes int,
    nombreMes nvarchar(10),
    codEmpleado int,
    nombreEmpleado nvarchar(256),
    segundoNombre nvarchar(256),
    apellidoEmpleado nvarchar(256),
    segundoApellido nvarchar(256),
    apellidoCasada nvarchar(256),
    salarioMensual decimal(10, 2),
    diasLaborados int,
    fechaIngreso date,
    devengado decimal(10, 2)
);

DECLARE @anioPlanilla INT;
DECLARE @mesPlanilla INT;

SET
	@anioPlanilla =(
		SELECT
			top 1 año
		FROM
			@planilla
		order by
			id desc
	);

SET
	@mesPlanilla =(
		SELECT
			top 1 mes
		FROM
			@planilla
		order by
			id desc
	);

insert into
	@salarios
SELECT
	año,
	mes,
	nombreMes,
	codEmpleado,
	nombreEmpleado,
	segundoNombre,
	apellidoEmpleado,
	segundoApellido,
	apellidoCasada,
	salarioMensual,
	diasLaborados,
	fechaIngreso,
	devengado
FROM
	@planilla
UNION

ALL

SELECT
	año,
	mes,
	nombreMes,
	codEmpleado,
	nombreEmpleado,
	segundoNombre,
	apellidoEmpleado,
	segundoApellido,
	apellidoCasada,
	salarioMensual,
	diasLaborados,
	fechaIngreso,
	devengado
FROM
	@planillaTemoral
WHERE
	mes > @mesPlanilla
	AND año = @anioPlanilla

-- SELECT @@ROWCOUNT

/*
	PARA MOSTRAR EL ULTIMO MES LA PLANILLA TEMPORAL DEBE ESTAR EXPORTADA (+3 DIAS)
*/

UPDATE
	@salarios
SET
	devengado = salarioMensual / 30 * diasLaborados
SELECT
	[año],
	mes,
	nombreMes,
	codEmpleado,
	bono,
	aguinaldo
FROM
	(
		SELECT
			*,
			CASE
				WHEN (
					[año] = @anBono
					AND mes >= 7
				)
				OR ([año] = @anBono + 1) THEN devengado
				ELSE 0
			END as Bono,
			CASE
				WHEN MONTH(@fechaCalculo) = 11
				AND DAY(@fechaCalculo) >= 30 THEN 0 --VALIDA QUE LA FECHA SEA ANTERIOR AL ULTIMO DIA DE NOVIEMBRE
				WHEN (
					[año] = @anAguinaldo
					AND mes >= 12
				)
				OR ([año] = @anAguinaldo + 1) THEN devengado
				ELSE 0
			END as Aguinaldo
		FROM
			@salarios
	) x
WHERE
	x.Bono > 0
	OR x.Aguinaldo > 0
ORDER BY
	codEmpleado ASC,
	[año] ASC,
	mes ASC 

-- DIAS INDEMNIZACION
SELECT
	codEmpleado,
	DATEDIFF(DAY, fechaIngreso, @fechaCalculo) + 1 as dias
FROM
	tContrato
WHERE
	codEmpresa = @codEmpresa
	AND codEmpleado = @codEmpleado
	AND activo = 1;

-- VACACIONES PROPORCIONALES
SELECT
	codEmpleado,
	CONVERT(varchar, fechaIngreso, 103) AS fechaIngreso,
	CONVERT(varchar, ultimoPeriodo, 103) AS ultimoPeriodo,
	CASE
		WHEN diasVacacionesProporcionales > 364 THEN 0
		ELSE diasVacacionesProporcionales
	END as vacacionesProporcionales
FROM
	(
		SELECT
			*,
			DATEDIFF(DAY, ultimoPeriodo, @fechaCalculo) + 1 as diasVacacionesProporcionales
		FROM
			(
				SELECT
					codEmpleado,
					fechaIngreso,
					CASE
						WHEN DATEFROMPARTS(
							YEAR(@fechaCalculo),
							MONTH(fechaIngreso),
							DAY(fechaIngreso)
						) < @fechaCalculo THEN DATEFROMPARTS(
							YEAR(@fechaCalculo),
							MONTH(fechaIngreso),
							DAY(fechaIngreso)
						)
						ELSE DATEFROMPARTS(
							YEAR(@fechaCalculo) - 1,
							MONTH(fechaIngreso),
							DAY(fechaIngreso)
						)
					END ultimoPeriodo
				FROM
					tContrato
				WHERE
					codEmpresa = @codEmpresa
					AND codEmpleado = @codEmpleado
					AND activo = 1
			) x
	) k 

-- VACACIONES PENDIENTES //cada 364 dias toma como año completo
SELECT
	*,
	CONVERT(varchar, fechaIngreso, 103) AS fechaIngreso2,
	CONVERT(varchar, UltimasVacaciones, 103) AS UltimasVacaciones2,
	CONVERT(varchar, UltimasVacacionesGozadas, 103) AS UltimasVacacionesGozadas,
	periodosPagar = CASE
		WHEN periodosPendientes > 5 THEN 5
		ELSE periodosPendientes
	END
FROM
	(
		SELECT
			*,
			DATEDIFF(DAY, UltimasVacaciones, @fechaCalculo) / 364 as periodosPendientes
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
					) as UltimasVacacionesGozadas,
					CONVERT(
						nvarchar,
						DATEADD(
							YEAR,
							1,
							(
								ISNULL(
									(DATEADD(YEAR, 1, t1.ultimasVacaciones)),
									DATEADD(DAY, -1, t0.fechaIngreso)
								)
							)
						),
						103
					) as UltimasVacacionesFinal
				FROM
					tContrato t0
					LEFT OUTER JOIN tVacacion t1 ON t0.codEmpleado = t1.codEmpleado
					AND t1.vigente = 1
					AND DATEADD(YEAR, 1, t1.ultimasVacaciones) > t0.fechaIngreso
				WHERE
					codEmpresa = @codEmpresa
					AND t0.activo = 1
					AND t0.codEmpleado = @codEmpleado
				order by
					t1.ultimasVacaciones desc
			) x
	) k