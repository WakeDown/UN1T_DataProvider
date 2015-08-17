CREATE PROCEDURE [dbo].[set_claim_current_state]
	@id_claim int,
	@id_claim_state int
	as begin set nocount on;
		update claims
		set id_claim_state = @id_claim_state where id=@id_claim
	end
