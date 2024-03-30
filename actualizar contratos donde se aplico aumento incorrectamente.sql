USE PINULITO_NOMINA;

SELECT 
    t2.noContract,
    ISNULL((
        SELECT TOP 1 salarioOrdinario
        FROM logtContrato
        WHERE CONVERT(date, fechaHoraLog) = CONVERT(date, t1.fechaCreado) AND noContract = t2.noContract
        ORDER BY idLog DESC
    ), 0) salarioOrdinario,
    ISNULL((
        SELECT TOP 1 salarioMensual
        FROM logtContrato
        WHERE CONVERT(date, fechaHoraLog) = CONVERT(date, t1.fechaCreado) AND noContract = t2.noContract
        ORDER BY idLog DESC
    ), 0) salarioMensual,
    CONVERT(date, t1.fechaCreado) fechaCreado,
    t2.codEmpleado
FROM 
    tAumento t1
    JOIN tContrato t2 ON t2.codEmpleado = t1.codEmpleado
    --JOIN logtContrato t3 ON t3.codEmpleado = t2.codEmpleado AND t3.noContract = t2.noContract AND CONVERT(date, t3.fechaHoraLog) = CONVERT(date, t1.fechaCreado)
WHERE 
    YEAR(t1.fechaCreado) = 2024
    --AND MONTH(t1.fechaCreado) > 1
    AND t1.codEmpleado NOT IN (
        235,
        806,
        1413,
        1690,
        2710
    )
    AND t1.nuevoSalario > 3
    AND t2.salarioOrdinario <> (
        SELECT TOP 1 salarioOrdinario
        FROM logtContrato
        WHERE CONVERT(date, fechaHoraLog) = CONVERT(date, t1.fechaCreado) AND noContract = t2.noContract
        ORDER BY idLog DESC
    )
    AND t2.salarioMensual <> (
        SELECT TOP 1 salarioMensual
        FROM logtContrato
        WHERE CONVERT(date, fechaHoraLog) = CONVERT(date, t1.fechaCreado) AND noContract = t2.noContract
        ORDER BY idLog DESC
    )
    AND (
        finContract IS NOT NULL
        AND YEAR(finContract) > 1900
        AND finContract <= '2024-03-01'
    )
ORDER BY
    t2.codEmpleado;