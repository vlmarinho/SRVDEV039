

/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_Aut_DecriptaSenhaHSM]
Propósito: Procedure responsável por decriptar senha atraves do HSM.
Autor: Cristiano Silva Barbosa - Tecnologia Policard
--------------------------------------------------------------------------
Data Alteração: 26/04/2018
Chamados: 494467  / 3947
Responsavel: Cristiano Barbosa- Up Brasil
--------------------------------------------------------------------------
Data Alteração: 29/11/2018
Chamados: 581341/4666
Responsavel: João Henrique- Up Brasil
--------------------------------------------------------------------------
Data Alteracao: 05/08/2021
Autor: João Henrique
CH: 1741118 
Descrição: Inclusão da captura dos cartões PAT na PagSeguro
--------------------------------------------------------------------------
Data: 09/08/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1893271 - GMUD: 1893858
Descrição: Otimiza trecho de código que efetua o XOR.
-------------------------------------------------------------------------- 
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1888210
Descrição: Projeto ABECS para transações Auttar/Getnet.
-------------------------------------------------------------------------- 	
*/

CREATE PROCEDURE [dbo].[pr_Aut_DecriptaSenhaHSM](
	 @cNumeroCartao				VARCHAR(16)
	,@iCrtUsrCodigo				INT
	,@iFranquiaUsuario			INT
	,@sSenhaAutorizador			VARCHAR(16)
	,@bBaseOrigem				CHAR(1)
	,@iRedeNumero				INT
	,@iCodigoEstabelecimento	INT
	,@cProvedor					VARCHAR(50)
	,@cBit059					VARCHAR(1000)
	,@iTamanhoSenha				INT
	,@cPlanoBanco				VARCHAR(16)
	,@sPinBlockPWD				VARCHAR(16)
	,@bEncriptaPinBlock			BIT
	,@bSenhaValida				BIT				OUTPUT
	,@iResposta					INT				OUTPUT
	,@cIdentificadorWK			VARCHAR(64) = NULL
	,@cLoteWk					VARCHAR(64) = NULL
	)
