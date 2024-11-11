use pinulito_pdv

select
substring(indendificador, 1, 5) as empresa,
substring(indendificador, 7, 5) as tienda
from tFacturaSemanal
where empresa = 'null' and tienda = 'null' and cast(fechaHora as date) between '2024-09-01' and '2024-09-20'

-- update tFacturaSemanal
-- set empresa = substring(indendificador, 1, 5),tienda = substring(indendificador, 7, 5)
-- where empresa = 'null' and tienda = 'null' and cast(fechaHora as date) between '2024-09-01' and '2024-09-11'