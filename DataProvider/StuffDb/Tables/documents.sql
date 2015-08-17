CREATE TABLE [dbo].[documents](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[data_sid] [uniqueidentifier] ROWGUIDCOL  NOT NULL DEFAULT newid(),
	summary varbinary(MAX),
	[data] [varbinary](max) filestream NULL,
	[name] [nvarchar](500) NOT NULL,
	[dattim1] [datetime] NOT NULL,
	[dattim2] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL,
	[creator_sid] [varchar](46) NOT NULL,
	[deleter_sid] [varchar](46) NULL,
 CONSTRAINT [PK_documents] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ__document__CC80C6D41F98B2C1] UNIQUE NONCLUSTERED 
(
	[data_sid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


ALTER TABLE [dbo].[documents] ADD  CONSTRAINT [DF_documents_dattim1]  DEFAULT (getdate()) FOR [dattim1]
GO

ALTER TABLE [dbo].[documents] ADD  CONSTRAINT [DF_documents_dattim2]  DEFAULT ('3.3.3333') FOR [dattim2]
GO

ALTER TABLE [dbo].[documents] ADD  CONSTRAINT [DF_documents_enabled]  DEFAULT ((1)) FOR [enabled]
GO