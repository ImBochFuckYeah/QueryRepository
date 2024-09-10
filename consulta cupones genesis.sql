select
vex.*, tkn.created_at
from [pinulito_pdv].[dbo].[tValeExterno] as vex
join [api_token_genesis].[dbo].[series] as srs on vex.serie = srs.serie
join [api_token_genesis].[dbo].[token_additional_information] as tkn on tkn.id = vex.idApiToken
where ([srs].[status] = 1)