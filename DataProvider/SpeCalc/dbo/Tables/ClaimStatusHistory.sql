CREATE TABLE [dbo].[ClaimStatusHistory] (
    [Id]         INT             IDENTITY (1, 1) NOT NULL,
    [RecordDate] DATETIME        NOT NULL,
    [IdClaim]    INT             NOT NULL,
    [IdStatus]   INT             NOT NULL,
    [Comment]    NVARCHAR (1000) NULL,
    [IdUser]     NVARCHAR (500)  NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClaimStatusHistory_ClaimStatus] FOREIGN KEY ([IdStatus]) REFERENCES [dbo].[ClaimStatus] ([Id]),
    CONSTRAINT [FK_ClaimStatusHistory_TenderClaim] FOREIGN KEY ([IdClaim]) REFERENCES [dbo].[TenderClaim] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

