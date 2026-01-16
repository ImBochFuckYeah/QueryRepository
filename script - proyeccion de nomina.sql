USE PINULITO_NOMINA;
GO

WITH DataSource AS (
	SELECT pl.idEmpresa AS codEmpresa,
	MONTH(pr.fechaInicio) AS mes,
	COUNT(DISTINCT pl.codEmpleado) AS empleados,
	SUM(pl.salarioMensual/2) AS salarioNominal,
	SUM(pl.hSimples) AS cantidadHorasSimples,
	SUM(pl.sSimples) AS salarioHorasSimples,
	SUM(pl.hDobles) AS cantidadHorasDobles,
	SUM(pl.sDobles) AS salarioHorasDobles,
	SUM(pl.bonifDecreto) AS bonificacionDecreto
	FROM [dbo].[tPlanilla] pl
	JOIN [dbo].[tPeriodo] pr ON pl.idPeriodo = pr.idPeriodo
	WHERE YEAR(pr.fechaInicio) = YEAR(GETDATE()) -- AND MONTH(pr.fechaInicio) BETWEEN 1 AND 10
	GROUP BY pl.idEmpresa, MONTH(pr.fechaInicio)
), ProyeccionNomina AS (
	SELECT ep.nombre AS [Empresa],
	AVG(ds.empleados) AS [Planilla],
	SUM(ds.salarioNominal) AS [Ordinario],
	SUM(ds.cantidadHorasSimples) AS [Cantidad horas simples],
	SUM(ds.salarioHorasSimples) AS [Horas simples en Q.],
	SUM(ds.cantidadHorasDobles) AS [Cantidad horas dobles],
	SUM(ds.salarioHorasDobles) AS [Horas dobles en Q.],
	SUM(ds.bonificacionDecreto) AS [Bonificación Decreto]
	FROM DataSource ds
	JOIN [dbo].[tEmpresa] ep ON ds.codEmpresa = ep.codEmpresa
	GROUP BY ep.nombre
)
SELECT *
FROM ProyeccionNomina
ORDER BY Empresa;