use pinulito_nomina

select
    idEmpresa id_empresa,
    (
        select
        nombre
        from
        tEmpresa
        where
        tEmpresa.codEmpresa = tPlanilla.idEmpresa
    ) nombre_empresa,
    codEmpleado codigo_empleado,
    empleado nombre_empleado,
    idPeriodo id_periodo,
    (
        select
        nombrePeriodo
        from
        tPeriodo
        where
        tPeriodo.idPeriodo = tPlanilla.idPeriodo
    ) nombre_periodo,
    ahorro monto_cootragua
from 
    tplanilla
where
    codEmpleado in (4403)
    and ahorro > 0
order by
    codEmpleado