AS
BEGIN 

	DECLARE 
		 @lensenha			CHAR(2)
		,@i					INT
		,@resultado			VARCHAR(16)
		,@SessionToken		NVARCHAR(MAX)
		,@dDataAlteracao	DATETIME
		,@Num1 				INT = 0 
		,@Num2 				INT = 0 
		,@Aux 				INT = 0 		
		,@exceptionMessage  VARCHAR(4000)
				
	SET @iResposta = 27
		
	SET @dDataAlteracao = GETDATE()
		
	IF ( @cPlanoBanco IS NOT NULL)
	BEGIN

		SELECT   @lensenha = dbo.f_ZerosEsquerda(LEN(@cPlanoBanco),2)
				,@i = 1
				,@resultado = ''

		SELECT @cNumeroCartao = dbo.f_ZerosEsquerda(SUBSTRING(@cNumeroCartao,4,12),16)
				,@cPlanoBanco = dbo.f_PreencheCaracter('F', CONVERT(VARCHAR(16),@lensenha) + CONVERT(VARCHAR(16),@cPlanoBanco),16,'D')

		WHILE @i <= LEN(@cNumeroCartao)
		BEGIN
			SET @Num1 = CONVERT(INT, convert(VARBINARY(1), '0' + SUBSTRING(@cNumeroCartao, @i, 1), 2))
			SET @Num2 = CONVERT(INT, convert(VARBINARY(1), '0' + SUBSTRING(@cPlanoBanco, @i, 1), 2))
			SET @Aux = @Num1 ^ @Num2
			SET @resultado += right(CONVERT(VARCHAR(2), CONVERT(BINARY (1), @Aux), 2), 1)
			SET @i = @i + 1
		END
		
	END
	ELSE 
	BEGIN
		SET @exceptionMessage = '@cPlanoBanco is null';		
		THROW 500001, @exceptionMessage, 1;		
	END
	
	/*ATENDER GATEWAY SOFTNEX (GETNET, PAGSEGURO)*/
	IF @iRedeNumero IN (32,33,34,35) 
	BEGIN
		SET @iRedeNumero = '32'
		SET @cProvedor = 'GATEWAY SOFTNEX' 
		
	END
	IF @iRedeNumero in (55,56)
	BEGIN

		SET @iRedeNumero = 55
		SET @cProvedor = 'PAGSEGURO' 
		
	END

	
	IF (ISNULL(@resultado, '') <> '')
	BEGIN
	
		/*

		Translate de dados:
		Parâmetros:
			data - Dado a ser convertido.
			sourceLabel - Label da chave pela qual o dado está cifrado.
			sourceToken - Token pelo qual o dado está cifrado.
			targetLabel - Label da chave que deve cifrar o dado.
			targetToken - Token que deve cifrar o dado.
	
			** O uso de label é prioritário, se ambos forem passados será utilizado o label.
		*/


		DECLARE 	
			 @iRetorno			INT = 0
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
			,@sChaveRSA			varchar(2048)
			,@sLenChaveRSA		VARCHAR(4)

		IF @cIdentificadorWK IS NULL
		BEGIN
		
			SELECT @sLabelChaveTDB = LabelChaveTDB
				  ,@sLabelChavePOS = LabelChavePOS
				  ,@sLabelChaveRSA = LabelChaveRSA
				  ,@sLenChaveRSA   = CONVERT(VARCHAR(4),LenChaveRSA)
				  ,@sChaveRSA	   = ChaveRSA
			FROM aut_ChavesHSM WITH (NOLOCK)
			WHERE Provedor = @cProvedor
				AND IdRede = @iRedeNumero;
		END
		ELSE
		BEGIN
			
			SELECT @sLabelChaveTDB = LabelChaveTDB
				  ,@sLabelChavePOS = LabelChavePOS
				  ,@sLabelChaveRSA = LabelChaveRSA
				  ,@sLenChaveRSA   = CONVERT(VARCHAR(4),LenChaveRSA)
				  ,@sChaveRSA	   = ChaveRSA
			FROM aut_ChavesHSM WITH (NOLOCK)
			WHERE Provedor = @cProvedor
				AND IdentificadorWK = @cIdentificadorWK
				AND (@cLoteWk IS NULL OR LoteWK = @cLoteWk)	
		END

		IF (@cProvedor = 'SOFTWARE EXPRESS')
		BEGIN

			DECLARE  @iIDX_DES INT
					,@iIDX_3DES INT
					,@TAG	CHAR(3)
					,@LEN	CHAR(3)
					,@VALUE	VARCHAR(100)

			SET @TAG = SUBSTRING(@cBit059, 1,3)
			SET @LEN = SUBSTRING(@cBit059, 4,3)
			SET @VALUE = SUBSTRING(@cBit059,7,CONVERT(INT, @LEN))
								
			SELECT TOP 1 
				 @iIDX_DES = IDX_DES
				,@iIDX_3DES = IDX_3DES
			FROM dbo.ChaveAberturaTEF WITH(NOLOCK)
			WHERE Estabelecimento = @iCodigoEstabelecimento
			AND Provedor = @cProvedor
			AND (IDX_DES IS NOT NULL AND IDX_3DES IS NOT NULL)
			ORDER BY ChaveAberturaTefCodigo DESC

			IF @VALUE = 0 /*CHAVE DES*/
				SELECT @sLabelChavePOS = LabelChave FROM Aut_Chaves_SE_TMK WITH(NOLOCK) WHERE IdChave = @iIDX_DES
			ELSE IF @VALUE = 1 /*CHAVE 3DES*/
				SELECT @sLabelChavePOS = LabelChave FROM Aut_Chaves_SE_TMK WITH(NOLOCK) WHERE IdChave = @iIDX_3DES

		END
				
		SELECT @sServerName = @@SERVERNAME
			  ,@sHttpMethod = 'SOAP'
			  
		IF (@sServerName = 'SRVUDI039\PROCESSADORA')
			SET @sUrl = 'http://srvudi036:8180/hstcryptoapi/webservice?wsdl' /*PRODUCAO*/
		ELSE
			SET @sUrl = 'http://srvudi044hml:8180/hstcryptoapi/webservice?wsdl'	/*DESENVOLVIMENTO*/

		
		IF (@bEncriptaPinBlock = 1)
		BEGIN 

			IF (@sChaveRSA IS NULL)
			BEGIN
				
				/*GET RSA*/
				SET @sParamsValues = 'requestId=123&exponent=Aw==&rsaLabel='+ @sLabelChaveRSA +'&size='+ @sLenChaveRSA +''
				SET @sSoapAction = 'ws:getRSA'
				SET @sSoapMetodo = 'RSARequest'
				
				EXEC [pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sSoapAction, @sSoapMetodo, @resultado, @sAuxiliar OUTPUT, @sRetorno OUTPUT, @iRetorno OUTPUT
		

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

				EXEC Encripta_HSM 1 ,@sChaveRSA, @resultado, @sRetorno OUTPUT
	
				
			END 

			IF (@iRetorno = 0)
			BEGIN
			
				EXEC dbo.pr_Aut_HexaDecimal_Base64 @sRetorno OUTPUT

				/*GET TOKEN*/
				SET @sParamsValues = 'requestId=123&key='+ @sRetorno + '&rsaLabel='+ @sLabelChaveRSA + ''
				SET @sSoapAction = 'ws:requestToken'
				SET @sSoapMetodo = 'TokenRequest'

				

				EXEC [pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sSoapAction, @sSoapMetodo, @resultado, @sAuxiliar OUTPUT, @sRetorno OUTPUT, @iRetorno OUTPUT
			

				IF (@iRetorno = 0)
				BEGIN

					EXEC dbo.pr_Aut_HexaDecimal_Base64 @sRetorno OUTPUT

					/*TRANSLATE*/
					SET @sParamsValues = 'requestId=123&data='+ @sRetorno +'&sourceToken='+ @sAuxiliar + '&targetLabel=' + @sLabelChaveTDB + ''
					SET @sSoapAction = 'ws:translateData'
					SET @sSoapMetodo = 'TranslateRequest'
	
					EXEC [pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sSoapAction, @sSoapMetodo, @resultado, @sAuxiliar OUTPUT, @sPinBlockPWD OUTPUT, @iRetorno OUTPUT
	
			

					IF (@iRetorno = 0 AND LEN (@sPinBlockPWD) = 16)
					BEGIN

						IF (@bBaseOrigem = 'P')
						BEGIN
						
							UPDATE Processadora.dbo.CartoesUsuarios 
							SET PinBlock = @sPinBlockPWD
								,DataAlteracaoSenha = @dDataAlteracao 
								,DataAlteracaoPinBlock = @dDataAlteracao
							WHERE CrtUsrCodigo = @iCrtUsrCodigo

						END		
						ELSE
						BEGIN
	
							UPDATE Policard_603078.dbo.Cartao_Usuario 
							SET PinBlock = @sPinBlockPWD
								,DataAlteracaoSenha = @dDataAlteracao 
								,DataAlteracaoPinBlock = @dDataAlteracao
							WHERE Codigo = @iCrtUsrCodigo
							AND Franquia = @iFranquiaUsuario
							
						END
					END
				END
			END
			ELSE 
			BEGIN
				SET @exceptionMessage = '@sUrl: ' + CONVERT(VARCHAR,ISNULL(@sUrl, '')) + ','
					+ '@sHttpMethod: ' + CONVERT(VARCHAR,ISNULL(@sHttpMethod, '')) + ','
					+ '@sParamsValues: ' + CONVERT(VARCHAR,ISNULL(@sParamsValues, '')) + ','
					+ '@sSoapAction: ' + CONVERT(VARCHAR,ISNULL(@sSoapAction, '')) + ','
					+ '@sSoapMetodo: ' + CONVERT(VARCHAR,ISNULL(@sSoapMetodo, '')) + ','
					+ '@resultado: ' + CONVERT(VARCHAR,ISNULL(@resultado, '')) + ','
					+ '@sAuxiliar: ' + CONVERT(VARCHAR,ISNULL(@sAuxiliar, '')) + ','
					+ '@sRetorno: ' + CONVERT(VARCHAR,ISNULL(@sRetorno, '')) + ','
					+ '@iRetorno: ' + CONVERT(VARCHAR,ISNULL(@iRetorno, 0));
				
				THROW 500001, @exceptionMessage, 1;
			END
			
		END
		IF (@iRetorno = 0)
		BEGIN
	

			SET @sRetorno = @sSenhaAutorizador

			EXEC dbo.pr_Aut_HexaDecimal_Base64 @sRetorno OUTPUT

			SET @sAuxiliar = @sPinBlockPWD

			EXEC dbo.pr_Aut_HexaDecimal_Base64 @sAuxiliar OUTPUT

			SET @sParamsValues = 'requestId=123&comparableData='+ @sAuxiliar +'&data='+ @sRetorno +'&sourceLabel='+ @sLabelChavePOS +'&targetLabel=' + @sLabelChaveTDB + ''
			SET @sSoapAction = 'ws:verify'
			SET @sSoapMetodo = 'VerifyRequest'
			
			EXEC [pr_Aut_RequestHttpWebService] @sUrl, @sHttpMethod, @sParamsValues, @sSoapAction, @sSoapMetodo, @resultado, @sAuxiliar OUTPUT, @sRetorno OUTPUT, @iRetorno OUTPUT

			SET @bSenhaValida = @sRetorno
			
			IF (@bSenhaValida = 1)
				SET @iResposta = 0
			ELSE
				SET @iResposta = 27


		END
		ELSE
		BEGIN
			SET @exceptionMessage = '[@iRetorno: ' + CONVERT(VARCHAR, ISNULL(@iRetorno, 0))
				+ ', @sRetorno: ' + CONVERT(VARCHAR, ISNULL(@sRetorno, ''))
				+ ', @sAuxiliar: ' + CONVERT(VARCHAR, ISNULL(@sAuxiliar, ''));
			THROW 500001, @exceptionMessage, 1;			
			
		END
		
	END
	ELSE
	BEGIN
		SET @exceptionMessage = '@resultado is null or empty';
		THROW 500001, @exceptionMessage, 1;			
	END
	
END
