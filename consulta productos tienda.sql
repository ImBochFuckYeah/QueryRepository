use db_corporacion_21

select 
a.itemcode, a.itemname, b.Price
from oitm as a
join itm1 as b on a.itemcode = b.itemcode
where a.validfor = 'y' and b.pricelist = 25 and b.Price > 0
order by b.price