USE [PINULITO_NOMINA]
GO
/****** Object:  StoredProcedure [dbo].[spCalcularPlanilla]    Script Date: 22/11/2023 12:26:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/* EL CONTRATO SE FINALIZA, SE COLOCA FECHA FIN  Y ACTIVO 0 PERO NO SE DESVINCULA HASTA QUE 
  SE HAYA PAGADO LA LIQUIDACION */

/* Contrato tiene Cod Empleado y Empleado tiene noContrato, cual es el real?? */

/* El primer paso es generar descuentos de IGSS */

/* Agregar Campo a descuentos de si aparecen en boleta o solo se muestra como OtrosDescuentos */

/* Salario mensual es automatico?? salario ordinario + bonif decreto*/

/* No se puede guardar cambios a contrato */

/* Al colocar un ingreso extra indica que generara una solicitud */



--Inicia consulta para generar nomina en un periodo establecido



ALTER PROCEDURE [dbo].[spCalcularPlanilla] @idPeriodo as int, @codEmpresa as int
AS

DECLARE @fechaInicio date, 
		@fechaFin date, 
		@dias int, 
		@nombrePeriodo varchar(64);

SELECT @nombrePeriodo = nombrePeriodo, 
	   @fechaInicio = fechaInicio, 
	   @fechaFin = fechaFin, 
	   @dias = DATEDIFF(DAY, fechaInicio, fechaFin) + 1
	FROM tPeriodo WHERE idPeriodo = @idPeriodo

	DELETE tPlanillaTemporal WHERE idPeriodo = @idPeriodo AND idEmpresa = @codEmpresa

	INSERT INTO tPlanillaTemporal (idEmpresa, idPeriodo, codEmpleado, departamento, codigo, empleado, salarioMensual, 
	bonifDecreto, diasLaborados, hSimples, hDobles, otrosIngresos, otrosDescuentos, ahorro)  
SELECT  
		@codEmpresa as idEmpresa, @idPeriodo as idPeriodo, t0.codEmpleado, t2.nombre as departamento, aliasCodigo as codigo, nombreEmpleado + ' ' + isnull(segundoNombre,'') + ' ' + apellidoEmpleado 
		+ ' ' + isnull(segundoApellido,'') + ' ' + isnull(apellidoCasada,'') as Empleado,
		salarioOrdinario as salarioMensual, t1.bonifDecreto, diasLaborados = dbo.fnDiasLaborados(@fechaInicio, @fechaFin, @dias, t1.fechaIngreso, t1.finContract, t0.codEmpleado), 
		isnull((SELECT sum(cantidadHoras) FROM tHoraExtra WHERE vigente = 1 AND tipoHora = 'S' AND idPeriodo = @idPeriodo AND codEmpleado = t1.codEmpleado),0) as hSimple, 
		isnull((SELECT sum(cantidadHoras) FROM tHoraExtra WHERE vigente = 1 AND tipoHora = 'D' AND idPeriodo = @idPeriodo AND codEmpleado = t1.codEmpleado),0) as hDoble,
		isnull((SELECT sum(montoIngreso) FROM tIngreso WHERE vigente = 1 AND idPeriodo = @idPeriodo AND codEmpleado = t1.codEmpleado),0) as otrosIngresos,
		isnull((SELECT sum(montoDescuento) FROM tDescuento WHERE idTipoDescuento not in (6) AND vigente = 1 AND idPeriodo = @idPeriodo AND codEmpleado = t1.codEmpleado AND isnull(idPlanilla,0) = 0),0) +
		isnull((SELECT sum(montoDescuento) FROM tDescuentoRecurrente WHERE idTipoDescuento<>6 AND  vigente = 1 AND codEmpleado = t1.codEmpleado),0) as descuentos,
		CASE WHEN isnull((SELECT sum(montoDescuento) FROM tDescuentoRecurrente WHERE idTipoDescuento=6 AND  vigente = 1 AND codEmpleado = t1.codEmpleado),0)>0
			THEN isnull((SELECT sum(montoDescuento) FROM tDescuentoRecurrente WHERE idTipoDescuento=6 AND  vigente = 1 AND codEmpleado = t1.codEmpleado),0)
			ELSE isnull((SELECT sum(montoDescuento) FROM tDescuento WHERE idTipoDescuento in (6) AND vigente = 1 AND idPeriodo = @idPeriodo AND codEmpleado = t1.codEmpleado AND isnull(idPlanilla,0) = 0),0) END as ahorro
	FROM tEmpleado t0
	INNER JOIN tContrato t1 ON t0.noContract = t1.noContract
	INNER JOIN tDepartamento t2 ON t1.codDepto = t2.codDepto
	WHERE (t1.finContract is null OR t1.finContract >= @fechaInicio OR t1.finContract = '1900-01-01') AND t1.fechaIngreso <= @fechaFin 
	AND t1.codEmpresa = @codEmpresa --AND t1.activo = 1
	 
	 INSERT INTO tMensajeError VALUES('SE GENERO LA PLANILLA ' + CAST(@idPeriodo as varchar));

	 SELECT * FROM tPlanillaTemporal WHERE idPeriodo = @idPeriodo AND idEmpresa = @codEmpresa ORDER BY departamento ASC, codigo ASC
--Fin de consulta para generar nomina