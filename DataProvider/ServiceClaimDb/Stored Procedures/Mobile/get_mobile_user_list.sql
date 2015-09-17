CREATE PROCEDURE [dbo].[get_mobile_user_list]
AS
	begin
	set nocount on;

	select sid, login, password from mobile_users
	where enabled = 1

	end