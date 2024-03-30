/* GENERAR NUMERO ALEATORIO PARA FIRMAR CONTINGENCIAS */

DECLARE @RandomNumber INT
SET @RandomNumber = CAST(RAND() * 1000000000 AS INT)

--SELECT @RandomNumber AS RandomNumber

/* ASIGNAR NUMEROS A FACTURAS (SIN NUMERO DE CONTINGENCIA) */

UPDATE tFacturaSemanal 
SET noContingencia = CAST(RAND(CHECKSUM(NEWID())) * 1000000000 AS INT), contingencia = 1, uuidFactura = NULL, fechaCertificacion = NULL
WHERE idFactura IN (
    18531495
)