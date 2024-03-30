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