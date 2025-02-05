CREATE TABLE OrdenVenta (
    id INT IDENTITY(1,1) PRIMARY KEY,
    company NVARCHAR(10) NOT NULL,
    card_code NVARCHAR(10) NOT NULL,
    doc_date DATE NOT NULL,
    doc_due_date DATE NOT NULL,
    comments NVARCHAR(550),
    doc_series INT NOT NULL,
    create_at DATETIME NOT NULL DEFAULT GETDATE(),
    U_Cod_tienda NVARCHAR(15),
    U_Usu_Plat INT
);
-- 
CREATE TABLE OrdenVentaDetalle (
    orden_id INT NOT NULL,
    item_code NVARCHAR(20) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (orden_id, item_code),
    FOREIGN KEY (orden_id) REFERENCES OrdenVenta(id) ON DELETE CASCADE
);