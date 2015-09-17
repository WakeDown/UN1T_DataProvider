CREATE PROCEDURE [dbo].[GetTenderClaimFile]
	@guid nvarchar(50)
AS
	begin 

	select fileDATA, fileName from TenderClaimFiles
	where fileGUID = @guid
	--id=@IdCert
	end
