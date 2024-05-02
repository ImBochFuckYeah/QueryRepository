USE PINULITO_PDV;

SELECT 
    emp.empresa codigo_empresa,
    UPPER(emp.nombre) nombre_empresa,
    tda.tienda codigo_tienda,
    UPPER(tda.tda_nombre) nombre_tienda,
    UPPER(tda.direccion) direccion_tienda,
    UPPER(tda.departamento) departamento_tienda,
    UPPER(tda.municipio) municipio_tienda,
    UPPER(tda.division) division,
    CASE WHEN tda.inactiva = 0 THEN 'ACTIVA' ELSE 'INACTIVA' END estado_tienda
FROM 
    tTienda tda
    JOIN tEmpresa emp ON tda.empresa = emp.empresa
WHERE
    emp.idEmpresa IN (1, 2, 3, 4, 5)
    AND tda.idTienda NOT IN (588, 628)
    AND tda.tienda NOT IN ('99999');