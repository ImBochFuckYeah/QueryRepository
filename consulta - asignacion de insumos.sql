USE PINULITO_PDV;
-- 
SELECT inv.idInventario AS [id], tda.empresa AS [codigo_empresa], tda.tienda AS [codigo_tienda], tda.tda_nombre AS [nombre_tienda], inv.ItemCode AS [item_code], inv.ItemName AS [item_name], FORMAT(inv.fechaActualizacion, 'dd/MM/yyyy') AS [fecha_registro]
FROM tIventarioTiendaInsumos AS inv
JOIN tTienda AS tda ON inv.empresa = tda.empresa AND inv.tienda = tda.tienda
WHERE inv.ItemCode = 'ME0041';