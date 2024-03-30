SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[VerificarFechaEnSemana]
    @fecha_parametro DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener la fecha de sistema
    DECLARE @fecha_sistema DATE = GETDATE();
    DECLARE @fecha_hora_sistema DATETIME = GETDATE();

    -- Obtener la fecha de inicio y fin de la semana actual
    DECLARE @fecha_inicio_semana DATE;
    DECLARE @fecha_fin_semana DATE;

    SELECT @fecha_inicio_semana = FechaInicio,
           @fecha_fin_semana = FechaFinal
    FROM tSemana
    WHERE @fecha_sistema BETWEEN FechaInicio AND FechaFinal;

    -- Ajustar la fecha de inicio de la semana si es lunes antes de las 4:00 PM
    IF DATEPART(WEEKDAY, @fecha_hora_sistema) = 2 AND DATEPART(HOUR, @fecha_hora_sistema) < 16
    BEGIN
        SET @fecha_inicio_semana = DATEADD(DAY, -7, CONVERT(DATE, @fecha_inicio_semana));
    END

    -- Verificar si la fecha_parametro está dentro del rango de fechas de la semana
    DECLARE @resultado BIT;

    IF @fecha_parametro BETWEEN @fecha_inicio_semana AND @fecha_fin_semana
        SET @resultado = 1; -- Verdadero
    ELSE
        SET @resultado = 0; -- Falso

    -- Imprimir o devolver el resultado según tus necesidades
    SELECT 
        CONVERT(VARCHAR, @fecha_inicio_semana) AS [start_date],
        CONVERT(VARCHAR, @fecha_fin_semana) AS [end_date],
        @resultado AS result;
END;
GO
