USE PINULITO_NOMINA;

DECLARE @year INT = 2023, @company INT = 8;

SELECT
	table_1.noContract id_contrato,
	ISNULL(UPPER(table_1.codEmpleado), '') codigo_empleado,
	ISNULL(UPPER(table_2.nombreEmpleado), '') primer_nombre,
	ISNULL(UPPER(table_2.segundoNombre), '') segundo_nombre,
	ISNULL(UPPER(table_2.apellidoEmpleado), '') primer_apellido,
	ISNULL(UPPER(table_2.segundoApellido), '') segundo_apellido,
	ISNULL(UPPER(table_2.apellidoCasada), '') apellido_casada,
	ISNULL(table_7.codigo, '') nacionalidad,
	CASE WHEN table_2.discapacidad = 'ninguna' OR table_2.discapacidad IS NULL THEN 0 ELSE 1 END discapacidad,
	CASE WHEN table_2.estadoCivil = 'soltero' THEN 1 WHEN table_2.estadoCivil = 'casado' THEN 2 WHEN table_2.estadoCivil = 'unido' THEN 3 ELSE 0 END estado_civil,
	CASE WHEN table_2.tipoDoc = 'dpi' THEN 1 WHEN table_2.tipoDoc = 'certificado de nacimiento' THEN 2 WHEN table_2.tipoDoc = 'pasaporte' THEN 3 ELSE 0 END tipo_documento_identificacion,
	ISNULL(table_2.noDoc, '') numero_documento_identificacion,
	ISNULL(table_3.codMunicipio, '') codigo_municipio,
	ISNULL(table_2.nit, '') numero_nit,
	ISNULL(table_2.noiggs, '') numero_iggs,
	CASE WHEN table_2.sexo = 'F' THEN 2 WHEN table_2.sexo = 'M' THEN 1 ELSE 0 END sexo,
	CONVERT(NVARCHAR, table_2.fechaNac, 103) fecha_nacimiento,
	CASE WHEN table_2.raza = 'xinca' THEN 1 WHEN table_2.raza = 'maya' THEN 2 WHEN table_2.raza = 'garifona' THEN 3 WHEN table_2.raza = 'ladino' OR table_2.raza = 'mestizo' THEN 4 WHEN table_2.raza = 'extranjero' THEN 5 ELSE 0 END grupo_etnico,
	23 idioma,
	CASE WHEN table_1.timeContract = 'indefinido' THEN 1 ELSE 2 END tiempo_contrato,
	CASE WHEN table_1.tipoContract = 'verbal' THEN 1 WHEN table_1.tipoContract = 'escrito' THEN 2 ELSE 0 END tipo_contrato,
	ISNULL(CONVERT(NVARCHAR, table_1.fechaIngreso, 103), '-') fecha_inicio_contrato,
	ISNULL(CONVERT(NVARCHAR, table_1.finContract, 103), '-') fecha_fin_contrato,
	ISNULL(table_4.codigo, 0) tipo_ocupacion,
	CASE WHEN table_1.jornadaLab = 'Diurna' THEN 1 WHEN table_1.jornadaLab = 'Nocturna' THEN 2 WHEN table_1.jornadaLab = 'Mixta' THEN 3 ELSE 0 END jornada_laboral,
	ISNULL(table_1.codOcupacionIGSS, 0) codigo_ocupacion_iggs,
	ISNULL(table_1.salarioMensual, 0) salario_mensual,
	ISNULL(table_1.salarioMensual * 12, 0) salario_anual,
	ISNULL(table_1.bonifDecreto, 0) bonificacion_decreto,
	DATEDIFF(DAY, table_1.fechaIngreso, DATEFROMPARTS(@year, 12, 31)) dias_laborados,
	ISNULL((
		SELECT 
			SUM(sub_table_2.hSimples + sub_table_2.hDobles)
		FROM 
			tPeriodo sub_table_1
			JOIN tPlanilla sub_table_2 ON sub_table_2.idPeriodo = sub_table_1.idPeriodo
		WHERE
			sub_table_1.fechaInicio >= DATEFROMPARTS(@year, 1, 1) 
			AND sub_table_1.fechaFin <= DATEFROMPARTS(@year, 12, 31)
			AND sub_table_2.codEmpleado = table_1.codEmpleado
			AND sub_table_2.idEmpresa = table_1.codEmpresa
			AND sub_table_2.departamento = table_1.codDepto
	), 0) horas_extras_laboradas,
	CAST(
		(((table_1.salarioMensual / 30) / 8) * 1.5) AS DECIMAL(36, 2)
	) pago_hora_extra,
	ISNULL((
		SELECT 
			SUM(sub_table_1.bono14)
		FROM 
			tBono14 sub_table_1
		WHERE
			sub_table_1.anio = @year
			AND sub_table_1.codEmpleado = table_1.codEmpleado
	), 0) bono_14,
	ISNULL((
		SELECT 
			SUM(sub_table_1.aguinaldo)
		FROM 
			tAguinaldo sub_table_1
		WHERE
			sub_table_1.anio = @year
			AND sub_table_1.codEmpleado = table_1.codEmpleado
	), 0) aguinaldo,
	ISNULL((
		SELECT 
			SUM(vacacion)
		FROM 
			tVacacion sub_table_1
		WHERE
			YEAR(ultimasVacaciones) = @year - 1
			AND sub_table_1.codEmpleado = table_1.codEmpleado
	), 0) vacacion,
	ISNULL((
		SELECT 
			SUM(total)
		FROM 
			tLiquidacion sub_table_1
		WHERE
			sub_table_1.codEmpleado = table_1.codEmpleado
			AND sub_table_1.noContract = table_1.noContract
	), 0) liquidacion,
	ISNULL(table_5.nombreCorto, 'N/A') prefijo_empresa,
	ISNULL(table_6.nivelAcad, 'N/A') nivel_academico,
	ISNULL(table_2.numeroHijos, 0) numero_hijos
