CREATE TABLE [dbo].[classifier_categories]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_parent] INT NOT NULL, 
    [name] NVARCHAR(4000) NOT NULL, 
    [number] NVARCHAR(20) NOT NULL, 
    [complexity] INT NULL, 
	[descr] NVARCHAR(MAX) NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [creator_sid] NVARCHAR(46) NOT NULL DEFAULT ''
)
