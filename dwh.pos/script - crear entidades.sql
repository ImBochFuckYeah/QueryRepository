CREATE SCHEMA IF NOT EXISTS pos AUTHORIZATION current_user;
-- 
DROP TABLE IF EXISTS pos.tienda;
-- 
CREATE TABLE IF NOT EXISTS pos.tienda (
    id_tienda INT PRIMARY KEY,
    codigo_empresa VARCHAR(50) NOT NULL,
    codigo_tienda VARCHAR(50) NOT NULL,
    nombre VARCHAR(250) NOT NULL,
    direccion VARCHAR(550) NOT NULL,
    altitud VARCHAR(50),
    latitud VARCHAR(50),
    numero_telefono VARCHAR(10),
    departamento VARCHAR(100),
    municipio VARCHAR(100),
    numero_establecimiento_sat INT,
    codigo_centro_costo_sap VARCHAR(50),
    codigo_almacen_sap VARCHAR(50),
    codigo_cliente_sap VARCHAR(50),
    division INT NOT NULL,
    supervisor_id INT
);
-- 
DROP TABLE IF EXISTS pos.supervisor;
-- 
CREATE TABLE IF NOT EXISTS pos.supervisor (
    id_supervisor INT PRIMARY KEY,
    codigo_interno VARCHAR(50) NOT NULL,
    nombre VARCHAR(250) NOT NULL,
    sexo VARCHAR(50) NOT NULL,
    numero_documento_identificacion VARCHAR(150) NOT NULL,
    numero_telefono VARCHAR(10),
	division INT NOT NULL
);
-- 
DROP TABLE IF EXISTS pos.encabezado_venta;
-- 
CREATE TABLE IF NOT EXISTS pos.encabezado_venta (
    id_encabezado_venta BIGINT PRIMARY KEY,
    codigo_empresa VARCHAR(10) NOT NULL,
    codigo_tienda VARCHAR(10) NOT NULL,
    serie_fel VARCHAR(50),
    numero_fel VARCHAR(50),
    uuid_fel VARCHAR(100),
    canal_venta VARCHAR(50) NOT NULL,
    nit_receptor VARCHAR(50),
    total_con_iva DECIMAL(15, 2) NOT NULL,
    fecha_emision DATE NOT NULL,
    uuid_anulacion_fel VARCHAR(100),
    fecha_anulacion_fel DATE,
    dispositivo VARCHAR(50),
    numero_documento_sap INT,
    descripcion_pago VARCHAR(550),
    sincronizado BOOLEAN,
    anulado BOOLEAN,
    identificador_unico_fel VARCHAR(250)
);
-- 
DROP TABLE IF EXISTS pos.detalle_venta;
-- 
CREATE TABLE IF NOT EXISTS pos.detalle_venta (
    id_detalle_venta BIGINT PRIMARY KEY,
    encabezado_venta_id BIGINT NOT NULL,
    sku VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150) NOT NULL,
    cantidad DECIMAL(12, 0) NOT NULL,
    precio DECIMAL(12, 0) NOT NULL,
    total DECIMAL(12, 0) NOT NULL,
    descuento DECIMAL(12, 0) NOT NULL
);
-- 
DROP TABLE IF EXISTS pos.material;
-- 
CREATE TABLE IF NOT EXISTS pos.material (
    id_material SERIAL PRIMARY KEY,
    codigo_producto VARCHAR(50) NOT NULL,
    nombre_producto VARCHAR(250) NOT NULL,
    sku_producto VARCHAR(50),
    codigo_material VARCHAR(50) NOT NULL,
    nombre_material VARCHAR(250) NOT NULL,
    cantidad DECIMAL(12, 2) NOT NULL
);
-- 
DROP TABLE IF EXISTS pos.division;
-- 
CREATE TABLE IF NOT EXISTS pos.division (
    id_division INT PRIMARY KEY,
    nombre VARCHAR(150)
);
-- 
DROP TABLE IF EXISTS pos.meta_divsion;
-- 
CREATE TABLE IF NOT EXISTS pos.meta_divsion (
    numero_division INT NOT NULL,
    descripcion_division VARCHAR(50) NOT NULL,
    año INT NOT NULL,
    mes INT NOT NULL,
    meta_semanal DECIMAL(12, 2),
    meta_mensual DECIMAL(12, 2),
    PRIMARY KEY (numero_division, año, mes)
);
-- 
DROP TABLE IF EXISTS pos.entrada_mercancia;
-- 
CREATE TABLE IF NOT EXISTS pos.entrada_mercancia (
    serie_ticket VARCHAR(50) NOT NULL,
    numero_ticket INT NOT NULL,
    codigo_empresa VARCHAR(50) NOT NULL,
    codigo_tienda VARCHAR(50) NOT NULL,
    fecha_entrada TIMESTAMP NOT NULL,
    numero_documento_sap INT,
    sku_producto_entrada VARCHAR(50) NOT NULL,
    descripcion_producto_entrada VARCHAR(250) NOT NULL,
    unidad_medida_entrada VARCHAR(50) NOT NULL,
    cantidad_entrada DECIMAL(12, 2) NOT NULL,
    sku_producto_equivalente VARCHAR(50) NOT NULL,
    descripcion_producto_equivalente VARCHAR(250) NOT NULL,
    unidad_medida_equivalente VARCHAR(50) NOT NULL,
    unidad_paquete_equivalente VARCHAR(50) NOT NULL,
    precio_unitario_equivalente DECIMAL(12, 2) NOT NULL
);
-- 
DROP TABLE IF EXISTS pos.gasto_tienda;
-- 
CREATE TABLE IF NOT EXISTS pos.gasto_tienda (
    division_tienda INT NOT NULL,
	codigo_empresa VARCHAR(50) NOT NULL,
    codigo_tienda VARCHAR(50) NOT NULL,
	nombre_tienda VARCHAR(250) NOT NULL,
	fecha_ingreso DATE NOT NULL,
	fecha_gasto DATE NOT NULL,
	descripcion_tipo_gasto VARCHAR(500) NOT NULL,
	nit_emisor VARCHAR(100),
	nombre_emisor VARCHAR(550),
	serie_fel VARCHAR(50),
	numero_fel BIGINT,
	uuid_fel VARCHAR(150),
	descripcion_gasto VARCHAR(500),
	precio_unitario DECIMAL(12, 2),
	cantidad DECIMAL(12, 2),
	total DECIMAL(12, 2),
	comentario VARCHAR(500),
	numero_documento_sap INT,
	anulado BOOLEAN NOT NULL,
	codigo_usuario_registro VARCHAR(50),
	nombre_usuario_registro VARCHAR(150)
);
-- 
DROP TABLE IF EXISTS pos.inventario_inicio;
-- 
CREATE TABLE IF NOT EXISTS pos.inventario_inicio (
	tienda_id INT NOT NULL,
	fecha_inventario DATE NOT NULL,
	sku_producto VARCHAR(50) NOT NULL,
	codigo_material VARCHAR(50),
	cantidad_inventario DECIMAL(12, 2) NOT NULL
);
-- 
CREATE SCHEMA IF NOT EXISTS infocorp AUTHORIZATION current_user;
-- 
DROP TABLE IF EXISTS infocorp.ruta_avigua;
-- 
CREATE TABLE IF NOT EXISTS infocorp.ruta_avigua (
    id_ruta_avigua INT NOT NULL,
    codigo_empresa VARCHAR(50) NOT NULL,
    codigo_tienda VARCHAR(50) NOT NULL,
    fecha_ruta_avigua DATE NOT NULL,
    origen_avigua VARCHAR(150) NOT NULL,
    serie_avigua VARCHAR(50) NOT NULL,
    placa_vehiculo VARCHAR(50) NOT NULL,
    conductor_vehiculo VARCHAR(150) NOT NULL,
    despachador_avigua VARCHAR(150) NOT NULL,
    numero_ticket_avigua INT NOT NULL,
    numero_documento_sap INT,
    sku_producto VARCHAR(50) NOT NULL,
    cantidad_producto DECIMAL(12, 2) NOT NULL
);
-- 
CREATE SCHEMA IF NOT EXISTS dividendos AUTHORIZATION current_user;
-- 
DROP TABLE IF EXISTS dividendos.ruta_corporm;
-- 
CREATE TABLE IF NOT EXISTS dividendos.ruta_corporm (
    id_ruta_corporm INT NOT NULL,
    codigo_empresa VARCHAR(50) NOT NULL,
    codigo_tienda VARCHAR(50) NOT NULL,
    fecha_ruta_corporm DATE NOT NULL,
    origen_corporm VARCHAR(150) NOT NULL,
    serie_corporm VARCHAR(50) NOT NULL,
    placa_vehiculo VARCHAR(50) NOT NULL,
    conductor_vehiculo VARCHAR(150) NOT NULL,
    despachador_corporm VARCHAR(150) NOT NULL,
    numero_ticket_corporm INT NOT NULL,
    numero_documento_sap INT,
    sku_producto VARCHAR(50) NOT NULL,
    cantidad_producto DECIMAL(12, 2) NOT NULL
);