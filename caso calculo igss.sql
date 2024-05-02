SELECT
	T3.codEmpleado,
	UPPER(dbo.RemoveAccent(T1.nombreEmpleado)) AS primerNombre,
	UPPER(dbo.RemoveAccent(T1.segundoNombre)) AS segundoNombre,
	UPPER(dbo.RemoveAccent(T1.apellidoEmpleado)) AS primerApellido,
	UPPER(dbo.RemoveAccent(T1.segundoApellido)) AS segundoApellido,
	UPPER(dbo.RemoveAccent(T1.apellidoCasada)) AS apellidoCasada,
	T1.NIT AS nitEmpleado,
	T1.noIGGS,
	T2.codDepto,
	MONTH(T2.fechaIngreso) as mesInicio,
	YEAR(T2.fechaIngreso) as yearInicio,
	MONTH(T2.finContract) as mesFinal,
	YEAR(T2.finContract) as yearFinal,
	T2.idLiquidacionIGSS,
	T2.codCentroTrabajoIGSS AS centroIGSS,
	COALESCE(
		T2.codOcupacionIGSS,
		(
			SELECT
				TOP 1 codOcupacionIGSS
			FROM
				tContrato
			WHERE
				codEmpleado = T3.codEmpleado
				AND codOcupacionIGSS IS NOT NULL
		)
	) AS codOcupacionIGSS,
	CONVERT(nvarchar, T2.fechaIngreso, 103) as fechaInicio,
	CONVERT(nvarchar, T2.finContract, 103) as fechaFin,
	CASE
		WHEN T6.tipoAusencia = 'V'
		AND T6.codEmpleado = T3.codEmpleado
		AND T6.fechaInicio BETWEEN '2023-09-01'
		AND '2023-09-30' THEN SUM(T3.neto - T3.bonifDecreto) + T5.vacacion
		ELSE SUM(T3.neto - T3.bonifDecreto)
	END AS salario
FROM
	tEmpleado T1
	INNER JOIN tPlanilla T3 ON T1.codEmpleado = T3.codEmpleado
	INNER JOIN tContrato T2 ON T3.idEmpresa = T2.codEmpresa
	AND T3.codEmpleado = T2.codEmpleado
	INNER JOIN tPeriodo T4 ON T3.idPeriodo = T4.idPeriodo
	AND (
		T4.fechaInicio <= T2.finContract
		OR T2.finContract IS NULL
		OR T2.finContract = '1900-01-01'
	)
	LEFT JOIN tVacacion T5 ON T3.codEmpleado = T5.codEmpleado
	AND T5.fechaInicio BETWEEN '2023-09-01'
	AND '2023-09-30'
	AND T5.vigente = 1
	LEFT JOIN tAusencia T6 ON T3.codEmpleado = T6.codEmpleado
	AND T6.fechaInicio BETWEEN '2023-09-01'
	AND '2023-09-30'
	AND T6.tipoAusencia = 'V'
	AND T6.vigente = 1
	LEFT JOIN tDepartamento T7 ON T2.codDepto = T7.codDepto
WHERE
	T3.idEmpresa = 4
	AND T2.fechaIngreso <= '2023-09-30'
	AND T4.fechaInicio BETWEEN '2023-09-01'
	AND '2023-09-30'
GROUP BY
	T3.codEmpleado,
	T1.nombreEmpleado,
	T1.segundoNombre,
	T1.apellidoEmpleado,
	T1.segundoApellido,
	T1.apellidoCasada,
	T1.NIT,
	T1.noIGGS,
	T2.codDepto,
	T5.vacacion,
	T6.tipoAusencia,
	T6.codEmpleado,
	T6.fechaInicio,
	T2.fechaIngreso,
	T2.finContract,
	T2.idLiquidacionIGSS,
	T2.codCentroTrabajoIGSS,
	T2.codOcupacionIGSS
ORDER BY
	T1.nombreEmpleado,
	T1.segundoNombre