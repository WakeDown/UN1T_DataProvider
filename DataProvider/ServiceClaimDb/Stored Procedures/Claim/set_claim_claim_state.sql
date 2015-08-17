CREATE PROCEDURE [dbo].[set_claim_claim_state]
	@id int = null,
	@sid varchar(46) = null,
	@id_claim_state int
AS
begin
set nocount on;
if @id is not null and @id > 0
begin
update claims
set id_claim_state=@id_claim_state
where id=@id end 
else if @sid is not null and @sid <> ''
begin
	update claims
set id_claim_state=@id_claim_state
where sid=@sid 
end
end
