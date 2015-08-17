CREATE TABLE [dbo].[catalog_products]
(
    [name] NVARCHAR(MAX) NOT NULL, 
    [price] DECIMAL(10, 2) NOT NULL DEFAULT 0, 
    [id_currency] INT NOT NULL DEFAULT 1, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [part_number] NVARCHAR(50) NOT NULL DEFAULT '', 
    [id] NVARCHAR(50) NOT NULL, 
    [sid] BIGINT NOT NULL  IDENTITY, 
    [sid_cat] BIGINT NOT NULL, 
    [vendor] NVARCHAR(500) NOT NULL, 
    [currency_str] NVARCHAR(20) NULL, 
    CONSTRAINT [PK_catalog_products] PRIMARY KEY ([sid]) 
)
