with cte as (
    select empresa, tienda, codigoPrestamo from tPrestamosTienda where estado = 1
)

-- select * from tPrestamosTienda as cta join cte on cta.codigoPrestamo = cte.codigoPrestamo where estado = 2

update tPrestamosTienda 
set empresaEnvio = (select empresa from cte where cte.codigoPrestamo = tPrestamosTienda.codigoPrestamo),
tiendaEnvio = (select tienda from cte where cte.codigoPrestamo = tPrestamosTienda.codigoPrestamo) 
where tPrestamosTienda.estado = 2 and tPrestamosTienda.empresaEnvio is null and tPrestamosTienda.tiendaEnvio is null