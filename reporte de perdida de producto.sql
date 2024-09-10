select 
idIngresoRecibo as id, table_4.nombre as descripcion_gasto, fecha as fecha_venta, fechaIngreso as fecha_ingreso, monto as total_gasto, table_1.empresa as codigo_empresa, table_3.nombre as nombre_empresa, table_1.tienda as codigo_tienda, table_2.tda_nombre as nombre_tienda, comentario, table_2.division
from tIngresoRecibo as table_1
join tTienda as table_2 on table_1.empresa = table_2.empresa and table_1.tienda = table_2.tienda
join tEmpresa as table_3 on table_1.empresa = table_3.empresa
join tTipoRecibo as table_4 on table_1.idTipoRecibo = table_4.idTipoRecibo
where table_1.idTipoRecibo in (9,19) and cast(fecha as date) between '2024-07-01' and '2024-08-11' and table_1.vigente = 1