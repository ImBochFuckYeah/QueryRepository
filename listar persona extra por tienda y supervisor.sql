use pinulito_nomina;

-- SELECT
--     codigoPersonaExtra,
--     CASE 
-- 			WHEN segundoNombre IS NOT NULL AND segundoApellido IS NOT NULL
-- 			THEN  primerNombre+' '+segundoNombre+' '+primerApellido+' '+segundoApellido
-- 			ELSE
-- 				CASE
-- 					WHEN segundoNombre IS NULL AND segundoApellido IS NULL
-- 					THEN primerNombre+' '+primerApellido
-- 				END
-- 		END  nombreEmpleado,
--     DPI,
--     NIT,
--     [PINULITO_PDV].[dbo].[ObtenerTiendasPorCodigoPersonaExtra](idPersonaExtra) tiendas
-- FROM tPersonaExtra
-- WHERE vigente = 1

-- select * from tiendas

select 
    -- top 100 
    tda.nombre_empresa empresa,
    tda.nombre_tienda tienda,
    pex.codigoPersonaExtra codigo,
    RTRIM(LTRIM(
        pex.primerNombre + ' ' + 
        COALESCE(pex.segundoNombre + ' ', '') +
        pex.primerApellido + ' ' +
        COALESCE(pex.segundoApellido, '')
    )) AS nombre,
    tda.nombre_administrador as supervisor
from 
    [pinulito_pdv].[dbo].[tAsignacionTienda] ast
    join [pinulito_nomina].[dbo].[tPersonaExtra] pex on pex.idPersonaExtra = CAST(SUBSTRING(CAST(ast.codEmpleado AS VARCHAR), 4, 4) AS INT)
    join [pinulito_nomina].[dbo].[tiendas] tda on ast.empresa = tda.codigo_empresa and ast.tienda = tda.codigo_tienda
where 
    ast.vigente = 1 and pex.vigente = 1 and len(ast.codEmpleado) > 4