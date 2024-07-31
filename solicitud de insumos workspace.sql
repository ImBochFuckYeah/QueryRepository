use db_pruebas_avigua

-- select * from owhs where whscode = '09'
select prccode, * from oprc where prccode = 'Renderin'

/* categorias de articulos */
select
ufd1.FldValue,
ufd1.Descr
from cufd
join ufd1 on cufd.FieldID = ufd1.FieldID and cufd.TableID = ufd1.TableID
where cufd.TableID = 'OITM' and cufd.AliasID = 'U_CategoriaArt'

/* categorias de responsables */
-- select
-- ufd1.FldValue,
-- ufd1.Descr
-- from cufd
-- join ufd1 on cufd.FieldID = ufd1.FieldID and cufd.TableID = ufd1.TableID
-- where cufd.TableID = 'OITM' and cufd.AliasID = 'U_Responsable'

/* filtrar por categorias */
select itemcode, itemname from oitm where u_u_categoriaart = 'AN' group by itemcode, itemname

/* filtrar por responsables */
select itemcode, itemname from oitm where u_u_responsable = 'KF' group by itemcode, itemname

/* 
° database: pinulito_ins

° table: empresas
- id
- codigo (unico)
- nombre (unico)
- nombre_db (unico)
- logo
- decimales
- fecha_modificacion
- vigente

° table: bodegas
- id
- nombre
- id_empresa
- codigo (unico)
- codigo_centro_costo (unico)
- revision
- autorizacion
- fecha_modificacion
- vigente

° table: usuario_bodegas
- id
- id_empleado
- id_bodega
- solicitar
- revisar
- autorizar
- fecha_modificacion
- vigente

° table: precios
- id
- item_code
- card_code
- precio
- fecha_modificacion
- vigente

° view: usuarios
- id
- nombres
- apellidos
- correo_electronico
- telefono_corporativo
- firma_digital
- firma_escrita
*/