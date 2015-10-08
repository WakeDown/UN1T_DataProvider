CREATE TABLE [dbo].[claims]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [sid] VARCHAR(46) NOT NULL DEFAULT newid(), 
    [id_contractor] INT NULL, 
    [id_contract] INT NULL, 
    [id_device] INT NULL, 
    [contractor_name] NVARCHAR(500) NULL, 
    [contract_number] NVARCHAR(150) NULL, 
    [device_name] NVARCHAR(500) NULL, 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [id_admin] INT NULL, 
    [id_engeneer] INT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [id_claim_state] INT NOT NULL, 
    [deleter_sid] VARCHAR(46) NULL, 
    [id_work_type] INT NOT NULL DEFAULT 0, 
    [specialist_sid] VARCHAR(46) NULL, 
    [date_state_change] DATETIME NOT NULL DEFAULT getdate(), 
    [client_sd_num] NVARCHAR(50) NULL, 
    [changer_sid] VARCHAR(46) NULL, 
    [cur_engeneer_sid] VARCHAR(46) NULL, 
    [cur_admin_sid] VARCHAR(46) NULL, 
    [cur_tech_sid] VARCHAR(46) NULL, 
    [cur_manager_sid] VARCHAR(46) NULL, 
    [serial_num] VARCHAR(150) NULL, 
    [cur_service_issue_id] INT NULL, 
    [id_service_came] INT NULL 
)

GO

CREATE INDEX [IX_service_claims_enabled] ON [dbo].[claims] ([enabled] DESC)

GO

CREATE INDEX [IX_service_claims_id_admin] ON [dbo].[claims] ([id_admin])

GO

CREATE INDEX [IX_service_claims_id_engeneer] ON [dbo].[claims] ([id_engeneer])
