use pinulito_nomina;

select 
    table_1.codEmpleado codigo_empleado,
    isnull(table_1.nombreEmpleado, '') + ' '  + isnull(table_1.segundoNombre, '') + ' '  + isnull(table_1.apellidoEmpleado, '') + ' '  + isnull(table_1.segundoApellido, '') nombre_empleado,
    case
        when table_2.finContract is null then '-'
        when table_2.finContract = '1900-01-01' then '-'
        else convert(varchar, table_2.finContract)
    end fecha_baja,
    case
        when table_2.finContract is null then 'ACTIVO'
        when table_2.finContract = '1900-01-01' then 'ACTIVO'
        else 'INACTIVO'
    end estado_empleado
from 
    tEmpleado table_1
    join tContrato table_2 on table_1.noContract = table_2.noContract
where
    table_1.codEmpleado in (
        0
    )