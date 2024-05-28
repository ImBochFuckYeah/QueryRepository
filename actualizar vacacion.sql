use pinulito_nomina;

select * from tAusencia where idAusencia = 5240;

select * from tVacacion where idAusencia = 5240;

select * from tVacacionDetalle where idVacacion = 3603;

select * from tPeriodo where year(fechaInicio) = 2024 and MONTH(fechaInicio) in (3, 4, 5)

------------------------------------------------------------------------------------------

select 
    MONTH(tPeriodo.fechaFin) mes,
    SUM(tPlanilla.sSimples + tPlanilla.sDobles + tPlanilla.otrosIngresos) extraordinario
from 
    tPlanilla
    join tPeriodo on tPlanilla.idPeriodo = tPeriodo.idPeriodo
where 
    tPlanilla.codEmpleado = 119 
    and tPeriodo.idPeriodo in (101,102,103,104,105,106)
group by 
    MONTH(tPeriodo.fechaInicio), MONTH(tPeriodo.fechafin);