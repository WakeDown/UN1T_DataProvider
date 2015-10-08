CREATE TABLE [dbo].[service_sheet]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [process_enabled] BIT NOT NULL , 
    [device_enabled] BIT NOT NULL , 
    [zip_claim] BIT NULL , 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [counter_mono] BIGINT NULL, 
    [counter_color] BIGINT NULL, 
    [zip_claim_number] NVARCHAR(50) NULL, 
    [counter_total] BIGINT NULL, 
    [no_counter] BIT NOT NULL DEFAULT 0, 
    [descr] NVARCHAR(MAX) NULL, 
    [counter_unavailable] BIT NULL , 
    [counter_descr] NVARCHAR(MAX) NULL, 
    [admin_sid] VARCHAR(46) NULL, 
    [engeneer_sid] VARCHAR(46) NULL, 
    [id_service_issue] INT NOT NULL, 
    [id_claim] INT NOT NULL, 
    [time_on_work_minutes] INT NULL    
)
