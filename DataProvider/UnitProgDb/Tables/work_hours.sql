CREATE TABLE [dbo].[work_hours] (
    [id_time]  INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [time]     TIME (0)       NOT NULL,
    [sys_name] NVARCHAR (150) NULL,
    CONSTRAINT [PK_work_hours] PRIMARY KEY CLUSTERED ([id_time] ASC)
);

