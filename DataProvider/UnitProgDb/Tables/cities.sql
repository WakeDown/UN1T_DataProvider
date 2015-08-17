CREATE TABLE [dbo].[cities] (
    [id_city]     INT               IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name]        NVARCHAR (50)     NULL,
    [enabled]     BIT               CONSTRAINT [DF_cities_enabled] DEFAULT ((1)) NOT NULL,
    [order_num]   INT               CONSTRAINT [DF_cities_order_num] DEFAULT ((500)) NOT NULL,
    [id_creator]  INT               NULL,
    [dattim1]     DATETIME          NULL,
    [dattim2]     DATETIME          NULL,
    [region]      NVARCHAR (150)    NULL,
    [area]        NVARCHAR (150)    NULL,
    [locality]    NVARCHAR (100)    NULL,
    [coordinates] [sys].[geography] NULL,
    [coord]       NVARCHAR (50)     NULL,
    CONSTRAINT [PK_cities] PRIMARY KEY CLUSTERED ([id_city] ASC)
);

