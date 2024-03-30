DECLARE @Date DATETIME = '2024-01-01T15:00:00'
DECLARE @CurrentDate DATETIME = GETDATE()
DECLARE @estadoDia VARCHAR(150)

SELECT
    @estadoDia = CASE
        -- Día 1 y 2 de enero de 2024 antes de las 13:00:00 del 24 de diciembre de 2023
        WHEN YEAR(@Date) = 2024
             AND MONTH(@Date) = 1
             AND DAY(@Date) IN (1, 2)
             AND @CurrentDate <= '2023-12-31T12:59:59'
        THEN 'DIA ABIERTO'

        -- Otros días de enero de 2024 después de las 13:00:00 del día actual
        WHEN @Date > @CurrentDate + 1
             AND NOT (
                YEAR(@Date) = 2024
                AND MONTH(@Date) = 1
                AND DAY(@Date) IN (1, 2)
             )
        THEN 'DIA ABIERTO'

        -- En cualquier otro caso
        ELSE 'DIA CERRADO'
    END

-- Puedes mostrar el resultado o hacer lo que necesites con @estadoDia
SELECT @estadoDia AS 'estadoDia'