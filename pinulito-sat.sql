-- Tabla para la información de certificación
CREATE TABLE dte_certificacion (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nit_certificador NVARCHAR(20) NOT NULL,
    nombre_certificador NVARCHAR(200),
    numero NVARCHAR(20) NOT NULL,
    serie NVARCHAR(20) NOT NULL,
    numero_autorizacion NVARCHAR(100) NOT NULL,
    fecha_hora_certificacion DATETIME,
    creadoPor INT,
    creadoEl DATETIME DEFAULT GETDATE()
    CONSTRAINT uc_certificacion UNIQUE (numero, serie, numero_autorizacion)
);

-- Tabla para almacenar la información del SAT y DTE
CREATE TABLE sat (
    id INT IDENTITY(1,1) PRIMARY KEY,
    clase_documento NVARCHAR(10) NOT NULL,
    CONSTRAINT uc_sat UNIQUE (clase_documento)
);

-- Tabla para almacenar la información del emisor
CREATE TABLE emisor (
    id INT IDENTITY(1,1) PRIMARY KEY,
    afiliacion_iva NVARCHAR(10) NOT NULL,
    codigo_establecimiento NVARCHAR(10) NOT NULL,
    correo NVARCHAR(150),
    nit NVARCHAR(15) NOT NULL,
    nombre_comercial NVARCHAR(100),
    nombre NVARCHAR(100),
    direccion NVARCHAR(255),
    codigo_postal NVARCHAR(10),
    municipio NVARCHAR(100),
    departamento NVARCHAR(100),
    pais NVARCHAR(5),
    CONSTRAINT uc_emisor UNIQUE (nit, codigo_establecimiento)
);

-- Tabla para almacenar la información del receptor
CREATE TABLE receptor (
    id INT IDENTITY(1,1) PRIMARY KEY,
    correo NVARCHAR(150),
    nit NVARCHAR(15) NOT NULL,
    nombre NVARCHAR(100),
    direccion NVARCHAR(255),
    codigo_postal NVARCHAR(10),
    municipio NVARCHAR(100),
    departamento NVARCHAR(100),
    pais NVARCHAR(5),
    CONSTRAINT uc_receptor UNIQUE (nit)
);

-- Tabla para las frases
CREATE TABLE frase (
    id INT IDENTITY(1,1) PRIMARY KEY,
    codigo_escenario NVARCHAR(10) NOT NULL,
    tipo_frase NVARCHAR(10) NOT NULL,
    CONSTRAINT uc_frase UNIQUE (codigo_escenario, tipo_frase)
);

CREATE TABLE dte (
    id INT IDENTITY(1,1) PRIMARY KEY,
    sat_id INT FOREIGN KEY REFERENCES sat(id),
    emisor_id INT FOREIGN KEY REFERENCES emisor(id),
    receptor_id INT FOREIGN KEY REFERENCES receptor(id),
    dte_certificacion_id INT FOREIGN KEY REFERENCES dte_certificacion(id),
    codigo_moneda NVARCHAR(5) NOT NULL,
    fecha_hora_emision DATETIME NOT NULL,
    tipo NVARCHAR(10) NOT NULL
);

-- Tabla para las frases
CREATE TABLE dte_frase (
    dte_id INT FOREIGN KEY REFERENCES dte(id),
    frase_id INT FOREIGN KEY REFERENCES frase(id)
    PRIMARY KEY (dte_id, frase_id)
);

-- Tabla para los items (productos o servicios)
CREATE TABLE dte_item (
    id INT IDENTITY(1,1) PRIMARY KEY,
    dte_id INT FOREIGN KEY REFERENCES dte(id),
    bien_o_servicio NVARCHAR(1) NOT NULL,
    numero_linea INT NOT NULL,
    cantidad DECIMAL(18, 2) NOT NULL,
    unidad_medida NVARCHAR(10),
    descripcion NVARCHAR(255),
    precio_unitario DECIMAL(18, 2),
    precio DECIMAL(18, 2),
    descuento DECIMAL(18, 2),
    total DECIMAL(18, 2)
);

-- Tabla para los impuestos
CREATE TABLE dte_item_impuesto (
    dte_item_id INT FOREIGN KEY REFERENCES dte_item(id),
    nombre_corto NVARCHAR(50),
    codigo_unidad_gravable NVARCHAR(10),
    monto_gravable DECIMAL(18, 2),
    monto_impuesto DECIMAL(18, 2),
    PRIMARY KEY (dte_item_id, nombre_corto)
);

-- Índice para la tabla dte_certificacion en el campo numero_autorizacion
CREATE INDEX idx_numero_autorizacion 
ON dte_certificacion (numero_autorizacion);

-- Índice para la tabla emisor en el campo nit
CREATE INDEX idx_emisor_nit 
ON emisor (nit);

-- Índice para la tabla receptor en el campo nit
CREATE INDEX idx_receptor_nit 
ON receptor (nit);

-- Eliminar tabla de impuestos
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dte_item_impuesto]') AND type in (N'U'))
DROP TABLE [dbo].[dte_item_impuesto]
GO

-- Eliminar tabla de detalle
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dte_item]') AND type in (N'U'))
DROP TABLE [dbo].[dte_item]
GO

-- Eliminar tabla de frases de detalle
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dte_frase]') AND type in (N'U'))
DROP TABLE [dbo].[dte_frase]
GO

-- Eliminar tabla de encabezado
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dte]') AND type in (N'U'))
DROP TABLE [dbo].[dte]
GO

-- Eliminar tabla de frase
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[frase]') AND type in (N'U'))
DROP TABLE [dbo].[frase]
GO

-- Eliminar tabla de receptor
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[receptor]') AND type in (N'U'))
DROP TABLE [dbo].[receptor]
GO

-- Eliminar tabla de emisor
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[emisor]') AND type in (N'U'))
DROP TABLE [dbo].[emisor]
GO

-- Eliminar tabla de tipos de documentos
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sat]') AND type in (N'U'))
DROP TABLE [dbo].[sat]
GO

-- Eliminar tabla de certificacion
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dte_certificacion]') AND type in (N'U'))
DROP TABLE [dbo].[dte_certificacion]
GO