SELECT 
    table_1.ItemName descripcion, 
    table_1.itemCode sku
FROM
    [DB_CORPORACION_21].[dbo].[oitm] table_1
    JOIN [DB_CORPORACION_21].dbo.ITM1 table_2 ON table_1.itemCode = table_2.itemCode
WHERE
    table_1.U_Conf_POS IN (4)
    AND table_2.PriceList IN (25, 26)
    AND PATINDEX('%[^0-9]%', table_1.itemCode) = 0
    AND table_1.validFor = 'Y'
    AND ISNULL(table_1.validFrom, CONVERT(DATE, GETDATE())) <= CONVERT(DATE, GETDATE())
    AND ISNULL(table_1.validTo, CONVERT(DATE, GETDATE())) >= CONVERT(DATE, GETDATE())
GROUP BY table_1.ItemName, table_1.itemCode;