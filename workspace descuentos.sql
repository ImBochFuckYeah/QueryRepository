use pinulito_nomina
select * from tTipoDescuento where nombretipodescuento like '%cootragua%'
select * from tDescuento where codEmpleado = 4403
select * from tDescuentoRecurrente

/* 
DESCUENTOS COOPERATIVA 
- Ahorro: id = 6
- Aportaciones: id = 17
- Couta de ingreso: id = 29
- Prestamos: id = 30
¡ELIMINAR DESCUENTOS RECURRENTES DE TIPO AHORRO!
*/

-- Declarar variables para los parámetros
DECLARE @id_empresa INT = 8;
DECLARE @id_periodo INT = 83;

-- Ejecutar el procedimiento almacenado
EXEC get_reporte_quincena @id_empresa, @id_periodo;
EXEC CalcularTotalAhorro 4403;