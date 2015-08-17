CREATE TABLE [dbo].[Stock] (
    [IdProduct]  INT             NOT NULL,
    [Currency]   INT             NOT NULL,
    [Location]   INT             NOT NULL,
    [Value]      INT             NOT NULL,
    [Price]      DECIMAL (18, 2) NOT NULL,
    [Provider]   INT             NOT NULL,
    [RecordDate] DATETIME2 (7)   NOT NULL,
    CONSTRAINT [FK_Stock_Product] FOREIGN KEY ([IdProduct]) REFERENCES [dbo].[Product] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

