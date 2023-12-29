ALTER PROCEDURE get_reporte_quincena @id_empresa INT,
@id_periodo INT AS BEGIN
SELECT
    idEmpresa AS id_empresa,
    departamento AS id_departamento,
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
    ) AS nombre_departamento,
    codEmpleado AS id_empleado,
    codigo AS alias_codigo,
    empleado AS nombre_empleado,
    idPeriodo AS id_periodo,
    ISNULL(
        (
            SELECT
                CONVERT(nvarchar, fechaInicio)
            FROM
                tPeriodo
            WHERE
                tPeriodo.idPeriodo = tPlanilla.idPeriodo
        ),
        ''
    ) AS fecha_inicio_periodo,
    ISNULL(
        (
            SELECT
                CONVERT(nvarchar, fechaFin)
            FROM
                tPeriodo
            WHERE
                tPeriodo.idPeriodo = tPlanilla.idPeriodo
        ),
        ''
    ) AS fecha_fin_periodo,
    ISNULL(
        dbo.get_couta_inicial(tPlanilla.codEmpleado, tPlanilla.idPeriodo),
        0
    ) AS couta_inicial,
    ISNULL(
        dbo.get_ahorro(tPlanilla.codEmpleado, tPlanilla.idPeriodo),
        0
    ) AS couta_ahorro,
    ISNULL(
        dbo.get_aportacion(tPlanilla.codEmpleado, tPlanilla.idPeriodo),
        0
    ) AS couta_aportacion,
    ISNULL(
        dbo.get_prestamo(tPlanilla.codEmpleado, tPlanilla.idPeriodo),
        0
    ) AS couta_prestamo,
    (
        SELECT
            MONTH(fechaInicio)
        FROM
            tPeriodo
        WHERE
            tPeriodo.idPeriodo = tPlanilla.idPeriodo
    ) AS mes,
    (
        SELECT
            YEAR(fechaInicio)
        FROM
            tPeriodo
        WHERE
            tPeriodo.idPeriodo = tPlanilla.idPeriodo
    ) AS [año],
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
    ) AS no_quincena
FROM
    tPlanilla
WHERE
    idEmpresa = @id_empresa
    AND idPeriodo = @id_periodo
END;