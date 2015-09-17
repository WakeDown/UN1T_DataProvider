CREATE TABLE [dbo].[client_access]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_client_etalon] INT NULL, 
    [login] NVARCHAR(50) NOT NULL, 
    [password] NVARCHAR(500) NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [zip_access] BIT NOT NULL DEFAULT 0, 
    [counter_access] BIT NOT NULL DEFAULT 0, 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [deleter_sid] VARCHAR(46) NULL, 
    [ad_sid] VARCHAR(46) NULL, 
    [name] NVARCHAR(500) NULL, 
    [full_name] NVARCHAR(500) NULL
)
