CREATE TABLE [dbo].[work_hours]
(
	[id_time] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[time] [time](0) NOT NULL,
	[sys_name] [nvarchar](150) NULL, 
    CONSTRAINT [PK_work_hours] PRIMARY KEY ([id_time])
)
