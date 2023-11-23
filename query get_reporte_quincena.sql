USE pinulito_nomina;

SELECT
    idEmpresa id_empresa,
    departamento id_departamento,
    ISNULL(
        (
            SELECT
                nombre
            FROM
                tDepartamento
            WHERE
                tDepartamento.codDepto = tPlanilla.departamento
        ),
        ''
    ) nombre_departamento,
    codEmpleado id_empleado,
    codigo alias_codigo,
    empleado nombre_empleado,
    idPeriodo id_periodo,
    ISNULL(
        dbo.get_couta_inicial(tPlanilla.codEmpleado, tPlanilla.idPeriodo),
        0
    ) couta_inicilal,
    ISNULL(
        dbo.get_ahorro(tPlanilla.codEmpleado, tPlanilla.idPeriodo),
        0
    ) couta_ahorro,
    ISNULL(
        dbo.get_aportacion(tPlanilla.codEmpleado, tPlanilla.idPeriodo),
        0
    ) couta_aportacion,
    ISNULL(
        dbo.get_prestamo(tPlanilla.codEmpleado, tPlanilla.idPeriodo),
        0
    ) couta_prestamo,
    (
        SELECT
            MONTH(fechaInicio)
        FROM
            tPeriodo
        WHERE
            tPeriodo.idPeriodo = tPlanilla.idPeriodo
    ) mes,
    (
        SELECT
            YEAR(fechaInicio)
        FROM
            tPeriodo
        WHERE
            tPeriodo.idPeriodo = tPlanilla.idPeriodo
    ) [año],
    (
        SELECT
            CASE
                WHEN DAY(fechaInicio) <= 15 THEN 1
                ELSE 2
            END
        FROM
            tPeriodo
        WHERE
            tPeriodo.idPeriodo = tPlanilla.idPeriodo
    ) no_quincena
FROM
    tPlanilla
WHERE
    idEmpresa = 8
    AND idPeriodo = 91