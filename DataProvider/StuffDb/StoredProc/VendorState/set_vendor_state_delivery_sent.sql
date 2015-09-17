CREATE PROCEDURE [dbo].[set_vendor_state_delivery_sent]
	@id int
AS
begin

update vendor_states
set expired_delivery_sent=1
where id=@id

end
