USE pinulito_nomina DECLARE @empleados AS TABLE (codEmpleado INT);

DECLARE @historial_contratos AS TABLE (
	codEmpleado VARCHAR(10),
	nombre VARCHAR(255),
	empresa VARCHAR(255),
	departamento VARCHAR(255),
	fecha_ingreso DATE,
	fecha_baja DATE,
	activo BIT
);

INSERT INTO
	@empleados (codEmpleado)
SELECT
	codEmpleado
FROM
	tContrato
WHERE
	activo = 1
	AND finContract IS NULL
	OR finContract = '1900-01-01'
INSERT INTO
	@historial_contratos (
		codEmpleado,
		nombre,
		empresa,
		departamento,
		fecha_ingreso,
		fecha_baja,
		activo
	)
SELECT
	t4.aliasCodigo,
	t4.nombreEmpleado + ' ' + t4.segundoNombre + ' ' + t4.apellidoEmpleado + ' ' + t4.segundoApellido + ' ' + ISNULL(t4.apellidoCasada, ''),
	t3.nombre,
	t2.nombre,
	t1.fechaIngreso,
	CASE
		WHEN t1.finContract IS NULL
		OR t1.finContract = '1900-01-01' THEN NULL
		ELSE t1.finContract
	END,
	t1.activo
FROM
	tContrato t1
	INNER JOIN tDepartamento t2 ON t1.codDepto = t2.codDepto
	INNER JOIN tEmpresa t3 ON t2.codEmpresa = t3.codEmpresa
	INNER JOIN tEmpleado t4 ON t1.codEmpleado = t4.codEmpleado
WHERE
	t1.codEmpleado IN (
		SELECT
			codEmpleado
		FROM
			@empleados
	)
	
SELECT
	*
FROM
	@historial_contratos
ORDER BY
	codEmpleado ASC