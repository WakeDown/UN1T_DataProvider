CREATE TABLE [dbo].[PositionStateHistory]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY, 
    [IdPosition] BIT NOT NULL, 
    [IdState] INT NOT NULL, 
    [DateCreate] DATETIME NOT NULL DEFAULT getdate(), 
    [Creator] VARCHAR(46) NOT NULL
)

GO

CREATE INDEX [IX_PositionStateHistory_IdPositionIdState] ON [dbo].[PositionStateHistory] ([IdPosition], [IdState])

GO
