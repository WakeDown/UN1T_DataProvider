CREATE TABLE [dbo].[positions]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [name] NVARCHAR(500) NOT NULL, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [order_num] INT NOT NULL DEFAULT 500, 
    [creator_sid] VARCHAR(46) NULL, 
    [name_rod] NVARCHAR(500) NULL, 
    [name_dat] NVARCHAR(500) NULL, 
    [sys_name] NVARCHAR(50) NULL 
)
