CREATE PROCEDURE [dbo].[LoadClaimCertList]
	@IdClaim int 
AS
begin
	
SELECT id, fileDATA.PathName(), fileName, fileGUID
FROM dbo.ClaimCertFiles
where IdClaim=@IdClaim
end
