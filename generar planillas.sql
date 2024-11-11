-- use pinulito_nomina;

select * from tPeriodo where fechainicio = '20241216';

/* generar planila tempora */
    
-- exec spCalcularPlanilla @idPeriodo = 120, @codEmpresa = 15;

select count(*) from tPlanillaTemporal where idPeriodo = 120 and idEmpresa = 15;

/* traladar a planilla confirmada */
    
-- exec spTrasladoPlanilla @idEmpresa = 15, @idPeriodo = 120;

select count(*) from tPlanilla where idPeriodo = 120 and idEmpresa = 15;