USE PINULITO_PDV;
-- 
GO
-- 
CREATE VIEW [dbo].[vwDwhSupervisores] AS
SELECT e.aliasCodigo AS CodSupervisor,
CONCAT(e.nombreEmpleado, ' ', e.segundoNombre, ' ', e.apellidoEmpleado, ' ', e.segundoApellido) AS NomSupervisor,
ISNULL(t.tda_nombre, '') AS NomTda,
TRY_CAST(t.tienda AS INT) AS CodTda
FROM [PINULITO_NOMINA].[dbo].[tResponsableCentroCosto] rc
JOIN [PINULITO_NOMINA].[dbo].[tEmpleado] e ON rc.codEmpleado = e.codEmpleado
JOIN [PINULITO_NOMINA].[dbo].[tDepartamento] d ON rc.codDepto = d.codDepto
JOIN [PINULITO_PDV].[dbo].[tTienda] t ON LEFT(d.idPOS, 5) = t.empresa AND RIGHT(d.idPOS, 5) = t.tienda
WHERE rc.vigente = 1 AND e.activo = 1
GROUP BY e.aliasCodigo, e.nombreEmpleado, e.segundoNombre, e.apellidoEmpleado, e.segundoApellido, t.tda_nombre, TRY_CAST(t.tienda AS INT);
-- 
CREATE VIEW [dbo].[vwDwhTiendas] AS
SELECT TRY_CAST(empresa AS INT) AS CodEmp,
TRY_CAST(tienda AS INT) AS CodTda,
ISNULL(tda_nombre, '') AS tda_nombre,
ISNULL(departamento, '') AS departamento,
idSupervisor,
ISNULL(clienteSAP, '') AS clienteSAP,
ISNULL(division, 0) AS division,
altitudGps,
latitudGps
FROM [PINULITO_PDV].[dbo].[tTienda]
WHERE inactiva = 0 AND TRY_CAST(empresa AS INT) BETWEEN 1 AND 7;
-- 
CREATE VIEW [dbo].[vwDwhArticulos] AS
SELECT ItemCode AS CodItem,
ItemName AS NomItem,
SWW AS CodPOS
FROM [DB_22_CORPORACION].[dbo].[OITM]
WHERE LEFT(ItemCode, 2) NOT IN ('AF','GA', 'GT',',RA','PN','UC','UL','RA','PU', 'RM');
-- 
CREATE VIEW [dbo].[vwDwhDatos] AS
SELECT TRY_CAST(fs.empresa AS INT) AS CodEmp,
FORMAT(fs.fechaHora, 'yyyy-MM-dd') AS Fecha,
TRY_CAST(fs.tienda AS INT) AS CodTda,
ISNULL(t.tda_nombre, '') AS NomTda,
mp.ChildItemCode AS CodItem,
'A' AS Semana,
ISNULL(t.division, 0) AS Divi,
ISNULL(SUM(fds.cantidad * mp.Quantity), 0) AS Cantidad,
FORMAT(fs.fechaHora, 'dd') AS Dia
FROM [PINULITO_PDV].[dbo].[tFacturaSemanal] fs
JOIN [PINULITO_PDV].[dbo].[tTienda] t ON fs.empresa = t.empresa AND fs.tienda = t.tienda
JOIN [PINULITO_PDV].[dbo].[tFacturaDetalleSemanal] fds ON fs.idFactura = fds.idFactura
JOIN [PINULITO_PDV].[dbo].[tMaterialesProducto] mp ON fds.sku = mp.OldItemCode
WHERE fs.anulada = 0 AND TRY_CAST(fs.fechaHora AS DATE) = TRY_CAST(GETDATE() AS DATE) AND TRY_CAST(fs.empresa AS INT) BETWEEN 1 AND 7
GROUP BY TRY_CAST(fs.empresa AS INT), FORMAT(fs.fechaHora, 'yyyy-MM-dd'), TRY_CAST(fs.tienda AS INT), t.tda_nombre, mp.ChildItemCode, t.division, FORMAT(fs.fechaHora, 'dd');
-- 
CREATE VIEW [dbo].[vwInfocorpRutaAvigua] AS
SELECT ISNULL(idruta, 0) AS idruta,
ISNULL(empresa, '') AS empresa,
ISNULL(tienda, '') AS tienda,
FORMAT(fecha, 'yyyy-MM-dd') AS fecha,
ISNULL(Origen, '') AS Origen,
ISNULL(Serie, '') AS Serie,
ISNULL(IdVehiculo, '') AS IdVehiculo,
ISNULL(Piloto, '') AS Piloto,
ISNULL(Despachador, '') AS Despachador,
ISNULL(idenvio, 0) AS idenvio,
numSAP,
sku,
cantidad
FROM [grupopinulito].[dbo].[tRutasEnvio]
UNPIVOT (
    cantidad FOR sku IN (
        [PTV-001],
        [PTV-002],
        [PTV-003],
        [PTV-004],
        [PTV-005],
        [PTV-006],
        [PTV-007],
        [PTV-008],
        [PTV-009],
        [PTV-010],
        [PTV-011],
        [PTV-012],
        [PTV-013],
        [P010171],
        [PTV-015],
        [PTV-016],
        [PTV-041],
        [PTV-042]
    )
) AS unpvt
WHERE fecha = TRY_CAST(GETDATE() AS DATE) AND cantidad > 0;
--
CREATE VIEW [dbo].[vwPosEncabezadoVenta] AS
SELECT idFactura,
ISNULL(empresa, '') AS empresa,
ISNULL(tienda, '') AS tienda,
serie,
numero,
uuidFactura,
ISNULL(canal, '') AS canal,
nit AS nit_receptor,
ISNULL(total, 0) AS total_con_iva,
FORMAT(ISNULL(fechaHora, GETDATE()), 'yyyy-MM-dd') AS fecha_emision,
uuidAnulacion,
FORMAT(TRY_CAST(fechaAnulacion AS DATE), 'yyyy-MM-dd') AS fecha_anulacion,
dispositivoUpdate AS dispositivo,
numSAP AS numero_documento_venta_sap,
detallePago,
sincronizado,
anulada,
indendificador
FROM [PINULITO_PDV].[dbo].[tFacturaSemanal]
WHERE TRY_CAST(fechaHora AS DATE) = TRY_CAST(GETDATE() AS DATE) AND TRY_CAST(empresa AS INT) BETWEEN 1 AND 7;
-- 
CREATE VIEW [dbo].[vwPosDetalleVenta] AS
SELECT fds.idFacturaDetalle,
fds.idFactura,
ISNULL(fds.cantidad, 0) AS cantidad,
ISNULL(fds.sku, '') AS sku,
ISNULL(fds.descripcion, '') AS descripcion,
ISNULL(fds.precio, 0) AS precio,
ISNULL(fds.total, 0) AS total,
ISNULL(fds.descuento, 0) AS descuento
FROM [PINULITO_PDV].[dbo].[tFacturaSemanal] fs
JOIN [PINULITO_PDV].[dbo].[tFacturaDetalleSemanal] fds ON fs.idFactura = fds.idFactura
WHERE TRY_CAST(fs.fechaHora AS DATE) = TRY_CAST(GETDATE() AS DATE) AND TRY_CAST(empresa AS INT) BETWEEN 1 AND 7;
-- 
CREATE VIEW [dbo].[vwPosTienda] AS
SELECT t.idTienda,
ISNULL(t.empresa, '') AS empresa,
ISNULL(t.tienda, '') AS tienda,
ISNULL(t.tda_nombre, '') AS tda_nombre,
ISNULL(t.direccion, '') AS direccion,
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
ISNULL(t.division, 0) AS division,
rc.codEmpleado
FROM [PINULITO_NOMINA].[dbo].[tResponsableCentroCosto] rc
JOIN [PINULITO_NOMINA].[dbo].[tDepartamento] d ON rc.codDepto = d.codDepto
JOIN [PINULITO_PDV].[dbo].[tTienda] t ON LEFT(d.idPOS, 5) = t.empresa AND RIGHT(d.idPOS, 5) = t.tienda
WHERE rc.vigente = 1;
-- 
CREATE VIEW [dbo].[vwPosSupervisor] AS
SELECT ep.codEmpleado,
ISNULL(ep.aliasCodigo, '') AS aliasCodigo,
nombreEmpleado = CONCAT(ep.nombreEmpleado, ' ', ep.segundoNombre, ' ', ep.apellidoEmpleado, ' ', ep.segundoApellido),
ISNULL(ep.sexo, '') AS sexo,
ISNULL(ep.noDoc, '') AS noDoc,
ep.noTel,
ISNULL(td.division, 0) AS division
FROM [PINULITO_NOMINA].[dbo].[tResponsableCentroCosto] AS rc
JOIN [PINULITO_NOMINA].[dbo].[tDepartamento] AS dp ON rc.codDepto = dp.codDepto
JOIN [PINULITO_NOMINA].[dbo].[tEmpleado] AS ep ON rc.codEmpleado = ep.codEmpleado
JOIN [PINULITO_PDV].[dbo].[tTienda] AS td ON LEFT(dp.idPOS, 5) = td.empresa
AND RIGHT(dp.idPOS, 5) = td.tienda
WHERE rc.vigente = 1
AND ep.activo = 1
GROUP BY ep.codEmpleado,
ep.aliasCodigo,
ep.nombreEmpleado,
ep.segundoNombre,
ep.apellidoEmpleado,
ep.segundoApellido,
ep.sexo,
ep.noDoc,
ep.noTel,
td.division;
-- ... CREATE VIEW AS vwPosEntradaMercancia, CREATE VIEW AS vwPosGastoTienda, CREATE VIEW AS vwDividendosRutaCorporm