-- VER CUANTOS ACTUALIZARON
select * from PINULITO_PDV..tDispositivoTienda where versionApp = '6.0.18' and year(ultimaConexionPOS) = 2023

-- VER CUANTOS FALTAN POR ACTUALIZAR
select * from PINULITO_PDV..tDispositivoTienda where versionApp != '6.0.18' and year(ultimaConexionPOS) = 2023

-- consultar por tienda
select * from PINULITO_PDV..tTienda where tda_nombre like '%justo%'

-- ver cuantas tiendas ya llegaron, por empresa
select DISTINCT(tienda) from PINULITO_PDV..tFacturaTemporalPos where empresa = '00001'

-- consultar cuantas facturas por empresa, tienda y fecha
select count(*) from PINULITO_PDV..tFacturaTemporalPos where tienda = '00071' and empresa = '00001' and convert(date,fechaHora)='2023-06-13'

-- consultar cuantas facturas por empresa, tienda y fecha [VER DETALLE]
select * from PINULITO_PDV..tFacturaTemporalPos where empresa = '00001' and tienda = '00071' and convert(date,fechaHora)='2023-06-13'