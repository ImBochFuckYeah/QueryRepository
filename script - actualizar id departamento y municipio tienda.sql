USE PINULITO_PDV;
-- 
SELECT TOP 5 tda.idTienda, tda.empresa, tda.tienda, tda.tda_nombre, tda.idDepartamentoGeo, tda.idMunicipioIGSS, igss.idDepartamentoCentro, igss.idMunicipioCentro
FROM tTienda AS tda
JOIN [PINULITO_NOMINA].[dbo].[tDepartamento] AS dpt ON tda.empresa = LEFT(dpt.idPOS, 5) AND tda.tienda = RIGHT(dpt.idPOS, 5)
JOIN [PINULITO_NOMINA].[dbo].[tCentroIGSS] AS igss ON dpt.centroIGSS = igss.codigoCentroTrabajo AND dpt.codEmpresa = igss.codEmpresa
WHERE tda.idDepartamentoGeo IS NULL AND tda.idMunicipioIGSS IS NULL;
-- 
-- UPDATE tda
-- SET tda.idDepartamentoGeo = igss.idDepartamentoCentro, tda.idMunicipioIGSS = igss.idMunicipioCentro
-- FROM tTienda AS tda
-- JOIN [PINULITO_NOMINA].[dbo].[tDepartamento] AS dpt ON tda.empresa = LEFT(dpt.idPOS, 5) AND tda.tienda = RIGHT(dpt.idPOS, 5)
-- JOIN [PINULITO_NOMINA].[dbo].[tCentroIGSS] AS igss ON dpt.centroIGSS = igss.codigoCentroTrabajo AND dpt.codEmpresa = igss.codEmpresa
-- WHERE tda.idDepartamentoGeo IS NULL AND tda.idMunicipioIGSS IS NULL;