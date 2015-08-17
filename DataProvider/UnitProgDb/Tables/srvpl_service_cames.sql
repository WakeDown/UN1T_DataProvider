CREATE TABLE [dbo].[srvpl_service_cames] (
    [id_service_came]        INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_service_claim]       INT            NOT NULL,
    [date_came]              DATETIME       NOT NULL,
    [descr]                  NVARCHAR (MAX) NULL,
    [counter]                INT            NULL,
    [id_service_engeneer]    INT            NOT NULL,
    [id_service_action_type] INT            NOT NULL,
    [dattim1]                DATETIME       CONSTRAINT [DF_srvpl_service_cames_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]                DATETIME       CONSTRAINT [DF_srvpl_service_cames_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    [enabled]                BIT            CONSTRAINT [DF_srvpl_service_cames_enabled] DEFAULT ((1)) NOT NULL,
    [id_creator]             INT            NOT NULL,
    [counter_colour]         INT            NULL,
    [id_akt_scan]            INT            NULL,
    CONSTRAINT [PK_srvpl_service_cames] PRIMARY KEY CLUSTERED ([id_service_came] ASC),
    CONSTRAINT [FK_srvpl_service_cames_srvpl_service_action_types] FOREIGN KEY ([id_service_action_type]) REFERENCES [dbo].[srvpl_service_action_types] ([id_service_action_type])
);

