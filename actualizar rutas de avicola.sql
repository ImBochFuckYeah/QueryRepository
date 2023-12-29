use grupopinulito

select * from [pinulito_pdv]..tTienda where tda_nombre like '%mazatenango%'

select (
    select 
    tda_nombre 
    from 
    [pinulito_pdv]..tTienda
    where
    tTienda.empresa = tRutasEnvio.empresa
    and tTienda.tienda = tRutasEnvio.tienda
) tda_nombre, * from tRutasEnvio where idruta = 24 and fecha = '2023-12-09'

select * from tRutasEnvio where empresa = '00004' and tienda = '00087' and fecha = '2023-12-09'

--update tRutasEnvio set idruta = 24 where empresa = '00004' and tienda = '00087' and fecha = '2023-12-09'

select *, (
    select 
    tda_nombre 
    from 
    [pinulito_pdv]..tTienda
    where
    tTienda.empresa = tRutas.empresa
    and tTienda.tienda = tRutas.tienda
) tda_nombre from 
tRutas 
where 
empresa = '00004' 
and tienda = '00087'

--insert into tRutas (idruta, nombre, empresa, tienda) values (24, 'Ruta Mazatenango', '00004', '00087')

select * from tListaRutas order by idlruta
--insert into tListaRutas (idlruta, nombre, cede) values (24, 'Ruta Mazatenango', 'occidente')
select * from tListaRutas where cede = 'occidente'
select * from tListaRutas where cede = 'rastro'