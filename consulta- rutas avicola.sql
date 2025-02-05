USE grupopinulito;
-- 
SELECT t1.idruta AS [#], t1.nombre AS [ruta], t2.cede, t3.empresa, t3.tienda, t3.tda_nombre AS [nombre_tienda], t3.division
FROM tRutas AS t1
JOIN tListaRutas AS t2 ON t1.idruta = t2.idlruta
JOIN [PINULITO_PDV].[dbo].[tTienda] AS t3 ON t1.empresa = t3.empresa AND t1.tienda = t3.tienda
WHERE t3.inactiva = 0
ORDER BY t1.idruta;