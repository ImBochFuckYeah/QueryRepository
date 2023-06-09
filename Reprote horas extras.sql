SELECT T4.nombre AS empresa, T2.nombre AS tienda, T1.codigo, T1.empleado, T3.nombrePeriodo, hSimples as horasSimples, T1.sSimples as pagoHorasSimples, T1.hDobles as horasDobles, T1.sDobles pagoHorasDobles
	FROM tPlanilla T1
	INNER JOIN tDepartamento T2 ON T1.departamento=T2.codDepto
	INNER JOIN tPeriodo T3 ON T1.idPeriodo=T3.idPeriodo
	INNER JOIN tEmpresa T4 ON T1.idEmpresa=T4.codEmpresa
	WHERE T1.idEmpresa BETWEEN 1 AND 5 AND T3.fechaInicio BETWEEN '2022-08-01' AND '2022-10-15' and (T1.hSimples>0 or T1.hDobles>0)
	order by nombrePeriodo, empresa, tienda
