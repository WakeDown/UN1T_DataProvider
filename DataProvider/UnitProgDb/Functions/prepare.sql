-- =============================================
-- Author:		Anton Rekhov
-- Create date: 19.03.2014
-- Description:	Подготовка различных объектов к нужному виду
-- =============================================
CREATE FUNCTION [dbo].[prepare] 
(
	@action NVARCHAR(50),
	--@str NVARCHAR(MAX) = null
	@money DECIMAL(18, 4) = null
)
RETURNS nvarchar
AS
BEGIN
	DECLARE @result NVARCHAR(MAX)
	
	IF @action = 'money'
	BEGIN
		--DECLARE @money DECIMAL(18, 4) = NULL
		--SET @money = CONVERT(DECIMAL(18, 2), @str)
			SELECT @result = REPLACE(CONVERT(NVARCHAR(MAX), @money, 1), ',', ' ')
	end
	
	
	RETURN @result
END
