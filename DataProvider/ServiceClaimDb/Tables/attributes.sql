CREATE TABLE [dbo].[attributes]
(
    [sys_name] NVARCHAR(50) NOT NULL, 
    [value] NVARCHAR(50) NOT NULL, 
    CONSTRAINT [PK_attributes] PRIMARY KEY ([sys_name])
)

GO