/* buscar deposito por numero de boleta */
select * from [pinulito_pdv].[dbo].[tDeposito] where noBoleta in ('40551674') and year(fechaboleta) = year(getdate())

/* revertir conciliacion del deposito */
-- update [pinulito_pdv].[dbo].[tDeposito] set idMovimientoBancario = null, estado = 'NO CONCILIADO', usuarioConciliacion = null, fechaHoraConciliacion = null where idDeposito = 919970

/* buscar movimiento en el estado de cuenta */
select * from [pinulito_dividendos].[dbo].[tMovimientoBancario] where documento in ('40551674') and year(fecha) = year(getdate())

/* revertir conciliacion del movimiento en el estado de cuenta */
-- update [pinulito_dividendos].[dbo].[tMovimientoBancario] set conciliado = 0 where idMovimientoBancario = 709559