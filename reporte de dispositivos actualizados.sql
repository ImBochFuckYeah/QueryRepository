-- use pinulito_pdv

select 
    dispositivo,
    tda_nombre as tienda,
    versionApp,
    ultimaConexionPOS,
    upper(isnull(ext.nombre_administrador, 'n/a')) as supervisor,
    upper(ISNULL(ext.division, 'n/a')) as division
from
    tDispositivoTienda dis
    left join tTienda tda on dis.empresa = tda.empresa and dis.tienda = tda.tienda
    left join [pinulito_nomina].[dbo].[tiendas] ext on tda.idTienda = llave_pdv
-- where 
--     versionApp < '6.0.41'
--     and year(ultimaConexionPOS) = year(getdate())
--     and month(ultimaConexionPOS) = month(getdate())
group by dispositivo, tda_nombre, versionApp, ultimaConexionPOS, ext.nombre_administrador, ext.division
order by ultimaConexionPOS