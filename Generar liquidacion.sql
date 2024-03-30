DECLARE @codEmpresa int = 8 DECLARE @fechaCalculo as date = '2022-01-15' DECLARE @codEmpleado2 int = 4628
SET
	@fechaCalculo = (
		SELECT
			TOP 1 finContract
		FROM
			tContrato
		WHERE
			codEmpleado = @codEmpleado2
		ORDER BY
			finContract DESC
	) 
/*    
-- EMPRESA
SELECT
	codEmpresa,
	nombre,
	nombreComercial,
	nit,
	nombreCorto
FROM
	tEmpresa
WHERE
	codEmpresa = @codEmpresa 

-- DATOS EMPLEADO
SELECT
	TOP 1 *,
	CASE
		WHEN MONTH(@fechaCalculo) = 11
		AND DAY(@fechaCalculo) = 30 THEN 0
		ELSE DATEDIFF(
			DAY,
			CONVERT(date, periodoAguinaldo, 103),
			@fechaCalculo
		) + 1
	END AS diasAguinaldo,
	DATEDIFF(
		DAY,
		CONVERT(date, periodoBono, 103),
		@fechaCalculo
	) + 1 as diasBono
FROM
	(
		SELECT
			t0.codEmpleado,
			T5.codigo AS aliasCodigo,
			t1.nombreEmpleado,
			t1.segundoNombre,
			t1.apellidoEmpleado,
			t1.segundoApellido,
			t1.apellidoCasada,
			UPPER(
				ISNULL(t1.nombreEmpleado, '') + ' ' + ISNULL(t1.segundoNombre, '') + ' ' + ISNULL(t1.apellidoEmpleado, '') + ' ' + ISNULL(t1.segundoApellido, '') + ' ' + ISNULL(t1.apellidoCasada, '')
			) AS empleado,
			t1.noDoc,
			T3.nombreDepartamento,
			T4.nombreMunicipio,
			MONTH(T0.finContract) -1 AS mesFinContract,
			dbo.numeroAletra(DAY(t0.finContract)) AS diaFinContract,
			dbo.numeroAletra(YEAR(t0.finContract)) AS anioContract,
			t0.nomPuesto,
			CONVERT(varchar, t0.fechaIngreso, 103) as fechaIngreso,
			CONVERT(varchar, t0.finContract, 103) as finContract,
			t0.salarioOrdinario,
			t0.bonifDecreto,
			t0.motivRetiro,
			t2.nombre AS departamento,
			periodoAguinaldo = CASE
				WHEN (MONTH(@fechaCalculo) = 12) THEN CASE
					WHEN DATEFROMPARTS(YEAR(@fechaCalculo), 12, 1) > t0.fechaIngreso THEN CONVERT(
						varchar,
						DATEFROMPARTS(YEAR(@fechaCalculo), 12, 1),
						103
					)
					ELSE CONVERT(varchar, t0.fechaIngreso, 103)
				END
				ELSE CASE
					WHEN DATEFROMPARTS(YEAR(@fechaCalculo) - 1, 12, 1) > t0.fechaIngreso THEN CONVERT(
						varchar,
						DATEFROMPARTS(YEAR(@fechaCalculo) - 1, 12, 1),
						103
					)
					ELSE CONVERT(varchar, t0.fechaIngreso, 103)
				END
			END,
			periodoBono = CASE
				WHEN (MONTH(@fechaCalculo) > 6) THEN CASE
					WHEN DATEFROMPARTS(YEAR(@fechaCalculo), 7, 1) > t0.fechaIngreso THEN CONVERT(
						varchar,
						DATEFROMPARTS(YEAR(@fechaCalculo), 7, 1),
						103
					)
					ELSE CONVERT(varchar, t0.fechaIngreso, 103)
				END
				ELSE CASE
					WHEN DATEFROMPARTS(YEAR(@fechaCalculo) - 1, 7, 1) > t0.fechaIngreso THEN CONVERT(
						varchar,
						DATEFROMPARTS(YEAR(@fechaCalculo) - 1, 7, 1),
						103
					)
					ELSE CONVERT(varchar, t0.fechaIngreso, 103)
				END
			END
		FROM
			tContrato t0
			INNER JOIN tEmpleado t1 ON t0.codEmpleado = t1.codEmpleado
			INNER JOIN tDepartamento t2 ON t0.codDepto = t2.codDepto
			INNER JOIN tDepartamentoGeo T3 ON t1.departVec = T3.idDepartamentoGeo
			INNER JOIN tMunicipioEmpleador T4 ON t1.muniVec = T4.idMunicipioEmpleador
			LEFT JOIN tPlanilla T5 ON t0.codEmpleado = T5.codEmpleado
			AND T5.idEmpresa = @codEmpresa
		WHERE
			t0.codEmpresa = @codEmpresa
			AND t0.codEmpleado = @codEmpleado2
			AND t0.finContract = @fechaCalculo
	) x 
*/
-- SALARIO ULTIMOS 180 DIAS
SET
	@fechaCalculo = DATEADD(DAY, 1, @fechaCalculo);

