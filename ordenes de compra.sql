use pinulito_pdv

select table_1.idSolicitud, table_2.itemCode, table_3.*
from tSolicitudEmpaques as table_1
join tSolicitudDetalleEmpaques as table_2 on table_1.idSolicitud = table_2.idSolicitud
join tAsignarProveedorEmpaques as table_3 on table_2.idDetalle = table_3.idDetalle
where table_1.docNum = 18 and table_3.vigencia = 1
order by table_3.docEntry

-- select * from tSolicitudEmpaques where idSolicitud = 1525

-- update tSolicitudEmpaques set revisado = 0, fechaHoraFirmaRevisado = null, firmaRevisado = null where idSolicitud = 1539

-- update tAsignarProveedorEmpaques set docEntry = 943, docNum = 935 where idAsignar in (73,74)

-- use db_empaques;

-- select docentry, docnum from opor where docentry = 943

-- select itemcode, dscription, quantity from por1 where docentry = 3151

-- select * from por1 where baseEntry = 18

-- select * from prq1 where docEntry = 924