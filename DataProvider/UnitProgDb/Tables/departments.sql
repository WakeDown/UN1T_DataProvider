CREATE TABLE [dbo].[departments] (
    [id_department] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]          NVARCHAR (150) NOT NULL,
    [display_name]  NVARCHAR (100) NULL,
    [id_company]    INT            NULL,
    [enabled]       BIT            CONSTRAINT [DF_departments_enabled] DEFAULT ((1)) NOT NULL,
    [order_num]     INT            CONSTRAINT [DF_departments_order_num] DEFAULT ((50)) NOT NULL,
    [dattim1]       DATETIME       CONSTRAINT [DF_departments_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]       DATETIME       CONSTRAINT [DF_departments_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [sys_name]      NVARCHAR (50)  NULL,
    CONSTRAINT [PK_departments] PRIMARY KEY CLUSTERED ([id_department] ASC)
);

