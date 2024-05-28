BEGIN TRANSACTION;

BEGIN TRY
    -- Paso 2: Eliminar los registros hijos en facturadetalle
    DELETE FROM tFacturaDetalleSemanal
    WHERE idFactura IN (
        SELECT idFactura
        FROM tFacturaSemanal
        WHERE empresa = '00004' AND tienda = '00053'
        AND CAST(fechaHora AS DATE) BETWEEN '2024-05-19' AND '2024-05-19'
    );

    -- Paso 3: Eliminar los registros de la tabla cabecera factura
    DELETE FROM tFacturaSemanal
    WHERE empresa = '00004' AND tienda = '00053'
    AND CAST(fechaHora AS DATE) BETWEEN '2024-05-19' AND '2024-05-19'

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    -- Manejar el error aquí
    DECLARE @ErrorMessage NVARCHAR(4000);
    SET @ErrorMessage = ERROR_MESSAGE();
    RAISERROR (@ErrorMessage, 16, 1);
END CATCH;
