CREATE TABLE [dbo].[document_meet_links](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_document] [int] NOT NULL,
	[id_department] [int] NULL,
	[id_position] [int] NULL,
	[id_employee] [int] NULL,
	[dattim1] [datetime] NOT NULL,
	[creator_sid] [varchar](46) NOT NULL,
	[enabled] [bit] NOT NULL,
	[dattim2] [datetime] NOT NULL,
	[deleter_sid] [varchar](46) NULL,
 CONSTRAINT [PK_document_links] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


ALTER TABLE [dbo].[document_meet_links] ADD  CONSTRAINT [DF_document_links_dattim1]  DEFAULT (getdate()) FOR [dattim1]
GO

ALTER TABLE [dbo].[document_meet_links] ADD  CONSTRAINT [DF_document_meet_links_enabled]  DEFAULT ((1)) FOR [enabled]
GO

ALTER TABLE [dbo].[document_meet_links] ADD  CONSTRAINT [DF_document_meet_links_dattim2]  DEFAULT ('3.3.3333') FOR [dattim2]
GO
