---- PROGRAMA GENERA ENCABEZADO DE FACTURAS DE VENTAS DEL POS
---- BORIS COLOMA
---- GUAT. 22 ABRIL 2024
----------------------------------------------------
USE PINULITO_PDV;
 
--- VARIABLES
DECLARE @FechaIni	DATE;
DECLARE @FechaFin	DATE;
DECLARE @Empresa	Nvarchar(05);
DECLARE @Tienda		Nvarchar(05);
 
--- VALORES VARIABLES
SET @FechaIni = '2025-12-01'
SET @FechaFin = '2025-12-31'
SET @Empresa  = '00003'
-- SET @Tienda   = '00002'
 
--- CREACIÓN TABLE TEMPORAL
CREATE TABLE #tmp_invoices (
	idFact		NVARCHAR(15),
	Empresa		NVARCHAR(05),
	CodTda		NVARCHAR(05),
	NomTda		NVARCHAR(150),
	NitClie		NVARCHAR(15),
	NomClie		NVARCHAR(150),
	ConFact		NVARCHAR(01),
	NumCont		NVARCHAR(15),
	SerFact		NVARCHAR(15),
	NumFact		NVARCHAR(15),
	UidFact		NVARCHAR(50),
	FecFact		DATE,
	CerFact		NVARCHAR(25),
	TotFact		NUMERIC(12,2),
	EstFact		NVARCHAR(01),
	TotValI		NUMERIC(12,2),
	SerVale		NVARCHAR(25), 
	idUnico		NVARCHAR(65),
	TotDet		NUMERIC(12,2)		
)
 
--- DATOS DE LA FACTURA
INSERT INTO #tmp_invoices (idFact, Empresa, CodTda, NomTda, NitClie, NomClie, ConFact, NumCont, SerFact, NumFact, UidFact, FecFact, CerFact, TotFact, EstFact, idUnico, TotDet)
SELECT 
T1.idfactura, 
T1.empresa,
T1.tienda,
T2.tda_nombre,
T1.nit,
T1.nombre,
T1.contingencia,
T1.noContingencia,
T1.serie,
T1.numero,
T1.uuidFactura,
T1.fechaHora as FechaFactura, 
CONVERT(DATE, T1.fechaCertificacion),
T1.total, 
T1.anulada, 
T1.indendificador, 
SUM((T3.cantidad * T3.precio) - T3.descuento) Total
FROM tFacturaSemanal T1 JOIN tTienda T2 ON T1.empresa = T2.empresa AND T1.tienda = T2.tienda
JOIN tFacturaDetalleSemanal T3 ON T1.idFactura = T3.idFactura
WHERE CONVERT(date, T1.fechaHora) BETWEEN @FechaIni AND @FechaFin AND T1.anulada = 0 AND T1.empresa = @Empresa AND T1.fechaCertificacion <> 'NULL' -- AND T1.tienda = @Tienda	
GROUP BY T1.idfactura, T1.empresa, T1.tienda, T2.tda_nombre, T1.nit, T1.nombre, T1.contingencia, T1.noContingencia, T1.serie, T1.numero, T1.uuidFactura, T1.fechaHora, T1.total, T1.anulada, T1.indendificador, T1.fechaCertificacion
ORDER BY T1.fechaHora
 
--- VALES INTERNOS CANJEADOS
-- INSERT INTO #tmp_invoices (Empresa, Tienda, FecFact, CerFact, TotValI)
-- SELECT empresaCanje, tiendaCanje, CONVERT(date, fechaCanje), CONVERT(varchar, fechaCanje,25), montoTotal
-- FROM tValeComida 
-- WHERE CONVERT(date, fechaCanje) BETWEEN @FechaIni AND @FechaFin AND empresaCanje = @Empresa AND tiendaCanje = @Tienda
-- AND tipoVale = '2'
 
--- VALES COMIDA EXTERNOS
-- INSERT INTO #tmp_invoices (Empresa, Tienda, CerFact, TotValI, SerVale)
-- SELECT empresaCanje, tiendaCanje, CONVERT(nvarchar, fechaCanje,25), montoTotal, serie ---, descripcionVale
-- FROM tValeExterno
-- WHERE CONVERT(DATE, fechaCanje) BETWEEN @FechaIni AND @FechaFin AND empresaCanje = @Empresa AND tiendaCanje = @Tienda
 
--- DATOS TABLE TEMPORAL
SELECT * FROM #tmp_invoices
ORDER BY CodTda, idFact --, CerFact, FecFact
 
--- BORRAR TABLA TEMPORAL
DROP TABLE #tmp_invoices