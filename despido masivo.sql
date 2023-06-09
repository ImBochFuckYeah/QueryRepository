DECLARE @codEmpleado INT
DECLARE @contrato INT
DECLARE @codDepto INT
DECLARE @nomPuesto nvarchar(250)
DECLARE @fechaIngreso date ='2023-01-01'
DECLARE @salarioOrdinario decimal(12,2)
DECLARE @bonifDecreto decimal(12,2)
DECLARE @bonifExtra decimal(12,2)
DECLARE @salarioMensual decimal(12,2)
DECLARE @tipoPago nvarchar(250)
DECLARE @departLab int
DECLARE @muniLab int
DECLARE @tipoContract nvarchar(250)
DECLARE @timeContract nvarchar(250)
DECLARE @jornadaLab nvarchar(250)
DECLARE @codEmpresa int 
DECLARE @comentario nvarchar(250)=''
DECLARE @motivRetiro nvarchar(250)=''
DECLARE @recontratable int =1
DECLARE @finContract date= NULL
DECLARE @activo int =1
DECLARE @constanciaRetension decimal(12,2)
DECLARE @idLoteBancario int
DECLARE @idLiquidacionIgss int
DECLARE @codCentroTrabajoIgss int
DECLARE @codOcupacionIgss int
DECLARE @creadoPor int =266
DECLARE @modificadoPor int =NULL
DECLARE @ocupacion nvarchar(250)

DECLARE C CURSOR
	FOR SELECT codEmpleado,noContract,codDepto,nomPuesto,salarioOrdinario,bonifDecreto,bonifExtra,salarioMensual,tipoPago,departLab,muniLab,tipoContract,timeContract,jornadaLab,codEmpresa,constanciaRetension,idLoteBancario,idLiquidacionIGSS,codCentroTrabajoIGSS,codOcupacionIGSS,ocupacion FROM tContrato WHERE ACTIVO=1 AND codEmpresa=1 AND codEmpleado IN (636,818,310,522,988,2908,3821,3824,3825,3829,3830,3831,3834,3861,3865,3866,3867,3886,3896,3899,3900,3904,3905,3906,3927,3956,3962) and fechaIngreso < @fechaIngreso
OPEN C
FETCH C INTO @codEmpleado,@contrato,@codDepto,@nomPuesto,@salarioOrdinario,@bonifDecreto,@bonifExtra,@salarioMensual,@tipoPago,@departLab,@muniLab,@tipoContract,@timeContract,@jornadaLab,@codEmpresa,@constanciaRetension,@idLoteBancario,@idLiquidacionIgss,@codCentroTrabajoIgss,@codOcupacionIgss,@ocupacion
	WHILE (@@FETCH_STATUS=0)
	BEGIN
	UPDATE tContrato SET activo=0, finContract='2022-12-31', motivRetiro='DESPIDO/REORGANIZACION', comentario='DESPIDO/REORGANIZACION 31/12/2022' WHERE codEmpleado = @codEmpleado AND noContract=@contrato AND activo=1
	INSERT INTO tcontrato (codEmpleado,codDepto,nomPuesto,fechaIngreso,salarioOrdinario,bonifDecreto,bonifExtra,salarioMensual,tipoPago,departLab,muniLab,tipoContract,timeContract,jornadaLab,comentario,motivRetiro,recontratable,codEmpresa,finContract,activo,constanciaRetension,idLoteBancario,idLiquidacionIGSS,codCentroTrabajoIGSS,codOcupacionIGSS,creadoPor,modificadoPor,ocupacion)
	              VALUES(@codEmpleado,@codDepto,@nomPuesto,@fechaIngreso,@salarioOrdinario,@bonifDecreto,@bonifExtra,@salarioMensual,@tipoPago,@departLab,@muniLab,@tipoContract,@timeContract,@jornadaLab,@comentario,@motivRetiro,@recontratable,@codEmpresa,@finContract,@activo,@constanciaRetension,@idLoteBancario,@idLiquidacionIgss,@codCentroTrabajoIgss,@codOcupacionIgss,@creadoPor,@modificadoPor,@ocupacion)
	UPDATE tEmpleado SET noContract=(SELECT noContract FROM tContrato WHERE CODEMPLEADO = @codEmpleado AND activo=1) WHERE codEmpleado=@codEmpleado
	FETCH C INTO @codEmpleado,@contrato,@codDepto,@nomPuesto,@salarioOrdinario,@bonifDecreto,@bonifExtra,@salarioMensual,@tipoPago,@departLab,@muniLab,@tipoContract,@timeContract,@jornadaLab,@codEmpresa,@constanciaRetension,@idLoteBancario,@idLiquidacionIgss,@codCentroTrabajoIgss,@codOcupacionIgss,@ocupacion
	END
CLOSE C
DEALLOCATE C


--SELECT codEmpleado,noContract,codDepto,nomPuesto,salarioOrdinario,bonifDecreto,bonifExtra,salarioMensual,tipoPago,departLab,muniLab,tipoContract,timeContract,jornadaLab,codEmpresa,constanciaRetension,idLoteBancario,idLiquidacionIGSS,codCentroTrabajoIGSS,codOcupacionIGSS,ocupacion FROM tContrato WHERE ACTIVO=0 and finContract='2022-12-31' AND codEmpresa=2 AND codEmpleado IN (1168,1172,1243,1272,1353,1372,3448,3828,3848,3850,3862,3868,3892,3898,3901,3902,3922,3924,3926,3950,3964,3965) order by codEmpleado
--SELECT codEmpleado,noContract,codDepto,nomPuesto,salarioOrdinario,bonifDecreto,bonifExtra,salarioMensual,tipoPago,departLab,muniLab,tipoContract,timeContract,jornadaLab,codEmpresa,constanciaRetension,idLoteBancario,idLiquidacionIGSS,codCentroTrabajoIGSS,codOcupacionIGSS,ocupacion FROM tContrato WHERE ACTIVO=1 and finContract is null AND codEmpresa=2 AND codEmpleado IN (1168,1172,1243,1272,1353,1372,3448,3828,3848,3850,3862,3868,3892,3898,3901,3902,3922,3924,3926,3950,3964,3965) order by codEmpleado


