use pinulito_pdv

select 
    codEmpleado codigo_empleado,
    (
        select 
        nombreEmpleado + ' ' + segundoApellido
        from 
        [PINULITO_NOMINA]..tEmpleado
        where 
        tEmpleado.codEmpleado = tValeComida.codEmpleado
    ) nombre_empleado,
    motivo motivo_vale,
    montoTotal monto_vale,
    format(fechaCrea, 'yyyy/MM/dd hh:mm tt') fecha_creacion_vale,
    (
        select 
        nombreEmpleado + ' ' + apellidoEmpleado
        from 
        [PINULITO_NOMINA]..tEmpleado
        where 
        tEmpleado.codEmpleado = tValeComida.creadoPor
    ) creado_por,
    (
        select 
        nombreEmpleado + ' ' + apellidoEmpleado
        from 
        [PINULITO_NOMINA]..tEmpleado
        where 
        tEmpleado.codEmpleado = tValeComida.autorizadoPor
    ) autorizado_por,
    isnull(

        (
            select
            tda_nombre
            from
            tTienda
            where
            tTienda.empresa = tValeComida.empresaCanje
            and tTienda.tienda = tValeComida.tiendaCanje
        ), 'SIN CANJEAR'
    ) tienda_canejada,
    isnull(convert(varchar, format(fechaCanje, 'yyyy/MM/dd hh:mm tt')), 'SIN CANJEAR') fecha_canjeada
from 
    tvalecomida 
where 
    autorizadoPor = 177
    /*
    codEmpleado in (
        select 
        codEmpleado
        from 
        [PINULITO_NOMINA]..tContrato 
        where 
        coddepto = 610 
        and (finContract is null or finContract = '1900-01-01')
        and activo = 1
        group by 
        codEmpleado
    )
    */
    and year(fechaCrea) = year(GETDATE())
    and month(fechaCrea) >= 10
order by fechaCrea desc