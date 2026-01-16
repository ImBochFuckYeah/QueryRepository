USE PINULITO_PDV;
-- 
GO
-- 
DECLARE @startDate VARCHAR(10) = '2025-08-17', @endDate VARCHAR(10) = '2025-08-24';
DECLARE @cols AS NVARCHAR(MAX), @query AS NVARCHAR(MAX);
-- 
WITH [days] AS (
    SELECT CAST(@startDate AS DATE) AS [day]
    UNION ALL
    SELECT DATEADD(DAY, 1, [day])
    FROM [days]
    WHERE DATEADD(DAY, 1, [day]) <= CAST(@endDate AS DATE)
)
-- 
SELECT
    @cols = STUFF(
        (
            SELECT ',' + QUOTENAME(FORMAT([day], 'dd'))
            FROM [days] FOR XML PATH(''),
                TYPE
        ).value('.', 'NVARCHAR(MAX)'),
        1,
        1,
        ''
    );
-- 
SET
    @query = 'SELECT *
    FROM (
        SELECT tienda = tda.tda_nombre,
        dia = FORMAT(tfs.fechaHora, ''dd''),
        intervalo = CONCAT(
            RIGHT(''00'' + CAST((DATEPART(HOUR, tfs.fechaHora) / 2) * 2 AS VARCHAR), 2),
            '':00-'',
            RIGHT(''00'' + CAST(((DATEPART(HOUR, tfs.fechaHora) / 2) * 2) + 2 AS VARCHAR), 2),
            '':00''
        ),
        pollos = (SUM(tfds.cantidad * artp.Quantity) / 7)
        FROM tFacturaSemanal AS tfs
        JOIN tFacturaDetalleSemanal AS tfds ON tfs.idFactura = tfds.idFactura
        JOIN tProductoPiezas AS artp ON tfds.sku = artp.FatherItemCode
        JOIN tTienda AS tda ON tfs.empresa = tda.empresa AND tfs.tienda = tda.tienda
        WHERE tda.reporteVentaPollos = 1 AND tfs.anulada = 0 AND CAST(tfs.fechaHora AS DATE) >= ''' + @startDate + ''' AND CAST(tfs.fechaHora AS DATE) <= ''' + @endDate + '''
        GROUP BY tda.tda_nombre, FORMAT(tfs.fechaHora, ''dd''), (DATEPART(HOUR, tfs.fechaHora) / 2)
    ) AS SourceData
    PIVOT (
        SUM (pollos)
        FOR dia IN (' + @cols + ')
    ) AS PivotTable';
-- 
EXEC sp_executesql @query;