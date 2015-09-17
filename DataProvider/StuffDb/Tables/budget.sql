CREATE TABLE [dbo].[budget]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [name] NVARCHAR(500) NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [order_num] INT NOT NULL DEFAULT 500, 
    [descr] NVARCHAR(MAX) NULL, 
    [deleter_sid] VARCHAR(46) NULL, 
    [id_parent] INT NULL
)
