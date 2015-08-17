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
    [deleter_sid] VARCHAR(46) NULL 
)

GO

CREATE INDEX [IX_service_claims_enabled] ON [dbo].[claims] ([enabled] DESC)

GO

CREATE INDEX [IX_service_claims_id_admin] ON [dbo].[claims] ([id_admin])

GO

CREATE INDEX [IX_service_claims_id_engeneer] ON [dbo].[claims] ([id_engeneer])
