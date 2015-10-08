CREATE PROCEDURE [dbo].[set_vendor_state_delivery_sent]
	@id int,
	@new bit = 0,
	@expired bit = 0,
	@updated bit = 0
AS
begin
if @expired=1 
begin
update vendor_states
set expired_delivery_sent=1
where id=@id
end
else
if @new = 1
begin
update vendor_states
set new_delivery_sent=1
where id=@id
end
else
if @updated = 1
begin
update vendor_states
set update_delivery_sent=1
where id=@id
end

end
