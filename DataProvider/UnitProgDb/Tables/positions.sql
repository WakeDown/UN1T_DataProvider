CREATE TABLE [dbo].[positions] (
    [id_position] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]        NVARCHAR (100) NOT NULL,
    [enabled]     BIT            CONSTRAINT [DF_positions_enabled] DEFAULT ((1)) NOT NULL,
    [order_num]   INT            CONSTRAINT [DF_positions_order_num] DEFAULT ((50)) NOT NULL,
    [dattim1]     DATETIME       CONSTRAINT [DF_positions_dattim1] DEFAULT (getdate()) NOT NULL,
    [dattim2]     DATETIME       CONSTRAINT [DF_positions_dattim2] DEFAULT ('3.3.3333') NOT NULL,
    CONSTRAINT [PK_positions] PRIMARY KEY CLUSTERED ([id_position] ASC)
);

