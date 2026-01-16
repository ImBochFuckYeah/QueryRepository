USE PINULITO_NOMINA;
GO

WITH empleados_activos AS ( 
	SELECT e.codEmpleado, e.aliasCodigo, e.nombreEmpleado, e.segundoNombre, e.apellidoEmpleado, e.segundoApellido, c.noContract
	FROM [dbo].[tEmpleado] e
	JOIN [dbo].[tContrato] c ON e.codEmpleado = c.codEmpleado
		AND e.noContract = c.noContract
	WHERE (c.finContract IS NULL OR c.finContract = '19000101')
), empleados AS (
	SELECT e.noContract,
		c.codEmpleado,
		e.aliasCodigo,
		NULLIF(TRIM(e.nombreEmpleado), '') AS nombreEmpleado,
		NULLIF(TRIM(e.segundoNombre), '') AS segundoNombre,
		NULLIF(TRIM(e.apellidoEmpleado), '') AS apellidoEmpleado,
		NULLIF(TRIM(e.segundoApellido), '') AS segundoApellido,
		MIN(c.fechaIngreso) AS fechaIngreso
	FROM empleados_activos e
	JOIN [dbo].[tContrato] c ON e.codEmpleado = c.codEmpleado
	GROUP BY e.noContract,
		c.codEmpleado,
		e.aliasCodigo,
		e.nombreEmpleado,
		e.segundoNombre,
		e.apellidoEmpleado,
		e.segundoApellido
), empleados_antiguedad AS (
	SELECT em.nombre AS empresa,
		dp.nombre AS departamento,
		ep.aliasCodigo AS codigo,
		CONCAT(
			ep.nombreEmpleado,
			' ',
			ep.segundoNombre,
			' ',
			ep.apellidoEmpleado,
			' ',
			ep.segundoApellido
		) AS nombre,
		DATEDIFF(YEAR, ep.fechaIngreso, TRY_CAST(GETDATE() AS DATE)) AS años,
		DATEDIFF(MONTH, ep.fechaIngreso, TRY_CAST(GETDATE() AS DATE)) AS meses,
		DATEDIFF(DAY, ep.fechaIngreso, TRY_CAST(GETDATE() AS DATE)) AS dias
	FROM empleados ep
	JOIN [dbo].tContrato ct ON ep.noContract = ct.noContract
		AND ep.codEmpleado = ct.codEmpleado
	JOIN [dbo].[tEmpresa] em ON ct.codEmpresa = em.codEmpresa
	JOIN [dbo].[tDepartamento] dp ON ct.codDepto = dp.codDepto
)
SELECT *
FROM empleados_antiguedad
ORDER BY empresa, departamento;