﻿CREATE TABLE [dbo].[claim2claim_states]
(
	[id] BIGINT NOT NULL PRIMARY KEY IDENTITY, 
    [id_claim] INT NOT NULL, 
    [id_claim_state] INT NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [descr] NVARCHAR(MAX) NULL, 
    [specialist_sid] VARCHAR(46) NULL, 
    [id_work_type] INT NULL, 
    [id_service_sheet] INT NULL, 
    [id_zip_claim] INT NULL
)
