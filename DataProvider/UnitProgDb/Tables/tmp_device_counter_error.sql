CREATE TABLE [dbo].[tmp_device_counter_error] (
    [id_contract]        INT           NOT NULL,
    [id_device]          INT           NOT NULL,
    [date]               DATETIME      NOT NULL,
    [counter]            INT           NULL,
    [counter_color]      INT           NULL,
    [place]              NVARCHAR (50) NULL,
    [dattim1]            DATETIME      CONSTRAINT [DF_tmp_device_counter_error_dattim1] DEFAULT (getdate()) NOT NULL,
    [prev_counter]       INT           NULL,
    [prev_counter_color] INT           NULL,
    [prev_place]         NVARCHAR (50) NULL,
    [prev_date]          DATETIME      NULL
);

