CREATE PROCEDURE [dbo].[SaveTenderClaimFile]
	@IdClaim INT,
	@file VARBINARY(MAX),
	@fileName NVARCHAR(500)
AS
BEGIN
set NOCOUNT ON;
declare @id int
INSERT INTO TenderClaimFiles(IdClaim, fileDATA, fileName)
values(@IdClaim, @file, @fileName)
select @id=@@IDENTITY
select @id as id
END
