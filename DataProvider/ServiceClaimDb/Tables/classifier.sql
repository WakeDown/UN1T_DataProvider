CREATE TABLE [dbo].[classifier]
(
[id] INT NOT NULL PRIMARY KEY IDENTITY,
	[id_category] INT NOT NULL , 
    [id_work_type] INT NOT NULL, 
    [time] INT NOT NULL DEFAULT 0, 
    [price] DECIMAL(10, 2) NOT NULL DEFAULT 0, 
    [cost_people] DECIMAL(10, 2) NOT NULL DEFAULT 0, 
    [cost_company] DECIMAL(10, 2) NOT NULL DEFAULT 0,     
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [creator_sid] NVARCHAR(46) NOT NULL
)
