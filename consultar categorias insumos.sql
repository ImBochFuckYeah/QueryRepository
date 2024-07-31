use db_22_corporacion

-- select sww, ItemName, U_Categoria from oitm where U_Categoria is not null and U_Categoria not in ('-') and sww is not null

select ItemCode, ItemName from oitm where U_Categoria is not null and U_Categoria not in ('-') and sww is not null