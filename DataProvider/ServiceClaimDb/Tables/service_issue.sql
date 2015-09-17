CREATE TABLE [dbo].[service_issue]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_claim] INT NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [date_plan] DATETIME NULL, 
    [specialist_sid] VARCHAR(46) NULL, 
    [descr] NVARCHAR(MAX) NULL, 
    [creator_sid] VARCHAR(46) NOT NULL
)
