-- Crear una tabla temporal para almacenar los periodos generados
DECLARE @periodos AS TABLE (
    idPeriodo INT PRIMARY KEY,
    nombrePeriodo VARCHAR(50),
    fechaInicio DATE,
    fechaFin DATE,
    pagada BIT,
    noQuincena INT,
    activo BIT
);

-- Variables para el año
DECLARE @Anio INT = YEAR(GETDATE());
DECLARE @FechaInicio DATE = DATEFROMPARTS(@Anio, 1, 1);
DECLARE @FechaFin DATE = DATEFROMPARTS(@Anio, 12, 31);

-- Variable para el contador de periodos
DECLARE @Contador INT = 1;

-- Establecer el idioma en español
SET LANGUAGE Spanish;

-- Bucle para generar periodos por cada quincena
WHILE @FechaInicio <= @FechaFin
BEGIN
    DECLARE @NombrePeriodo VARCHAR(50) = 
        CASE 
            WHEN @Contador % 2 = 1 THEN 'Primera'
            WHEN @Contador % 2 = 0 THEN 'Segunda'
        END 
        + ' de ' + DATENAME(MONTH, @FechaInicio) + ' ' + CAST(YEAR(@FechaInicio) AS VARCHAR);

    DECLARE @FechaFinQuincena DATE;

    -- Determinar la fecha de fin de la quincena
    IF DAY(@FechaInicio) <= 15
        SET @FechaFinQuincena = DATEADD(DAY, 14, @FechaInicio);
    ELSE
        SET @FechaFinQuincena = EOMONTH(@FechaInicio);

    INSERT INTO @periodos (idPeriodo, nombrePeriodo, fechaInicio, fechaFin, pagada, noQuincena, activo)
    VALUES (@Contador, @NombrePeriodo, @FechaInicio, @FechaFinQuincena, 0, @Contador, 1);

    SET @FechaInicio = DATEADD(DAY, 1, @FechaFinQuincena);
    SET @Contador = @Contador + 1;
END

-- Seleccionar los periodos generados
SELECT * FROM @periodos;