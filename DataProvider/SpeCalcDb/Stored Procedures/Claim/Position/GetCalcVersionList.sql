CREATE PROCEDURE [dbo].[GetCalcVersionList]
	@idClaim int
AS
	begin
	set nocount on;
		select c.Version from ClaimPosition c
		where c.Deleted=0 and c.IdClaim=@idClaim
		group by c.Version
		order by c.Version
	end
