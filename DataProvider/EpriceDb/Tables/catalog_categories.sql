CREATE TABLE [dbo].[catalog_categories]
(
    [id_provider] INT NOT NULL, 
    [name] NVARCHAR(500) NOT NULL, 
    [id] NVARCHAR(50) NOT NULL, 
    [id_parent] NVARCHAR(50) NOT NULL DEFAULT '', 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [sid] BIGINT NOT NULL  IDENTITY, 
    CONSTRAINT [PK_catalog_categories] PRIMARY KEY ([sid])
)

GO

CREATE INDEX [IX_catalog_categories_enabled] ON [dbo].[catalog_categories] ([enabled] DESC)

GO

CREATE INDEX [IX_catalog_categories_id_provider] ON [dbo].[catalog_categories] ([id_provider])
