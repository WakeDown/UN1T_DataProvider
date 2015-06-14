CREATE TABLE [dbo].[employee_states]
(
	[id] INT NOT NULL PRIMARY KEY, 
    [name] NVARCHAR(50) NOT NULL, 
    [sys_name] NVARCHAR(50) NOT NULL, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [display_in_list] BIT NOT NULL DEFAULT 1, 
    [order_num] INT NOT NULL DEFAULT 500
)
