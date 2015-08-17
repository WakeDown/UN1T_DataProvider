
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[minutes2HMString] (@minutes INT)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE @hours INT
		,@result NVARCHAR(30)

	SET @hours = @minutes / 60

	IF @hours > 0
	BEGIN
		SET @minutes = @minutes % 60
	END

	SET @result = CASE 
			WHEN @hours > 0
				THEN convert(NVARCHAR(15), @hours) + 'ч. '
			ELSE ''
			END + CASE 
			WHEN @minutes > 0
				THEN convert(NVARCHAR(3), @minutes) + 'м.'
			ELSE ''
			END

	RETURN @result
END
