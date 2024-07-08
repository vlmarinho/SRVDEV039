/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_Aut_AlterarSenhaHSM]
Propósito: Procedure responsável por alterar senha atraves do HSM.
Autor: Cristiano Silva Barbosa - Tecnologia Policard
--------------------------------------------------------------------------
Data Alteração: 26/04/2018
Chamados: 494467  / 3947
Responsavel: Cristiano Barbosa- Up Brasil
--------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[pr_Aut_AlterarSenhaHSM](
	 @cNumeroCartao		VARCHAR(16)
	,@sSenhaCapturada	VARCHAR(16)
	,@cBaseOrigem		CHAR(1)
	,@iRedeNumero		INT
	,@cProvedor			VARCHAR(50)
	,@iCartaoUsuario	INT
	,@iFranquiUsuario	INT
	,@iResposta			INT		OUTPUT
	)
AS
BEGIN 

	SET @iResposta = 1

	DECLARE 
		-- @lensenha			CHAR(2)
		--,@i					INT
		 @dDataAlteracao	DATETIME
		,@sHttpMethod		VARCHAR(10)
		,@sServerName		VARCHAR(100)
		,@sUrl				VARCHAR(1024)
		,@sSoapAction		VARCHAR(1024)
		,@sSoapMetodo		VARCHAR(1024)
		,@sParamsValues		VARCHAR(MAX)  
		,@sRetorno			VARCHAR(MAX)
		,@sAuxiliar			VARCHAR(MAX)
		,@sLabelChaveTDB	VARCHAR(50)
		,@sLabelChavePOS	VARCHAR(50)
		,@sLabelChaveRSA	VARCHAR(50)
		,@sLenChaveRSA		VARCHAR(4)

	SELECT @sLabelChaveTDB = LabelChaveTDB
			,@sLabelChavePOS = LabelChavePOS
			,@sLabelChaveRSA = LabelChaveRSA
			,@sLenChaveRSA   = LenChaveRSA
			,@dDataAlteracao = GETDATE()
	FROM aut_ChavesHSM WITH (NOLOCK)
	WHERE Provedor = @cProvedor
	AND IdRede = @iRedeNumero

	--IF (@sSenhaCapturada IS NOT NULL)
	--BEGIN

	--	SELECT @lensenha = dbo.f_ZerosEsquerda(LEN(@sSenhaCapturada),2)
	--		  ,@i = 1
	--		  ,@sPinBlockPWD = ''

	--	SELECT @cNumeroCartao = dbo.f_ZerosEsquerda(SUBSTRING(@cNumeroCartao,4,12),16)
	--		  ,@sSenhaCapturada = dbo.f_PreencheCaracter('F', CONVERT(VARCHAR(16),@lensenha) + CONVERT(VARCHAR(16),@sSenhaCapturada),16,'D')

	--	WHILE @i <= LEN(@cNumeroCartao)
	--	BEGIN

	--		DECLARE @Num1 INT = 0
	--			   ,@Num2 INT = 0
	--			   ,@Aux  INT = 0
	--			   ,@HEX  CHAR(1)

	--		SELECT @Num1 = DBO.f_AUT_HexadecimalParaDecimal(SUBSTRING(@cNumeroCartao, @i, 1))
	--			  ,@Num2 = DBO.f_AUT_HexadecimalParaDecimal(SUBSTRING(@sSenhaCapturada, @i, 1))
		
	--		SELECT @Aux = @Num1 ^ @Num2

	--		SELECT @HEX = dbo.f_InteiroParaHexadecimal(@Aux)

	--		SET @sPinBlockPWD = @sPinBlockPWD + @HEX

	--		SET @i = @i + 1

	--	END
	--END

	IF (@sSenhaCapturada <> '' OR @sSenhaCapturada IS NOT NULL)
	BEGIN

		SELECT @sServerName = @@SERVERNAME
			  ,@sHttpMethod = 'SOAP'
			  
		IF (@sServerName = 'SRVUDI039\PROCESSADORA')
			SET @sUrl = 'http://srvudi036:8180/hstcryptoapi/webservice?wsdl' /*PRODUCAO*/
		ELSE
			SET @sUrl = 'http://srvudi044hml:8180/hstcryptoapi/webservice?wsdl'	/*DESENVOLVIMENTO*/

		/*GET RSA*/
		SET @sParamsValues = 'requestId=123&exponent=Aw==&rsaLabel='+ @sLabelChaveRSA +'&size=' + @sLenChaveRSA +''
		SET @sSoapAction = 'ws:getRSA'
		SET @sSoapMetodo = 'RSARequest'

		EXEC [pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sSoapAction, @sSoapMetodo, @sSenhaCapturada, @sAuxiliar OUTPUT, @sRetorno OUTPUT, @iResposta OUTPUT
		
		IF (@iResposta = 0)
		BEGIN

			EXEC dbo.pr_Aut_HexaDecimal_Base64 @sRetorno OUTPUT

			/*GET TOKEN*/
			SET @sParamsValues = 'requestId=123&key='+ @sRetorno + '&rsaLabel='+ @sLabelChaveRSA + ''
			SET @sSoapAction = 'ws:requestToken'
			SET @sSoapMetodo = 'TokenRequest'

			EXEC [pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sSoapAction, @sSoapMetodo, @sSenhaCapturada, @sAuxiliar OUTPUT, @sRetorno OUTPUT, @iResposta OUTPUT

			IF (@iResposta = 0)
			BEGIN

				EXEC dbo.pr_Aut_HexaDecimal_Base64 @sRetorno OUTPUT

				/*TRANSLATE*/
				SET @sParamsValues = 'requestId=123&data='+ @sRetorno +'&sourceToken='+ @sAuxiliar + '&targetLabel=' + @sLabelChaveTDB + ''
				SET @sSoapAction = 'ws:translateData'
				SET @sSoapMetodo = 'TranslateRequest'
			
				EXEC [pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sSoapAction, @sSoapMetodo, @sSenhaCapturada, @sAuxiliar OUTPUT, @sRetorno OUTPUT, @iResposta OUTPUT

				IF (@iResposta = 0 AND LEN (@sRetorno) = 16)
				BEGIN

					IF (@cBaseOrigem = 'P')
					BEGIN

						UPDATE Processadora.dbo.CartoesUsuarios 
						SET PinBlock = @sRetorno
							,DataAlteracaoSenha = @dDataAlteracao 
							,DataAlteracaoPinBlock = @dDataAlteracao
							,AtualizaSenhaTransacao = 0
						WHERE CrtUsrCodigo = @iCartaoUsuario


					END		
					ELSE
					BEGIN

						UPDATE Policard_603078.dbo.Cartao_Usuario 
						SET PinBlock = @sRetorno
							,DataAlteracaoSenha = @dDataAlteracao 
							,DataAlteracaoPinBlock = @dDataAlteracao
							,AtualizaSenhaTransacao = 0
						WHERE Codigo = @iCartaoUsuario
						AND Franquia = @iFranquiUsuario

							
					END
				END
			END
		END
	END
END
