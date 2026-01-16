USE PINULITO_PDV;
-- 
SELECT td.division,
ir.empresa,
ir.tienda,
td.tda_nombre,
ir.fechaIngreso,
ir.fecha AS fechaGasto,
'RECIBO SIN FACTURA' AS tipoGasto,
'N/A' AS nit,
'N/A' AS nombre,
NULL AS serie,
NULL AS numero,
NULL AS uuid,
tr.nombre AS descripcion,
ir.monto AS precio,
CAST(1 AS DECIMAL(5, 2)) AS cantidad,
ir.monto,
ir.comentario,
NULL AS numeroSAP,
ir.vigente AS estado
FROM tIngresoRecibo AS ir
JOIN tTipoRecibo AS tr ON ir.idTipoRecibo = tr.idTipoRecibo
JOIN tTienda AS td ON ir.empresa = td.empresa AND ir.tienda = td.tienda
WHERE CAST(fecha AS DATE) = CAST(GETDATE() AS DATE) AND ir.idTipoRecibo <> 10 
-- 
UNION 
-- 
SELECT td.division,
c.empresa,
c.tienda,
td.tda_nombre,
c.fechaIngreso,
c.fechaPago AS fechaGasto,
c.tipo AS tipoGasto,
c.nit,
c.nombre,
c.serie,
c.numero,
c.uuid,
cd.itemName AS descripcion,
cd.price AS precio,
cd.quantity AS cantidad,
(cd.price * quantity) AS monto,
c.comentario,
c.SAP AS numeroSAP,
c.vigente AS estado
FROM tCompra AS c
JOIN tCompraDetalle AS cd ON c.idCompra = cd.idCompra
JOIN tTienda AS td ON c.empresa = td.empresa AND c.tienda = td.tienda
WHERE CAST(c.fechaPago AS DATE) = CAST(GETDATE() AS DATE)
-- 
UNION
-- 
SELECT td.division,
ar.empresa,
ar.tienda,
td.tda_nombre,
ar.fecha AS fechaIngreso,
ar.fecha AS fechaGasto,
'ABONO DE RENTA' AS tipoGasto,
'N/A' AS nit,
'N/A' AS nombre,
NULL AS serie,
NULL AS numero,
NULL AS uuid,
CONCAT('RESERVA DE RENTA ', ar.mesRenta) AS descripcion,
ar.monto AS precio,
CAST(1 AS DECIMAL(5, 2)) AS cantidad,
ar.monto,
ar.comentario,
NULL AS numeroSAP,
ar.vigente AS estado
FROM tAbonoRenta ar
JOIN tTienda AS td ON ar.empresa = td.empresa AND ar.tienda = td.tienda
WHERE CAST(ar.fecha AS DATE) = CAST(GETDATE() AS DATE)
-- 
UNION
-- 
SELECT td.division,
iv.empresa,
iv.tienda,
td.tda_nombre,
CAST(iv.fechaHora AS DATE) AS fechaIngreso,
iv.fechaCompra AS fechaGasto,
'COMPRA DE VERDURA' AS tipoGasto,
'N/A' AS nit,
'N/A' AS nombre,
NULL AS serie,
NULL AS numero,
NULL AS uuid,
v.descripcion,
v.precio,
v.cantidad,
(v.cantidad * v.precio) AS monto,
iv.comentario,
NULL AS numeroSAP,
iv.vigente AS estado
FROM tIngresoVerdura iv
CROSS APPLY (VALUES
    ('CEBOLLA',   iv.cantCebolla,   iv.precioCebolla),
    ('PIMIENTO',  iv.cantPimiento,  iv.precioPimiento),
    ('REPOLLO',   iv.cantRepollo,   iv.precioRepollo),
    ('ZANAHORIA', iv.cantZanahoria, iv.precioZanahoria),
    ('LECHUGA',   iv.cantLechuga,   iv.precioLechuga),
    ('OTRA V.',     TRY_CAST(iv.cantOtros AS DECIMAL(12, 2)), iv.precioOtros)
) v (descripcion, cantidad, precio)
JOIN tTienda AS td ON iv.empresa = td.empresa AND iv.tienda = td.tienda
WHERE CAST(iv.fechaHora AS DATE) = CAST(GETDATE() AS DATE) AND v.cantidad > 0
-- 
UNION
-- 
SELECT td.division,
pe.empresa,
pe.tienda,
td.tda_nombre,
pe.fechaFactura AS fechaIngreso,
pe.fechaPago AS fechaGasto,
'PAGO DE ENERGIA ELECTRICA' AS tipoGasto,
pe.nit AS nit,
pe.empresaElectrica AS nombre,
NULL AS serie,
NULL AS numero,
NULLIF(pe.uuid, '') AS uuid,
CONCAT('PAGO DE CONTADOR NO: ', pe.nis) AS descripcion,
pe.montoPago AS precio,
CAST(1 AS DECIMAL(5, 2)) AS cantidad,
pe.montoPago AS monto,
pe.comentario,
NULL AS numeroSAP,
pe.vigente AS estado
FROM tPagoElectricidad pe
JOIN tTienda AS td ON pe.empresa = td.empresa AND pe.tienda = td.tienda
WHERE CAST(pe.fechaPago AS DATE) = CAST(GETDATE() AS DATE)
-- 
UNION
-- 
SELECT td.division,
ppe.empresa,
ppe.tienda,
td.tda_nombre,
CAST(ppe.fechaHora AS DATE) AS fechaIngreso,
ppe.fechaBoleta AS fechaGasto,
'PAGO PERSONA EXTRA' AS tipoGasto,
'N/A' AS nit,
'N/A' AS nombre,
NULL AS serie,
NULL AS numero,
NULL AS uuid,
CONCAT('PAGO A: ', codEmpleado, ' POR ', pped.horasPago, ' HORAS') AS descripcion,
pped.precioxHora AS precio,
CAST(1 AS DECIMAL(5, 2)) AS cantidad,
pped.totalDia AS monto,
comentario,
NULL AS numeroSAP,
ppe.vigente AS estado
FROM tPagoPersonaExtra AS ppe
JOIN tPagoPersonaExtraDetalle AS pped ON ppe.idPagoPersonaExtra = pped.idPagoPersonaExtra
JOIN tTienda AS td ON ppe.empresa = td.empresa AND ppe.tienda = td.tienda
WHERE CAST(ppe.fechaHora AS DATE) = CAST(GETDATE() AS DATE);