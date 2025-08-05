-- BEGIN TRANSACTION;
-- 
USE PINULITO_NOMINA;
-- 
WITH SourceEmployeesTable AS (
    SELECT ctt2.noContract, ctt2.fechaIngreso, ctt2.codEmpleado, ctt2.codEmpresa, ctt2.codDepto, ctt2.finContract, newCompany = ctt.codEmpresa, newDepartment = ctt.codDepto, newCodeEmployee = emp.aliasCodigo
    FROM tContrato AS ctt
    JOIN tContrato AS ctt2 ON ctt.codEmpleado = ctt2.codEmpleado AND ctt.fechaIngreso = ctt2.fechaIngreso
    JOIN tEmpleado AS emp ON ctt.codEmpleado = emp.codEmpleado
    WHERE (ctt.codEmpresa = 21) AND (ctt.finContract IS NULL OR ctt.finContract = '19000101') AND (ctt2.finContract IS NOT NULL AND ctt2.finContract > '19000101')
)
-- 
SELECT prd.nombrePeriodo, registrosPlanilla = COUNT(*)
FROM SourceEmployeesTable AS emp
JOIN tPeriodo AS prd ON prd.fechaInicio >= emp.fechaIngreso AND prd.fechaFin <= emp.finContract
JOIN tPlanilla AS pnl ON emp.codEmpleado = pnl.codEmpleado AND emp.codEmpresa = pnl.idEmpresa AND prd.idPeriodo = pnl.idPeriodo
GROUP BY prd.nombrePeriodo;
-- 
-- INSERT INTO tPlanilla
-- OUTPUT inserted.idPlanilla, 
-- inserted.idEmpresa,
-- inserted.idPeriodo,
-- inserted.codEmpleado,
-- inserted.departamento,
-- inserted.codigo,
-- inserted.empleado,
-- inserted.salarioMensual,
-- inserted.ordinario,
-- inserted.diasLaborados,
-- inserted.hSimples,
-- inserted.hDobles,
-- inserted.sSimples,
-- inserted.sDobles,
-- inserted.bonifDecreto,
-- inserted.otrosIngresos,
-- inserted.neto,
-- inserted.igss,
-- inserted.isr,
-- inserted.seguro,
-- inserted.ahorro,
-- inserted.otrosDescuentos,
-- inserted.liquido,
-- inserted.comentarios,
-- inserted.anticipos
-- SELECT emp.newCompany,
-- pnl.idPeriodo,
-- pnl.codEmpleado,
-- emp.newDepartment,
-- emp.newCodeEmployee,
-- pnl.empleado,
-- pnl.salarioMensual,
-- pnl.ordinario,
-- pnl.diasLaborados,
-- pnl.hSimples,
-- pnl.hDobles,
-- pnl.sSimples,
-- pnl.sDobles,
-- pnl.bonifDecreto,
-- pnl.otrosIngresos,
-- pnl.neto,
-- pnl.igss,
-- pnl.isr,
-- pnl.seguro,
-- pnl.ahorro,
-- pnl.otrosDescuentos,
-- pnl.liquido,
-- pnl.comentarios,
-- pnl.anticipos
-- FROM SourceEmployeesTable AS emp
-- JOIN tPeriodo AS prd ON prd.fechaInicio >= emp.fechaIngreso AND prd.fechaFin <= emp.finContract
-- JOIN tPlanilla AS pnl ON emp.codEmpleado = pnl.codEmpleado AND emp.codEmpresa = pnl.idEmpresa AND prd.idPeriodo = pnl.idPeriodo;
-- 
-- ROLLBACK;
-- COMMIT;