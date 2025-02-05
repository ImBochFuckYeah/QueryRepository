DECLARE @semanas AS TABLE (
    idSemana INT PRIMARY KEY,
    noSemana INT,
    fechaInicio DATE,
    fechaFin DATE,
    anio INT,
    vigente INT,
    creadoPor INT
);

-- Variables para el año
DECLARE @Anio INT = YEAR(GETDATE());
DECLARE @FechaInicio DATE = DATEFROMPARTS(@Anio, 1, 1);
DECLARE @FechaFin DATE = DATEFROMPARTS(@Anio, 12, 29);

-- Variable para el contador de periodos
DECLARE @Contador INT = 1;

-- Bucle para generar periodos por cada semana, considerando años bisiestos
WHILE @FechaInicio <= @FechaFin
BEGIN

    DECLARE @FechaFinSemana DATE = DATEADD(DAY, 6, @FechaInicio);

    INSERT INTO @semanas (idSemana, noSemana, fechaInicio, fechaFin, anio, vigente, creadoPor)
    VALUES (@Contador, @Contador, @FechaInicio, @FechaFinSemana, @Anio, 1, 4403);

    SET @FechaInicio = DATEADD(DAY, 1, @FechaFinSemana);
    SET @Contador = @Contador + 1;
END

-- Seleccionar los periodos generados
SELECT * FROM @semanas;
/********************************************************************************************************/
DECLARE @anio INT = 2025;
DECLARE @fechaInicio DATE = DATEADD(YEAR, @anio - YEAR(GETDATE()), '2023-12-29'); -- ISO 8601: Semana 1 puede iniciar en diciembre
DECLARE @fechaFinal DATE;
DECLARE @numeroSemana INT = 1;

WHILE YEAR(@fechaInicio) <= @anio
BEGIN
    -- Calcular fecha de inicio y final de la semana
    SET @fechaInicio = DATEADD(DAY, -DATEPART(WEEKDAY, @fechaInicio) + 2, @fechaInicio); -- Ajustar al lunes
    SET @fechaFinal = DATEADD(DAY, 6, @fechaInicio); -- Siguiente domingo

    -- Verificar si pertenece al año ISO 2025
    IF YEAR(@fechaFinal) = @anio OR (YEAR(@fechaInicio) = @anio AND DATEPART(WEEK, @fechaInicio) = 1)
    BEGIN
        INSERT INTO [dbo].[tSemana] (numeroSemana, fechaInicio, fechaFinal, anio, vigente, creadoPor)
        VALUES (@numeroSemana, @fechaInicio, @fechaFinal, @anio, 1, 1);
        SET @numeroSemana += 1;
    END

    -- Avanzar a la siguiente semana
    SET @fechaInicio = DATEADD(DAY, 7, @fechaInicio);
END