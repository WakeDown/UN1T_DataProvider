
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Сохраняем отчет об отправленом письме
-- =============================================
CREATE PROCEDURE [dbo].[sk_sended_mails] @id_program INT
	,@type_sys_name NVARCHAR(150) = NULL
	,@uid NVARCHAR(max)
	,@sp_test BIT = NULL
	,@id_sended_mail_type INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @log_params NVARCHAR(max)
		,@log_descr NVARCHAR(max)
		,@id NVARCHAR(20)

	SELECT @log_params = CASE 
			WHEN @id_program IS NULL
				THEN ''
			ELSE ' @id_program=' + CONVERT(NVARCHAR, @id_program)
			END + CASE 
			WHEN @sp_test IS NULL
				THEN ''
			ELSE ' @sp_test=' + CONVERT(NVARCHAR, @sp_test)
			END + CASE 
			WHEN @type_sys_name IS NULL
				THEN ''
			ELSE ' @type_sys_name=' + CONVERT(NVARCHAR, @type_sys_name)
			END + CASE 
			WHEN @uid IS NULL
				THEN ''
			ELSE ' @uid=' + CONVERT(NVARCHAR, @uid)
			END + CASE 
			WHEN @id_sended_mail_type IS NULL
				THEN ''
			ELSE ' @id_sended_mail_type=' + CONVERT(NVARCHAR, @id_sended_mail_type)
			END

	EXEC sk_log @action = 'insLog'
		,@proc_name = 'sk_sended_mails'
		,@id_program = @id_program
		,@params = @log_params
		,@descr = @log_descr

	IF @sp_test IS NOT NULL
	BEGIN
		RETURN
	END

	IF @id_sended_mail_type IS NULL
	BEGIN
		SELECT @id_sended_mail_type = id_sended_mail_type
		FROM dbo.sended_mail_types smd
		WHERE smd.id_program = @id_program
			AND smd.sys_name = @type_sys_name
	END

	--Могут передвавтья массивы id в строке
	IF (
			SELECT COUNT(1)
			FROM dbo.Split(@uid, ',')			
			) > 1
	BEGIN
		DECLARE curs CURSOR
		FOR
		SELECT value
		FROM dbo.Split(@uid, ',')
		WHERE value IS NOT NULL
			AND rtrim(ltrim(value)) != ''

		OPEN curs

		FETCH NEXT
		FROM curs
		INTO @id

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO dbo.sended_mails (
				id_sended_mail_type
				,dattim
				,uid
				)
			VALUES (
				@id_sended_mail_type
				,GETDATE()
				,@id
				)

			FETCH NEXT
			FROM curs
			INTO @id
		END

		CLOSE curs

		DEALLOCATE curs
	END
	ELSE
	BEGIN
		INSERT INTO dbo.sended_mails (
			id_sended_mail_type
			,dattim
			,uid
			)
		VALUES (
			@id_sended_mail_type
			,GETDATE()
			,@uid
			)
	END
END
