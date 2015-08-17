CREATE PROCEDURE [dbo].[spCBRRates] (
	 @@Date	SMALLDATETIME = NULL
	,@@XML	NText	= NULL	OUTPUT
) AS BEGIN
	DECLARE	 @ErrCode	Int
		,@Handle	Int
		,@URL		SysName
	SELECT	 @URL = 'http://www.cbr.ru/scripts/XML_daily.asp?date_req=' + Convert(Char(10), CASE when @@Date IS NULL THEN GETDATE() ELSE @@Date end,103)
	EXEC @ErrCode = dbo.spHTTPCall @URL, @@XML			IF (@ErrCode != 0) RETURN @@Error
	EXEC @ErrCode = sys.sp_xml_preparedocument @Handle OUT, @@XML	IF (@ErrCode != 0) BEGIN RAISERROR('Ошибка парсирования XML',18,1) RETURN @@Error END

	-- А тут допиливаете нужную вам логику
--	INSERT	...
declare @xmlString varchar(8000),  @retVal INT, @oXML INT, @loadRetVal INT, @h int
declare @d1 datetime
set @d1 = GetDate()
	select  CharCode, Nominal, Convert(money, replace(Value, ',', '.')) 'Value'
from OpenXML (@h, '//Valute', 0)
with ( Name varchar(99) './Name', Nominal int './Nominal', Value varchar(10) './Value', CharCode varchar(9) './CharCode' )

	EXEC @ErrCode = sys.sp_xml_removedocument @Handle
END
