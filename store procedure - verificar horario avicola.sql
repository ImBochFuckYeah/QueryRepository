SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[spVerificarDiaAvicola]
    @date DATE,
    @user INT,
    @typeSchedule VARCHAR (1)
AS
BEGIN
    BEGIN TRY
        SET DATEFIRST 1;
        DECLARE @currentDate DATETIME = GETDATE();
        DECLARE @weekDay INT = DATEPART(WEEKDAY, @date);
        DECLARE @schedule TIME;
        DECLARE @timeLimit DATETIME;

        -- Obtener el horario límite del día correspondiente
        SELECT @schedule = CASE WHEN @typeSchedule = 'E' THEN horarioEspecial ELSE horario END 
        FROM tHorarioAvicola 
        WHERE diaSemana = @weekDay;

        -- Validar si se encontró un horario para el día de la semana
        IF @schedule IS NULL
        BEGIN
            THROW 50001, 'Horario no encontrado para el día especificado', 1;
        END

        IF (@user = 4221 OR @user = 4798) AND @typeSchedule = 'O'
        BEGIN
            SET @schedule = DATEADD(HOUR, 1, @schedule);
        END;

		IF @typeSchedule = 'O'
		BEGIN
			SET @date = DATEADD(DAY, -1, @date);
		END;

        -- Construir la fecha con horario límite
        SET @timeLimit = CAST(@date AS DATETIME) + CAST(@schedule AS DATETIME);

		-- PRINT CAST(@date AS DATE);

        -- Comparar fechas y determinar estado del día
        IF @date >= CAST(@currentDate AS DATE)
        BEGIN
            -- Si la fecha del parámetro es mayor que la fecha actual, verificar que la fecha-hora límite también lo sea
            IF @timeLimit > @currentDate
                SELECT 'DIA ABIERTO' AS estado;
            ELSE
                SELECT 'DIA CERRADO' AS estado;
        END
        ELSE 
        BEGIN
            SELECT 'DIA CERRADO' AS estado;
        END;
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        SELECT 'DIA CERRADO' AS estado;
    END CATCH
END;
GO
