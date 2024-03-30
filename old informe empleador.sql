USE PINULITO_NOMINA;

DECLARE @year INT = 2023, @company INT = 8;

SELECT
    T4.noContract,
	T3.codEmpleado,
	UPPER(T3.nombreEmpleado) AS primerNombre,
	UPPER(T3.segundoNombre) AS segundoNombre,
	UPPER(T3.apellidoEmpleado) AS primerApellido,
	UPPER(T3.segundoApellido) AS segundoApellido,
	UPPER(T3.apellidoCasada) AS apellidoCasada,
	T10.codigo AS nacionalidad,
	'0' AS discapacidad,
	CASE
		WHEN T3.estadoCivil = 'Soltero' THEN '1'
		WHEN T3.estadoCivil = 'Casado' THEN '2'
		WHEN T3.estadoCivil = 'Unido' THEN '3'
	END AS estadoCivil,
	CASE
		WHEN T3.tipoDoc = 'DPI' THEN '1'
		WHEN T3.tipoDoc = 'Certificado de Nacimiento' THEN '2'
		WHEN T3.tipoDoc = 'Pasaporte' THEN '3'
	END AS tipoDoc,
	T3.noDoc,
	T5.codMunicipio AS codMunicipio,
	T3.NIT,
	T3.noIGGS,
	CASE
		WHEN T3.sexo = 'M' THEN '1'
		ELSE '2'
	END AS sexo,
	CONVERT(NVARCHAR, T3.fechaNac, 103) AS fechaNac,
	CASE
		WHEN T3.raza = 'Xinca' THEN '1'
		WHEN T3.raza = 'Maya' THEN '2'
		WHEN T3.raza = 'Garífona' THEN '3'
		WHEN T3.raza = 'Ladino'
		OR T3.raza = 'Mestizo' THEN '4'
		WHEN T3.raza = 'Extranjero' THEN '5'
		ELSE '4'
	END AS grupoEtnico,
	'23' AS idioma,
	CASE
		WHEN T4.timeContract = 'Indefinido' THEN '1'
		ELSE '2'
	END AS tiempoCotrato,
	CASE
		WHEN T4.tipoContract = 'Verbal' THEN '1'
		WHEN T4.tipoContract = 'Escrito' THEN '2'
	END AS tipoContrato,
	CONVERT(NVARCHAR, T4.fechaIngreso, 103) AS inicioContrato,
	CASE
		WHEN T4.finContract = '1900-01-01' THEN NULL
		WHEN YEAR(T4.finContract) > @year THEN NULL
		ELSE CONVERT(NVARCHAR, T4.finContract, 103)
	END finContrato,
	T11.codigo AS ocupacion,
	CASE
		WHEN T4.jornadaLab = 'Diurna' THEN '1'
		WHEN T4.jornadaLab = 'Nocturna' THEN '2'
		WHEN T4.jornadaLab = 'Mixta' THEN '3'
	END AS jornadaLabo,
	T4.codOcupacionIGSS,
	T4.salarioMensual AS salarioMesual,
	SUM(T1.ordinario) AS salarioAnual,
	250.00 AS bonoDecreto,
	case
		WHEN YEAR(fechaIngreso) = @year
		AND (
			finContract IS NULL
			OR finContract = '1900-01-01'
		) THEN DATEDIFF(day, fechaIngreso, DATEFROMPARTS(@year, 12, 31))
		ELSE SUM(T1.diasLaborados)
	END AS diasLaborados,
	SUM(T1.hDobles + T1.hSimples) AS horasExtras,
	CAST(
		(((T4.salarioMensual / 30) / 8) * 1.5) AS DECIMAL(36, 2)
	) AS valorHoraExtra,
	ISNULL(T7.bono14, 0) bono14,
	ISNULL(T6.aguinaldo, 0) AS aguinaldo,
	ISNULL(T8.vacacion, 0) AS vacacion,
	ISNULL(T9.total, 0) AS liqudacion,
	ISNULL(T9.aguinaldo, 0) AS aguinaldoLiquidacion,
	ISNULL(T9.vacacion, 0) AS vacacionLiquidacion,
	ISNULL(T9.bono14, 0) AS bonoLiquidacion,
	T12.nombreCorto,
	CASE
		WHEN T13.numeroNivel IS NULL THEN '3'
		ELSE MAX(T13.numeroNivel)
	END as nivelAcademico,
	CASE
		WHEN T13.detalleAcad IS NULL THEN '6to. Primaria'
		ELSE T13.nivelAcad
	END AS titulo,
	ISNULL(T3.numeroHijos, 0) numeroHijos
