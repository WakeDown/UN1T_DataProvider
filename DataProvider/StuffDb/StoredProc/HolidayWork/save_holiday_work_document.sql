CREATE PROCEDURE [dbo].[save_holiday_work_document]	 
	@date_start DATE,
	@date_end DATE,
	@creator_sid VARCHAR(46)
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO holiday_work_documents (date_start, date_end, creator_sid)
    VALUES (@date_start,@date_end, @creator_sid)
    
END
