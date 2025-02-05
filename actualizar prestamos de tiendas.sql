-- USE PINULITO_PDV;
-- SELECT TOP 1 * FROM tPrestamosTienda WHERE codigoPrestamo = '7AJ8JD' AND estado = 1;
-- SELECT TOP 1 * FROM tPrestamosTienda WHERE codigoPrestamo = '7AJ8JD' AND estado = 2;
SELECT TOP 1 * FROM tPrestamosTienda WHERE codigoPrestamo = 'ANITPP' AND estado = 1;
SELECT TOP 1 * FROM tPrestamosTienda WHERE codigoPrestamo = 'ANITPP' AND estado = 2;

/* UPDATE [dbo].[tPrestamosTienda]
SET 
    empresa = empresaEnvio,
    tienda = tiendaEnvio,
    empresaEnvio = empresa,
    tiendaEnvio = tienda
WHERE 
    estado = 1; */

/* UPDATE t1
SET 
    t1.empresa = t2.empresaEnvio,
    t1.tienda = t2.tiendaEnvio
FROM [dbo].[tPrestamosTienda] t1
INNER JOIN [dbo].[tPrestamosTienda] t2 
    ON t1.codigoPrestamo = t2.codigoPrestamo
WHERE 
    t1.estado = 2 AND 
    t2.estado = 1; */