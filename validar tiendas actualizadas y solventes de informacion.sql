-- VER CUANTOS ACTUALIZARON
select * from PINULITO_PDV..tDispositivoTienda where versionApp = '6.0.18' and year(ultimaConexionPOS) = 2023

-- VER CUANTOS FALTAN POR ACTUALIZAR
select * from PINULITO_PDV..tDispositivoTienda where versionApp != '6.0.18' and year(ultimaConexionPOS) = 2023

-- consultar por tienda
select * from PINULITO_PDV..tTienda where tda_nombre like '%jutiapa 5%'

-- ver cuantas tiendas ya llegaron, por empresa
select DISTINCT(tienda) from PINULITO_PDV..tFacturaTemporalPos where empresa = '00001'

-- consultar cuantas facturas por empresa, tienda y fecha
select count(*) from PINULITO_PDV..tFacturaTemporalPos where tienda = '00112' and empresa = '00003' and convert(date,fechaHora)='2023-06-12'

-- consultar cuantas facturas por empresa, tienda y fecha [VER DETALLE]
select SUM(total) from PINULITO_PDV..tFacturaTemporalPos where empresa = '00003' and tienda = '00112' and convert(date,fechaHora)='2023-06-13'

-- consultar cuantas factura cargo una tienda
SELECT T.tienda, T.empresa, T.tda_nombre, (SELECT COUNT(*) FROM PINULITO_PDV..tFacturaTemporalPos F WHERE F.tienda = T.tienda AND F.empresa = T.empresa and convert(date, F.fechaHora) = '2023-06-12') AS TotalFacturas
FROM PINULITO_PDV..tTienda T where inactiva = 0 order by TotalFacturas asc

-- consultar tiendas actualizadas
SELECT T.tienda, T.empresa, T.tda_nombre,
       (SELECT COUNT(*) FROM PINULITO_PDV..tFacturaTemporalPos F
        WHERE F.tienda = T.tienda AND F.empresa = T.empresa and convert(date, F.fechaHora) = '2023-06-12') AS TotalFacturas
FROM PINULITO_PDV..tTienda T where inactiva = 0 and empresa not in(00015,00018) and T.tda_nombre like '%JUTIAPA 5%' order by TotalFacturas asc