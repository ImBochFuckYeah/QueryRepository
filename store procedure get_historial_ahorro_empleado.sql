ALTER PROCEDURE HistorialAhorro_Empleado
    @CodigoEmpleado INT
AS
BEGIN
    SELECT 
        tPeriodo.nombrePeriodo,
        CASE 
            WHEN tPlanilla.ahorro = 25 THEN 'Ahorro'
            WHEN tPlanilla.ahorro = 125 THEN 'Cuota Inicial'
            WHEN tPlanilla.ahorro = 250 THEN 'Cuota Inicial'
            ELSE 'Aportacion'
        END AS TipoAhorro,
        tPlanilla.ahorro
    FROM 
        tPlanilla
    INNER JOIN 
        tPeriodo ON tPlanilla.idPeriodo = tPeriodo.idPeriodo
    WHERE 
        tPlanilla.codEmpleado = @CodigoEmpleado
        AND tPlanilla.ahorro > 0
    ORDER BY 
        tPeriodo.fechaInicio ASC;
END;