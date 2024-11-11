-- use pinulito_pdv

with cte_pe_extra as (
    select idMarcajeExtra, empresa, tienda, alias, TRY_CAST(RIGHT(codEmpleado, 4) AS INT) as idPersonaExtra, FORMAT(fecha, 'dd/MM/yyyy') as fecha, LEFT(TRY_CAST(horaEntrada AS VARCHAR), 5) AS horaEntrada, LEFT(TRY_CAST(horaSalida AS VARCHAR), 5) AS horaSalida, horasTrabajadas, idPagoPersonaExtra
    from tMarcaje
    where fecha between '20240916' and '20240916' and vigente = 1 and len(codEmpleado) > 4
)

select 
a.idMarcajeExtra as [id_marcaje],
b.nombre_tienda,
a.alias as [codigo_pe],
concat(c.primerNombre, concat(' ', concat(c.segundoNombre, concat(' ', concat(c.primerApellido, concat(' ', c.segundoApellido)))))) as [nombre_pe],
c.dpi as [numero_indentificacion_pe],
a.fecha as fecha,
isnull(a.horaSalida, '-') as [hora_e],
isnull(a.horaSalida, '-') as [hora_s],
isnull(datediff(hour, horaEntrada, horaSalida), 0) as [total_horas],
isnull(a.idPagoPersonaExtra, 0) as [numero_pago_pe],
isnull(d.monto, 0) as [total_pago_pe]
from cte_pe_extra as a
join vwTiendas as b on a.empresa = b.codigo_empresa and a.tienda = b.codigo_tienda
join [pinulito_nomina].[dbo].[tPersonaExtra] as c on a.idPersonaExtra = c.idPersonaExtra
left join tPagoPersonaExtra as d on a.idPagoPersonaExtra = d.idPagoPersonaExtra
where a.idPersonaExtra <> 365