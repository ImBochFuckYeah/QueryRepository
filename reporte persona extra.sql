USE pinulito_nomina

SELECT
a.codigoPersonaExtra AS codigo,
CONCAT(a.primerApellido, CONCAT(' ', CONCAT(a.segundoNombre, CONCAT(' ', CONCAT(a.primerApellido, CONCAT(' ', a.segundoApellido)))))) as nombre,
a.DPI AS documento_identificacion,
STRING_AGG(c.nombre_tienda, ', ') AS tiendas_asignadas, 
c.division
FROM tPersonaExtra AS a
JOIN [pinulito_pdv].[dbo].[tAsignacionTienda] AS b ON a.idPersonaExtra = CAST(RIGHT(b.codEmpleado, 4) AS INT)
JOIN [pinulito_pdv].[dbo].[vwTiendas] AS c ON b.empresa = c.codigo_empresa AND b.tienda = c.codigo_tienda
WHERE a.vigente = 1 AND LEN(b.codEmpleado) > 4
GROUP BY a.codigoPersonaExtra, a.primerNombre, a.segundoNombre, a.primerApellido, a.segundoApellido, a.DPI, c.division