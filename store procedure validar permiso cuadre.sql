SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BuscarPermisoCuadre]
    @fecha_cuadre DATE,
    @codigo_empleado INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener el año actual
    DECLARE @anio INT = YEAR(GETDATE());

    -- Obtener la fecha del sistema
    DECLARE @fecha_sistema DATE = GETDATE();

    -- Variable para controlar el resultado
    DECLARE @resultado BIT;

    -- Realizar la búsqueda en tPermisoCuadre y tSemana
    SELECT @resultado = CASE
        WHEN EXISTS (
            SELECT 1
            FROM tPermisoCuadre pc
            JOIN tSemana s ON pc.numeroSemana = s.numeroSemana AND s.anio = @anio
            WHERE pc.codEmpleado = @codigo_empleado
                AND @fecha_cuadre BETWEEN s.FechaInicio AND s.FechaFinal
                AND pc.fechaVigencia = @fecha_sistema
                AND pc.vigente = 1
        )
        THEN 1 -- Verdadero
        ELSE 0 -- Falso
    END;

    -- Imprimir o devolver el resultado según tus necesidades
    SELECT @resultado AS result;
END;
GO
