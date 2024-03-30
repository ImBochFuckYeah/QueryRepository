DECLARE @year INT = 2023, @company INT = 8;

SELECT
	T3.nit,
	T1.nombreEmpleado + ' ' + T1.apellidoEmpleado AS nombreEmpleado,
	T3.nombreComercial,
	T1.codEmpleado,
	UPPER(
		T1.nombreEmpleado + ' ' + T1.segundoNombre + ' ' + T1.apellidoEmpleado + ' ' + T1.segundoApellido + ' ' + ISNULL(T1.apellidoCasada, '')
	) AS empleado,
	(DATEDIFF(YEAR, T1.fechaNac, GETDATE())) AS edad,
	CASE
		WHEN T1.sexo = 'F' THEN 'FEMENINO'
		ELSE 'MASCULINO'
	END AS sexo,
	CASE
		WHEN T1.paisOrigen = 'Guatemala'
		AND T1.sexo = 'F' THEN 'GUATEMALTECA'
		ELSE 'GUATEMALTECO'
	END AS Nacionalidad,
	UPPER(T2.nomPuesto) AS profesion,
	T1.noIGGS,
	T1.noDoc,
	CONVERT(nvarchar, T2.fechaIngreso, 103) AS fechaInicio,
	CASE
		WHEN T2.finContract = '1900-01-01' THEN ''
		WHEN T2.finContract IS NULL THEN ''
		ELSE CONVERT(nvarchar, T2.finContract, 103)
	END AS 'fechaFinContrato',
	YEAR(T2.finContract) AS yearFinContrato,
	CONVERT(nvarchar, t2.fechaIngreso, 23) as fechaIngreso,
	CASE
		WHEN t2.finContract IS NULL
		OR T2.finContract = '1900-01-01' THEN case
			when YEAR(GETDATE()) = @year then CONVERT(nvarchar, GETDATE(), 23)
			else CAST(@year AS varchar) + '-12-31'
		end
		ELSE CONVERT(nvarchar, T2.finContract, 23)
	END finContract,
	T2.noContract
FROM
	tEmpleado T1
	INNER JOIN tContrato T2 ON T1.codEmpleado = T2.codEmpleado
	INNER JOIN tEmpresa T3 ON T2.codEmpresa = T3.codEmpresa
	INNER JOIN tDepartamento T4 ON T2.codDepto = T4.codDepto
	and T4.vigencia = 1
WHERE
	T2.codEmpresa = @company
	AND (
		YEAR(T2.fechaIngreso) <= @year
		AND (
			T2.finContract IS NULL
			OR YEAR(T2.finContract) = 1900
			OR YEAR(T2.finContract) >= @year
		)
	)
GROUP BY
	T3.nit,
	T3.nombreComercial,
	T1.codEmpleado,
	T1.nombreEmpleado,
	T1.segundoNombre,
	T1.apellidoEmpleado,
	T1.segundoApellido,
	T1.apellidoCasada,
	T1.fechaNac,
	T1.sexo,
	T1.paisOrigen,
	T2.nomPuesto,
	T1.noIGGS,
	T1.noDoc,
	T2.noContract,
	T2.fechaIngreso,
	T2.finContract
ORDER BY
	empleado