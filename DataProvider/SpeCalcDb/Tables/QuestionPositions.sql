CREATE TABLE [dbo].[QuestionPositions]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_question] INT NOT NULL, 
    [user_sid] VARCHAR(46) NOT NULL, 
    [descr] NVARCHAR(MAX) NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [dattim2] DATETIME NOT NULL DEFAULT '3.3.3333',
    [enabled] BIT NOT NULL DEFAULT 1, 
    [creator_sid] VARCHAR(46) NOT NULL
)
