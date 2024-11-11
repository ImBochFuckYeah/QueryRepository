-- use pinulito_pdv

with cte_facturas as (
    select 
    cast(substring(observaciones, 21, 6) as int) as codigo,
    observaciones, count(*) as num
    from tFacturaSemanal 
    where cast(fechaHora as date) between '20240901' and '20240915' and anulada = 1 and observaciones like 'factura anulada%' group by observaciones
)

select b.nombreEmpleado + ' ' + b.apellidoEmpleado as nombre, a.* from cte_facturas as a left join [pinulito_nomina].[dbo].[tEmpleado] as b on a.codigo = b.codEmpleado