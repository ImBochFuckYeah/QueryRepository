USE PINULITO_PDV;
GO

--SELECT idTienda, empresa, tienda, tda_nombre, division
--FROM tTienda
--WHERE idTienda IN (289,49,43,15,469,541,301);

SELECT [TIENDA],
	[06:00 AM],
	[07:00 AM],
	[08:00 AM],
	[09:00 AM],
	[10:00 AM],
	[11:00 AM],
	[12:00 PM],
	[01:00 PM],
	[02:00 PM],
	[03:00 PM],
	[04:00 PM],
	[05:00 PM],
	[06:00 PM],
	[07:00 PM],
	[08:00 PM],
	[09:00 PM],
	[10:00 PM],
	[11:00 PM]
FROM (
	SELECT td.tda_nombre AS [TIENDA],
	FORMAT(fs.fechaHora, 'hh:00 tt') AS [HORA],
	COUNT(*) AS [FACTURAS]
	FROM tFacturaSemanal fs
	JOIN tTienda td ON fs.empresa = td.empresa AND fs.tienda = td.tienda
	WHERE fs.anulada = 0
		AND TRY_CAST(fs.fechaHora AS DATE) >= '2025-09-01'
		AND TRY_CAST(fs.fechaHora AS DATE) <= '2025-09-30'
		AND td.idTienda IN (289,49,43,15,469,541,301)
	GROUP BY td.tda_nombre, FORMAT(fs.fechaHora, 'hh:00 tt')
) AS SourceData
PIVOT (
	SUM([FACTURAS])
	FOR [HORA] IN (
		[09:00 PM],
		[08:00 AM],
		[07:00 PM],
		[11:00 PM],
		[05:00 PM],
		[08:00 PM],
		[06:00 PM],
		[11:00 AM],
		[02:00 PM],
		[10:00 AM],
		[03:00 PM],
		[06:00 AM],
		[10:00 PM],
		[04:00 PM],
		[09:00 AM],
		[01:00 PM],
		[12:00 PM],
		[07:00 AM]
	)
) AS PivotResults;