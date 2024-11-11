SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spCalculoPasivoLaboral]
    @codigo INT
AS
BEGIN
    DECLARE @salario_ordinario DECIMAL(10,4);
    DECLARE @salario_extraordinario DECIMAL(10,4);

    -- Obtener el contrato del empleado
    DECLARE @noContract INT = (SELECT noContract FROM tEmpleado WHERE codEmpleado = @codigo);

    -- Obtener fecha de cálculo
    DECLARE @fecha_calculo DATE = ISNULL((SELECT NULLIF(finContract, '1900-01-01') FROM tContrato WHERE noContract = @noContract), GETDATE());

    -- Establecer fechas de inicio y fin
    DECLARE @fecha_inicio DATE = DATEFROMPARTS(YEAR(DATEADD(MONTH, -6, @fecha_calculo)), MONTH(DATEADD(MONTH, -6, @fecha_calculo)), 1);
    DECLARE @fecha_fin DATE = CASE
        WHEN @fecha_calculo <> EOMONTH(@fecha_calculo) THEN EOMONTH(DATEADD(MONTH, -1, @fecha_calculo))
        ELSE @fecha_calculo
    END;

    -- Calcular días laborados
    DECLARE @dias_laborados INT = (
        SELECT DATEDIFF(DAY, fechaIngreso, ISNULL(NULLIF(finContract, '1900-01-01'), @fecha_calculo))
        FROM tEmpleado emp
        JOIN tContrato ctc ON ctc.noContract = emp.noContract
        WHERE emp.codEmpleado = @codigo
    );

    -- Calcular salario proporcional
    DECLARE @salario_proporcional DECIMAL(10, 4) = (
        SELECT 
            CASE 
                WHEN SUM(salarioMensual / 2) IS NULL 
                -- THEN (SELECT (salarioOrdinario/DAY(EOMONTH(@fecha_calculo))) * DAY(@fecha_calculo) FROM tContrato WHERE noContract = @noContract)
                THEN (SELECT (salarioOrdinario / 30) * DAY(@fecha_calculo) FROM tContrato WHERE noContract = @noContract)
                ELSE 0
            END
        FROM 
            tPlanilla 
        WHERE 
            codEmpleado = @codigo 
            AND idPeriodo = (SELECT idPeriodo FROM tPeriodo WHERE @fecha_calculo BETWEEN fechaInicio AND fechaFin)
    );

    -- Calcular salarios promedio y ordinario en una sola consulta
    WITH Salarios AS (
        -- SELECT 
        --     SUM((pnl.salarioMensual / 30) * 15) AS salario_ordinario,
        --     SUM(pnl.sSimples + pnl.sDobles + pnl.otrosIngresos) AS salario_extraordinario
        -- FROM tPlanilla pnl
        -- JOIN tPeriodo prd ON prd.idPeriodo = pnl.idPeriodo
        -- WHERE prd.fechaInicio >= @fecha_inicio AND prd.fechaFin <= @fecha_fin AND pnl.codEmpleado = @codigo
        SELECT 
            SUM((pnl.salarioMensual / 30) * 15) AS salario_ordinario,
            SUM(pnl.sSimples + pnl.sDobles + pnl.otrosIngresos) AS salario_extraordinario
            -- pnl.*
        FROM tPeriodo prd
        LEFT JOIN tPlanilla pnl ON prd.idPeriodo = pnl.idPeriodo AND pnl.codEmpleado = @codigo
        JOIN tContrato ctt ON ctt.noContract =  @noContract
        WHERE prd.fechaInicio >= @fecha_inicio AND prd.fechaFin <= @fecha_fin
    )
    SELECT 
        @salario_ordinario = CASE WHEN @dias_laborados > 180 THEN ((salario_ordinario / 180) * 30) ELSE (((salario_ordinario + @salario_proporcional) / (@dias_laborados - 1)) * 30) END,
        @salario_extraordinario = (salario_extraordinario / 6)
    FROM Salarios;

    -- Calcular indemnización
    DECLARE @indemnizacion DECIMAL(10, 4) = ((((@salario_ordinario + @salario_extraordinario) + (@salario_ordinario / 6)) * (@dias_laborados + 1)) / 365);

    -- Calcular aguinaldo
    DECLARE @fecha_inicio_aguinaldo DATE = DATEFROMPARTS(YEAR(
            CASE WHEN CAST(GETDATE() AS DATE) < DATEFROMPARTS(YEAR(@fecha_calculo), 11, 30) THEN DATEADD(YEAR, -1, @fecha_calculo) ELSE @fecha_calculo END
        ), 12, 1);
    DECLARE @fecha_fin_aguinaldo DATE = @fecha_calculo;
    -- DECLARE @fecha_fin_aguinaldo DATE = DATEFROMPARTS(YEAR(@fecha_calculo), 11, 30);
    DECLARE @salario_proporcional_aguinaldo DECIMAL(10, 4) = (
        SELECT
            TOP 1 
            (SELECT ((salarioOrdinario / 30) * DATEDIFF(DAY, prd.fechaFin, @fecha_calculo)) FROM tContrato WHERE noContract = @noContract)
        FROM tPlanilla pnl
        JOIN tPeriodo prd ON prd.idPeriodo = pnl.idPeriodo
        WHERE prd.fechaInicio >= @fecha_inicio_aguinaldo
            AND prd.fechaFin <= @fecha_fin_aguinaldo 
            AND pnl.codEmpleado = @codigo
        ORDER BY idPlanilla DESC
    );
    DECLARE @aguinaldo DECIMAL(10, 4) = (
        SELECT (SUM(pnl.salarioMensual / 2) + @salario_proporcional_aguinaldo) / 12
        FROM tPlanilla pnl
        JOIN tPeriodo prd ON prd.idPeriodo = pnl.idPeriodo
        WHERE prd.fechaInicio >= @fecha_inicio_aguinaldo AND prd.fechaFin <= @fecha_fin_aguinaldo AND pnl.codEmpleado = @codigo
    );

    -- Calcular bono catorce
    DECLARE @fecha_inicio_bono_catorce DATE = DATEFROMPARTS(YEAR(
            CASE WHEN CAST(GETDATE() AS DATE) < DATEFROMPARTS(YEAR(@fecha_calculo), 6, 30) THEN DATEADD(YEAR, -1, @fecha_calculo) ELSE @fecha_calculo END
    ), 7, 1);
    DECLARE @fecha_fin_bono_catorce DATE = @fecha_calculo;
    -- DECLARE @fecha_fin_bono_catorce DATE = DATEFROMPARTS(YEAR(@fecha_calculo), 6, 30);
    DECLARE @salario_proporcional_bono_catorce DECIMAL(10, 4) = (
        SELECT
            TOP 1 
            (SELECT ((salarioOrdinario / 30) * DATEDIFF(DAY, prd.fechaFin, @fecha_calculo)) FROM tContrato WHERE noContract = @noContract)
        FROM tPlanilla pnl
        JOIN tPeriodo prd ON prd.idPeriodo = pnl.idPeriodo
        WHERE prd.fechaInicio >= @fecha_inicio_bono_catorce
            AND prd.fechaFin <= @fecha_fin_bono_catorce
            AND pnl.codEmpleado = @codigo
        ORDER BY idPlanilla DESC
    );
    DECLARE @bono_catorce DECIMAL(10, 4) = (
        SELECT (SUM(pnl.salarioMensual / 2) + @salario_proporcional_bono_catorce) / 12
        FROM tPlanilla pnl
        JOIN tPeriodo prd ON prd.idPeriodo = pnl.idPeriodo
        WHERE prd.fechaInicio >= @fecha_inicio_bono_catorce AND prd.fechaFin <= @fecha_fin_bono_catorce AND pnl.codEmpleado = @codigo
    );

    -- Obtener último periodo
    DECLARE @ultimo_periodo DATE = (
        SELECT TOP 1 DATEFROMPARTS(YEAR(prd.fechaInicio), MONTH(prd.fechaInicio), 1)
        FROM tPlanilla pnl
        JOIN tPeriodo prd ON prd.idPeriodo = pnl.idPeriodo
        WHERE pnl.codEmpleado = @codigo
        ORDER BY pnl.idPeriodo DESC
    );

    -- Calcular vacaciones pendientes y proporcionales
    DECLARE @vacaciones_pendientes DECIMAL(10, 4) = (
        SELECT
            TOP 1
            CASE 
                WHEN ISNULL(DATEDIFF(DAY, DATEADD(YEAR, 1, ultimasVacaciones), @fecha_calculo), DATEDIFF(DAY, fechaIngreso, @fecha_calculo)) / 364 > 0 
                THEN (@salario_ordinario + @salario_extraordinario) / 2 
                ELSE 0
            END
        FROM
            tContrato ctt
            LEFT JOIN tVacacion vcc ON vcc.codEmpleado = ctt.codEmpleado AND DATEADD(YEAR, 1, vcc.ultimasVacaciones) > ctt.fechaIngreso AND vcc.vigente = 1
        WHERE
            noContract = @noContract
        ORDER BY
            YEAR(ultimasVacaciones) DESC
    );

    -- Calcular ultimas vacaciones
    DECLARE @ultimas_vacaciones DATE = (
        SELECT
            TOP 1
            DATEFROMPARTS(YEAR(ISNULL(DATEADD(YEAR, 1, ultimasVacaciones), fechaIngreso)), MONTH(fechaIngreso), DAY(fechaIngreso))
        FROM
            tContrato ctt
            LEFT JOIN tVacacion vcc ON vcc.codEmpleado = ctt.codEmpleado AND DATEADD(YEAR, 1, vcc.ultimasVacaciones) > ctt.fechaIngreso AND vcc.vigente = 1
        WHERE
            noContract = @noContract
        ORDER BY
            YEAR(ultimasVacaciones) DESC
    );

    -- Calcular vacaciones proporcionales
    DECLARE @vacaciones_proporcionales DECIMAL(10, 4) = (
        SELECT
            TOP 1
            CASE 
                WHEN ISNULL(DATEDIFF(DAY, DATEADD(YEAR, 1, ultimasVacaciones), @fecha_calculo), DATEDIFF(DAY, fechaIngreso, @fecha_calculo)) / 364 > 0 
                THEN ((@salario_ordinario + @salario_extraordinario) / 30) * (ISNULL(DATEDIFF(DAY, DATEADD(YEAR, 1, @ultimas_vacaciones), @fecha_calculo) + 1, @dias_laborados + 1)) * 0.0410958904109589
                ELSE ((@salario_ordinario + @salario_extraordinario) / 30) * (ISNULL(DATEDIFF(DAY, @ultimas_vacaciones, @fecha_calculo) + 1, @dias_laborados + 1)) * 0.0410958904109589
            END
        FROM
            tContrato ctt
            LEFT JOIN tVacacion vcc ON vcc.codEmpleado = ctt.codEmpleado AND DATEADD(YEAR, 1, vcc.ultimasVacaciones) > ctt.fechaIngreso AND vcc.vigente = 1
        WHERE
            noContract = @noContract
        ORDER BY
            YEAR(ultimasVacaciones) DESC
    );

    -- Calcular el pasivo total
    SELECT 
        @indemnizacion AS indemnizacion,
        @aguinaldo AS aguinaldo,
        @bono_catorce AS bono_catorce,
        @vacaciones_pendientes AS vacaciones_pendientes,
        @vacaciones_proporcionales AS vacaciones_proporcionales,
        @indemnizacion + @aguinaldo + @bono_catorce + @vacaciones_pendientes + @vacaciones_proporcionales AS total,
        (@indemnizacion + @aguinaldo + @bono_catorce + @vacaciones_pendientes + @vacaciones_proporcionales) * 0.75 AS pasivo;
END;
GO
