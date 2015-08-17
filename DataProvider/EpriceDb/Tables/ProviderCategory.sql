CREATE TABLE [dbo].[ProviderCategory] (
    [Id]             NVARCHAR (100) NOT NULL,
    [IdType]         INT            NOT NULL,
    [IdParent]       NVARCHAR (100) NOT NULL,
    [IdParentType]   INT            NOT NULL,
    [Provider]       INT            NOT NULL,
    [IdUN1TCategory] INT            NOT NULL,
    CONSTRAINT [FK_ProviderCategory_UN1TCategory] FOREIGN KEY ([IdUN1TCategory]) REFERENCES [dbo].[UN1TCategory] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

