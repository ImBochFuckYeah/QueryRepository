use pinulito_dividendos
use pinulito_nomina
--------------------------------
select * from templeado
--------------------------------
select * from [PINULITO_NOMINA].. tDepartamento where codDepto = 15
--------------------------------
select * from pinulito_dividendos..tUsuarioRol where codEmpleado = 4415

select * from trol
--------------------------------
select * from tmenurol

select * from tMenu
--------------------------------
SELECT t1.*,
  CASE WHEN t2.idMenu IS NOT NULL THEN 1 ELSE 0 END AS Activo
	FROM tMenu t1
		LEFT JOIN tMenuRol t2 ON t1.IdMenu = t2.IdMenu AND t2.idRol = 1
-----------------------------------------------------------------------
SELECT t1.*
	FROM tRol t1
		INNER JOIN tUsuarioRol t2 ON t2.idRol = t1.idRolMenu
			WHERE t2.codEmpleado = 4403

SELECT ROW_NUMBER() OVER (ORDER BY idRolMenu) AS numero, nombreRol AS nombre, vigente AS estado FROM tRol
----------------------------------------------------------------------------------------------------------
SELECT t1.aliasCodigo AS codigo, t3.nombre AS departamento, t1.nombreEmpleado+' '+ISNULL(t1.segundoNombre,'')+' '+ISNULL(t1.apellidoEmpleado,'')+' '+ISNULL(t1.segundoApellido,'')+' '+ISNULL(t1.apellidoCasada,'') AS nombre, t1.password, t4.vigente AS estado, t5.nombreRol AS rol, t1.codEmpleado
	FROM [PINULITO_NOMINA]..tEmpleado t1 
	INNER JOIN [PINULITO_NOMINA]..tContrato t2 ON t1.noContract = t2.noContract
	INNER JOIN [PINULITO_NOMINA]..tDepartamento t3 ON t2.codDepto = t3.codDepto
	LEFT JOIN [PINULITO_DIVIDENDOS]..tUsuarioRol t4 ON t1.codEmpleado = t4.codEmpleado
	LEFT JOIN [PINULITO_DIVIDENDOS]..tRol t5 ON t4.idRol = t5.idRolMenu
	WHERE t1.activo = 1 AND t3.codEmpresa = 00008 AND t3.codDepto = 1

SELECT t2.idUsuarioRol, t2.idRol, t2.vigente AS estado, t3.nombreRol
        FROM [PINULITO_NOMINA]..tEmpleado t1
        LEFT JOIN [PINULITO_DIVIDENDOS]..tusuarioRol t2 ON t1.codEmpleado = t2.codEmpleado
		LEFT JOIN [PINULITO_DIVIDENDOS].. trol t3 ON t2.idRol = t3.idRolMenu
        WHERE t1.codEmpleado = 4403

SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS valid
FROM PINULITO_DIVIDENDOS..tUsuarioRol
WHERE codEmpleado = 4415
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT t1.* 
FROM tMenu t1
INNER JOIN tMenuRol t2 ON t1.idMenu = t2.idMenu
WHERE t2.idRol = 1 
--------------------------------------------------------
SELECT * FROM tMenu WHERE idPadre = 0