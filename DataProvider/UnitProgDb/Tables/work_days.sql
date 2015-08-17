CREATE TABLE [dbo].[work_days] (
    [date]       DATE NOT NULL,
    [work_hours] INT  NOT NULL,
    CONSTRAINT [PK_work_days] PRIMARY KEY CLUSTERED ([date] ASC)
);

