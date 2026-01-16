-- pos.tienda: sincronizar semanalmente (domingo)
SELECT t.idTienda,
t.empresa,
t.tienda,
t.tda_nombre,
t.direccion,
t.altitudGps,
t.latitudGps,
t.celular,
t.departamento,
t.municipio,
t.establecimiento,
t.idSupervisor,
t.costingCode,
t.whsCode,
t.clienteSAP,
t.division,
rc.codEmpleado
FROM [PINULITO_NOMINA].[dbo].[tResponsableCentroCosto] rc
JOIN [PINULITO_NOMINA].[dbo].[tDepartamento] d ON rc.codDepto = d.codDepto
JOIN [PINULITO_PDV].[dbo].[tTienda] t ON LEFT(d.idPOS, 5) = t.empresa AND RIGHT(d.idPOS, 5) = t.tienda
WHERE rc.vigente = 1;
-- pos.supervisor: sincronizar semanalmente (domingo)
SELECT e.aliasCodigo,
e.codEmpleado,
nombreEmpleado = CONCAT(e.nombreEmpleado, ' ', e.segundoNombre, ' ', e.apellidoEmpleado, ' ', e.segundoApellido),
e.sexo,
e.noDoc,
e.noTel
FROM [PINULITO_NOMINA].[dbo].[tResponsableCentroCosto] rc
JOIN [PINULITO_NOMINA].[dbo].[tEmpleado] e ON rc.codEmpleado = e.codEmpleado
WHERE rc.vigente = 1
GROUP BY e.aliasCodigo, e.codEmpleado, e.nombreEmpleado, e.segundoNombre, e.apellidoEmpleado, e.segundoApellido, e.sexo, e.noDoc, e.noTel;
-- pos.venta_encabezado: sincronizar diariamente
SELECT TOP 100 idFactura,
empresa,
tienda,
serie,
numero,
uuidFactura,
canal,
nit AS nit_receptor,
total AS total_con_iva,
FORMAT(fechaHora, 'yyyy-MM-dd') AS fecha_emision,
uuidAnulacion,
fechaAnulacion AS fecha_anulacion,
dispositivoUpdate AS dispositivo,
numSAP AS numero_documento_venta_sap,
detallePago,
sincronizado,
anulada,
indendificador
FROM [PINULITO_PDV].[dbo].[tFacturaSemanal]
WHERE CAST(fechaHora AS DATE) = '20250901' AND CAST(empresa AS INT) BETWEEN 1 AND 7;
-- pos.venta_detalle: sincronizar diariamente
SELECT fds.idFacturaDetalle, fds.idFactura, fds.cantidad, fds.sku, fds.descripcion, fds.precio, fds.total, fds.descuento
FROM [PINULITO_PDV].[dbo].[tFacturaSemanal] fs
JOIN [PINULITO_PDV].[dbo].[tFacturaDetalleSemanal] fds ON fs.idFactura = fds.idFactura
WHERE CAST(fs.fechaHora AS DATE) = '20250901' AND CAST(empresa AS INT) BETWEEN 1 AND 7;
-- pos.material sincronizar semanalmente (domingo)
SELECT TOP 1 FatherItemCode, FatherItemName, OldItemCode, ChildItemCode, ChildItemName, Quantity
FROM [PINULITO_PDV].[dbo].[tMaterialesProducto];
-- pos.division: sincronizar semanalmente (domingo)
SELECT id_division, nombre_division
FROM [PINULITO_PDV].[dbo].[tDivisiones];
-- pos.metas: sincronizar semanalmente (domingo)
--  dias 1, 2, 3 de septiembre