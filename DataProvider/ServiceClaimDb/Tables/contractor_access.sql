CREATE TABLE [dbo].[contractor_access]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [ad_sid] VARCHAR(46) NULL, 
    [login] NVARCHAR(50) NOT NULL, 
    [password] NVARCHAR(500) NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [deleter_sid] VARCHAR(46) NULL, 
    [name] NVARCHAR(500) NOT NULL, 
    [org_name] NVARCHAR(500) NULL, 
    [city] NVARCHAR(500) NULL, 
    [org_sid] VARCHAR(46) NULL, 
    [email] NVARCHAR(50) NULL
)
