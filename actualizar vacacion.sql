use pinulito_nomina;

select * from tAusencia where idAusencia = 5349;

select * from tVacacion where idAusencia = 5349;

select * from tVacacionDetalle where idVacacion = 3661;

select STRING_AGG(idPeriodo, ',') periodos from tPeriodo where year(fechaInicio) = 2024 and MONTH(fechaInicio) in (4, 5, 6)

------------------------------------------------------------------------------------------

select 
    MONTH(tPeriodo.fechaFin) mes,
    SUM(tPlanilla.sSimples + tPlanilla.sDobles + tPlanilla.otrosIngresos) extraordinario
from 
    tPlanilla
    join tPeriodo on tPlanilla.idPeriodo = tPeriodo.idPeriodo
where 
    tPlanilla.codEmpleado = 4086 
    and tPeriodo.idPeriodo in (103,104,105,106,107,108)
group by 
    MONTH(tPeriodo.fechaInicio), MONTH(tPeriodo.fechafin);