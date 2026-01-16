USE PINULITO_NOMINA;
GO

SELECT
	UPPER(epa.nombre) AS [SOCIEDAD],
	UPPER(dpo.nombre) AS [CENTRO DE COSTO],
	UPPER(dig.nombre) AS [DEPARTAMENTO],
	epo.aliasCodigo AS [CODIGO],
	UPPER(CONCAT(epo.nombreEmpleado, ' ', epo.segundoNombre, ' ', epo.apellidoEmpleado, ' ', epo.segundoApellido)) AS [NOMBRE],
	cto.fechaIngreso AS [FECHA DE INGRESO],
	NULLIF(cto.finContract, '19000101') AS [FECHA DE BAJA],
	ISNULL((
		SELECT pna.salarioMensual
		FROM [dbo].[tPlanilla] pna
		WHERE pna.codEmpleado = epo.codEmpleado
		AND pna.idPeriodo = 144
	), 0.00) AS [SALARIO NOMINAL 2025],
	cto.salarioOrdinario AS [SALARIO NOMINAL 2026],
	cto.bonifDecreto AS [BONIFICACION DECRETO]
FROM [dbo].[tEmpleado] epo
JOIN [dbo].[tContrato] cto ON epo.noContract = cto.noContract
	AND epo.codEmpleado = cto.codEmpleado
JOIN [dbo].[tDepartamento] dpo ON cto.codDepto = dpo.codDepto
JOIN [dbo].[tEmpresa] epa ON dpo.codEmpresa = epa.codEmpresa
JOIN [dbo].[tCentroIGSS] cig ON dpo.centroIGSS = cig.codigoCentroTrabajo
	AND epa.codEmpresa = cig.codEmpresa
JOIN [dbo].[tDepartamentoIGSS] dig ON cig.idDepartamentoCentro = dig.idDepartamentoIGSS
WHERE (
		cto.finContract IS NULL OR
		cto.finContract = '19000101' OR
		cto.finContract >= '20260101'
	)
ORDER BY [SOCIEDAD], [CENTRO DE COSTO];