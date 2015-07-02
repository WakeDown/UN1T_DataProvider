CREATE TABLE [dbo].[QuestionStateHistory]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_question] INT NOT NULL, 
    [id_que_state] INT NOT NULL, 
    [dattim1] DATETIME NOT NULL DEFAULT getdate(), 
    [creator_sid] VARCHAR(46) NOT NULL, 
    [descr] NVARCHAR(MAX) NULL, 
    [enabled] BIT NULL DEFAULT 1
)
