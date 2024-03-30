USE PINULITO_NOMINA;

/* SELECT 
 tAumento.codEmpleado,
 COUNT(tContrato.noContract) num_contratos
 FROM 
 tAumento
 JOIN tContrato ON tContrato.codEmpleado = tAumento.codEmpleado
 WHERE 
 YEAR(fechaCreado) = 2024 
 AND MONTH(fechaCreado) > 2 
 AND aplicado = 1 
 AND vigente = 1
 GROUP BY 
 tAumento.codEmpleado
 HAVING
 COUNT(tContrato.noContract) > 1 */
 
SELECT
    noContract,
    nomPuesto,
    codEmpleado,
    salarioOrdinario,
    ISNULL(
        (
            SELECT
                TOP 1 salarioOrdinario
            FROM
                logtContrato subtable
            WHERE
                subtable.noContract = headertable.noContract
                AND YEAR(fechaHoraLog) = 2024
                AND MONTH(fechaHoraLog) > 2
                AND usuarioLog = 'sa'
                AND subtable.salarioOrdinario <> headertable.salarioOrdinario
            ORDER BY
                idLog DESC
        ),
        0
    ) ultimo_salario_ordinario,
    salarioMensual,
    ISNULL(
        (
            SELECT
                TOP 1 salarioMensual
            FROM
                logtContrato subtable
            WHERE
                subtable.noContract = headertable.noContract
                AND YEAR(fechaHoraLog) = 2024
                AND MONTH(fechaHoraLog) > 2
                AND usuarioLog = 'sa'
                AND subtable.salarioMensual <> headertable.salarioMensual
            ORDER BY
                idLog DESC
        ),
        0
    ) ultimo_salario_mensual,
    finContract
FROM
    tContrato headertable
WHERE
    codEmpleado IN (
        23,
        2539,
        69,
        2299,
        2794,
        29,
        3372,
        75,
        2502,
        201,
        9,
        2720,
        2757,
        3292,
        1426,
        3839,
        2708,
        2442,
        2820,
        2943,
        2373,
        235,
        3753,
        2628,
        26,
        3258,
        3756,
        135,
        112,
        6,
        2711,
        2356,
        2505,
        2611,
        49,
        1821,
        190,
        2420,
        144,
        2798,
        184,
        3422,
        67,
        1063,
        3562,
        2589,
        21,
        2932,
        3270,
        3370,
        107,
        156,
        2812,
        130,
        3284,
        2308,
        2320,
        44,
        2506,
        150,
        47,
        141,
        1730,
        3058,
        2517,
        3436,
        233,
        30,
        1690,
        2331,
        84,
        2715,
        227,
        61,
        2815,
        41,
        2709,
        2317,
        2368,
        2952,
        3542,
        119,
        2372,
        3700,
        3391,
        806,
        2303,
        2349,
        2781,
        2426,
        19,
        2529,
        2535,
        171,
        25,
        3165,
        460,
        2624,
        13,
        3259,
        42,
        5,
        3302,
        2612,
        2446,
        2154,
        3611,
        2592,
        122,
        222,
        3783,
        2695,
        3946,
        2813,
        1413,
        3291,
        3646,
        2458,
        245,
        94,
        257,
        77,
        3280,
        3612,
        17,
        1986,
        2387,
        2679,
        3878,
        3549,
        40,
        111,
        3406,
        2945,
        2994,
        2702,
        120,
        2298,
        2304,
        2590,
        28,
        131,
        2384,
        2476,
        14,
        3283,
        3340,
        51,
        151,
        194
    )
    AND (
        finContract IS NOT NULL
        AND finContract <> '1900-01-01'
    )
ORDER BY
    codEmpleado