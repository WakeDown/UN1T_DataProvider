CREATE TABLE [dbo].[work_types]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_parent] INT NOT NULL , 
    [name] NVARCHAR(1500) NOT NULL, 
    [sys_name] NVARCHAR(20) NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [creator_sid] VARCHAR(46) NULL, 
    [order_num] INT NOT NULL DEFAULT 500, 
    [zip_install] BIT NOT NULL DEFAULT 0, 
    [zip_order] BIT NOT NULL DEFAULT 0
)
