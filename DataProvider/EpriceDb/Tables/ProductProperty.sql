CREATE TABLE [dbo].[ProductProperty] (
    [IdProduct]              INT            NOT NULL,
    [Provider]               INT            NOT NULL,
    [IdPropertyProvider]     VARCHAR (100)  NOT NULL,
    [IdPropertyProviderType] INT            NOT NULL,
    [Name]                   NVARCHAR (200) NOT NULL,
    [Value]                  NVARCHAR (500) NOT NULL,
    CONSTRAINT [FK_ProductProperty_Product] FOREIGN KEY ([IdProduct]) REFERENCES [dbo].[Product] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

