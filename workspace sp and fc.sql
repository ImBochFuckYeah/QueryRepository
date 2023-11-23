use pinulito_nomina

select top 1 * from tContrato;

/*
tContrato:
-noContract
-codEmpleado
-codDepto
-nomPuesto
-fechaIngreso
-salarioOrdinario
-bonifDecreto
-bonifExtra
-salarioMensual
-tipoPago
-departLab
-muniLab
-tipoContract
-timeContract
-jornadaLab
-comentario
-motivRetiro
-recontratable
-codEmpresa
-finContract
-activo
-constanciaRetension
-idLoteBancario
-idLiquidacionIGSS
-codCentroTrabajoIGSS
-codOcupacionIGSS
-creadoPor
-modificadoPor
-ocupacion
*/

select top 1 * from tPeriodo;

/*
tPeriodo:
-idPeriodo
-nombrePeriodo
-fechaInicio
-fechaFin
-pagada
-noQuincena
-activo
*/

select top 1 * from tPlanilla;

/*
tPlanilla:
-idPlanilla
-idEmpresa
-idPeriodo
-codEmpleado
-departamento
-codigo
-empleado
-salarioMensual
-ordinario
-diasLaborados
-hSimples
-hDobles
-sSimples
-sDobles
-bonifDecreto
-otrosIngresos
-neto
-igss
-isr
-seguro
-ahorro
-otrosDescuentos
-liquido
-comentarios
-anticipos
*/

DROP PROCEDURE CalcularTotalAhorro;

EXEC CalcularTotalAhorro @CodigoEmpleado = 4495;

DROP FUNCTION IF EXISTS dbo.CalcularTotalAhorroFuncion;

SELECT dbo.CalcularTotalAhorro(4475) AS TotalAhorro;

EXEC HistorialAhorro_Empleado @CodigoEmpleado = 4403;