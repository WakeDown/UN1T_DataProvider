CREATE TABLE [dbo].[mobile_users]
(
id int not null PRIMARY KEY IDENTITY,
	[sid] VARCHAR(46) NOT NULL  DEFAULT newid(), 
    [login] NVARCHAR(50) NOT NULL, 
    [password] NVARCHAR(50) NOT NULL, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333'
)

GO