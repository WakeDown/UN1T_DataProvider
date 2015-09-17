CREATE TABLE [dbo].[vendor_state_pictures]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_vendor_state] INT NOT NULL,
	file_data varbinary(max) filestream NOT NULL, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    file_fuid uniqueidentifier default newid() unique rowguidcol not null, 
    [file_name] NVARCHAR(500) NOT NULL
)
