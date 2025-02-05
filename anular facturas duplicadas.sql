USE PINULITO_PDV;
DECLARE @fechaIni DATE = '2024-11-01' DECLARE @fechaFin DATE = '2024-11-30' DECLARE @idFactura int DECLARE @uuid nvarchar(36) DECLARE c CURSOR FOR
SELECT
    MIN(idFactura) idFactura,
    uuidFactura
FROM
    tFacturaSemanal
WHERE
    CONVERT(DATE, fechaHora) BETWEEN @fechaIni
    AND @fechaFin
    AND uuidFactura != '00000000-0000-0000-0000-000000000000'
    AND uuidFactura is not null
    AND anulada = 0
GROUP BY
    uuidFactura
HAVING
    COUNT(*) > 1 OPEN c FETCH NEXT
FROM
    c INTO @idFactura,
    @uuid WHILE @@FETCH_STATUS = 0 BEGIN
UPDATE
    tFacturaSemanal
SET
    anulada = 1
WHERE
    uuidFactura = @uuid
    AND idFactura != @idFactura FETCH NEXT
FROM
    c INTO @idFactura,
    @uuid
END CLOSE c DEALLOCATE c DECLARE @noContingencia nvarchar(12) DECLARE @idFacturaPos nvarchar(36) DECLARE @fechaHora datetime DECLARE c CURSOR FOR
SELECT
    MIN(idFactura) idFactura,
    noContingencia,
    idFacturaPOS,
    fechaHora
FROM
    tFacturaSemanal
WHERE
    CONVERT(DATE, fechaHora) BETWEEN @fechaIni
    AND @fechaFin
    AND contingencia = 1
    AND anulada = 0
GROUP BY
    noContingencia,
    idFacturaPOS,
    fechaHora
HAVING
    COUNT(*) > 1 OPEN c FETCH NEXT
FROM
    c INTO @idFactura,
    @noContingencia,
    @idFacturaPos,
    @fechaHora WHILE @@FETCH_STATUS = 0 BEGIN
UPDATE
    tFacturaSemanal
SET
    anulada = 1
WHERE
    noContingencia = @noContingencia
    AND idFacturaPOS = @idFacturaPos
    AND fechaHora = @fechaHora
    AND idFactura != @idFactura FETCH NEXT
FROM
    c INTO @idFactura,
    @noContingencia,
    @idFacturaPos,
    @fechaHora
END CLOSE c DEALLOCATE c