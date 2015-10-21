CREATE TABLE [dbo].[mobile_cames]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [device_serial_num] NVARCHAR(20) NOT NULL, 
    [id_device] INT NULL, 
    [device_model] NVARCHAR(150) NULL, 
    [city] NVARCHAR(150) NULL, 
    [address] NVARCHAR(150) NULL, 
    [client_name] NVARCHAR(150) NULL, 
    [id_work_type] INT NULL, 
    [counter_mono] BIGINT NULL, 
    [counter_color] BIGINT NULL, 
    [counter_total] BIGINT NULL, 
    [descr] NVARCHAR(MAX) NULL, 
    [specialist_sid] VARCHAR(46) NOT NULL, 
    [date_create] DATETIME NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [creator_sid] VARCHAR(46) NOT NULL
)
