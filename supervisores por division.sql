use pinulito_nomina;

select 
    t1.codEmpleado id_empleado,
    t1.aliasCodigo codigo_supervisor,
    CONCAT(t1.nombreEmpleado, CONCAT(' ', t1.apellidoEmpleado)) nombre_supervisor
from
    tEmpleado t1
    join tResponsableCentroCosto t2 on t1.codEmpleado = t2.codEmpleado
    join tDepartamento t3 on t2.codDepto = t3.codDepto
    join [pinulito_pdv].[dbo].[tTienda] t4 on substring(t3.idPOS, 1, 5) = t4.empresa and substring(t3.idPOS, 7, 11) = t4.tienda
where
    t2.vigente = 1
    and t3.codEmpresa in (1, 2, 3, 4, 5)
    -- and t4.division in ('moris sazo')
group by
    t1.codEmpleado,
    t1.aliasCodigo,
    CONCAT(t1.nombreEmpleado, CONCAT(' ', t1.apellidoEmpleado))