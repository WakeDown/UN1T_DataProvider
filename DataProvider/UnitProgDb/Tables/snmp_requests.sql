CREATE TABLE [dbo].[snmp_requests] (
    [id_requset]    INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [id_exchange]   INT           NOT NULL,
    [id_contractor] INT           NULL,
    [id_device]     INT           NULL,
    [serial_num]    NVARCHAR (50) NULL,
    [host]          NVARCHAR (20) NULL,
    [counter]       INT           NULL,
    [counter_color] INT           NULL,
    [date_request]  DATETIME      NULL,
    [dattim1]       DATETIME      CONSTRAINT [DF_snmp_requests_dattim1] DEFAULT (getdate()) NOT NULL,
    [prog_version]  NVARCHAR (10) NULL,
    CONSTRAINT [PK_snmp_requests] PRIMARY KEY CLUSTERED ([id_requset] ASC)
);

