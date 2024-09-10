use pinulito_nomina

with rdeptos as (
    select
    t2.*
    from tDepartamento as t1
    join tResponsableCentroCosto as t2 on t2.codDepto = t1.codDepto and t2.vigente = 1
    where t1.codEmpresa in (1,2,3,4,5) and t1.vigencia = 1
)

select
rdeptos.*
from rdeptos
join tEmpleado as  emp on rdeptos.codEmpleado = emp.codEmpleado
where emp.activo = 0