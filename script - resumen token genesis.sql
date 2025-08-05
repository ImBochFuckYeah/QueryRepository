USE api_token_genesis;
-- 
SELECT v.serie,
descripcion = v.descripcionVale,
total_cupones = COUNT(*),
cupones_cajeados = SUM(CASE WHEN v.fechaCanje IS NOT NULL THEN 1 ELSE 0 END),
cupones_pendientes_de_caje = SUM(CASE WHEN v.fechaCanje IS NULL AND v.idApiToken IS NOT NULL THEN 1 ELSE 0 END),
cupones_disponibles = SUM(CASE WHEN v.fechaCanje IS NULL AND v.idApiToken IS NULL THEN 1 ELSE 0 END)
FROM [PINULITO_PDV].[dbo].[tValeExterno] AS v
JOIN series AS s ON v.serie = s.serie
LEFT JOIN token_additional_information AS t ON v.idApiToken = t.id
GROUP BY v.serie, v.descripcionVale;