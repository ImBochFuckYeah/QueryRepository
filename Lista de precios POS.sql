SELECT
    itemCode as sku,
    x.priceList as listaPrecios,
    itemName as nombre,
    'http://sistema.grupopinulito.com:81/POS/images/' + isnull(picturName, '') as foto,
    price as precio,
    '00001' as uniMed,
    0 as maxDesc,
    0 as precioVariable,
    ISNULL(
        (
            SELECT
                vigente
            FROM
                tProductoPerdida
            WHERE
                itemCode COLLATE DATABASE_DEFAULT = x.itemCode
                AND vigente = 1
        ),
        0
    ) as perdida
FROM
    (
        SELECT
            t0.U_Sub_categoria,
            t0.u_ssub_categoria,
            t2.empresa,
            t2.tienda,
            t1.priceList,
            t0.itemCode,
            t0.frgnName ItemName,
            t1.Price,
            t0.picturName
        FROM
            [DB_CORPORACION_21].dbo.OITM t0
            INNER JOIN [DB_CORPORACION_21].dbo.ITM1 t1 ON t0.itemCode = t1.itemCode
            INNER JOIN tTienda t2 ON t1.priceList in (25)
        WHERE
            t0.U_Conf_POS >= 4
            AND t1.Price > 0
            AND t0.validFor = 'Y'
            AND ISNULL(t0.validFrom, CONVERT(DATE, GETDATE())) <= CONVERT(DATE, GETDATE())
            AND ISNULL(t0.validTo, CONVERT(DATE, GETDATE())) >= CONVERT(DATE, GETDATE())
    ) x
WHERE
    empresa = '00004'
    and tienda = '00051'
ORDER BY
    CAST(U_Sub_categoria as int) ASC,
    CAST(u_SSub_categoria as int) ASC