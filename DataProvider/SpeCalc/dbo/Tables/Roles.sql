CREATE TABLE [dbo].[Roles] (
    [Id]        INT            NOT NULL,
    [GroupId]   NVARCHAR (500) NOT NULL,
    [GroupName] NVARCHAR (500) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

