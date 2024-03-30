SELECT
    distinct t1.U_CATEGORIA AS categoria,
    t2.nombrecategoria AS nombre,
    t1.itemname,
    'Dia de Pedido es ' + t8.nombre as semana,
    t3.ItemCode,
    ISNULL(t6.quantity, 0) AS stockPedido,
    COALESCE(t3.stock, 0) AS stock,
    t1.SalUnitMsr AS unidad,
    isnull(t5.comentarioTienda, '') as comentarioTienda
FROM
    DB_22_CORPORACION..OITM t1
    INNER JOIN tcategoriaSAp t2 ON t1.U_CATEGORIA = t2.idcategoria
    and t2.vigente = 1
    INNER JOIN tIventarioTiendaInsumos t3 ON t1.SWW = t3.itemcode COLLATE SQL_Latin1_General_CP1_CI_AS
    INNER JOIN ttienda t4 ON t3.empresa = t4.empresa
    AND t3.tienda = t4.tienda
    LEFT JOIN tSolicitudSupervisorTienda t5 ON t5.codigoTienda = t4.tiendaglovo
    and convert(date, t5.fechaPedido) = '2024-02-20'
    and t5.vigente = 1
    LEFT JOIN tSolicitudSupervisorTiendaDetalle t6 ON t6.idSolicitud = t5.idSolicitud
    and t1.sww = t6.ItemCode COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN tRutasBodegasTiendas t7 ON t3.empresa = t7.empresa
    and t3.tienda = t7.tienda
    and t7.vigencia = 0
    LEFT JOIN tdiaSemana t8 ON t7.idSemana = t8.idDia -- LEFT JOIN tSolicitudVerdurasTienda t9 ON t9.idSolicitudInsumos = t5.idSolicitud
    -- LEFT JOIN tSolicitudesVerdurasTiendaDetalle t10 ON t9.idSolicitud = t10.idSolicitud
WHERE
    t1.U_CATEGORIA IS NOT NULL
    AND t3.ItemCode IS NOT NULL
    AND t3.ItemName IS NOT NULL
    AND t3.empresa = '00004'
    AND t3.tienda = '00051'
    AND t2.idcategoria = t2.idcategoria
    AND t2.idcategoria = '1'
GROUP BY
    t1.U_CATEGORIA,
    t2.nombrecategoria,
    t8.nombre,
    t1.ItemName,
    t3.ItemCode,
    t6.quantity,
    t3.stock,
    t5.comentarioTienda,
    t1.SalUnitMsr
order by
    t1.ItemName asc