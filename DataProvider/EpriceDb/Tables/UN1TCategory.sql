CREATE TABLE [dbo].[UN1TCategory] (
    [Id]       INT            NOT NULL,
    [IdParent] INT            NOT NULL,
    [NAME]     NVARCHAR (250) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

