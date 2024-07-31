USE PINULITO_PDV;

-- SELECT empresa, COUNT(*) FROM vwContingenciasPendientesSemanal WHERE CAST(fechaHora AS DATE) BETWEEN CAST(DATEADD(DAY, -5, GETDATE()) AS DATE) AND CAST(DATEADD(DAY, -1, GETDATE()) AS DATE) GROUP BY empresa;

-- SELECT CAST(fecha AS DATE), COUNT(*) FROM vwContingenciasPendientesSemanal WHERE CAST(fechaHora AS DATE) BETWEEN CAST(DATEADD(DAY, -5, GETDATE()) AS DATE) AND CAST(DATEADD(DAY, -1, GETDATE()) AS DATE) GROUP BY CAST(fecha AS DATE);

-- SELECT CAST(DATEADD(DAY, -5, GETDATE()) AS DATE) [start_date], CAST(DATEADD(DAY, -1, GETDATE()) AS DATE) [end_date];

-- SELECT empresa, COUNT(*) FROM vwContingenciasPendientesSemanal WHERE CAST(fechaHora AS DATE) BETWEEN '2024-04-01' AND '2024-04-30' GROUP BY empresa;

SELECT * FROM vwContingenciasPendientesSemanal WHERE empresa = '00002' AND CAST(fechaHora AS DATE) BETWEEN '2024-06-08' AND '2024-06-09';

-- EXEC update_totales_cabecera @empresa = '00002', @FechaInicio = '2024-04-01', @FechaFin = '2024-04-18'