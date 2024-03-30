use pinulito_nomina;

select idEmpresa id_empresa, (
    select
        nombre
    from
        tEmpresa
    where
    tEmpresa.codEmpresa = tPlanilla.idEmpresa
) nombre_empresa, codEmpleado codigo_empleado, empleado nombre_empleado, idPeriodo id_periodo,
    (
    select
        nombrePeriodo
    from
        tPeriodo
    where
    tPeriodo.idPeriodo = tPlanilla.idPeriodo
) nombre_periodo, ahorro monto_cootragua
from tPlanilla
where idperiodo <= 93 and codempleado in (0) and ahorro > 0
order by idEmpresa, codEmpleado, idPeriodo;