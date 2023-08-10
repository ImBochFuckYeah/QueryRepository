USE 
	PINULITO_PDV
SELECT
	CASE WHEN cab.canal = 'POS-GAS' OR cab.canal = 'POS-TIENDA' THEN 'GASOLINERA' ELSE 'CONTABILIDAD' END AS generadoPor,
	emp.nombre AS empresa,
	tda.tda_nombre AS tienda,
	cab.nit,
	cab.nombre AS nombre_cliente,
	det.descripcion,
	CONVERT(varchar, cab.fechaHora, 103) AS fecha,
	CONVERT(varchar, cab.fechaHora, 108) AS hora,
	cab.uuidFactura,
	det.cantidad,
	det.precio,
	det.total
FROM
	tfacturasemanal AS cab
	INNER JOIN tfacturadetallesemanal AS det ON cab.idfactura = det.idfactura
	INNER JOIN ttienda AS tda ON cab.empresa = tda.empresa AND cab.tienda = tda.tienda
	INNER JOIN tempresa AS emp ON cab.empresa = emp.empresa
WHERE
	cab.empresa = '00015'
	AND CONVERT(date, cab.fechahora) BETWEEN '2023-07-01' AND '2023-07-31';