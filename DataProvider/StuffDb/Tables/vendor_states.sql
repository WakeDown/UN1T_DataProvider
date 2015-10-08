CREATE TABLE [dbo].[vendor_states]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_vendor] INT NOT NULL, 
    [descr] NVARCHAR(MAX) NULL, 
    [date_end] DATETIME NOT NULL, 
    [id_organization] INT NOT NULL, 
    [id_language] INT NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [deleter_sid] VARCHAR(46) NULL, 
    [old_id] INT NULL,
	pic_data varbinary(max) filestream NULL,
	pic_guid uniqueidentifier default newid() unique rowguidcol NOT null, 
    [expired_delivery_sent] BIT NOT NULL DEFAULT 0, 
    [name] NVARCHAR(150) NULL, 
    [new_delivery_sent] BIT NOT NULL DEFAULT 0, 
    [update_delivery_sent] BIT NOT NULL DEFAULT 1
)