FROM
	tPlanilla T1
	JOIN tPeriodo T2 ON T1.idPeriodo = T2.idPeriodo AND YEAR(T2.fechaInicio) = @year
	JOIN tEmpleado T3 ON T1.codEmpleado = T3.codEmpleado 	
    JOIN tContrato T4 ON T3.codEmpleado = T4.codEmpleado AND T4.codEmpresa = @company
	LEFT JOIN tMunicipioEmpleador T5 ON T3.muniNac = T5.idMunicipioEmpleador
	LEFT JOIN tAguinaldo T6 ON T1.codEmpleado = T6.codEmpleado	AND T6.anio = @year
	LEFT JOIN tBono14 T7 ON T1.codEmpleado = T7.codEmpleado	AND T7.anio = @year
	LEFT JOIN tVacacion T8 ON T1.codEmpleado = T8.codEmpleado AND YEAR(T8.ultimasVacaciones) = 2022
	LEFT JOIN tLiquidacion T9 ON T1.codEmpleado = T9.codEmpleado AND T4.noContract = T9.noContract -- se agrego nocontract
	LEFT JOIN tPais T10 ON T3.paisOrigen = T10.nombrePais
	LEFT JOIN tOcupacion T11 ON T4.ocupacion = T11.profesion
	LEFT JOIN tEmpresa T12 ON T1.idEmpresa = T12.codEmpresa
	LEFT JOIN tEducacion T13 ON T1.codEmpleado = T13.codEmpleado
	AND T13.numeroNivel = (
		SELECT
			MAX(E.numeroNivel)
		FROM
			tEducacion E
		WHERE
			E.codEmpleado = T1.codEmpleado
	)
WHERE
	T1.idEmpresa = @company
	AND (
		YEAR(T4.fechaIngreso) <= @year
		AND (
			T4.finContract IS NULL
			OR YEAR(T4.finContract) = 1900
			OR YEAR(T4.finContract) >= @year
		)
	)
GROUP BY
    T4.noContract,
	T3.nombreEmpleado,
	T3.segundoNombre,
	T3.apellidoEmpleado,
	T3.segundoApellido,
	T3.apellidoCasada,
	T3.paisOrigen,
	T3.discapacidad,
	T3.estadoCivil,
	T3.tipoDoc,
	T3.sexo,
	T3.noDoc,
	T5.codMunicipio,
	T3.NIT,
	T3.noIGGS,
	T3.fechaNac,
	T3.raza,
	T4.timeContract,
	T4.tipoContract,
	T4.fechaIngreso,
	T4.finContract,
	T4.codOcupacionIGSS,
	T4.jornadaLab,
	T4.salarioMensual,
	T6.aguinaldo,
	T7.bono14,
	T6.anio,
	T7.anio,
	T8.fechaInicio,
	T8.vacacion,
	T9.total,
	T9.aguinaldo,
	T9.vacacion,
	T9.bono14,
	T10.codigo,
	T3.codEmpleado,
	T11.codigo,
	T12.nombreCorto,
	T13.nivelAcad,
	T13.detalleAcad,
	T13.numeroNivel,
	T3.numeroHijos
ORDER BY
	primerNombre,
	segundoNombre,
	primerApellido,
	segundoApellido,
	inicioContrato