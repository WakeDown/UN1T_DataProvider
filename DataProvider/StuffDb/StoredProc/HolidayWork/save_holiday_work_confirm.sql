CREATE PROCEDURE [dbo].[save_holiday_work_confirm]	 
	@id_hw_document INT=null,
	@employee_sid VARCHAR(46)=null,
	@full_name nvarchar(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO holiday_work_confirms (id_hw_document, employee_sid, full_name)
    VALUES (@id_hw_document, @employee_sid, @full_name)
	declare @id int
	set @id = @@IDENTITY
	select @id as id
END
