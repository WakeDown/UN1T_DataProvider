CREATE TABLE [dbo].[claim_states]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [name] NVARCHAR(50) NOT NULL, 
    [sys_name] NVARCHAR(20) NOT NULL, 
    [order_num] INT NOT NULL DEFAULT 500, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [background_color] NVARCHAR(50) NULL, 
    [foreground_color] NVARCHAR(50) NULL, 
    [is_end] BIT NOT NULL DEFAULT 0, 
    [filter_display] BIT NOT NULL DEFAULT 1, 
    [id_state_group] INT NULL 
)
