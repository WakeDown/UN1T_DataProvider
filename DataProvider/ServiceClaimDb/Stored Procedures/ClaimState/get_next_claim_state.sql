CREATE PROCEDURE [dbo].[get_next_claim_state]
	@id_claim_state int
as begin set nocount on;
	select top 1 id, name ,sys_name,order_num,background_color,foreground_color
	from claim_states cs where enabled=1 and exists(select 1 from claim_states cs2 where cs2.enabled=1 and cs2.id=@id_claim_state and  cs.order_num > cs2.order_num)
	order by order_num
	end