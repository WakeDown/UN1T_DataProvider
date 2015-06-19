CREATE PROCEDURE [dbo].[GetCertFile]
	@guid nvarchar(50)
AS
	begin 

	select fileDATA, fileName from ClaimCertFiles
	where fileGUID = @guid
	--id=@IdCert
	end
