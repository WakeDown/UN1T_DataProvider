CREATE PROCEDURE [dbo].[spHTTPCall] (
	 @@URL		SysName
	,@@Responce	NText	OUTPUT
) AS BEGIN
	-- Для установки Proxy воспользуйтесь "proxycfg -u"
	DECLARE	 @OLEObject		Int
		,@HTTPStatus		Int
		,@ErrCode		Int
		,@ErrMethod		SysName
		,@ErrSource		SysName
		,@ErrDescription	SysName

	EXEC @ErrCode = sys.sp_OACreate 'MSXML2.ServerXMLHTTP', @OLEObject OUT
	IF (@ErrCode = 0) BEGIN
		EXEC @ErrCode = sys.sp_OAMethod @OLEObject ,'open',NULL ,'GET' ,@@URL ,'false'	IF (@ErrCode != 0) BEGIN SET @ErrMethod = 'open'	GOTO Error END
		EXEC @ErrCode = sys.sp_OAMethod @OLEObject ,'send',NULL ,NULL			IF (@ErrCode != 0) BEGIN SET @ErrMethod = 'send'	GOTO Error END
		EXEC @ErrCode = sys.sp_OAGetProperty @OLEObject ,'status' ,@HTTPStatus OUT	IF (@ErrCode != 0) BEGIN SET @ErrMethod = 'status'	GOTO Error END
		IF (@HTTPStatus = 200) BEGIN
			DECLARE	@Response TABLE ( Response NText )
			INSERT	@Response
			EXEC @ErrCode = sys.sp_OAGetProperty @OLEObject ,'responseText'		IF (@ErrCode != 0) BEGIN SET @ErrMethod = 'responseText'GOTO Error END
			SELECT @@Responce = Response FROM @Response
		END ELSE
			SELECT	 @ErrMethod	= 'send'
				,@ErrSource	= 'spSOAPMethod'
				,@ErrDescription= 'Ошибочный статус HTTP ответа "' + Convert(VarChar,@HTTPStatus) + '"'
		GOTO Destroy
	Error:	EXEC @ErrCode = sys.sp_OAGetErrorInfo @OLEObject ,@ErrSource OUT ,@ErrDescription OUT
	Destroy:EXEC @ErrCode = sys.sp_OADestroy @OLEObject
		IF (@ErrSource IS NOT NULL) BEGIN
			RAISERROR('Ошибка при выполнении метода "%s" в "%s": %s',18,1,@ErrMethod,@ErrSource,@ErrDescription)
			RETURN	@@Error
		END
	END ELSE BEGIN
		RAISERROR('Ошибка при создании OLE объекта "MSXML2.ServerXMLHTTP"',18,1)
		RETURN	@@Error
	END
END
