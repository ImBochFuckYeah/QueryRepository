USE PINULITO_NOMINA;
-- 
SELECT
SUBSTRING(t2.idPOS, 1, 5) as empresa,
SUBSTRING(t2.idPOS, 7, 5) as tienda,
t2.nombre,
isnull(T4.[PTV-001], 0) [PTV001], --POLLO GRANDE  TRADICIONAL.
isnull(T4.[PTV-002], 0) [PTV002], --POLLO GRANDE  PICANTE.
ISNULL(T4.[PTV-003], 0) + ISNULL(T4.[PTV-016], 0) AS [PTV003], --POLLO ESTANDAR TRADICIONAL.2 dias
isnull(T4.[PTV-004], 0) [PTV004], --POLLO ESTANDAR PICANTE
isnull(T4.[PTV-005], 0) [PTV005], --POLLO ESTANDAR ARTESANO
isnull(T4.[PTV-006], 0) [PTV006], --HIGADO (CORTESIA)
isnull(T4.[PTV-007], 0) [PTV007], --MOLLEJA
isnull(T4.[PTV-008], 0) [PTV008], --HIGADO
isnull(T4.[PTV-009], 0) [PTV009], --PATITAS
isnull(T4.[PTV-010], 0) [PTV010], --PESCUEZOS
isnull(T4.[PTV-011], 0) [PTV011], --CUADRILITOS
isnull(T4.[PTV-012], 0) [PTV012], --CUADRILITOS (CORTESIA)
isnull(T4.[PTV-013], 0) [PTV013], --ALITAS
isnull(T4.[P010171], 0) [P010171], --LASAÑA
isnull(T4.[PTV-015], 0) [PTV015], --PECHUGA SIN ALA
isnull(T4.[PTV-001], 0) [PTV001_], --POLLO GRANDE  TRADICIONAL.
isnull(T4.[PTV-002], 0) [PTV002_], --POLLO GRANDE  PICANTE.
isnull(T4.[PTV-003], 0) [PTV003_], --POLLO ESTANDAR TRADICIONAL.2 dias
isnull(T4.[PTV-004], 0) [PTV004_], --POLLO ESTANDAR PICANTE
isnull(T4.[PTV-005], 0) [PTV005_], --POLLO ESTANDAR ARTESANO
isnull(T4.[PTV-006], 0) [PTV006_], --HIGADO (CORTESIA)
isnull(T4.[PTV-007], 0) [PTV007_], --MOLLEJA
isnull(T4.[PTV-008], 0) [PTV008_], --HIGADO
isnull(T4.[PTV-009], 0) [PTV009_], --PATITAS
isnull(T4.[PTV-010], 0) [PTV010_], --PESCUEZOS
isnull(T4.[PTV-011], 0) [PTV011_], --CUADRILITOS
isnull(T4.[PTV-012], 0) [PTV012_], --CUADRILITOS (CORTESIA)
isnull(T4.[PTV-013], 0) [PTV013_], --ALITAS
isnull(T4.[P010171], 0) [P010171_], --LASAÑA
isnull(T4.[PTV-015], 0) [PTV015_], --PECHUGA SIN ALA
CASE WHEN T6.idruta IS NULL THEN 'NO ASIGNADA' ELSE 'ASIGNADA' END idruta
FROM tResponsableCentroCosto T1
JOIN tDepartamento T2 ON T1.codDepto = T2.codDepto
JOIN tEmpleado T3 ON T1.codEmpleado = T3.codEmpleado
LEFT JOIN [grupopinulito].[dbo].[tRutasEnvio] T4 ON T2.idPOS = T4.empresa + '-' + T4.tienda
LEFT JOIN [grupopinulito].[dbo].[tRutas] T6 ON T2.idPOS = T6.empresa + '-' + T6.tienda
WHERE
T1.codEmpleado = 96
AND T4.fecha = '20241218'
AND T1.vigente = 1
AND T2.codEmpresa IN (1, 2, 3, 4, 5, 19)
ORDER BY
T2.idPOS,
idruta