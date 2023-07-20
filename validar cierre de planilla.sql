select * from PINULITO_NOMINA..tPeriodo where idPeriodo = 83
select * from PINULITO_NOMINA..tPlanillaTemporal where idperiodo = 84
select * from PINULITO_NOMINA..tPlanilla where idperiodo = 83

SELECT codEmpleado, COUNT(codEmpleado) AS cantidad_duplicados
FROM PINULITO_NOMINA..tPlanilla 
WHERE idperiodo = 84
GROUP BY codEmpleado
HAVING COUNT(codEmpleado) > 1;