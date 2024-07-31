USE PINULITO_PDV;

SELECT * FROM tFacturaSemanal WHERE empresa = '00002' AND tienda = '00015' AND cast(fechaHora AS DATE) = '2024-06-14' AND (
    CHARINDEX('EFECTIVO', detallePago) > 0 
    AND CHARINDEX('EFECTIVO', detallePago, CHARINDEX('EFECTIVO', detallePago) + LEN('EFECTIVO')) > 0
);