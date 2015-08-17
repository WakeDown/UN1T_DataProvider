CREATE PROCEDURE [dbo].[save_claim2claim_state]
	@id_claim int,
	@id_claim_state int,
	@creator_sid varchar(46),
	@descr nvarchar(max)
	as begin set nocount on;
	declare @id int
	insert into claim2claim_states(id_claim, id_claim_state, creator_sid, descr)
	values (@id_claim, @id_claim_state, @creator_sid, @descr)	
	set @id = @@IDENTITY
	select @id as id
	end
