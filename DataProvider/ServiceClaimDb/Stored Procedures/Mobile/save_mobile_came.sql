CREATE PROCEDURE dbo.save_mobile_came
	@id INT = null, 
    @device_serial_num NVARCHAR(20) = NULL, 
    @id_device INT= NULL, 
    @device_model NVARCHAR(150) =NULL, 
    @city NVARCHAR(150) =NULL, 
    @address NVARCHAR(150) =NULL, 
    @client_name NVARCHAR(150) =NULL, 
    @id_work_type INT =NULL, 
    @counter_mono BIGINT =NULL, 
    @counter_color BIGINT =NULL, 
    @counter_total BIGINT =NULL, 
    @descr NVARCHAR(MAX) =NULL, 
    @specialist_sid VARCHAR(46) = NULL, 
    @date_create DATETIME = NULL,
	@creator_sid varchar(46)
	as begin
	set nocount on;
	INSERT INTO [dbo].[mobile_cames]
           ([device_serial_num]
           ,[id_device]
           ,[device_model]
           ,[city]
           ,[address]
           ,[client_name]
           ,[id_work_type]
           ,[counter_mono]
           ,[counter_color]
           ,[counter_total]
           ,[descr]
           ,[specialist_sid]
           ,[date_create]
           ,creator_sid)
     VALUES
           (@device_serial_num
           ,@id_device
           ,@device_model
           ,@city
           ,@address
           ,@client_name
           ,@id_work_type
           ,@counter_mono
           ,@counter_color
           ,@counter_total
           ,@descr
           ,@specialist_sid
           ,@date_create,
		   @creator_sid)
		   set @id = SCOPE_IDENTITY()
		   select @id as id
	end 