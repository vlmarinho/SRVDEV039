/*
--------------------------------------------------------------------------
Data Alteração: 16/04/2019
Chamados: 5070/628394
Responsavel: João Henrique - Up Brasil
Descrição: Validação OTP
--------------------------------------------------------------------------
*/
CREATE PROCEDURE pr_Aut_ValidarToken (@cBit052 varchar(32), @iResposta int Output)
AS
BEGIN

	DECLARE @OBJ INT;
	DECLARE @sUserId VARCHAR(20);
	DECLARE @iOtpCode VARCHAR(20);
	DECLARE @URL VARCHAR(200);
	DECLARE @RESPONSE VARCHAR(4000);
	DECLARE @sResponseXml XML;
	DECLARE @sRetorno Varchar(max)


	SET @sUserId = convert(bigint,substring(@cBit052,1,10))
	SET @iOtpCode = substring(@cBit052,11,6)
	

	--SET @URL = 'https://apis.upbrasil.com/v1/otp/api/user_devices/check_otp?request.userId='+@sUserId+'&request.oTPCode='+@iOtpCode+''
	--SET @URL = 'http://apihml.upbrasil.com/v1/otp/api/user_devices/check_otp?request.userId='+@sUserId+'&request.oTPCode='+@iOtpCode+''
		SET @Url = 'https://pnas.upbrasil.com/upidentificator/api/user_devices/check_otp?request.userId='+@sUserId+'&request.otpCode='+@iOtpCode+''
		EXEC SP_OACREATE 'MSXML2.ServerXMLHttp', @OBJ out
		EXEC sp_OAMethod @obj, 'setRequestHeader', NULL, 'Content-Type','application/json'
		EXEC sp_OAMethod @obj, 'setRequestHeader', NULL, 'apikey','dc2c7029-e43b-42ce-8944-a69ae4abbcba'
		EXEC SP_OAMETHOD @OBJ, 'OPEN', NULL, 'GET', @URL, FALSE
		EXEC SP_OAMETHOD @OBJ, 'SEND'
		exec SP_OAGETPROPERTY @OBJ, 'responseText', @RESPONSE out
		EXEC SP_OADESTROY @OBJ


	DECLARE @IPOINT INT
	DECLARE @TABLE TABLE(DADOS VARCHAR(1000))

	WHILE (CHARINDEX(',',@RESPONSE) > 0 )
	BEGIN

		SET @IPOINT = CHARINDEX(',',@RESPONSE) 
		INSERT INTO @TABLE

		SELECT SUBSTRING(@RESPONSE,0,@IPOINT)
		SET @RESPONSE = SUBSTRING(@RESPONSE,@IPOINT+1, LEN(@RESPONSE))

		IF (LEN(@RESPONSE) > 0 AND CHARINDEX(',',@RESPONSE) = 0 )
		BEGIN
			INSERT INTO @TABLE
			SELECT @RESPONSE
		END
	END


	IF EXISTS (SELECT 1 FROM @TABLE)
		SET @iResposta = 27
	Else
		SET @iResposta = 0

END


