USE PINULITO_NOMINA;
-- 
DECLARE @startDate DATE = DATEFROMPARTS(YEAR(GETDATE()) - 1, 6, 30);
DECLARE @endDate DATE = DATEFROMPARTS(YEAR(GETDATE()), 7, 1);
SELECT
1,
ROW_NUMBER() OVER (ORDER BY emp.codEmpleado),
CONCAT(LTRIM(RTRIM(emp.nombreEmpleado)), ' ', LTRIM(RTRIM(emp.segundoNombre)), ' ', LTRIM(RTRIM(emp.apellidoEmpleado)), ' ', LTRIM(RTRIM(emp.segundoApellido))),
LTRIM(RTRIM(emp.noCuenta)),
(SUM(pnl.salarioMensual / 2) / 12),
CONCAT('Bono14 Decreto 42-92 periodo ', YEAR(@startDate), ' - ', YEAR(@endDate))
FROM tContrato AS ctt
JOIN tPlanilla AS pnl ON ctt.codEmpleado = pnl.codEmpleado -- AND ctt.codEmpresa = pnl.idEmpresa
JOIN tPeriodo AS prd ON pnl.idPeriodo = prd.idPeriodo
JOIN tEmpleado AS emp ON ctt.noContract = emp.noContract AND ctt.codEmpleado = emp.codEmpleado
WHERE prd.fechaInicio >= @startDate AND prd.fechaFin <= @endDate AND ctt.codEmpresa = 21
AND (ctt.finContract IS NULL OR ctt.finContract = '19000101' OR ctt.finContract >= @endDate) AND prd.fechaFin >= ctt.fechaIngreso
GROUP BY emp.codEmpleado, emp.nombreEmpleado, emp.segundoNombre, emp.apellidoEmpleado, emp.segundoApellido, emp.noCuenta;