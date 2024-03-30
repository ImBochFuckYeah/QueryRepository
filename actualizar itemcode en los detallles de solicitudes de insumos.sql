USE PINULITO_PDV;

SELECT T2.*
FROM tSolicitudSupervisorTienda T1
    JOIN tSolicitudSupervisorTiendaDetalle T2 ON T1.idSolicitud = T2.idSolicitud
WHERE fechaPedido = '2024-02-21' AND T1.ruta = 5 AND T2.ItemCode = 'E0009'

/*----------------------------------------------------------------------------*/

UPDATE tSolicitudSupervisorTiendaDetalle
SET ItemCode = 'VD0005'
WHERE idDetalleSolicitud IN (
    SELECT T2.idDetalleSolicitud
    FROM tSolicitudSupervisorTienda T1
    JOIN tSolicitudSupervisorTiendaDetalle T2 ON T1.idSolicitud = T2.idSolicitud
    WHERE fechaPedido = '2024-02-21' AND T1.ruta = 5 AND T2.ItemCode = 'E0009'
);