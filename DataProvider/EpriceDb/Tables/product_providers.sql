CREATE TABLE [dbo].[product_providers]
(
	[id] INT NOT NULL PRIMARY KEY, 
    [name] NVARCHAR(50) NOT NULL, 
    [sys_name] NVARCHAR(20) NOT NULL, 
    [enabled] BIT NOT NULL DEFAULT 1
)
