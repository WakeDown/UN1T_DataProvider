CREATE PROCEDURE [dbo].[get_claim_state_list_filter]	
AS
	begin set nocount on;

	SELECT  st.id, st.name, t.cnt, st.background_color, st.foreground_color
FROM  dbo.claim_states st
full JOIN 
 (
select c.id_claim_state, count(1) as cnt 
	from claims_view c
	group by c.id_claim_state) AS t ON t.id_claim_state = st.id
	where st.filter_display=1
	ORDER BY st.order_num

	end
