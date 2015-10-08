CREATE PROCEDURE [dbo].[get_claim_list_count_by_states]
AS begin
set nocount on;
	SELECT  st.id, st.name, t.cnt
FROM (
select c.id_claim_state, count(1) as cnt 
	from claims_view c
	group by c.id_claim_state) AS t
	INNER JOIN dbo.claim_states st ON t.id_claim_state = st.id
	ORDER BY st.order_num
	end