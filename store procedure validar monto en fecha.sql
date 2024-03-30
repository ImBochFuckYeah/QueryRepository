ALTER PROCEDURE ValidarMontoDocumento
    @empresa VARCHAR(5),
    @tienda VARCHAR(5),
    @fecha_documento DATE,
    @total_documento DECIMAL,
    @tipo_documento INT
AS
BEGIN
    DECLARE @resultado_str VARCHAR(510);
    DECLARE @resultado_bool BIT = 0;

    IF @fecha_documento = CAST(GETDATE() - 1 AS DATE) AND
       CAST(GETDATE() AS TIME) BETWEEN '14:59:59' AND '16:59:59'
    BEGIN
        IF @tipo_documento = 1
        BEGIN
            SELECT @resultado_bool = CASE WHEN ISNULL(SUM(monto), 0) + @total_documento BETWEEN 0 AND 2000 THEN 1 ELSE 0 END,
                   @resultado_str = CASE WHEN ISNULL(SUM(monto), 0) + @total_documento BETWEEN 0 AND 2000 THEN 'El monto es válido' ELSE 'El monto es inválido' END
            FROM tDeposito
            WHERE empresa = @empresa
              AND tienda = @tienda
              AND CAST(fechaCrea AS DATE) = @fecha_documento
              AND CAST(fechaCrea AS TIME) BETWEEN '14:59:59' AND '16:59:59'
              AND Anulado = 0;
        END
        ELSE
        BEGIN
            SET @resultado_str = 'El tipo de documento no es válido.';
        END
    END
    ELSE
    BEGIN
        SET @resultado_str = 'Solicitud fuera de horario establecido.';
    END

    SELECT @resultado_bool AS resultado, @resultado_str AS mensaje;
END;
