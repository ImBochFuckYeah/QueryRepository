USE PINULITO_NOMINA

SELECT
    tEmpresa.codEmpresa codigo_empresa,
    tEmpresa.nombre,
    COUNT(*) num_empleados
FROM
    tContrato
    JOIN tEmpresa ON tEmpresa.codEmpresa = tContrato.codEmpresa
    JOIN tEmpleado ON tEmpleado.codEmpleado = tContrato.codEmpleado
WHERE
    (
        YEAR(fechaIngreso) <= 2023
        AND (
            finContract IS NULL
            OR YEAR(finContract) = 1900
            OR YEAR(finContract) >= 2023
        )
    )
GROUP BY
    tEmpresa.codEmpresa,
    tEmpresa.nombre
ORDER BY
    tEmpresa.codEmpresa;

----------------------------------

/* SELECT * FROM tContrato WHERE noContract = 54388;

SELECT * FROM tDepartamento WHERE codDepto = 347; */