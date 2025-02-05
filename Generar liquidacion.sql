DECLARE @codEmpresa INT = 4, @fechaCalculo DATE = '2024-11-25', @codEmpleado2 INT = 4249;

SET	@fechaCalculo = (
	SELECT
		TOP 1 finContract
	FROM
		tContrato
	WHERE
		codEmpleado = @codEmpleado2
	ORDER BY
		finContract DESC
);

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
	JOIN tEmpleado t1 ON t0.codEmpleado = t1.codEmpleado
	JOIN tContrato t2 ON t0.codEmpleado = t2.codEmpleado
	JOIN tPeriodo t3 ON t0.idPeriodo = t3.idPeriodo
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
	AND (
		finContract >= DATEADD(DAY, -1, @fechaCalculo)
		OR finContract IS NULL
		OR finContract = '1900-01-01'
	)
GROUP BY
	t1.codEmpleado,
	t1.nombreEmpleado,
	t1.segundoNombre,
	t1.apellidoEmpleado,
	t1.segundoApellido,
	t1.apellidoCasada,
	YEAR(t3.fechaInicio),
	MONTH(t3.fechaInicio),
	t2.fechaIngreso;

DECLARE @codEmpleado INT = 0;
DECLARE @codEmpleadoActual INT = 0;
DECLARE @an INT;
DECLARE @mes INT;
DECLARE @diasAcumulado INT = 0;
DECLARE @diasReal INT;
DECLARE @diasLiquidacion INT = 0;

/******************************************************************************************************************/
DECLARE c1 CURSOR FOR
	SELECT [año], mes, codEmpleado, diasReal
	FROM @salarios
	ORDER BY codEmpleado ASC, [año] DESC, mes DESC
OPEN c1 FETCH NEXT
FROM c1 INTO @an, @mes, @codEmpleado, @diasReal WHILE @@FETCH_STATUS = 0 
BEGIN 
	IF (@codEmpleadoActual != @codEmpleado)
	BEGIN
		SET
			@diasAcumulado = 0
		SET
			@codEmpleadoActual = @codEmpleado
	END
	--  
	IF (
		@diasReal = 30
		AND @diasAcumulado <= 150
	) BEGIN
		SET
			@diasAcumulado = @diasAcumulado + 30
		SET
			@diasLiquidacion = 30
	END
	-- 
	ELSE IF (
		@diasReal + @diasAcumulado + @diasMesActual <= 182
	) BEGIN
		SET
			@diasAcumulado = @diasAcumulado + @diasReal + @diasMesActual
		SET
			@diasLiquidacion = @diasReal
	END
	-- 
	ELSE IF (
		@diasReal > (180 - @diasAcumulado - @diasMesActual)
	) BEGIN
		SET
			@diasAcumulado = @diasAcumulado + (180 - @diasAcumulado - @diasMesActual)
		SET
			@diasLiquidacion = (180 - @diasAcumulado - @diasMesActual)
	END
	-- 
	ELSE IF (@diasAcumulado <= 180) 
	BEGIN
		SET
			@diasAcumulado = @diasAcumulado + @diasReal
		SET
			@diasLiquidacion = @diasReal
	END
	-- 
	ELSE 
	BEGIN
		SET
			@diasLiquidacion = 0
	END
-- 
	UPDATE @salarios
	SET diasLiquidacion = @diasLiquidacion
	WHERE codEmpleado = @codEmpleado AND mes = @mes AND [año] = @an 
-- 
FETCH NEXT
FROM c1 
INTO @an, @mes, @codEmpleado, @diasReal
END CLOSE c1 DEALLOCATE c1;
/******************************************************************************************************************/

-- 
SET
	@fechaCalculo = DATEADD(DAY, -1, @fechaCalculo);
-- 
SET
	@diasMesActual = DAY(@fechaCalculo);
-- 

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
	);

-- 
DELETE FROM
	@salarios
WHERE
	diasLiquidacion = 0;
-- 
UPDATE
	@salarios
SET
	devengado = salarioMensual / 30 * diasLiquidacion;
-- 

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
	mes ASC;