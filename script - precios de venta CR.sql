USE DB_25_CR_PINULITO;
-- 
SELECT ItemCode, ItemName
FROM OITM
WHERE ItemCode LIKE 'PTE%';
-- 
SELECT 
P.ItemCode AS CodigoArticulo,
I.ItemName AS NombreArticulo,
P.Price AS Precio,
((P.Price * 100) / 113) AS PrecioSinImpuesto,
P.PriceList AS ListaPrecio,
L.ListName AS NombreListaPrecio,
P.Currency AS Moneda
FROM ITM1 P -- Precios por lista
JOIN OITM I ON P.ItemCode = I.ItemCode -- Artículos
JOIN OPLN L ON P.PriceList = L.ListNum -- Listas de precios
WHERE P.PriceList = 12 AND I.ItemCode LIKE 'PTE%' -- Cambia este valor por el número de lista que necesites
ORDER BY I.ItemCode;