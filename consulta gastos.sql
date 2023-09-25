--TABLA GASTO TOTAL
DECLARE @GastoTotal as TABLE (
	empresa nvarchar(6),
    tienda nvarchar(6),
	noDoc nvarchar(max),
    tipoGasto nvarchar(64),
    descripcion nvarchar (max),
	fecha date,
    monto decimal (10, 2),
    estado nvarchar(64),
    serie nvarchar(100),
    numero nvarchar(max)
) --TABLA RECIBOS
DECLARE @Recibos as TABLE (
	empresa nvarchar(6),
    tienda nvarchar(6),
	noDoc nvarchar(max),
    tipoGasto nvarchar(64),
    descripcion nvarchar (max),
	fecha date,
    monto decimal (10, 2),
    estado nvarchar(64),
    serie nvarchar(100),
    numero nvarchar(max)
) --TABLA FACTURAS
DECLARE @Facturas as TABLE (
	empresa nvarchar(6),
    tienda nvarchar(6),
	noDoc nvarchar(max),
    tipoGasto nvarchar(64),
    descripcion nvarchar (max),
	fecha date,
    monto decimal (10, 2),
    estado nvarchar(64),
    serie nvarchar(100),
    numero nvarchar(max)
) --TABLA RENTAS
DECLARE @Rentas as TABLE (
	empresa nvarchar(6),
    tienda nvarchar(6),
	noDoc nvarchar(max),
    tipoGasto nvarchar(64),
    descripcion nvarchar (max),
	fecha date,
    monto decimal (10, 2),
    estado nvarchar(64),
    serie nvarchar(100),
    numero varchar(max)
) --TABLA VERDURA
DECLARE @Verduras as TABLE (
	empresa nvarchar(6),
    tienda nvarchar(6),
	noDoc nvarchar(max),
    tipoGasto nvarchar(64),
    descripcion nvarchar (max),
	fecha date,
    monto decimal (10, 2),
    estado nvarchar(64),
    serie nvarchar(100),
    numero nvarchar(max)
) --TABLA ENERGIA ELECTICA
DECLARE @EnergiaElectrica as TABLE (
	empresa nvarchar(6),
    tienda nvarchar(6),
	noDoc nvarchar(max),
    tipoGasto nvarchar(64),
    descripcion nvarchar (100),
	fecha date,
    monto decimal (10, 2),
    estado nvarchar(64),
    serie nvarchar(max),
    numero nvarchar(max)
) 

DECLARE @fechaInicio date = '2023-08-01' DECLARE @fechaFin date = '2023-08-31' 

--INSERT INTO TABLE @RECIBOS
INSERT INTO
    @Recibos
SELECT
	T1.empresa as empresa,
	T1.tienda AS tienda,
    idIngresoRecibo,
    'RECIBO' as tipo,
    T2.nombre,
    T1.fecha,
	T1.monto,
    'APLICADO' as estado,
    'N/A' as serie,
    idIngresoRecibo as numero
FROM
    tIngresoRecibo AS T1
    INNER JOIN tTipoRecibo T2 ON T1.idTipoRecibo = T2.idTipoRecibo
WHERE
    fecha between @fechaInicio
    and @fechaFin
    AND t1.vigente = 1
    AND T1.idTipoRecibo ! = 10 

--INSERT INTO TABLE @Facturas
INSERT INTO
    @Facturas
SELECT
	T1.empresa as empresa,
	T1.tienda AS tienda,
    T1.idCompra,
    'FACTURA' as tipo,
    (
        SELECT
            nombre
        FROM
            tCompra
        WHERE
            idCompra = t1.idCompra
    ) as descripcion,
	fechaFactura AS fecha,
    total,
    'APLICADO' as estado,
    T1.serie,
    T1.numero
FROM
    tCompra AS T1
WHERE
    fechaFactura between @fechaInicio
    and @fechaFin
    AND vigente = 1 

--INSERT INTO TABLE @Renta
INSERT INTO
    @Rentas
SELECT
	T1.empresa as empresa,
	T1.tienda AS tienda,
    idAbonoRenta,
    'RENTA',
    'RESERVA RENTA ' + mesRenta,
	fecha,
    monto,
    'APLICADO',
    'N/A' as serie,
    idAbonoRenta as numero
FROM
    tAbonoRenta AS T1
WHERE
    fecha between @fechaInicio
    and @fechaFin
    AND vigente = 1 

--INSERT INTO TABLE @Verdura
INSERT INTO
    @Verduras
SELECT
	T1.empresa as empresa,
	T1.tienda AS tienda,
    idIngresoVerdura,
    'RECIBO VERDURA' as tipo,
    'COMPRA DE VERDURA SIN FACTURA',
	fechaCompra as fecha,
    total,
    'APLICADO',
    'N/A' as serie,
    idIngresoVerdura as numero
FROM
    tIngresoVerdura AS t1
WHERE
    fechaCompra between @fechaInicio
    and @fechaFin 

--INSERT INTO TABLE @EnergiaElectrica
INSERT INTO
    @EnergiaElectrica
SELECT
	T1.empresa as empresa,
	T1.tienda AS tienda,
    idPagoElectricidad,
    'PAGO ELECTRICIDAD',
    'PAGO ENERGIA ' + empresaElectrica,
	fechaPago as fecha,
    montoPago,
    'APLICADO',
    'N/A' as serie,
    idPagoElectricidad as numero
FROM
    tPagoElectricidad AS T1
WHERE
    fechaPago between @fechaInicio
    and @fechaFin

INSERT INTO @GastoTotal
SELECT * FROM @Recibos

INSERT INTO @GastoTotal
SELECT * FROM @Facturas

INSERT INTO @GastoTotal
SELECT * FROM @Rentas

INSERT INTO @GastoTotal
SELECT * FROM @Verduras

INSERT INTO @GastoTotal
SELECT * FROM @EnergiaElectrica

SELECT * FROM @GastoTotal