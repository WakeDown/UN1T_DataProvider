CREATE TABLE [dbo].[claim_state_groups]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [name] NVARCHAR(50) NOT NULL, 
    [sys_name] NVARCHAR(50) NULL, 
    [order_num] INT NOT NULL DEFAULT 500
)
