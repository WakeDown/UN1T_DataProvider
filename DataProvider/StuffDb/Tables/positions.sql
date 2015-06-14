﻿CREATE TABLE [dbo].[positions]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [name] NVARCHAR(50) NOT NULL, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [order_num] INT NOT NULL DEFAULT 500
)
