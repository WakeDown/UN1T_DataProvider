CREATE PROCEDURE [dbo].[save_claim2claim_state]
	@id_claim int,
	@id_claim_state int,
	@creator_sid varchar(46),
	@descr nvarchar(max)=null,
	@specialist_sid varchar(46)=null,
	@id_work_type int = null,
	@id_service_sheet int = null
	as begin set nocount on;
	declare @id int
	insert into claim2claim_states(id_claim, id_claim_state, creator_sid, descr, specialist_sid, id_work_type, id_service_sheet)
	values (@id_claim, @id_claim_state, @creator_sid, @descr, @specialist_sid, @id_work_type, @id_service_sheet)	
	set @id = @@IDENTITY
	select @id as id
	end
