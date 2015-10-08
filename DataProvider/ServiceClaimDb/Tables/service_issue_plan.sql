CREATE TABLE [dbo].[service_issue_plan]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_service_issue] INT NOT NULL, 
    [id_service_issue_type] INT NOT NULL, 
    [period_start] DATE NOT NULL, 
    [period_end] DATE NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [enabled] INT NOT NULL DEFAULT 1, 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [deleter_sid] VARCHAR(46) NULL
)

GO

CREATE INDEX [IX_service_issue_plan_period_start] ON [dbo].[service_issue_plan] ([period_start] DESC)

GO

CREATE INDEX [IX_service_issue_plan_period_end] ON [dbo].[service_issue_plan] ([period_end] DESC)

GO

CREATE INDEX [IX_service_issue_plan_enabled] ON [dbo].[service_issue_plan] ([enabled] DESC)

GO

CREATE INDEX [IX_service_issue_plan_service_type] ON [dbo].[service_issue_plan] ([id_service_issue_type])
