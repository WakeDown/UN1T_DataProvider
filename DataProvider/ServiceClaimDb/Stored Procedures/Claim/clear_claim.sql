CREATE PROCEDURE [dbo].[clear_claim]
	@id int = null,
	@sid varchar(46) = null,
	@clear_specialist_sid bit = 0,
	@clear_id_work_type bit = 0,
	@clear_engeneer_sid bit = 0,
	@clear_admin_sid bit = 0,
	@clear_tech_sid bit = 0,
	@clear_manager_sid bit =0
	as begin
	set nocount on;

	

	if (@id is not null and @id > 0 and exists(select 1 from claims where id=@id))
	begin	
		if @clear_specialist_sid = 1 
		begin
		update claims
		set specialist_sid = null
		where id=@id
		end

		if @clear_id_work_type = 1 
		begin
		update claims
		set id_work_type = 0
		where id=@id
		end

		if @clear_engeneer_sid = 1 
		begin
		update claims
		set cur_engeneer_sid = 0
		where id=@id
		end

		if @clear_admin_sid = 1 
		begin
		update claims
		set cur_admin_sid = 0
		where id=@id
		end

		if @clear_tech_sid = 1 
		begin
		update claims
		set cur_tech_sid = 0
		where id=@id
		end

		if @clear_manager_sid = 1 
		begin
		update claims
		set cur_manager_sid = 0
		where id=@id
		end
	end
	else if (@sid is not null and @sid <> '' and exists(select 1 from claims where sid=@sid))
	begin
		if @clear_specialist_sid = 1 
		begin
		update claims
		set specialist_sid = null
		where sid=@sid
		end

		if @clear_id_work_type = 1 
		begin
		update claims
		set id_work_type = 0
		where sid=@sid
		end

		if @clear_engeneer_sid = 1 
		begin
		update claims
		set cur_engeneer_sid = 0
		where sid=@sid
		end

		if @clear_admin_sid = 1 
		begin
		update claims
		set cur_admin_sid = 0
		where sid=@sid
		end

		if @clear_tech_sid = 1 
		begin
		update claims
		set cur_tech_sid = 0
		where sid=@sid
		end

		if @clear_manager_sid = 1 
		begin
		update claims
		set cur_manager_sid = 0
		where sid=@sid
		end
	end
	
	select @id as id
	end