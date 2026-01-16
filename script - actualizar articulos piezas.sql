USE PINULITO_PDV;
-- 
DROP TABLE dbo.tProductoPiezas;
-- 
CREATE TABLE dbo.tProductoPiezas (
    FatherItemCode NVARCHAR(50),
    FatherItemName NVARCHAR(255),
    ChildItemCode NVARCHAR(50),
    ChildItemName NVARCHAR(255),
    Quantity DECIMAL(18,4)
);
-- 
TRUNCATE TABLE dbo.tProductoPiezas;
-- 
INSERT INTO dbo.tProductoPiezas
SELECT FatherItemCode = otm.ItemCode,
    FatherItemName = otm.ItemName,
    ChildItemCode = oit.ItemCode,
    ChildItemName = oit.ItemName,
    itt.Quantity
FROM [DB_CORPORACION_21].[dbo].[ITT1] itt
JOIN [DB_CORPORACION_21].[dbo].[OITM] otm ON itt.Father = otm.ItemCode
JOIN [DB_CORPORACION_21].[dbo].[OITM] oit ON itt.Code = oit.ItemCode
WHERE itt.Code IN ('010106', '010107')
-- 
UNION
SELECT 
    '010106',
    'POLLO SURTIDO',
    '010106',
    'POLLO SURTIDO',
    1;