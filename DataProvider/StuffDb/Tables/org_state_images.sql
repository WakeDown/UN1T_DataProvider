CREATE TABLE [dbo].[org_state_images]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_organization] INT NOT NULL,
	data varbinary(max) filestream NOT NULL, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    data_sid uniqueidentifier default newid() unique rowguidcol not null, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333'
)
