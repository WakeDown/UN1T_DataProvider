CREATE PROCEDURE [dbo].[set_claim_current_state]
	@id_claim int,
	@id_claim_state int,
	@creator_sid varchar(46)
	as begin set nocount on;
		update claims
		set id_claim_state = @id_claim_state, date_state_change = getdate(), changer_sid=@creator_sid where id=@id_claim
	end
