CREATE TABLE [dbo].[holiday_work_documents](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dattim1] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL,
	[date_start] [date] NOT NULL,
	[date_end] [date] NOT NULL,
	[creator_sid] [varchar](46) NOT NULL,
 CONSTRAINT [PK_holiday_work_delivery] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


ALTER TABLE [dbo].[holiday_work_documents] ADD  CONSTRAINT [DF_holiday_work_delivery_dattim1]  DEFAULT (getdate()) FOR [dattim1]
GO

ALTER TABLE [dbo].[holiday_work_documents] ADD  CONSTRAINT [DF_holiday_work_delivery_enabled]  DEFAULT ((1)) FOR [enabled]
GO
