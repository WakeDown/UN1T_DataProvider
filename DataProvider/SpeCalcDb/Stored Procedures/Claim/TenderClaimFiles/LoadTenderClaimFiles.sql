CREATE PROCEDURE [dbo].[LoadTenderClaimFiles]
	@IdClaim int 
AS
begin
	
SELECT id, fileDATA.PathName(), fileName, fileGUID
FROM dbo.TenderClaimFiles
where IdClaim=@IdClaim
end

