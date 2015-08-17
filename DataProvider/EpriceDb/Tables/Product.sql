CREATE TABLE [dbo].[Product] (
    [Id]         INT             IDENTITY (1, 1) NOT NULL,
    [IdCategory] INT             NOT NULL,
    [Name]       NVARCHAR (1000) NOT NULL,
    [Vendor]     NVARCHAR (200)  NULL,
    [Brand]      NVARCHAR (200)  NULL,
    [PartNumber] NVARCHAR (100)  NOT NULL,
    [Provider]   INT             NOT NULL,
    [RecordDate] DATETIME2 (7)   NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Product_UN1TCategory] FOREIGN KEY ([IdCategory]) REFERENCES [dbo].[UN1TCategory] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

