CREATE FUNCTION dbo.CalcularTotalAhorro
(
    @CodigoEmpleado INT
)
RETURNS INT
AS
BEGIN
    DECLARE @TotalAhorro INT
    SET @TotalAhorro = 0

    DECLARE @Ahorro INT
    DECLARE @Contador125 INT
    SET @Contador125 = 0

    DECLARE historial_cursor CURSOR FOR
    SELECT ahorro
    FROM tPlanilla
    WHERE codEmpleado = @CodigoEmpleado
    AND ahorro > 0
    ORDER BY idPlanilla

    OPEN historial_cursor

    FETCH NEXT FROM historial_cursor INTO @Ahorro

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Sumar el monto al total
        SET @TotalAhorro = @TotalAhorro + @Ahorro

        -- Verificar si el monto es 125 y contar las ocurrencias
        IF @Ahorro = 125
        BEGIN
            SET @Contador125 = @Contador125 + 1
        END
        ELSE
        BEGIN
            -- Reiniciar contador si no es 125
            SET @Contador125 = 0
        END

        -- Restar 150 al total si encuentra al menos dos valores de 125
        IF @Contador125 >= 2
        BEGIN
            SET @TotalAhorro = @TotalAhorro - 150
            -- Reiniciar contador
            SET @Contador125 = 0
        END

        -- Restar 150 al total si encuentra al menos una vez el valor de 250
        IF @Ahorro = 250
        BEGIN
            SET @TotalAhorro = @TotalAhorro - 150
        END

        FETCH NEXT FROM historial_cursor INTO @Ahorro
    END

    CLOSE historial_cursor
    DEALLOCATE historial_cursor

    -- Devolver el total de ahorro acumulado
    RETURN @TotalAhorro
END
