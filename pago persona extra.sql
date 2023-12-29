SELECT * FROM tPagoPersonaExtra WHERE codEmpleado='pe0275' AND fechaBoleta='2023-04-04'
SELECT * FROM tMarcaje WHERE alias ='pe0275' AND fecha='2023-04-03'
SELECT * FROM tPagoPersonaExtraDetalle WHERE idPagoPersonaExtra=34742

select 
    empresa codigo_empresa, 
    tienda codigo_tienda,
    (
        select
        tda_nombre
        from
        tTienda
        where
        tTienda.empresa = tPagoPersonaExtra.empresa
        and tTienda.tienda = tPagoPersonaExtra.tienda
    ) nombre_tienda,
    codEmpleado codigo_empleado,
    (
        select
        primerNombre + ' ' + segundoNombre + ' ' + primerApellido + ' ' + segundoApellido
        from
        [pinulito_nomina]..tPersonaExtra
        where
        tPersonaExtra.codigoPersonaExtra = tPagoPersonaExtra.codEmpleado
    ) nombre_empleado,
    monto,
    fechaBoleta, 
    comentario 
from 
    tPagoPersonaExtra 
where 
    convert(date, fechaBoleta) between '2023-11-01' and '2023-11-30'
    and vigente = 1
    and autorizado = 1

--UPDATE tPagoPersonaExtra SET autorizado=1 WHERE codEmpleado='pe0275' AND fechaBoleta='2023-04-04'

--http://sistema.grupopinulito.com:81/POS/services/personaExtra/generaBoletaPago.php?aliasCodigo=pe0275&idMarcaje =394216
--http://sistema.grupopinulito.com:81/POS/services/formatPagoPE.php?id=34742