DECLARE @diasMesActual int = DAY(@fechaCalculo);

DECLARE @salarios as TABLE (
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

INSERT INTO
	@salarios
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
	SUM(sSimples + otrosIngresos) as sSimples,
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
	AND T0.codEmpleado = @codEmpleado2
	AND t3.fechaInicio >= DATEADD(YEAR, -1, @fechaCalculo)
	AND t2.fechaIngreso <= t3.fechaFin
	AND (
		YEAR(t3.fechaInicio) < YEAR(@fechaCalculo)
		OR MONTH(t3.fechaInicio) < MONTH(@fechaCalculo)
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
SELECT
	@@ROWCOUNT DECLARE @codEmpleado int = 0 DECLARE @codEmpleadoActual int = 0 DECLARE @an int DECLARE @mes int DECLARE @diasAcumulado int = 0 DECLARE @diasReal int DECLARE @diasLiquidacion int = 0 DECLARE c1 CURSOR FOR
SELECT
	[año],
	mes,
	codEmpleado,
	diasReal
FROM
	@salarios
ORDER BY
	codEmpleado ASC,
	[año] DESC,
	mes DESC OPEN c1 FETCH NEXT
FROM
	c1 INTO @an,
	@mes,
	@codEmpleado,
	@diasReal WHILE @@FETCH_STATUS = 0 BEGIN IF (@codEmpleadoActual != @codEmpleado) BEGIN
SET
	@diasAcumulado = 0
SET
	@codEmpleadoActual = @codEmpleado
END IF (
	@diasReal = 30
	AND @diasAcumulado <= 150
) BEGIN
SET
	@diasAcumulado = @diasAcumulado + 30
SET
	@diasLiquidacion = 30
END
ELSE IF (
	@diasReal + @diasAcumulado + @diasMesActual <= 182
) BEGIN
SET
	@diasAcumulado = @diasAcumulado + @diasReal + @diasMesActual
SET
	@diasLiquidacion = @diasReal
END
ELSE IF (
	@diasReal > (180 - @diasAcumulado - @diasMesActual)
) BEGIN
SET
	@diasAcumulado = @diasAcumulado + (180 - @diasAcumulado - @diasMesActual)
SET
	@diasLiquidacion = (180 - @diasAcumulado - @diasMesActual)
END
ELSE IF (@diasAcumulado <= 180) BEGIN
SET
	@diasAcumulado = @diasAcumulado + @diasReal
SET
	@diasLiquidacion = @diasReal
END
ELSE BEGIN
SET
	@diasLiquidacion = 0
END
UPDATE
	@salarios
SET
	diasLiquidacion = CASE
		WHEN codEmpleado = 1763
		and mes in (1, 2, 3) THEN 0
		ELSE @diasLiquidacion
	END
WHERE
	codEmpleado = @codEmpleado
	AND mes = @mes
	AND [año] = @an FETCH NEXT
FROM
	c1 INTO @an,
	@mes,
	@codEmpleado,
	@diasReal
END CLOSE c1 DEALLOCATE c1
SET
	@fechaCalculo = DATEADD(DAY, -1, @fechaCalculo);

SET
	@diasMesActual = DAY(@fechaCalculo);

INSERT INTO
	@salarios
SELECT
	YEAR(@fechaCalculo),
	MONTH(@fechaCalculo),
	t3.fechaIngreso,
	t0.codEmpleado,
	t2.nombreEmpleado,
	t2.segundoNombre,
	t2.apellidoEmpleado,
	t2.segundoApellido,
	t2.apellidoCasada,
	t0.salarioMensual AS salarioOrdinario,
	ISNULL(
		(
			SELECT
				SUM(subtabplanilla.sSimples)
			FROM
				tPeriodo subtabperiodo
				join tPlanilla subtabplanilla ON subtabperiodo.idPeriodo = subtabplanilla.idPeriodo
			WHERE
				YEAR(subtabperiodo.fechaInicio) = YEAR(@fechaCalculo)
				AND MONTH(subtabperiodo.fechaInicio) = MONTH(@fechaCalculo)
				AND subtabplanilla.codEmpleado = T0.codEmpleado
		),
		0
	),
	ISNULL(
		(
			SELECT
				SUM(subtabplanilla.sDobles + otrosIngresos)
			FROM
				tPeriodo subtabperiodo
				join tPlanilla subtabplanilla ON subtabperiodo.idPeriodo = subtabplanilla.idPeriodo
			WHERE
				YEAR(subtabperiodo.fechaInicio) = YEAR(@fechaCalculo)
				AND MONTH(subtabperiodo.fechaInicio) = MONTH(@fechaCalculo)
				AND subtabplanilla.codEmpleado = T0.codEmpleado
		),
		0
	),
	@diasMesActual,
	@diasMesActual,
	NULL
FROM
	tPlanilla T0
	INNER JOIN tPeriodo T1 ON T0.idPeriodo = T1.idPeriodo
	INNER JOIN tEmpleado T2 ON T0.codEmpleado = T2.codEmpleado
	INNER JOIN tContrato T3 ON T3.codEmpresa = @codEmpresa
	AND T0.codEmpleado = T3.codEmpleado
	AND T0.idEmpresa = T3.codEmpresa
	AND (
		finContract >= @fechaCalculo
		OR finContract IS NULL
		OR finContract = '1900-01-01'
	)
WHERE
	T0.idEmpresa = @codEmpresa
	AND @fechaCalculo BETWEEN T1.fechaInicio
	AND T1.fechaFin
	AND t0.codEmpleado in (
		SELECT
			codEmpleado
		FROM
			@salarios NOLOCK
		GROUP BY
			codEmpleado
		HAVING
			SUM(diasLiquidacion) < 180
	)
	AND DATEFROMPARTS(YEAR(T1.fechaInicio), MONTH(T1.fechaInicio), 1) NOT IN(
		SELECT
			DATEFROMPARTS([año], [mes], 1)
		FROM
			@salarios NOLOCK
		WHERE
			codEmpleado = T0.codEmpleado
	)
DELETE FROM
	@salarios
WHERE
	diasLiquidacion = 0
UPDATE
	@salarios
SET
	devengado = salarioMensual / 30 * diasLiquidacion
SELECT
	codEmpleado,
	[año],
	t0.mes,
	t1.nombre,
	salarioMensual,
	sSimples,
	sDobles,
	diasLiquidacion,
	devengado,
	devengado + sSimples + sDobles as totalDevengado
FROM
	@salarios t0
	INNER JOIN tMes t1 ON t0.mes = t1.mes
ORDER BY
	codEmpleado ASC,
	[año] ASC,
	mes ASC