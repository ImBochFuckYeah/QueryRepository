use pinulito_edw_sat

select * from dte_frase
select * from frase
select * from dte_item_impuesto
select * from dte_item
select * from dte
select * from dte_certificacion
select * from emisor
select * from receptor
select * from sat

-- delete from dte_frase
-- delete from frase
-- delete from dte_item_impuesto
-- delete from dte_item
-- delete from dte
-- delete from dte_certificacion
-- delete from emisor
-- delete from receptor
-- delete from sat

SELECT b.numero, b.serie, b.numero_autorizacion, c.nit as nit_emisor, c.nombre as emisor, d.nit as nit_receptor, c.nombre as receptor, b.nit_certificador, b.nombre_certificador, b.fecha_hora_certificacion
FROM dte AS a JOIN dte_certificacion AS b ON a.dte_certificacion_id = b.id JOIN emisor AS c ON a.emisor_id = c.id JOIN receptor AS d ON a.receptor_id = d.id
WHERE b.numero_autorizacion = '89AF878A-5EB2-4827-A689-125A4EB7CDDB' AND c.nit = '26532476' AND d.nit = '72965746'

-- select det.*
select crt.numero_autorizacion, ems.nit, ems.nombre, rep.nit 
from dte as cab 
join dte_certificacion as crt on cab.emisor_id = crt.id
join dte_item as det on cab.id = det.dte_id
join dte_item_impuesto as imp on det.id = imp.dte_item_id
join emisor as ems on cab.emisor_id = ems.id
join receptor as rep on cab.receptor_id = rep.id
where emisor_id = 45;