-- Created by GitHub Copilot in SSMS - review carefully before executing
/*
Resumen: Genera una proyección anual de nómina por empresa para el año actual.
Agrupa por empresa y mes, agrega empleados, salarios y horas, y presenta totales por empresa.
*/

-- Construye la fuente de datos agregada por empresa y mes para el año actual
WITH DataSource AS (
    SELECT pl.idEmpresa AS codEmpresa,
           DATEPART(month, pr.fechaInicio) AS mes,
           COUNT(DISTINCT pl.codEmpleado) AS empleados,
           SUM(pl.salarioMensual / 2) AS salarioNominal,
           SUM(pl.hSimples) AS cantidadHorasSimples,
           SUM(pl.sSimples) AS salarioHorasSimples,
           SUM(pl.hDobles) AS cantidadHorasDobles,
           SUM(pl.sDobles) AS salarioHorasDobles,
           SUM(pl.bonifDecreto) AS bonificacionDecreto
    FROM dbo.tPlanilla pl
    JOIN dbo.tPeriodo pr ON pl.idPeriodo = pr.idPeriodo
    WHERE pr.fechaInicio >= DATEFROMPARTS(YEAR(GETDATE()), 1, 1) -- inicio año actual
      AND pr.fechaInicio < DATEFROMPARTS(YEAR(GETDATE()) + 1, 1, 1) -- inicio año siguiente
    GROUP BY pl.idEmpresa, DATEPART(month, pr.fechaInicio)
), ProyeccionNomina AS (
    SELECT ep.nombre AS Empresa,
           AVG(ds.empleados) AS Planilla,
           SUM(ds.salarioNominal) AS Ordinario,
           SUM(ds.cantidadHorasSimples) AS [Cantidad horas simples],
           SUM(ds.salarioHorasSimples) AS [Horas simples en Q.],
           SUM(ds.cantidadHorasDobles) AS [Cantidad horas dobles],
           SUM(ds.salarioHorasDobles) AS [Horas dobles en Q.],
           SUM(ds.bonificacionDecreto) AS [Bonificación Decreto]
    FROM DataSource ds
    JOIN dbo.tEmpresa ep ON ds.codEmpresa = ep.codEmpresa
    GROUP BY ep.nombre
)
-- Selección final con columnas explícitas y orden por empresa
SELECT Empresa,
       Planilla,
       Ordinario,
       [Cantidad horas simples],
       [Horas simples en Q.],
       [Cantidad horas dobles],
       [Horas dobles en Q.],
       [Bonificación Decreto]
FROM ProyeccionNomina
ORDER BY Empresa;