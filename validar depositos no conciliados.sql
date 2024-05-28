/* buscar deposito por numero de boleta */
select * from [pinulito_pdv].[dbo].[tDeposito] where noBoleta in ('88710196') and year(fechaboleta) = year(getdate())

/* buscar movimiento en el estado de cuenta */
select * from [pinulito_dividendos].[dbo].[tMovimientoBancario] where documento in ('88710196') and year(fecha) = year(getdate())

/* revertir conciliacion del movimiento en el estado de cuenta */
-- update [pinulito_dividendos].[dbo].[tMovimientoBancario] set conciliado = 0 where idMovimientoBancario = 660625