FROM
	tContrato table_1
	JOIN tEmpleado table_2 ON table_2.codEmpleado = table_1.codEmpleado
	LEFT JOIN tMunicipioEmpleador table_3 ON table_3.idMunicipioEmpleador = table_2.muniNac
	LEFT JOIN tOcupacion table_4 ON table_4.profesion = table_1.ocupacion
	LEFT JOIN tEmpresa table_5 ON table_5.codEmpresa = table_1.codEmpresa
	lEFT JOIN tEducacion table_6 ON table_6.codEmpleado = table_1.codEmpleado
	LEFT JOIN tPais table_7 ON table_7.nombrePais = table_2.paisOrigen
WHERE
	table_1.codEmpresa = @company
    AND (
        YEAR(table_1.fechaIngreso) <= @year
        AND (
            table_1.finContract IS NULL
            OR YEAR(table_1.finContract) = 1900
            OR YEAR(table_1.finContract) >= @year
        )
    ) /* AND (
		table_1.activo = 1
		AND table_2.activo = 1
	) */
/* GROUP BY
	table_1.codEmpleado,
	table_2.nombreEmpleado,
	table_2.segundoNombre,
	table_2.apellidoEmpleado,
	table_2.segundoApellido,
	table_2.apellidoCasada,
	table_2.paisOrigen,
	table_2.discapacidad,
	table_2.estadoCivil,
	table_2.tipoDoc,
	table_2.noDoc,
	table_3.codMunicipio,
	table_2.nit,
	table_2.noiggs,
	table_2.fechaNac,
	table_2.raza,
	table_1.timeContract,
	table_1.tipoContract,
	table_1.fechaIngreso,
	table_1.finContract,
	table_4.codigo,
	table_1.codOcupacionIGSS,
	table_5.nombreCorto,
	table_6.nivelAcad,
	table_2.numeroHijos */
ORDER BY
	table_1.codEmpleado