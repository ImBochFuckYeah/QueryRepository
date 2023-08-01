/*--------------------------------------ORDENES DE COMPRA BODEGA CENTRAL--------------------------------------*/
select * from pinulito_pdv..tSolicitudBodega where docnum = 11430
select * from pinulito_pdv..tSolicitudDetalleBodega where idSolicitud = 341
select top(100) * from pinulito_pdv..tAsignarProveedor where idasignar = 1879
-----------------------------------------------------------------------------------------------------------------------------------------
SELECT 
    t3.idAsignar, t2.idDetalle, t1.idSolicitud, t2.itemCode, t5.ItemName as producto, t2.cantidad, t2.unidades,
    t3.codigoProveedor, t4.CardName as proveedor, t3.precio, t3.docEntry, t3.docNum, t3.comentario,
	(t2.cantidad * t3.precio) as totallinea
FROM 
    pinulito_pdv..tSolicitudBodega as t1
    INNER JOIN PINULITO_PDV..tSolicitudDetalleBodega as t2 ON t1.idSolicitud = t2.idSolicitud AND t1.vigencia = 1 AND t1.situacion = 2
    INNER JOIN PINULITO_PDV..tAsignarProveedor as t3 ON t2.idDetalle = t3.idDetalle
    INNER JOIN DB_22_CORPORACION..OCRD as t4 ON t3.codigoProveedor = t4.cardCode COLLATE DATABASE_DEFAULT
    INNER JOIN DB_22_CORPORACION..OITM as t5 ON t2.itemCode = t5.ItemCode COLLATE DATABASE_DEFAULT
WHERE 
    t1.idsolicitud = 338 AND t3.docEntry IS NULL AND t3.codigoProveedor = 'PC00551'
-------------------------------------------------------------------------------------------------------------------
--update pinulito_pdv..tAsignarProveedor set docNum = 11467, docEntry = 2769 where idAsignar in ('1896','1897','1901') and docEntry is null

/*--------------------------------------ORDENES DE COMPRA BODEGA CENTRAL--------------------------------------*/
select * from pinulito_pdv..tSolicitudPaladin where docNum = 56
select * from pinulito_pdv..tSolicitudDetallePaladin where idSolicitud = 366
select top(100) * from pinulito_pdv..tAsignarProveedorPaladin where idasignar = 1879
-----------------------------------------------------------------------------------------------------------------------------------------
SELECT 
    t3.idAsignar, t2.idDetalle, t1.idSolicitud, t2.itemCode, t5.ItemName as producto, t2.cantidad, t2.unidades,
    t3.codigoProveedor, t4.CardName as proveedor, t3.precio, t3.docEntry, t3.docNum, t3.comentario,
	(t2.cantidad * t3.precio) as totallinea
FROM 
    pinulito_pdv..tSolicitudPaladin as t1
    INNER JOIN PINULITO_PDV..tSolicitudDetallePaladin as t2 ON t1.idSolicitud = t2.idSolicitud AND t1.vigencia = 1 AND t1.situacion = 2
    INNER JOIN PINULITO_PDV..tAsignarProveedorPaladin as t3 ON t2.idDetalle = t3.idDetalle
    INNER JOIN DB_PALADIN..OCRD as t4 ON t3.codigoProveedor = t4.cardCode COLLATE DATABASE_DEFAULT
    INNER JOIN DB_PALADIN..OITM as t5 ON t2.itemCode = t5.ItemCode COLLATE DATABASE_DEFAULT
WHERE 
    t1.idsolicitud = 366 AND t3.docEntry IS NULL AND t3.codigoProveedor = 'PC00551'
-------------------------------------------------------------------------------------------------------------------
--update pinulito_pdv..tAsignarProveedorPaladin set docNum = 411, docEntry = 464 where idAsignar = 1032 and docEntry is null