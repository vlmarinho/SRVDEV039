
/*
=====================================================================
Projeto: Translate de Senha
Descrição: Procedure utilizada para integrar o banco de dados a um WS.
Autor:	Cristiano Silva Barbosa
Data Criacao: 28/09/2017
Chamado/Mudança: 417680 / 3262
--------------------------------------------------------------------------
Data Alteração: 26/10/2017
Chamado : 430467/3378
Responsavel: Cristiano Barbosa- Up Brasil
--------------------------------------------------------------------------

=====================================================================
*/

CREATE PROCEDURE [dbo].[pr_Aut_RequestHttpWebService]
	 @sUrl			VARCHAR(1024)
	,@sHttpMethod	VARCHAR(10)
	,@sParamsValues	VARCHAR(MAX)    -- param1=value&param2=value
	,@sSoapAction	VARCHAR(1024) 
	,@sSoapMetodo	VARCHAR(1024) 
	,@sInput		VARCHAR(MAX)
	,@sAuxiliar		VARCHAR(MAX)	OUTPUT
	,@sRetorno		VARCHAR(MAX)	OUTPUT
	,@iRetorno		INT				OUTPUT
AS 
BEGIN 
	
	SET NOCOUNT ON;
	
	DECLARE @VTable TABLE (XmlData VARCHAR(MAX))

	DECLARE 
		 @Obj				INT
		,@sResponseXml		XML
		,@status			VARCHAR(50)
		,@sStatusText		VARCHAR(1024)
		,@sMethod			VARCHAR(10) = (CASE WHEN @sHttpMethod = 'SOAP' THEN 'POST' ELSE @sHttpMethod END)
		,@sMessageError		VARCHAR(1024)
		,@sHost				VARCHAR(1024)
		,@sEnvelope			VARCHAR(MAX) 
		,@sParams			VARCHAR(MAX) 
		,@exponent			VARCHAR(100)
		,@modulus			VARCHAR(MAX)
		,@Aux				VARBINARY(MAX)
		,@sResonseOutoPut   VARCHAR(20)
	
	IF (@sHttpMethod = 'GET' AND LEN(@sParamsValues) > 0)
		SET @sUrl = @sUrl + '?' + @sParamsValues

	EXEC @iRetorno = sp_OACreate 'MSXML2.ServerXMLHttp', @Obj OUTPUT
	IF (@iRetorno <> 0)
	BEGIN 
		SET @sMessageError = 'sp_OACreate MSXML2.ServerXMLHttp.3.0 failed' 
		GOTO FIM
	END
	
	EXEC @iRetorno = sp_OAMethod @Obj, 'open', NULL, @sMethod, @sUrl, false   
	IF (@iRetorno <> 0)
	BEGIN 
		SET @sMessageError = 'sp_OAMethod Open failed' 
		GOTO FIM
	END
	
	IF (@sHttpMethod = 'GET')
		EXEC sp_OAMethod @Obj, 'send'
	ELSE IF (@sHttpMethod = 'POST')
	BEGIN

		SET @sResonseOutoPut = 'responseText'

		IF (@sAuxiliar = 'RECARGA')
		BEGIN

			DECLARE @iLen INT

			SET @sHost = @sUrl

			IF (@sHost like 'http://%')
				SET @sHost = RIGHT(@sHost, len(@sHost) - 7)
			ELSE IF (@sHost like 'https://%')
				SET @sHost = RIGHT(@sHost, len(@sHost) - 8)

			SET @sHost = LEFT(@sHost, CHARINDEX('/', @sHost) - 1)
			SET @iLen = LEN (@sParamsValues)

			EXEC @iRetorno = sp_OAMethod @obj, 'setRequestHeader', NULL, 'Content-Type','application/x-www-form-urlencoded'
			IF @iRetorno <>0 
			BEGIN 
				SET @sMessageError = 'sp_OAMethod setRequestHeader failed' 
				GOTO FIM 
			END
			
			EXEC @iRetorno = sp_OAMethod @Obj, 'setRequestHeader', null, 'Content-Length', @iLen
			IF @iRetorno <>0 
			BEGIN 
				SET @sMessageError = 'sp_OAMethod setRequestHeader failed' 
				GOTO FIM 
			END

			EXEC @iRetorno = sp_OAMethod @Obj, 'setRequestHeader', NULL, 'Host', @sHost
			IF @iRetorno <> 0 
			BEGIN 
				SET @sMessageError = 'sp_OAMethod setRequestHeader host failed' 
				GOTO FIM
			END

			EXEC @iRetorno = sp_OAMethod @Obj, 'send',null, @sParamsValues
			IF @iRetorno <>0 
			BEGIN 
				SET @sMessageError = 'sp_OAMethod Send failed' 
				GOTO FIM
			END

		END
		ELSE 
		BEGIN		

			EXEC sp_OAMethod @Obj, 'setRequestHeader', null, 'Content-Type', 'application/json'
			EXEC sp_OAMethod @Obj, 'setRequestHeader', null, 'CLIENT_SECRET_KEY', @sAuxiliar

			EXEC sp_OAMethod @Obj, 'send', NULL, @sParamsValues

		END

	END
	ELSE IF (@sHttpMethod = 'SOAP')
	BEGIN

		SET @sHost = @sUrl
		SET @sParams = ''
		SET @sResonseOutoPut = 'responseXML.xml'
		
		SET @sEnvelope = '<?xml version="1.0" encoding="utf-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.cryptoapi.hst.com.br/"><soapenv:Header/><soapenv:Body><{action}><{metodo}>{params}</{metodo}></{action}></soapenv:Body></soapenv:Envelope>'

		IF (@sSoapAction IS NULL)
			RAISERROR('@sSoapAction is NULL', 10, 1)

		IF (@sHost like 'http://%')
			SET @sHost = RIGHT(@sHost, len(@sHost) - 7)
		ELSE IF (@sHost like 'https://%')
			SET @sHost = RIGHT(@sHost, len(@sHost) - 8)

		IF (CHARINDEX(':', @sHost) > 0 and CHARINDEX(':', @sHost) < CHARINDEX('/', @sHost))
		BEGIN
			SET @sHost = LEFT(@sHost, CHARINDEX(':', @sHost) - 1)
			SET @sHost = @sHost + ':8180'
		END
		ELSE 
			SET @sHost = LEFT(@sHost, CHARINDEX('/', @sHost) - 1)

		WHILE (LEN(@sParamsValues) > 0)
		BEGIN

			DECLARE  @param VARCHAR(1024)
					,@value VARCHAR(1024)

			IF (CHARINDEX('&', @sParamsValues) > 0)
			BEGIN

				SET @param = LEFT(@sParamsValues, CHARINDEX('&', @sParamsValues) - 1)
				SET @value = RIGHT(@param, LEN(@param) - CHARINDEX('=', @param))
				SET @param = LEFT(@param, CHARINDEX('=', @param) - 1)
				SET @sParams = @sParams + '<' + @param + '>' + @value + '</'+ @param + '>'
				SET @sParamsValues = RIGHT(@sParamsValues, LEN(@sParamsValues) - LEN(@param + '=' + @value + '&'))

			END
			ELSE
			BEGIN

				SET @value = RIGHT(@sParamsValues, LEN(@sParamsValues) - CHARINDEX('=', @sParamsValues))
				SET @param = LEFT(@sParamsValues, CHARINDEX('=', @sParamsValues) - 1)

				SET @sParams = @sParams + '<' + @param + '>' + @value + '</'+ @param + '>'
				SET @sParamsValues = NULL

			END
		END

		SET @sEnvelope = REPLACE(@sEnvelope, '{action}', @sSoapAction)
		SET @sEnvelope = REPLACE(@sEnvelope, '{metodo}', @sSoapMetodo)
		SET @sEnvelope = REPLACE(@sEnvelope, '{params}', @sParams)
		
		
		SET @sSoapAction = 'http://ws.cryptoapi.hst.com.br/' + @sSoapAction

		EXEC @iRetorno = sp_OAMethod @Obj, 'setRequestHeader', NULL, 'Content-Type', 'text/xml;charset=UTF-8'
		IF @iRetorno <> 0 
		BEGIN 
			SET @sMessageError = 'sp_OAMethod setRequestHeader failed' 
			GOTO FIM
		END

		EXEC @iRetorno = sp_OAMethod @Obj, 'setRequestHeader', NULL, 'Host', @sHost
		IF @iRetorno <> 0 
		BEGIN 
			SET @sMessageError = 'sp_OAMethod setRequestHeader host failed' 
			GOTO FIM
		END

		EXEC @iRetorno = sp_OAMethod @Obj, 'setRequestHeader', NULL, 'SOAPAction', @sSoapAction
		IF @iRetorno <> 0 
		BEGIN 
			SET @sMessageError = 'sp_OAMethod setRequestHeader SOAPAction failed' 
			GOTO FIM
		END

		EXEC @iRetorno = sp_OAMethod @Obj, 'send', NULL, @sEnvelope
		IF @iRetorno <> 0 
		BEGIN 
			SET @sMessageError = 'sp_OAMethod Send failed' 
			GOTO FIM
		END

	END

	EXEC @iRetorno = sp_OAGetProperty @Obj, 'status', @sStatusText OUTPUT
	IF @iRetorno <> 0 
	BEGIN 
		SET @sMessageError = 'sp_OAGetProperty read status failed' 
		GOTO FIM
	END

	IF (@sAuxiliar = 'RECARGA')
	BEGIN
		
		INSERT INTO @VTable
		EXEC @sRetorno = sp_OAGetProperty @Obj, @sResonseOutoPut--, @Response OUT 
	
		SELECT @sRetorno = XmlData from @VTable

	END
	ELSE
	BEGIN

		INSERT INTO @VTable
		EXEC @sRetorno = sp_OAGetProperty @Obj, @sResonseOutoPut--, @Response OUT 
	
		SELECT @sRetorno = XmlData from @VTable

		SET @sRetorno = REPLACE(@sRetorno, 'S:', '')
		SET @sRetorno = REPLACE(@sRetorno, 'ns2:', '')

		UPDATE @VTable SET XmlData = @sRetorno
	
		SELECT @sResponseXml = XmlData from @VTable

	END

	IF (@sSoapMetodo = 'RSARequest')
	BEGIN 

		SELECT 
			 @sMessageError= doc.col.value('message[1]','nvarchar(max)')
			,@iRetorno = doc.col.value ('returnCode[1]','int')
			,@modulus= doc.col.value ('modulus[1]','nvarchar(max)')
		FROM @sResponseXml.nodes ('Envelope/Body/getRSAResponse/return') doc(col)

		IF (@iRetorno = 0)
		BEGIN
			
			SET @Aux =  CAST(N'' as xml).value('xs:base64Binary(sql:variable("@modulus"))', 'varbinary(max)')
			
			SET @modulus = CONVERT(varchar(max),@Aux,2)

			SET @sAuxiliar = @modulus
		
			EXEC Encripta_HSM 1 ,@modulus, @sInput, @sRetorno OUT

		END
		ELSE 
			SET @sRetorno = @sMessageError

	END
	ELSE IF (@sSoapMetodo = 'TokenRequest')
	BEGIN

		DECLARE @TipoCripto CHAR(1)

		IF (@sAuxiliar = 'D')
			SET @TipoCripto = @sAuxiliar
		
		SELECT 
			 @sMessageError= doc.col.value('message[1]','nvarchar(max)')
			,@iRetorno= doc.col.value ('returnCode[1]','int')
			,@sAuxiliar=doc.col.value ('keyToken[1]','nvarchar(max)')
		FROM @sResponseXml.nodes ('Envelope/Body/requestTokenResponse/return') doc(col)

		IF (@TipoCripto = 'D')
		BEGIN

			SET @Aux =  CAST(N'' as xml).value('xs:base64Binary(sql:variable("@sAuxiliar"))', 'varbinary(max)')
			SET @sRetorno = CONVERT(varchar(max),@Aux,2)
			
		END
		ELSE
		BEGIN


			IF (@iRetorno = 0)
				EXEC Encripta_HSM 2 ,'', @sInput, @sRetorno OUT
			ELSE 
				SET @sRetorno = @sMessageError
				
		END

	END
	ELSE IF (@sSoapMetodo = 'TranslateRequest')
	BEGIN

		SELECT 
			 @sMessageError= doc.col.value('message[1]','nvarchar(max)')
			,@iRetorno= doc.col.value ('returnCode[1]','int')
			,@sAuxiliar=doc.col.value ('data[1]','nvarchar(max)')
		FROM @sResponseXml.nodes ('Envelope/Body/translateDataResponse/return') doc(col)

		IF (@iRetorno = 0)
		BEGIN

			SET @Aux =  CAST(N'' as xml).value('xs:base64Binary(sql:variable("@sAuxiliar"))', 'varbinary(max)')
			SET @sRetorno = CONVERT(varchar(max),@Aux,2)

		END
		ELSE 
			SET @sRetorno = @sMessageError
		
	END
	ELSE IF (@sSoapMetodo = 'VerifyRequest')
	BEGIN

		SELECT 
			 @sMessageError= doc.col.value('message[1]','nvarchar(max)')
			,@iRetorno= doc.col.value ('returnCode[1]','int')
			,@sAuxiliar=doc.col.value ('equal[1]','nvarchar(max)')
		FROM @sResponseXml.nodes ('Envelope/Body/verifyResponse/return') doc(col)

		IF (@iRetorno = 0)
		BEGIN
	
			SET @sRetorno = CONVERT (BIT, @sAuxiliar)

		END
		ELSE 
			SET @sRetorno = @sMessageError

	END
	
	FIM:
		EXEC sp_OADestroy @Obj

		IF (@iRetorno <> 0)
			SET @sRetorno = 'Erro: ' + CAST(@iRetorno AS VARCHAR) + ' - ' + @sMessageError



END



