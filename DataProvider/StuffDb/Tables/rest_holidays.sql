CREATE TABLE [dbo].[rest_holidays]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [employee_sid] VARCHAR(46) NOT NULL, 
    [start_date] DATETIME NOT NULL, 
    [end_date] DATETIME NOT NULL, 
    [duration] INT NOT NULL, 
    [can_edit] BIT NOT NULL DEFAULT 1, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [deleter_sid] NVARCHAR(46) NULL, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [year] INT NULL, 
    [confirmed] BIT NOT NULL DEFAULT 0, 
    [confirmator_sid] VARCHAR(46) NULL, 
    [can_edit_creator_sid] VARCHAR(46) NULL
)
