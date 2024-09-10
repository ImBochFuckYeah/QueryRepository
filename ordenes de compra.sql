use pinulito_pdv

select table_2.itemCode, table_3.*
from tSolicitudPaladin as table_1
join tSolicitudDetallePaladin as table_2 on table_1.idSolicitud = table_2.idSolicitud
join tAsignarProveedorPaladin as table_3 on table_2.idDetalle = table_3.idDetalle
where table_1.docNum = 121 -- and table_3.docNum = 888 -- and table_3.docNum not in (883, 884, 885, 886, 887, 888, 889, 892, 893, 897)
order by table_3.docEntry

-- update tAsignarProveedorPaladin set docEntry = 931, docNum = 923 where idAsignar in (65)

-- use db_paladin

-- select * from opor where docnum = 100152

-- select * from por1 where docentry = 862

-- select * from por1 where baseEntry = 121

-- select * from prq1 where docEntry = 121