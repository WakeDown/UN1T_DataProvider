CREATE TABLE [dbo].[TenderClaimFiles]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [IdClaim] INT NOT NULL,
	fileDATA varbinary(max) filestream NOT NULL, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    fileGUID uniqueidentifier default newid() unique rowguidcol not null, 
    [fileName] NVARCHAR(500) NOT NULL
)
