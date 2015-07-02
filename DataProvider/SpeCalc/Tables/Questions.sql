CREATE TABLE [dbo].[Questions]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [manager_sid] VARCHAR(46) NOT NULL, 
    [date_limit] DATETIME NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [descr] NVARCHAR(MAX) NULL, 
    [id_que_state] INT NULL
)
