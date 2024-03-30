USE PINULITO_NOMINA;

SELECT 
    tA.idAumento,
    tE.codEmpleado,
    tC.noContract,
    tC.salarioOrdinario,
    tA.nuevoSalario,
    tA.nuevoSalario + tC.bonifDecreto salarioMensual
FROM 
    tAumento tA
    JOIN tEmpleado tE ON tE.codEmpleado = tA.codEmpleado
    JOIN tContrato tC ON tC.noContract = tE.noContract
WHERE
    YEAR(tA.fechaCreado) = 2024
    AND (
        tC.finContract IS NOT NULL
        AND YEAR(tC.finContract) > 1900
    )
    AND tC.salarioOrdinario <> tA.nuevoSalario
    AND tA.nuevoSalario > 3