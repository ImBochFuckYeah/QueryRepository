/* USE PINULITO_NOMINA; */
WITH cte_empleados AS (
    SELECT codEmpleado, MIN(fechaIngreso) AS fechaIngreso
    FROM tContrato
    -- WHERE YEAR(fechaIngreso) <= 2022
    GROUP BY codEmpleado
)
SELECT 
eps.nombre AS empresa,
emp.aliasCodigo AS codigo,
CONCAT(
    UPPER(TRIM(CHAR(160) FROM emp.nombreEmpleado)),
    ' ',
    UPPER(TRIM(CHAR(160) FROM emp.segundoNombre)),
    ' ',
    UPPER(TRIM(CHAR(160) FROM emp.apellidoEmpleado)),
    ' ',
    UPPER(TRIM(CHAR(160) FROM emp.segundoApellido)),
    ' ',
    UPPER(TRIM(CHAR(160) FROM emp.apellidoCasada))
) AS nombre,
cte.fechaIngreso,
UPPER(dpt.nombre) AS departamento
-- cte.fechaIngreso,
-- tda.nombre_administrador AS supervisor,
-- tda.nombre_subadministrador AS subAdministrador,
-- tda.division
FROM tContrato AS ctt
JOIN cte_empleados AS cte ON ctt.codEmpleado = cte.codEmpleado
JOIN tEmpleado AS emp ON ctt.codEmpleado = emp.codEmpleado
-- JOIN [PINULITO_PDV].[dbo].[vwTiendas] AS tda ON ctt.codDepto = tda.id_departamento
JOIN tEmpresa AS eps ON ctt.codEmpresa = eps.codEmpresa
JOIN tDepartamento AS dpt ON ctt.codDepto = dpt.codDepto
WHERE (ctt.finContract IS NULL OR ctt.finContract = '19000101') AND ctt.codEmpresa = 8
ORDER BY ctt.codEmpresa, cte.fechaIngreso