USE PINULITO_NOMINA;
-- 
WITH records AS (
    SELECT pnl.codEmpleado, pnl.idPeriodo, rowsNum = COUNT(*)
    FROM tContrato AS ctt
    JOIN tPlanilla AS pnl ON ctt.codEmpleado = pnl.codEmpleado
    WHERE ctt.codEmpresa = 21
    GROUP BY pnl.codEmpleado, pnl.idPeriodo
    HAVING COUNT(*) > 1
)
-- 
-- SELECT p.codEmpleado, empresas = STRING_AGG(p.idEmpresa, ','), COUNT(*)
-- FROM tPlanilla AS p
-- JOIN records AS r ON p.codEmpleado = r.codEmpleado AND p.idPeriodo = r.idPeriodo
-- GROUP BY p.codEmpleado;
-- 
SELECT p.*
FROM tPlanilla AS p
JOIN records AS r ON p.codEmpleado = r.codEmpleado AND p.idPeriodo = r.idPeriodo
-- WHERE p.idEmpresa = 21
ORDER BY p.codEmpleado, p.idPeriodo;