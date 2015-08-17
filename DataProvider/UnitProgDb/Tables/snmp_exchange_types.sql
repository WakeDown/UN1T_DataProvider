CREATE TABLE [dbo].[snmp_exchange_types] (
    [id_exchange_type] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]             NVARCHAR (50) NOT NULL,
    [sys_name]         NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_snmp_exchange_types] PRIMARY KEY CLUSTERED ([id_exchange_type] ASC)
);

