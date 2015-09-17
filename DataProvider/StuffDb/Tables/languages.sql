CREATE TABLE [dbo].[languages]
(
	[id] INT NOT NULL PRIMARY KEY, 
    [name] NVARCHAR(50) NOT NULL, 
    [order_num] INT NOT NULL DEFAULT 500
)
