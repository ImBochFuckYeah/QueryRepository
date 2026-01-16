USE PINULITO_NOMINA;
GO

DECLARE @fecha_inicio DATE = '20251201',
		@fecha_fin DATE = '20251231';

SELECT
	epa.nombre AS [EMPRESA],
	dto.nombre AS [DEPARTAMENTO],
	prd.nombrePeriodo AS [PERIODO],
	pla.codigo AS [CODIGO],
	pla.empleado AS [NOMBRE],
	pla.hSimples AS [HS],
	pla.hDobles AS [HD],
	pla.diasLaborados AS [DT],
	pla.salarioMensual AS [NOMINAL],
	pla.ordinario AS [ORDINARIO],
	pla.bonifDecreto AS [BONO DECRETO],
	pla.sSimples AS [HORAS SIMPLES],
	pla.sDobles AS [HORAS DOBLES],
	pla.anticipos AS [ANTICIPOS],
	pla.otrosIngresos AS [OTROS INGRESOS],
	(
		pla.ordinario +
		pla.bonifDecreto +
		pla.sSimples +
		pla.sDobles +
		pla.anticipos +
		pla.otrosIngresos
	) AS [TOTAL INGRESOS],
	pla.igss AS [IGSS],
	pla.isr AS [ISR],
	pla.seguro AS [COOTRAGUA],
	pla.ahorro AS [AHORRO],
	pla.otrosDescuentos AS [OTROS],
	(
		pla.igss +
		pla.isr +
		pla.seguro +
		pla.ahorro +
		pla.otrosDescuentos
	) AS [TOTAL DESCUENTOS],
	pla.liquido AS [LIQUIDO],
	pla.comentarios AS [OBSERVACIONES]
FROM [dbo].[tPlanilla] pla
JOIN [dbo].[tPeriodo] prd
	ON pla.idPeriodo = prd.idPeriodo
JOIN [dbo].[tDepartamento] dto
	ON pla.departamento = dto.codDepto
JOIN [dbo].[tEmpresa] epa
	ON pla.idEmpresa = epa.codEmpresa
WHERE prd.pagada = 1
	AND prd.fechaInicio >= @fecha_inicio
	AND prd.fechaFin <= @fecha_fin
--
UNION
--
SELECT
	epa.nombre AS [EMPRESA],
	pla.departamento AS [DEPARTAMENTO],
	prd.nombrePeriodo AS [PERIODO],
	pla.codigo AS [CODIGO],
	pla.empleado AS [NOMBRE],
	pla.hSimples AS [HS],
	pla.hDobles AS [HD],
	pla.diasLaborados AS [DT],
	pla.salarioMensual AS [NOMINAL],
	pla.ordinario AS [ORDINARIO],
	pla.bonifDecreto AS [BONO DECRETO],
	pla.sSimples AS [HORAS SIMPLES],
	pla.sDobles AS [HORAS DOBLES],
	pla.anticipos AS [ANTICIPOS],
	pla.otrosIngresos AS [OTROS INGRESOS],
	(
		pla.ordinario +
		pla.bonifDecreto +
		pla.sSimples +
		pla.sDobles +
		pla.anticipos +
		pla.otrosIngresos
	) AS [TOTAL INGRESOS],
	pla.igss AS [IGSS],
	pla.isr AS [ISR],
	pla.seguro AS [COOTRAGUA],
	pla.ahorro AS [AHORRO],
	pla.otrosDescuentos AS [OTROS],
	(
		pla.igss +
		pla.isr +
		pla.seguro +
		pla.ahorro +
		pla.otrosDescuentos
	) AS [TOTAL DESCUENTOS],
	pla.liquido AS [LIQUIDO],
	pla.comentarios AS [OBSERVACIONES]
FROM [dbo].[tPlanillaTemporal] pla
JOIN [dbo].[tPeriodo] prd
	ON pla.idPeriodo = prd.idPeriodo
--JOIN [dbo].[tDepartamento] dto
--	ON pla.departamento = dto.codDepto
JOIN [dbo].[tEmpresa] epa
	ON pla.idEmpresa = epa.codEmpresa
WHERE prd.pagada = 0
	AND prd.fechaInicio >= @fecha_inicio
	AND prd.fechaFin <= @fecha_fin;