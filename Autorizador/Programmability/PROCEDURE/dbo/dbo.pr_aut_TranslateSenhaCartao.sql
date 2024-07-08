
/*
=====================================================================
Projeto: Translate de Senha
Descrição: Procedure utilizada para efetuar transale de senha via HSM
Autor:	Cristiano Silva Barbosa
Data Criacao: 28/09/2017
Chamado/Mudança: 417680 / 3262
---------------------------------------------------------------------
Autor:	Cristiano Silva Barbosa
Data Criacao: 30/10/2017
Chamado/Mudança: 440910/3388
---------------------------------------------------------------------
Autor:	Cristiano Silva Barbosa
Data Criacao: 12/03/2018
Chamado/Mudança: 487658 / 3809
---------------------------------------------------------------------
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
=====================================================================

*/

CREATE PROCEDURE [dbo].[pr_aut_TranslateSenhaCartao]
	@sBit001 VARCHAR(1000) OUTPUT, @sBit002 VARCHAR(1000) OUTPUT, @sBit003 VARCHAR(1000) OUTPUT, @sBit004 VARCHAR(1000) OUTPUT,
	@sBit005 VARCHAR(1000) OUTPUT, @sBit006 VARCHAR(1000) OUTPUT, @sBit007 VARCHAR(1000) OUTPUT, @sBit008 VARCHAR(1000) OUTPUT,
	@sBit009 VARCHAR(1000) OUTPUT, @sBit010 VARCHAR(1000) OUTPUT, @sBit011 VARCHAR(1000) OUTPUT, @sBit012 VARCHAR(1000) OUTPUT,
	@sBit013 VARCHAR(1000) OUTPUT, @sBit014 VARCHAR(1000) OUTPUT, @sBit015 VARCHAR(1000) OUTPUT, @sBit016 VARCHAR(1000) OUTPUT,
	@sBit017 VARCHAR(1000) OUTPUT, @sBit018 VARCHAR(1000) OUTPUT, @sBit019 VARCHAR(1000) OUTPUT, @sBit020 VARCHAR(1000) OUTPUT,
	@sBit021 VARCHAR(1000) OUTPUT, @sBit022 VARCHAR(1000) OUTPUT, @sBit023 VARCHAR(1000) OUTPUT, @sBit024 VARCHAR(1000) OUTPUT,
	@sBit025 VARCHAR(1000) OUTPUT, @sBit026 VARCHAR(1000) OUTPUT, @sBit027 VARCHAR(1000) OUTPUT, @sBit028 VARCHAR(1000) OUTPUT,
	@sBit029 VARCHAR(1000) OUTPUT, @sBit030 VARCHAR(1000) OUTPUT, @sBit031 VARCHAR(1000) OUTPUT, @sBit032 VARCHAR(1000) OUTPUT,
	@sBit033 VARCHAR(1000) OUTPUT, @sBit034 VARCHAR(1000) OUTPUT, @sBit035 VARCHAR(1000) OUTPUT, @sBit036 VARCHAR(1000) OUTPUT,
	@sBit037 VARCHAR(1000) OUTPUT, @sBit038 VARCHAR(1000) OUTPUT, @sBit039 VARCHAR(1000) OUTPUT, @sBit040 VARCHAR(1000) OUTPUT,
	@sBit041 VARCHAR(1000) OUTPUT, @sBit042 VARCHAR(1000) OUTPUT, @sBit043 VARCHAR(1000) OUTPUT, @sBit044 VARCHAR(1000) OUTPUT,
	@sBit045 VARCHAR(1000) OUTPUT, @sBit046 VARCHAR(1000) OUTPUT, @sBit047 VARCHAR(1000) OUTPUT, @sBit048 VARCHAR(1000) OUTPUT,
	@sBit049 VARCHAR(1000) OUTPUT, @sBit050 VARCHAR(1000) OUTPUT, @sBit051 VARCHAR(1000) OUTPUT, @sBit052 VARCHAR(1000) OUTPUT,
	@sBit053 VARCHAR(1000) OUTPUT, @sBit054 VARCHAR(1000) OUTPUT, @sBit055 VARCHAR(1000) OUTPUT, @sBit056 VARCHAR(1000) OUTPUT,
	@sBit057 VARCHAR(1000) OUTPUT, @sBit058 VARCHAR(1000) OUTPUT, @sBit059 VARCHAR(1000) OUTPUT, @sBit060 VARCHAR(1000) OUTPUT,
	@sBit061 VARCHAR(1000) OUTPUT, @sBit062 VARCHAR(1000) OUTPUT, @sBit063 VARCHAR(1000) OUTPUT, @sBit064 VARCHAR(1000) OUTPUT,
	@sBit065 VARCHAR(1000) OUTPUT, @sBit066 VARCHAR(1000) OUTPUT, @sBit067 VARCHAR(1000) OUTPUT, @sBit068 VARCHAR(1000) OUTPUT,
	@sBit069 VARCHAR(1000) OUTPUT, @sBit070 VARCHAR(1000) OUTPUT, @sBit071 VARCHAR(1000) OUTPUT, @sBit072 VARCHAR(1000) OUTPUT,
	@sBit073 VARCHAR(1000) OUTPUT, @sBit074 VARCHAR(1000) OUTPUT, @sBit075 VARCHAR(1000) OUTPUT, @sBit076 VARCHAR(1000) OUTPUT,
	@sBit077 VARCHAR(1000) OUTPUT, @sBit078 VARCHAR(1000) OUTPUT, @sBit079 VARCHAR(1000) OUTPUT, @sBit080 VARCHAR(1000) OUTPUT,
	@sBit081 VARCHAR(1000) OUTPUT, @sBit082 VARCHAR(1000) OUTPUT, @sBit083 VARCHAR(1000) OUTPUT, @sBit084 VARCHAR(1000) OUTPUT,
	@sBit085 VARCHAR(1000) OUTPUT, @sBit086 VARCHAR(1000) OUTPUT, @sBit087 VARCHAR(1000) OUTPUT, @sBit088 VARCHAR(1000) OUTPUT,
	@sBit089 VARCHAR(1000) OUTPUT, @sBit090 VARCHAR(1000) OUTPUT, @sBit091 VARCHAR(1000) OUTPUT, @sBit092 VARCHAR(1000) OUTPUT,
	@sBit093 VARCHAR(1000) OUTPUT, @sBit094 VARCHAR(1000) OUTPUT, @sBit095 VARCHAR(1000) OUTPUT, @sBit096 VARCHAR(1000) OUTPUT,
	@sBit097 VARCHAR(1000) OUTPUT, @sBit098 VARCHAR(1000) OUTPUT, @sBit099 VARCHAR(1000) OUTPUT, @sBit100 VARCHAR(1000) OUTPUT,
	@sBit101 VARCHAR(1000) OUTPUT, @sBit102 VARCHAR(1000) OUTPUT, @sBit103 VARCHAR(1000) OUTPUT, @sBit104 VARCHAR(1000) OUTPUT,
	@sBit105 VARCHAR(1000) OUTPUT, @sBit106 VARCHAR(1000) OUTPUT, @sBit107 VARCHAR(1000) OUTPUT, @sBit108 VARCHAR(1000) OUTPUT,
	@sBit109 VARCHAR(1000) OUTPUT, @sBit110 VARCHAR(1000) OUTPUT, @sBit111 VARCHAR(1000) OUTPUT, @sBit112 VARCHAR(1000) OUTPUT,
	@sBit113 VARCHAR(1000) OUTPUT, @sBit114 VARCHAR(1000) OUTPUT, @sBit115 VARCHAR(1000) OUTPUT, @sBit116 VARCHAR(1000) OUTPUT,
	@sBit117 VARCHAR(1000) OUTPUT, @sBit118 VARCHAR(1000) OUTPUT, @sBit119 VARCHAR(1000) OUTPUT, @sBit120 VARCHAR(1000) OUTPUT,
	@sBit121 VARCHAR(1000) OUTPUT, @sBit122 VARCHAR(1000) OUTPUT ,@sBit123 VARCHAR(1000) OUTPUT, @sBit124 VARCHAR(1000) OUTPUT,
	@sBit125 VARCHAR(1000) OUTPUT, @sBit126 VARCHAR(1000) OUTPUT, @sBit127 VARCHAR(1000) OUTPUT, @sBit128 VARCHAR(1000) OUTPUT,
	@iResposta INT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE  
		@sPlanoAutorizador			VARCHAR(16)
		,@cChaveTrabalho			CHAR(16)
		,@iRedeNumero				INT
		,@cNumeroCartao				CHAR(16)
		,@cProvedor					VARCHAR(50)
		,@iCodigoEstabelecimento	BIGINT
		,@iTamanhoSenha				INT
		,@bProdutoMigrado			BIT
		
	SET @sPlanoAutorizador = @sBit052
	SET @iRedeNumero = CASE WHEN CONVERT(BIGINT, @sBit032) IN (58, 13, 14, 15) THEN CONVERT(BIGINT, @sBit032)
						WHEN CONVERT(BIGINT, @sBit032) = 6142 AND @sBit001 <> '0800' THEN 10 /*Abertura de POS Walk envia Bit32 = 6142*/					  
						WHEN CONVERT(BIGINT, @sBit032) NOT IN (6142, 58) AND CONVERT(BIGINT, @sBit024) IN (SELECT Numero FROM Acquirer.dbo.SubRede WITH(NOLOCK)) THEN CONVERT(BIGINT, @sBit024)
						WHEN @sBit123 LIKE 'SCOPE%' THEN 7
					ELSE 0 END

	SET @cProvedor = CASE WHEN @iRedeNumero = 58 THEN 'POS WALK'
						WHEN @iRedeNumero = 10 THEN 'CIELO'
						WHEN @sBit123 LIKE 'SCOPE%' THEN SUBSTRING(@sBit123,1,12)
					ELSE @sBit048 END

	/*Capturando Cartão */
	IF (@sBit002 <> '' AND LEN (@sBit002) = 16 AND @sBit001 IN ('0100','0200'))
		SET @cNumeroCartao = @sBit002		/* Número do cartão - Digitação manual */
	ELSE
	BEGIN

		SET @cNumeroCartao = @sBit002 /* Número do cartão - Digitação manual */  /* CH - 58085 */

		IF (@cNumeroCartao IS NULL) OR (@cNumeroCartao = '')
			SET @cNumeroCartao = LEFT(@sBit035,16)				/* Número do cartão - Trilha 2 do cartão */
	
		IF (@cNumeroCartao IS NULL) OR (@cNumeroCartao = '')
			SET @cNumeroCartao = SUBSTRING(@sBit045,2,16)		/* Número do cartão - Trilha 1 do cartão */
		
	END

	IF LEFT(@cNumeroCartao,6) IN ('639240')
		SET @bProdutoMigrado = 1

	/*Validar se o codigo do estabelecimento é numerico*/
	IF (ISNUMERIC(@sBit042) = 1)
	BEGIN

		DECLARE @sCodigoEstabelecimento VARCHAR(15)
				,@cStatus CHAR(1)
				,@bEstabMigrado BIT

		SET @sCodigoEstabelecimento = @sBit042
		
		EXEC [dbo].[pr_AUT_RetornarEstabelecimento]  @sCodigoEstabelecimento OUTPUT, @cStatus OUTPUT ,@bEstabMigrado OUTPUT
	
		SELECT @iCodigoEstabelecimento = CONVERT(BIGINT,@sCodigoEstabelecimento)
	
	END

	IF (@iRedeNumero IN (10, 13, 22, 23, 24, 25, 58) OR @sBit104 = '003')
	BEGIN
				
		DECLARE @cWorkingKey VARCHAR(32)
				,@cWorkingKeyAux VARCHAR (32)
				
		SET @cWorkingKey = ''
					
		IF (@iRedeNumero IN (22,23,24))
		BEGIN

			IF EXISTS (SELECT 1 FROM dbo.WorkingKey WITH (NOLOCK) WHERE Terminal = @sBit041)
			BEGIN 
				SELECT @cWorkingKey = ChaveTrabalho FROM WorkingKey WITH (NOLOCK) WHERE terminal = @sBit041
			END 
			ELSE
			BEGIN
	
				INSERT INTO WorkingKey (TERMINAL, ChaveTrabalho, DataCriacaoChave, Provedor, Estabelecimento)
				(
				SELECT TERMINAL, ChaveTrabalho, DataCriacaoChave, Provedor, Estabelecimento 
				FROM Autorizacao.dbo.Aut_WorkingKey WITH(NOLOCK)
				WHERE terminal = @sBit041
				)
						
				SELECT @cWorkingKey = ChaveTrabalho FROM WorkingKey WITH (NOLOCK) WHERE terminal = @sBit041

			END					
					
			EXEC dbo.pr_aut_DecriptaTDES @cWorkingKey OUTPUT
										
			IF LEN (@cWorkingKey) = 32
				SELECT @sPlanoAutorizador = dbo.DecriptaSenha (@sPlanoAutorizador, @cWorkingKey, @cNumeroCartao)

		END
		ELSE IF (@iRedeNumero = 25)
		BEGIN 
									

			SELECT @cWorkingKey  = CHAVE FROM dbo.MasterkeySysdata WITH(NOLOCK) WHERE Indice = @sBit063

			IF LEN (@cWorkingKey) = 32
				SELECT @sPlanoAutorizador = dbo.DecriptaSenha (@sPlanoAutorizador, @cWorkingKey, @cNumeroCartao)

			SET @sBit063 = ''

		END
		ELSE IF (@sBit104 = '003' AND @cProvedor = 'PAYGO')
		BEGIN
					
			IF EXISTS (SELECT 1 FROM dbo.WorkingKey WITH (NOLOCK) WHERE Terminal = @sBit041 AND Estabelecimento = @iCodigoEstabelecimento)
			BEGIN 
				SELECT @cWorkingKey = ChaveTrabalho FROM WorkingKey WITH (NOLOCK) WHERE terminal = @sBit041 AND Estabelecimento = @iCodigoEstabelecimento
			END
			ELSE
			BEGIN

				INSERT INTO WorkingKey (TERMINAL, ChaveTrabalho, DataCriacaoChave, Provedor, Estabelecimento)
				(
				SELECT TERMINAL, ChaveTrabalho, DataCriacaoChave, Provedor, Estabelecimento 
				FROM Autorizacao.dbo.Aut_WorkingKey WITH(NOLOCK)
				WHERE terminal = @sBit041 AND Estabelecimento = @iCodigoEstabelecimento
				)
				SELECT @cWorkingKey = ChaveTrabalho FROM WorkingKey WITH (NOLOCK) WHERE terminal = @sBit041 AND Estabelecimento = @iCodigoEstabelecimento

			END
										
			EXEC dbo.pr_aut_DecriptaTDES @cWorkingKey OUTPUT
										
			IF LEN (@cWorkingKey) = 32
				SELECT @sPlanoAutorizador = dbo.DecriptaSenha (@sPlanoAutorizador, @cWorkingKey, @cNumeroCartao)

		END
		ELSE
			IF (@iRedeNumero = 27)
			BEGIN
				EXEC dbo.pr_DecriptaSenha @cNumeroCartao, @sPlanoAutorizador OUTPUT, 'APP MOBILE'
				SET @sPlanoAutorizador = SUBSTRING(@sPlanoAutorizador, 13, 4)
			END
			ELSE
				EXEC dbo.pr_DecriptaSenha @cNumeroCartao, @sPlanoAutorizador OUTPUT
	END
	ELSE
	BEGIN


		IF (@cProvedor = 'SCOPEPRIVATE')
		BEGIN 

			DECLARE @VTableScope TABLE (Codigo INT, Chave VARCHAR(32),Processado BIT)

			INSERT INTO @VTableScope
			SELECT TOP 5 Codigo, ChaveTrabalho, 0
			FROM dbo.WorkingKey WITH (NOLOCK) 
			WHERE Estabelecimento = @iCodigoEstabelecimento 
			AND Provedor = @cProvedor 
			ORDER BY 1 DESC


			WHILE EXISTS (SELECT * FROM @VTableScope WHERE Processado = 0)
			BEGIN
					
				SELECT TOP 1 @cWorkingKey = Chave FROM @VTableScope WHERE Processado = 0 ORDER BY Codigo DESC
				SET @cWorkingKeyAux = @cWorkingKey

				EXEC dbo.pr_aut_DecriptaScope @sBit123, @cWorkingKey OUTPUT
					
				IF LEN (@cWorkingKey) = 32
					SELECT @sPlanoAutorizador = dbo.DecriptaSenha (@sBit052, @cWorkingKey, @cNumeroCartao)
						
				/*Valida se a senha retornada é numerica e maior ou igual a 4 digitos*/
				IF ((ISNUMERIC(@sPlanoAutorizador)= 1 AND @sPlanoAutorizador NOT LIKE '%[A-Z]%' AND LEN(@sPlanoAutorizador) >= 4)) BREAK
					UPDATE @VTableScope SET Processado = 1 WHERE Chave = @cWorkingKeyAux

			END

		END
		ELSE IF (@cProvedor = 'VBI')/*PROVEDOR VBI COM CHAVE 3DES*/
		BEGIN

			SET @sPlanoAutorizador = @sBit052

			EXEC dbo.pr_DecriptaSenha @cNumeroCartao, @sPlanoAutorizador OUTPUT, @cProvedor

		END
		ELSE IF (@cProvedor = 'SOFTWARE EXPRESS') /*PROVEDOR SOFTWARE EXPRESS COM CHAVE 3DES*/
		BEGIN

			DECLARE @bSenhaValida BIT

			SET @sPlanoAutorizador = @sBit052
														
			EXEC dbo.pr_aut_DecriptaSenhaSE3DES @sPlanoAutorizador OUTPUT, @bSenhaValida OUTPUT
							
		END
		ELSE IF (@cProvedor IN ('CSI_CTF','ITAUTEC', 'ITAUTEC-SCOPE', 'DIRECAO', 'PAYGO'))
		BEGIN
	
			DECLARE @VTable TABLE (Chave VARCHAR(16), Processado BIT)

			SET @cChaveTrabalho = ''

			INSERT INTO @VTable
			SELECT	TOP 20 ChaveTrabalho, 0
			FROM	dbo.ChaveAberturaTEF WITH(NOLOCK)
			WHERE	Estabelecimento = @iCodigoEstabelecimento
			AND Provedor = @cProvedor
			AND ChaveTrabalho NOT IN ('-1','-2','') /*Chave com erro na geração*/
			ORDER BY ChaveAberturaTefCodigo DESC


			WHILE EXISTS (SELECT * FROM @VTable WHERE Processado = 0)
			BEGIN

				SELECT TOP 1 @cChaveTrabalho = Chave FROM @VTable WHERE Processado = 0

				IF (@cProvedor = 'DIRECAO')
				BEGIN
							
					IF (@sBit120 <> '')
						SET @iTamanhoSenha = CONVERT(INT,@sBit120)
					ELSE
					BEGIN

						IF (@bProdutoMigrado = 1)
							SET @iTamanhoSenha = 6
						ELSE
							SET @iTamanhoSenha = 4
						END
								
					SELECT @sPlanoAutorizador = [dbo].[DecriptografarDirecao] (@cChaveTrabalho, @sBit052, @iTamanhoSenha)

				END
				ELSE IF (@cProvedor IN ('ITAUTEC','ITAUTEC-SCOPE'))
					SELECT @sPlanoAutorizador = [dbo].[DecriptarItautec] (@cChaveTrabalho, @sBit052)
				ELSE IF (@cProvedor = 'CSI_CTF')
				BEGIN
							
					IF (@bProdutoMigrado = 1)
						SET @iTamanhoSenha = 6
					ELSE
						SET @iTamanhoSenha = 4

					SELECT @sPlanoAutorizador = [dbo].[DecriptarCSI] (@cChaveTrabalho, @sBit052, @iTamanhoSenha)

				END
				

				IF (ISNUMERIC(@sPlanoAutorizador) = 1  AND LEN(@sPlanoAutorizador) >= 4) BREAK

				UPDATE @VTable SET Processado = 1 WHERE Chave = @cChaveTrabalho
			END
		END
	END
	
	IF (ISNUMERIC(@sPlanoAutorizador)= 1 AND @sPlanoAutorizador NOT LIKE '%[A-Z]%' AND LEN(@sPlanoAutorizador) >= 4)
	BEGIN
	
		DECLARE 	
			 @sUrl				VARCHAR(1024)
			,@sHttpMethod		VARCHAR(10)
			,@sParamsValues		VARCHAR(MAX)  
			,@sSoapAction		VARCHAR(1024)
			,@sSoapMetodo		VARCHAR(1024)
			,@sRetorno			VARCHAR (MAX)
			,@iRetorno			INT = 0
			,@sAuxiliar			VARCHAR(MAX)
			,@sBinHex			VARCHAR(MAX)
			,@vBinary			VARBINARY(MAX)
			,@Statement			NVARCHAR(MAX)
			,@sServerName		VARCHAR(100)
			,@sLabelChaveTDB	VARCHAR(50)
			,@sLabelChavePOS	VARCHAR(50)
			,@sLabelChaveRSA	VARCHAR(50)
			,@sChaveRSA			varchar(2048)
			,@sLenChaveRSA		VARCHAR(4)


		SELECT @sLabelChaveTDB = LabelChaveTDB
			  ,@sLabelChavePOS = LabelChavePOS
			  ,@sLabelChaveRSA = LabelChaveRSA
			  ,@sLenChaveRSA   = CONVERT(VARCHAR(4),LenChaveRSA)
			  ,@sChaveRSA	   = ChaveRSA
		FROM aut_ChavesHSM WITH (NOLOCK)
		WHERE Provedor = @cProvedor
		AND IdRede = @iRedeNumero

		SELECT @sServerName = @@SERVERNAME
			  ,@sHttpMethod = 'SOAP'

		IF (@sServerName = 'SRVUDI039\PROCESSADORA')
			SET @sUrl = 'http://srvudi036:8180/hstcryptoapi/webservice?wsdl' /*PRODUCAO*/
		ELSE
			SET @sUrl = 'http://srvudi044hml:8180/hstcryptoapi/webservice?wsdl'	/*DESENVOLVIMENTO*/
			
		IF (@sChaveRSA IS NULL)
		BEGIN
		
			/*GET RSA*/
			SET @sParamsValues = 'requestId=123&exponent=Aw==&rsaLabel='+ @sLabelChaveRSA +'&size='+ @sLenChaveRSA +''
			SET @sSoapAction = 'ws:getRSA'
			SET @sSoapMetodo = 'RSARequest'
			
			EXEC [pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sSoapAction, @sSoapMetodo, @sPlanoAutorizador, @sAuxiliar OUTPUT, @sRetorno OUTPUT, @iRetorno OUTPUT
			
			IF (@sAuxiliar IS NOT NULL)
			BEGIN
	
				UPDATE aut_ChavesHSM 
				SET ChaveRSA = @sAuxiliar
					,Data = GETDATE()
				WHERE Provedor = @cProvedor
				AND IdRede = @iRedeNumero

			END
			
		END
		ELSE
		BEGIN
				
			EXEC Encripta_HSM 1 ,@sChaveRSA, @sPlanoAutorizador, @sRetorno OUT
			
		END 
	
		IF @iRetorno = 0
		BEGIN

			EXEC dbo.pr_Aut_HexaDecimal_Base64 @sRetorno OUTPUT
			
			/*GET TOKEN*/
			SET @sParamsValues = 'requestId=123&key='+ @sRetorno + '&rsaLabel='+ @sLabelChaveRSA + ''
			SET @sSoapAction = 'ws:requestToken'
			SET @sSoapMetodo = 'TokenRequest'

			EXEC [pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sSoapAction, @sSoapMetodo, @sPlanoAutorizador, @sAuxiliar OUTPUT, @sRetorno OUTPUT, @iRetorno OUTPUT

			IF (@iRetorno = 0)
			BEGIN
							
	
				EXEC dbo.pr_Aut_HexaDecimal_Base64 @sRetorno OUTPUT

				/*TRANSLATE*/
				SET @sParamsValues = 'requestId=123&data='+ @sRetorno +'&sourceToken='+ @sAuxiliar + '&targetLabel=' + @sLabelChaveTDB + ''
				SET @sSoapAction = 'ws:translateData'
				SET @sSoapMetodo = 'TranslateRequest'
			
				EXEC [pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sSoapAction, @sSoapMetodo, @sPlanoAutorizador, @sAuxiliar OUTPUT, @sRetorno OUTPUT, @iRetorno OUTPUT
						
				IF (@iRetorno = 0 AND LEN (@sRetorno) = 16)
					SET @sBit052 = @sRetorno

			END
		END
	END

	IF @sBit001 = '0200'
		SET @sBit001 = '0210'
	ELSE IF @sBit001 = '0400'
		SET @sBit001 = '0410'
	ELSE IF @sBit001 = '0420'
		SET @sBit001 = '0430'
	ELSE IF @sBit001 = '0500'
		SET @sBit001 = '0510'
	ELSE IF @sBit001 = '0600'
		SET @sBit001 = '0610'
	ELSE IF @sBit001 = '0800'
		SET @sBit001 = '0810'
	ELSE IF @sBit001 = '0100'
		SET @sBit001 = '0110'
	
END

