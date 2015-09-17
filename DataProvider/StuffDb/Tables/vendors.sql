CREATE TABLE [dbo].[vendors]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [name] NVARCHAR(150) NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [deleter_sid] VARCHAR(46) NULL, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [descr] NVARCHAR(MAX) NULL
)
