select * from pinulito_pdv..tSolicitudBodega where idsolicitud = 341
--update pinulito_pdv..tSolicitudBodega set docEntry = 2725, docNum = 11430 where idsolicitud = 338
select * from pinulito_pdv..tSolicitudDetalleBodega where idSolicitud = 341
select * from pinulito_pdv..tAsignarProveedor where iddetalle in (1722,1723,1724)
select * from pinulito_pdv..tPrecioProveedorBodega where itemcode in ('VD0002', 'VD0004','VD0003') and vigente = 1
--update pinulito_pdv..tAsignarProveedor set docEntry = 2725, docNum = 11430 where iddetalle in (1722,1723,1724)