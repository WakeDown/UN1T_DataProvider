CREATE TABLE [dbo].[claim_state2user_group]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [user_group_sid] NCHAR(10) NOT NULL, 
    [id_claim_state] NCHAR(10) NOT NULL, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333'
)
