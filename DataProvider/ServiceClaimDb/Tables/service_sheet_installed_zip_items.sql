CREATE TABLE [dbo].[service_sheet_installed_zip_items]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_service_sheet] INT NOT NULL, 
	id_ordered_zip_item int not null,
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333', 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [deleter_sid] VARCHAR(46) NULL, 
    [enabled] BIT NOT NULL DEFAULT 1 
)
