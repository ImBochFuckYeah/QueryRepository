use pinulito_nomina;

select * from tAusencia where idAusencia = 5027;

select * from tVacacion where idAusencia = 5027;

select * from tVacacionDetalle where idVacacion = 3463;

/* select * from tPeriodo where year(fechaInicio) = 2024 and MONTH(fechaInicio) in (2, 3, 4) */

------------------------------------------------------------------------------------------

select 
    MONTH(tPeriodo.fechaFin) mes,
    SUM(tPlanilla.sSimples + tPlanilla.sDobles) extraordinario
from 
    tPlanilla
    join tPeriodo on tPlanilla.idPeriodo = tPeriodo.idPeriodo
where 
    tPlanilla.codEmpleado = 4358 
    and tPeriodo.idPeriodo in (99,100,101,102,103,104)
group by 
    MONTH(tPeriodo.fechaInicio), MONTH(tPeriodo.fechafin);
