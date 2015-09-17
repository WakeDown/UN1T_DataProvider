CREATE PROCEDURE [dbo].[get_claim_list_count]
	@id_admin int = null,
	@id_engeneer int = null,
	@date_start date = null,
	@date_end date = null
	as begin
	set nocount on;

	select count(1) as cnt
	from claims_view c
	end