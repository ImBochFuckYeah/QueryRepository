USE pinulito_pdv

/* CABECERA DE ORDENES DE COMPRA */

SELECT
    -- table_1.idAsignar id,
    -- table_1.idDetalle id_detalle,
    table_2.DocEntry doc_entry,
    table_2.DocNum doc_num,
    CONVERT(VARCHAR, table_2.DocDate, 103) fecha_documento,
    CONVERT(VARCHAR, table_2.DocDueDate, 103) fecha_vencimiento_documento,
    table_2.CardCode card_code,
    table_2.CardName card_name,
    --CAST(table_2.DocTotal AS DECIMAL(10, 2)) total_documento,
    'Q' + FORMAT(table_2.DocTotal, 'N', 'es-GT') total_documento,
    table_2.Comments comentario_sap,
    table_1.comentario comentario_pos
FROM
    tAsignarProveedor table_1
    JOIN [DB_22_CORPORACION].[dbo].[OPOR] table_2 ON table_1.docEntry = table_2.docEntry
WHERE
    table_2.CardCode = 'PC00008'
    AND table_2.DocStatus = 'O'
    AND table_1.docNum = 13143
GROUP BY
    table_2.DocEntry,
    table_2.DocNum,
    CONVERT(VARCHAR, table_2.DocDate, 103),
    CONVERT(VARCHAR, table_2.DocDueDate, 103),
    table_2.CardCode,
    table_2.CardName,
    'Q' + FORMAT(table_2.DocTotal, 'N', 'es-GT'),
    table_2.Comments,
    table_1.comentario

/* DETALLE DE ORDENES DE COMPRA */

/* SELECT 
    table_2.DocNum base_num,
    table_1.DocEntry base_entry,
    table_1.LineNum line_num,
    table_1.LineStatus line_status,
    table_1.ItemCode item_code,
    table_1.Dscription item_name,
    table_1.unitMsr unidad,
    CAST(table_1.PriceAfVAT AS DECIMAL(10, 6)) precio,
    CAST(table_1.Quantity AS DECIMAL(10, 2)) cantidad_total,
    CAST((table_1.Quantity - table_1.OpenQty) AS DECIMAL(10, 2)) cantidad_cargada,
    CAST(table_1.OpenQty AS DECIMAL(10, 2)) cantidad_pendiente,
    table_1.OpenQty * table_1.PriceAfVAT total_linea
FROM [DB_22_CORPORACION].[dbo].[POR1] table_1
    JOIN [DB_22_CORPORACION].[dbo].[OPOR] table_2 ON table_1.DocEntry = table_2.DocEntry
WHERE table_1.DocEntry IN ( 5610 ) */