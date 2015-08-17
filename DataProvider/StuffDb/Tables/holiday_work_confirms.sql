CREATE TABLE [dbo].[holiday_work_confirms](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[employee_sid] [varchar](46) NULL,
	[id_hw_document] [int] NULL,
	[dattim1] [datetime] NOT NULL,
 [full_name] NVARCHAR(150) NOT NULL, 
    [enabled] BIT NOT NULL DEFAULT 1, 
    CONSTRAINT [PK_holiday_work_confirms] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


ALTER TABLE [dbo].[holiday_work_confirms] ADD  CONSTRAINT [DF_holiday_work_confirms_dattim1]  DEFAULT (getdate()) FOR [dattim1]
GO

