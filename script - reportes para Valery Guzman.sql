USE PINULITO_NOMINA;
-- 
SELECT [CODIGO] = e.aliasCodigo,
[NOMBRE] = CONCAT(e.nombreEmpleado, ' ', e.segundoNombre, ' ', e.apellidoEmpleado, ' ', e.segundoApellido),
[CUMPLEAÑOS] = e.fechaNac
FROM tEmpleado e
JOIN tContrato c ON e.noContract = c.noContract
WHERE (c.codDepto = 1) AND (c.finContract IS NULL OR c.finContract = '19000101');
-- 
SELECT [CODIGO] = emp.aliasCodigo,
[NOMBRE] = CONCAT(emp.nombreEmpleado, ' ', emp.segundoNombre, ' ', emp.apellidoEmpleado, ' ', emp.segundoApellido),
[DEPARTAMENTO] = dpt.nombre,
[EMPRESA] = eps.nombre
FROM tEmpleado AS emp
JOIN tContrato AS ctt ON emp.noContract = ctt.noContract
JOIN tDepartamento AS dpt ON ctt.codDepto = dpt.codDepto
JOIN tEmpresa AS eps ON ctt.codEmpresa = eps.codEmpresa
WHERE (ctt.codDepto IN (
    1,2,4,6,7,8,9,10,11,12,13,14,15,16,17,538,573,581,582,583,585,588,610,650,662,1670,1671,485,488,492,495,501,505,510,515,551,1677,1689
)) AND (ctt.finContract IS NULL OR ctt.finContract = '19000101');