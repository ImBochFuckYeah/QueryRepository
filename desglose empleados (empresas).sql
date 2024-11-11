USE PINULITO_NOMINA;

--SELECT * FROM tEmpresa;

SELECT 
    tContrato.codEmpresa id_empresa,
    tEmpresa.nombre nombre_empresa,
    COUNT(*) num_empleados 
FROM 
    tContrato
    JOIN tEmpresa ON tContrato.codEmpresa = tEmpresa.codEmpresa
WHERE 
    tContrato.codEmpresa IS NOT NULL 
    AND ( 
        finContract = '1900-01-01'
        OR finContract IS NULL 
    )  
GROUP BY 
    tContrato.codEmpresa, tEmpresa.nombre
ORDER BY tContrato.codEmpresa;

/* EJECUTAR SP INFORME EPLEADOR */

-- EXEC spGenerarInformeEmpleador @year = 2023, @company = 8;