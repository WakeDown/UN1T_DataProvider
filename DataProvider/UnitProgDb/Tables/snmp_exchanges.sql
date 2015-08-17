CREATE TABLE [dbo].[snmp_exchanges] (
    [id_exchange]      INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [sys_info]         NVARCHAR (MAX) NOT NULL,
    [dattim1]          DATETIME       CONSTRAINT [DF_snmp_exchanges_dattim1] DEFAULT (getdate()) NOT NULL,
    [decrypted]        BIT            CONSTRAINT [DF_snmp_exchanges_dectypted] DEFAULT ((0)) NOT NULL,
    [id_exchange_type] INT            NOT NULL,
    CONSTRAINT [PK_snmp_exchanges] PRIMARY KEY CLUSTERED ([id_exchange] ASC)
);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[snmp_exchanges_ins_trg] ON [dbo].[snmp_exchanges]
    AFTER INSERT
AS
    BEGIN
        SET NOCOUNT ON;
		
		DECLARE @id_exchange NVARCHAR(MAX)
		
		SELECT @id_exchange = id_exchange FROM inserted
		
        EXEC dbo.sk_snmp_scanner @action = 'decryptExchangeAndInsertRequest', @id_exchange = @id_exchange
    END
