CREATE TABLE [dbo].[service_sheet_ordered_zip_items]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_service_sheet] INT NOT NULL, 
    [part_num] NVARCHAR(50) NOT NULL, 
    [name] NVARCHAR(500) NULL, 
    [count] INT NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [deleter_sid] VARCHAR(46) NULL, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [id_zip_claim_unit] INT NULL, 
    [id_issued_zip_item] INT NULL  
)
