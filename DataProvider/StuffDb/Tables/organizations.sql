CREATE TABLE [dbo].[organizations]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [name] NVARCHAR(50) NOT NULL,      
	[enabled] BIT NOT NULL DEFAULT 1,
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [display_in_list] BIT NOT NULL DEFAULT 1, 
    [full_name] NVARCHAR(500) NULL, 
    [order_num] INT NOT NULL DEFAULT 500, 
    [creator_sid] VARCHAR(46) NULL
)
