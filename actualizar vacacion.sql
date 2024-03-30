use pinulito_nomina;

select * from tAusencia where idAusencia = 4511;

select * from tVacacion where idAusencia = 4511;

select * from tVacacionDetalle where idVacacion = 3152;

--select * from tPeriodo where year(fechaInicio) = 2024 and MONTH(fechaInicio) in (1, 2)

------------------------------------------------------------------------------------------

select 
    MONTH(tPeriodo.fechaFin) mes,
    SUM(tPlanilla.sSimples + tPlanilla.sDobles) extraordinario
from 
    tPlanilla
    join tPeriodo on tPlanilla.idPeriodo = tPeriodo.idPeriodo
where 
    tPlanilla.codEmpleado = 3278 
    and tPeriodo.idPeriodo in (95,96,97,98,99,100)
group by 
    MONTH(tPeriodo.fechaInicio), MONTH(tPeriodo.fechafin);
