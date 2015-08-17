CREATE TABLE [dbo].[work_days]
(
	[date] [date] NOT NULL,
	[work_hours] [int] NOT NULL, 
    CONSTRAINT [PK_work_days] PRIMARY KEY ([date])
)
