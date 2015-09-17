CREATE PROCEDURE [dbo].[UpdateClaimDeadline]
	@IdClaim int,
	@ClaimDeadline datetime
as
set nocount on;
update TenderClaim 
set ClaimDeadline = @ClaimDeadline
where Id=@IdClaim

