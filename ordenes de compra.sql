use pinulito_pdv

select table_1.idSolicitud, table_2.itemCode, table_3.*
from tSolicitudBodega as table_1
join tSolicitudDetalleBodega as table_2 on table_1.idSolicitud = table_2.idSolicitud
join tAsignarProveedor as table_3 on table_2.idDetalle = table_3.idDetalle
where table_1.docNum = 1495 and table_3.vigencia = 1 --AND table_3.codigoProveedor = 'PC00011'
order by table_3.docEntry;

-- select * from tSolicitudEmpaques where idSolicitud = 1525

-- update tSolicitudEmpaques set revisado = 0, fechaHoraFirmaRevisado = null, firmaRevisado = null where idSolicitud = 1539

-- update tAsignarProveedorEmpaques set docEntry = 1054, docNum = 1044 where idAsignar in (214)

-- use DB_22_CORPORACION;

-- select docentry, docnum from opor where DocNum = 1044

-- select itemcode, dscription, quantity from por1 where docentry = 1059

-- select * from por1 where baseEntry = 1495

-- select a.*
-- from por1 as a
-- join opor as b on a.docEntry = b.docEntry
-- where a.baseEntry = 97 and b.cardCode = '';

-- select * from prq1 where docEntry = 924