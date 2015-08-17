CREATE TABLE [dbo].[document_meets](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_doc_meet_link] [int] NOT NULL,
	[employee_sid] [varchar](46) NOT NULL,
	[dattim1] [datetime] NOT NULL,
 CONSTRAINT [PK_document_meets] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


ALTER TABLE [dbo].[document_meets] ADD  CONSTRAINT [DF_document_meets_dattim1]  DEFAULT (getdate()) FOR [dattim1]
GO