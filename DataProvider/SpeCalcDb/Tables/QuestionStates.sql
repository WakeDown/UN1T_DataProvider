CREATE TABLE [dbo].[QuestionStates]
(
	[id] INT NOT NULL PRIMARY KEY, 
    [name] NVARCHAR(50) NOT NULL, 
    [sys_name] NVARCHAR(50) NULL, 
    [order_num] INT NOT NULL DEFAULT 500, 
    [enabled] BIT NOT NULL DEFAULT 1
)
