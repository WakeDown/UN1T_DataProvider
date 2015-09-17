CREATE PROCEDURE [dbo].[get_claim_state_user_group_list]
	@id_claim_state int
AS
	begin
	set nocount on;
	select user_group_sid from claim_state2user_group where enabled=1 and id_claim_state=@id_claim_state
	

	end
