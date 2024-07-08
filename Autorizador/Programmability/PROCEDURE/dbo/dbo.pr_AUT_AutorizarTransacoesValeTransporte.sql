
/*
--------------------------------------------------------------------------
Data........: 08/06/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_AutorizarTransacoesValeTransporte
Propósito...: Procedure responsável por processar a autorização das tran-
			  sações de Vale Transporte.
--------------------------------------------------------------------------
Data alteração: 10/11/2015
Mudança.......: 1337-225666
Autor: Luiz Renato
--------------------------------------------------------------------------
Data alteração: 24/11/2015 -- 22:59 hs
Mudança.......: 229199 / 1394
Autor: Luiz Renato
--------------------------------------------------------------------------
Data alteração: 29/12/2015 -- 22:30 hs
Mudança.......: 235909 / 1499
Autor: Luiz Renato
--------------------------------------------------------------------------
Data alteração: 20/04/2016 -- 13:50 hs
Mudança.......: 258344 / 1817
Autor: Shuster Roberto
--------------------------------------------------------------------------
Data alteração: 04/10/2016 -- 13:50 hs
Mudança.......: 268725
Autor: Shuster Roberto
--------------------------------------------------------------------------
Data alteração: 10/03/2017
Mudança.......: Chamado 362815 - 2659 / Inclusao do flag bProcessaTransacao
Autor: Rafael A. M. Borges
--------------------------------------------------------------------------
Data alteração: 14/03/2017
Mudança.......: 363857  / 2667
Autor: Rafael A. M. Borges
--------------------------------------------------------------------------
Data Alteracao: 21/03/2017
Autor: Cristiano Barbosa
CH: 365214 - 2676
--------------------------------------------------------------------------
Data Alteracao: 23/03/2017
Autor: Cristiano Barbosa
CH: 365214 - 2676 --Ajuste
--------------------------------------------------------------------------
Data Alteracao: 30/03/2017
Autor: Rafael A. M. Borges
CH: 368851 - 2704
--------------------------------------------------------------------------
Data Alteracao: 31/03/2017
Autor: Rafael A. M. Borges
CH: 368851 - 2704 - Ajuste
--------------------------------------------------------------------------
Data Alteracao: 21/09/2017
Autor: Cristiano Barbosa
CH: 410827 - 3239
--------------------------------------------------------------------------
Data Alteracao: 11/11/2017
Autor: Cristiano Barbosa
CH: 417480 - 3420
--------------------------------------------------------------------------
Data Alteracao: 30/11/2017
Autor: Cristiano Barbosa
CH: 448216 - 3472
--------------------------------------------------------------------------
Data: 30/01/2018
Autor: Cristiano Barbosa - Tecnologia Policard
Chamado/Mudança: 464382 - 
--------------------------------------------------------------------------
Data: 02/02/2018
Autor: Cristiano Barbosa - Tecnologia Policard
Chamado: 474097 / 
--------------------------------------------------------------------------

*/

CREATE PROCEDURE [dbo].[pr_AUT_AutorizarTransacoesValeTransporte]
	 @sBit001 VARCHAR(1000) OUT, @sBit002 VARCHAR(1000) OUT, @sBit003 VARCHAR(1000) OUT, @sBit004 VARCHAR(1000) OUT
	,@sBit005 VARCHAR(1000) OUT, @sBit006 VARCHAR(1000) OUT, @sBit007 VARCHAR(1000) OUT, @sBit008 VARCHAR(1000) OUT
	,@sBit009 VARCHAR(1000) OUT, @sBit010 VARCHAR(1000) OUT, @sBit011 VARCHAR(1000) OUT, @sBit012 VARCHAR(1000) OUT
	,@sBit013 VARCHAR(1000) OUT, @sBit014 VARCHAR(1000) OUT, @sBit015 VARCHAR(1000) OUT, @sBit016 VARCHAR(1000) OUT
	,@sBit017 VARCHAR(1000) OUT, @sBit018 VARCHAR(1000) OUT, @sBit019 VARCHAR(1000) OUT, @sBit020 VARCHAR(1000) OUT
	,@sBit021 VARCHAR(1000) OUT, @sBit022 VARCHAR(1000) OUT, @sBit023 VARCHAR(1000) OUT, @sBit024 VARCHAR(1000) OUT
	,@sBit025 VARCHAR(1000) OUT, @sBit026 VARCHAR(1000) OUT, @sBit027 VARCHAR(1000) OUT, @sBit028 VARCHAR(1000) OUT
	,@sBit029 VARCHAR(1000) OUT, @sBit030 VARCHAR(1000) OUT, @sBit031 VARCHAR(1000) OUT, @sBit032 VARCHAR(1000) OUT
	,@sBit033 VARCHAR(1000) OUT, @sBit034 VARCHAR(1000) OUT, @sBit035 VARCHAR(1000) OUT, @sBit036 VARCHAR(1000) OUT
	,@sBit037 VARCHAR(1000) OUT, @sBit038 VARCHAR(1000) OUT, @sBit039 VARCHAR(1000) OUT, @sBit040 VARCHAR(1000) OUT
	,@sBit041 VARCHAR(1000) OUT, @sBit042 VARCHAR(1000) OUT, @sBit043 VARCHAR(1000) OUT, @sBit044 VARCHAR(1000) OUT
	,@sBit045 VARCHAR(1000) OUT, @sBit046 VARCHAR(1000) OUT, @sBit047 VARCHAR(1000) OUT, @sBit048 VARCHAR(1000) OUT
	,@sBit049 VARCHAR(1000) OUT, @sBit050 VARCHAR(1000) OUT, @sBit051 VARCHAR(1000) OUT, @sBit052 VARCHAR(1000) OUT
	,@sBit053 VARCHAR(1000) OUT, @sBit054 VARCHAR(1000) OUT, @sBit055 VARCHAR(1000) OUT, @sBit056 VARCHAR(1000) OUT
	,@sBit057 VARCHAR(1000) OUT, @sBit058 VARCHAR(1000) OUT, @sBit059 VARCHAR(1000) OUT, @sBit060 VARCHAR(1000) OUT
	,@sBit061 VARCHAR(1000) OUT, @sBit062 VARCHAR(1000) OUT, @sBit063 VARCHAR(1000) OUT, @sBit064 VARCHAR(1000) OUT
	,@sBit065 VARCHAR(1000) OUT, @sBit066 VARCHAR(1000) OUT, @sBit067 VARCHAR(1000) OUT, @sBit068 VARCHAR(1000) OUT
	,@sBit069 VARCHAR(1000) OUT, @sBit070 VARCHAR(1000) OUT, @sBit071 VARCHAR(1000) OUT, @sBit072 VARCHAR(1000) OUT
	,@sBit073 VARCHAR(1000) OUT, @sBit074 VARCHAR(1000) OUT, @sBit075 VARCHAR(1000) OUT, @sBit076 VARCHAR(1000) OUT
	,@sBit077 VARCHAR(1000) OUT, @sBit078 VARCHAR(1000) OUT, @sBit079 VARCHAR(1000) OUT, @sBit080 VARCHAR(1000) OUT
	,@sBit081 VARCHAR(1000) OUT, @sBit082 VARCHAR(1000) OUT, @sBit083 VARCHAR(1000) OUT, @sBit084 VARCHAR(1000) OUT
	,@sBit085 VARCHAR(1000) OUT, @sBit086 VARCHAR(1000) OUT, @sBit087 VARCHAR(1000) OUT, @sBit088 VARCHAR(1000) OUT
	,@sBit089 VARCHAR(1000) OUT, @sBit090 VARCHAR(1000) OUT, @sBit091 VARCHAR(1000) OUT, @sBit092 VARCHAR(1000) OUT
	,@sBit093 VARCHAR(1000) OUT, @sBit094 VARCHAR(1000) OUT, @sBit095 VARCHAR(1000) OUT, @sBit096 VARCHAR(1000) OUT
	,@sBit097 VARCHAR(1000) OUT, @sBit098 VARCHAR(1000) OUT, @sBit099 VARCHAR(1000) OUT, @sBit100 VARCHAR(1000) OUT
	,@sBit101 VARCHAR(1000) OUT, @sBit102 VARCHAR(1000) OUT, @sBit103 VARCHAR(1000) OUT, @sBit104 VARCHAR(1000) OUT
	,@sBit105 VARCHAR(1000) OUT, @sBit106 VARCHAR(1000) OUT, @sBit107 VARCHAR(1000) OUT, @sBit108 VARCHAR(1000) OUT
	,@sBit109 VARCHAR(1000) OUT, @sBit110 VARCHAR(1000) OUT, @sBit111 VARCHAR(1000) OUT, @sBit112 VARCHAR(1000) OUT
	,@sBit113 VARCHAR(1000) OUT, @sBit114 VARCHAR(1000) OUT, @sBit115 VARCHAR(1000) OUT, @sBit116 VARCHAR(1000) OUT
	,@sBit117 VARCHAR(1000) OUT, @sBit118 VARCHAR(1000) OUT, @sBit119 VARCHAR(1000) OUT, @sBit120 VARCHAR(1000) OUT
	,@sBit121 VARCHAR(1000) OUT, @sBit122 VARCHAR(1000) OUT ,@sBit123 VARCHAR(1000) OUT, @sBit124 VARCHAR(1000) OUT
	,@sBit125 VARCHAR(1000) OUT, @sBit126 VARCHAR(1000) OUT, @sBit127 VARCHAR(1000) OUT, @sBit128 VARCHAR(1000) OUT
	/* DADOS DE VALIDAÇÃO DE ESTABELECIMENTOS E USUÁRIOS */
	,@iRede					INT
	,@iResposta				INT				OUT
	,@iError				INT				OUT
	,@sErrorMessage			NVARCHAR(2048)	OUT
AS
BEGIN

	SET NOCOUNT ON;	
	
	DECLARE  
		 @sMsgIsoVTEnvio			VARCHAR(MAX)
		,@sMsgIsoVTRetorno			VARCHAR(MAX)
		,@sBit001Aux				VARCHAR(4)
		,@sBit003Aux				VARCHAR(50)
		,@sBit004Aux				VARCHAR(50)
		,@sBit005Aux				VARCHAR(50)
		,@sBit041Aux				VARCHAR(8)
		,@sBit042Aux				VARCHAR(15)
		,@sBit090Aux				VARCHAR(100)
		,@sBit125Aux				VARCHAR(50)
		,@dSaldoAnterior			DECIMAL(15,2)
		,@iCodContaCorrente			BIGINT
		,@bPossuiBitmap2			BIT
		,@sCNPJ						VARCHAR(20)
		,@sNomeEstab				VARCHAR(50)
		,@sEndereco					VARCHAR(50)
		,@sCidade					VARCHAR(30)
		,@sProvedor					VARCHAR(50)
		,@cEstado					CHAR(2)
		,@dValorMinimoRecarga		DECIMAL(15,2)
		,@dSaldoDispCartao			DECIMAL(15,2)
		,@dSaldoDispConta			DECIMAL(15,2)
		,@sNumeroCartao				VARCHAR(50)
		,@sNomeUsuario				VARCHAR(50)
		,@sLabelProduto				VARCHAR(50)
		,@sNroDocumento				VARCHAR(12)
		,@bPagtoContas				INT
		,@bPermiteDigitado			INT
		,@bPermiteSemSenha			INT
		,@iTipoMeioCaptura			INT
		,@iEstabelecimento			INT
		,@iCodTipoProduto			INT
		,@iCodigoReferencia			INT
		,@dValorTransacao			DECIMAL(15,2)
		,@iCodFranquia				INT
		,@iCodTransacaoExterna		BIGINT			
		,@iCodTransacao				BIGINT
		,@iCodTransacaoOriginal		BIGINT
		,@iCodTransacaoVenda		BIGINT
		,@sNSUTrnOriginal			VARCHAR(6)
		,@cStatus					CHAR(1)
		,@bProcessaTransacao		BIT
		,@bPrePago					BIT
			
	SET @bProcessaTransacao = 1
	
	SELECT
		 @sBit001Aux	= @sBit001
		,@sBit003Aux	= @sBit003
		,@sBit004Aux	= @sBit004
		,@sBit005Aux	= @sBit005
		,@sBit041Aux	= @sBit041
		,@sBit042Aux	= @sBit042
		,@sBit090Aux	= @sBit090
		,@sBit125Aux	= @sBit125
		,@sNumeroCartao = dbo.f_AUT_HexadecimalParaDecimal(@sBit002)
		,@sBit002		= ''
		,@sBit005		= ''
		,@sBit024		= ''	
		,@sBit038		= ''	
		

	--IF (@sBit001 =  '0100' and @sBit002 <> '')
	--BEGIN
		
	--	SET @sBit002 = dbo.f_AUT_HexadecimalParaDecimal(@sBit002)
	--	SET @sBit004 = '000000000000'

	--END
	--ELSE 
	--	SET @sBit002 = ''

	----print @sBit002

	/* INI: VALIDAÇÃO INICIAL DO ESTABELECIMENTO */
	EXEC pr_AUT_RetornarDadosEstabelecimento
		 @sBit001			/* Cabeçalho ISO */
		,@sBit002			/* Id Cartão para validação do VT */
		,@sBit004			/* Valor para validação do VT */
		,@sBit024			/* Rede */
		,@sBit032			/* Rede */
		,@sBit041			/* Terminal */
		,@sBit042			/* Estabelecimento */
		,@sBit047			/* Informações Terminal */
		,@sBit048			/* Informações Provedor */
		,@sBit090			/* Informações Transação Original */
		,@sBit125			/* NSU Transação Original */
		,@sProvedor			OUT
		,@sCNPJ				OUT
		,@sNomeEstab		OUT
		,@sEndereco			OUT
		,@sCidade			OUT
		,@cEstado			OUT
		,@bPermiteDigitado	OUT
		,@bPermiteSemSenha	OUT
		,@iTipoMeioCaptura	OUT
		,@iRede				--OUT
		,@iEstabelecimento	OUT
		,@bPrePago			OUT
		,@iResposta			OUT
	/* FIM: VALIDAÇÃO INICIAL DO ESTABELECIMENTO */

	IF (@iResposta = 0)
	BEGIN
		
		SELECT @dValorTransacao	  = dbo.f_RetornarValor(@sBit004)
	
		IF (@sBit001 = '0100' AND @sBit003 IN ('000100','000110','000120')) /* CONSULTAS E GERAÇÃO DE BOLETOS */
		BEGIN

			EXEC pr_AUT_GerarBoletos
				 @sBit003
				,@sBit004			
				,@sBit074
				,@iRede
				,@iEstabelecimento
				,@bPrePago			
				,@sBit062			OUT
				,@iResposta			OUT	

			SET @bProcessaTransacao = 0
			
			IF (@iResposta = 0)
				SET @sBit039 = dbo.f_ZerosEsquerda(@iResposta,2)

		END
		ELSE IF (@sBit001 = '0500') /* RELATORIO */
		BEGIN

			EXEC pr_AUT_RelatorioFechamento
				 @sBit041
				,@sBit063
				,@sCNPJ
				,@sNomeEstab
				,@sEndereco
				,@sCidade
				,@cEstado
				,@iEstabelecimento
				,@iRede
				,@sBit062			OUT
				,@iResposta			OUT

			SET @bProcessaTransacao = 0

			IF (@iResposta = 0)
				SET @sBit039 = dbo.f_ZerosEsquerda(@iResposta,2)

		END	
		ELSE
		BEGIN

			IF (@sBit001 = '0200')
			BEGIN

				IF (@sBit003 IN ('000012','000013')) --RECARGA VT
				BEGIN

					IF LTRIM(RTRIM(@sNumeroCartao)) = ''
						SET @iResposta = 27 --TIPO RECARGA NAO AUTORIZADA			

					/****** TRAVA DE VALOR MÍNIMO DE RECARGA - PARAMETROS DO ACQUIRER ******/
					SELECT @dValorMinimoRecarga = CONVERT(DECIMAL(15,2), Descricao)
					FROM Acquirer.dbo.ParametroSistema
					WHERE CodigoParametroSistema = 66--67

					--IF @dValorMinimoRecarga > (CONVERT(DECIMAL(15,2), @sBit004)/100)
					--	SET @iResposta = 28	

				END
			END
			ELSE IF (@sBit001 IN ('0400','0420'))
			BEGIN

				IF (@sBit001 = '0400')
				BEGIN

					SELECT 
						  @sNSUTrnOriginal	= RIGHT(@sBit125,6)
						 ,@dValorTransacao	= dbo.f_RetornarValor(@sBit004)

					SELECT TOP 1 @iCodTransacaoOriginal = TE.CodTransacao
								,@cStatus = TE.Status
					FROM Processadora.dbo.TransacoesExternas TE WITH(NOLOCK)
					WHERE TE.CodEstabelecimento = @iEstabelecimento
					AND TE.Terminal = @sBit041
					AND TE.Valor = @dValorTransacao
					AND TE.NSUOrigem = @sNSUTrnOriginal
					AND CONVERT(VARCHAR(10),TE.Data,120) = CONVERT(VARCHAR(10),GETDATE(),120)
					
				 

				END
				ELSE
				BEGIN
		
					SELECT 
						  @sNSUTrnOriginal	= SUBSTRING(@sBit090,5,6)
						 ,@dValorTransacao	= dbo.f_RetornarValor(@sBit004)
					 	
					SELECT TOP 1 @iCodTransacaoOriginal = TE.CodTransacao
								,@cStatus = TE.Status
					FROM Processadora.dbo.TransacoesExternas TE WITH(NOLOCK)
					WHERE TE.CodEstabelecimento = @iEstabelecimento
					AND TE.Valor = @dValorTransacao
					AND TE.NSUOrigem = @sNSUTrnOriginal
					AND CONVERT(VARCHAR(10),TE.Data,120) = CONVERT(VARCHAR(10),GETDATE(),120)
				
				END					   

				IF @iCodTransacaoOriginal IS NOT NULL AND @cStatus = 'D'
					SET @iResposta = 13 /* TRANSAÇÃO JÁ DESFEITA */
				ELSE IF @iCodTransacaoOriginal IS NOT NULL AND @cStatus = 'E'
					SET @iResposta = 15 /* TRANSAÇÃO JÁ ESTORNADA */
				ELSE IF @iCodTransacaoOriginal IS NULL 
					SET @iResposta = 271 /* TRANSAÇÃO ORIGINAL NAO ENCONTRADA */
				
			END	/* FIM: CONFIRMAÇÃO, DESFAZIMENTO OU ESTORNO DE TRANSAÇÕES */
			ELSE IF (@sBit001 = '0800' AND (@sBit047 = '' OR @sBit057 = ''))
				SET @bProcessaTransacao = 0
		END
	END

	INSERT INTO LogTransacoesVT (
		 Data_hora
		,BIT001
		,BIT002
		,BIT003
		,BIT004
		,BIT005
		,BIT007
		,BIT011
		,BIT012
		,BIT013
		,BIT014
		,BIT015
		,BIT017
		,BIT022
		,BIT032
		,BIT033
		,BIT035
		,BIT037
		,BIT038
		,BIT039
		,BIT041
		,BIT042
		,BIT047
		,BIT048
		,BIT049
		,BIT052
		,BIT054
		,BIT057
		,BIT061
		,BIT062
		,BIT064
		,BIT066
		,BIT067
		,BIT074
		,BIT086
		,BIT090
		,BIT100
		,BIT118
		,BIT119
		,BIT120
		,BIT121
		,BIT124
		,BIT125
		,BIT126
		,BIT127
		)
	VALUES
		(GETDATE()
		,@sBIT001
		,@sNumeroCartao
		,@sBIT003
		,@sBIT004
		,@sBit005Aux
		,@sBIT007
		,@sBIT011
		,@sBIT012
		,@sBIT013
		,@sBIT014
		,@sBIT015
		,@sBIT017
		,@sBIT022
		,@sBIT032
		,@sBIT033
		,@sBIT035
		,@sBIT037
		,@sBIT038
		,@sBIT039
		,@sBIT041
		,@sBIT042
		,@sBIT047
		,@sBIT048
		,@sBIT049
		,@sBIT052
		,@sBIT054
		,@sBIT057
		,@sBIT061
		,@sBIT062
		,@sBIT064
		,@sBIT066
		,@sBIT067
		,@sBIT074
		,@sBIT086
		,@sBIT090
		,@sBIT100
		,@sBIT118
		,@sBIT119
		,@sBIT120
		,@sBIT121
		,@sBIT124
		,@sBIT125
		,@sBIT126
		,@sBIT127
		)

	SET @iCodigoReferencia = SCOPE_IDENTITY()

	/*Nao processar transacao (00100) até que seja verificado*/
	IF (@sBit001 = '0800' AND @sBit003 = '000100')
	BEGIN
		
		SET @bProcessaTransacao = 0
		IF (@sBit057 <> '') 
			SET @sBit057 = '#' + @sBit057 + '#'

	END
					
	IF (@iResposta = 0 AND @bProcessaTransacao = 1)
	BEGIN
		
		IF (@sBit057 <> '') 
			SET @sBit057 = '#' + @sBit057 + '#'

		IF (@sBit003 = '000013')
			SET @sBit003 = '000012'
				
		SELECT @sBit041 = dbo.f_ZerosEsquerda(CodTerminalExterno,8)
			, @sBit042 = dbo.f_ZerosEsquerda(CodLojaExterno,15) 
   		FROM Acquirer.dbo.MeioCaptura WITH(NOLOCK) 
		WHERE NumeroLogico = @sBit041

		BEGIN TRAN
		BEGIN TRY
		
			SET @sMsgIsoVTEnvio = 
				@sBit001 + '|' + @sBit002 + '|' + @sBit003 + '|' + @sBit004 + '|' + @sBit005 + '|' + @sBit006 + '|' + @sBit007 + '|' + @sBit008 + '|' +
				@sBit009 + '|' + @sBit010 + '|' + @sBit011 + '|' + @sBit012 + '|' + @sBit013 + '|' + @sBit014 + '|' + @sBit015 + '|' + @sBit016 + '|' +
				@sBit017 + '|' + @sBit018 + '|' + @sBit019 + '|' + @sBit020 + '|' + @sBit021 + '|' + @sBit022 + '|' + @sBit023 + '|' + @sBit024 + '|' +
				@sBit025 + '|' + @sBit026 + '|' + @sBit027 + '|' + @sBit028 + '|' + @sBit029 + '|' + @sBit030 + '|' + @sBit031 + '|' + @sBit032 + '|' +
				@sBit033 + '|' + @sBit034 + '|' + @sBit035 + '|' + @sBit036 + '|' + @sBit037 + '|' + @sBit038 + '|' + @sBit039 + '|' + @sBit040 + '|' +
				@sBit041 + '|' + @sBit042 + '|' + @sBit043 + '|' + @sBit044 + '|' + @sBit045 + '|' + @sBit046 + '|' + @sBit047 + '|' + @sBit048 + '|' +
				@sBit049 + '|' + @sBit050 + '|' + @sBit051 + '|' + @sBit052 + '|' + @sBit053 + '|' + @sBit054 + '|' + @sBit055 + '|' + @sBit056 + '|' +
				@sBit057 + '|' + @sBit058 + '|' + @sBit059 + '|' + @sBit060 + '|' + @sBit061 + '|' + @sBit062 + '|' + @sBit063 + '|' + @sBit064 + '|' +
				@sBit065 + '|' + @sBit066 + '|' + @sBit067 + '|' + @sBit068 + '|' + @sBit069 + '|' + @sBit070 + '|' + @sBit071 + '|' + @sBit072 + '|' +
				@sBit073 + '|' + @sBit074 + '|' + @sBit075 + '|' + @sBit076 + '|' + @sBit077 + '|' + @sBit078 + '|' + @sBit079 + '|' + @sBit080 + '|' +
				@sBit081 + '|' + @sBit082 + '|' + @sBit083 + '|' + @sBit084 + '|' + @sBit085 + '|' + @sBit086 + '|' + @sBit087 + '|' + @sBit088 + '|' +
				@sBit089 + '|' + @sBit090 + '|' + @sBit091 + '|' + @sBit092 + '|' + @sBit093 + '|' + @sBit094 + '|' + @sBit095 + '|' + @sBit096 + '|' +
				@sBit097 + '|' + @sBit098 + '|' + @sBit099 + '|' + @sBit100 + '|' + @sBit101 + '|' + @sBit102 + '|' + @sBit103 + '|' + @sBit104 + '|' +
				@sBit105 + '|' + @sBit106 + '|' + @sBit107 + '|' + @sBit108 + '|' + @sBit109 + '|' + @sBit110 + '|' + @sBit111 + '|' + @sBit112 + '|' +
				@sBit113 + '|' + @sBit114 + '|' + @sBit115 + '|' + @sBit116 + '|' + @sBit117 + '|' + @sBit118 + '|' + @sBit119 + '|' + @sBit120 + '|' +
				@sBit121 + '|' + @sBit122 + '|' + @sBit123 + '|' + @sBit124 + '|' + @sBit125 + '|' + @sBit126 + '|' + @sBit127 + '|' + @sBit128

	
			IF (@sBit001 <> '0100')
			BEGIN
			
				SELECT @sMsgIsoVTRetorno = dbo.ProcessaTransacaoVT(@sMsgIsoVTEnvio)
				
				IF (@sBit001 NOT IN ('0202', '0402'))
				BEGIN
					SET @bPossuiBitmap2 = CASE dbo.f_ContarBitmap(@sMsgIsoVTRetorno, '|') WHEN 63 THEN 0 WHEN 127 THEN 1 END

					SET	@sBit001 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit002 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit003 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit004 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit005 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit006 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit007 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit008 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit009 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit010 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit011 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit012 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit013 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit014 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit015 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit016 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit017 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit018 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit019 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit020 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit021 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit022 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit023 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit024 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit025 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit026 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit027 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit028 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit029 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit030 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit031 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit032 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit033 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit034 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit035 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit036 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit037 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit038 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit039 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit040 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit041 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit042 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit043 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit044 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit045 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit046 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit047 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit048 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit049 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit050 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit051 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit052 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit053 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit054 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit055 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit056 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit057 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit058 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit059 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit060 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit061 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit062 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit063 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
					SET	@sBit064 = SUBSTRING(@sMsgIsoVTRetorno,1, CASE WHEN CHARINDEX('|',@sMsgIsoVTRetorno)-1 < 0 THEN 0 ELSE CHARINDEX('|',@sMsgIsoVTRetorno)-1 END)
					SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))

					IF (@bPossuiBitmap2 = 1)
					BEGIN
						SET	@sBit065 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit066 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit067 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit068 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit069 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit070 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit071 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit072 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit073 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit074 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit075 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit076 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit077 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit078 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit079 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit080 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit081 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit082 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit083 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit084 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit085 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit086 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit087 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit088 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit089 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit090 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit091 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit092 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit093 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit094 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit095 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit096 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit097 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit098 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit099 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit100 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit101 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit102 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit103 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit104 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit105 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit106 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit107 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit108 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit109 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit110 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit111 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit112 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit113 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit114 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit115 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit116 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit117 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit118 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit119 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit120 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit121 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit122 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit123 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit124 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit125 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit126 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit127 = SUBSTRING(@sMsgIsoVTRetorno,1,(CHARINDEX('|',@sMsgIsoVTRetorno)-1)) SET @sMsgIsoVTRetorno = SUBSTRING(@sMsgIsoVTRetorno, (CHARINDEX('|',@sMsgIsoVTRetorno)+1), LEN(@sMsgIsoVTRetorno))
						SET	@sBit128 = REPLACE(@sMsgIsoVTRetorno, '|', '')
					END
				END
			END
			COMMIT
		END TRY
		BEGIN CATCH
			
			SET @sErrorMessage = ERROR_MESSAGE()
			SET @iError		= @@ERROR
			

			ROLLBACK TRAN

			SET @iResposta	= 6
			SET @sBit039 = 'AG'
			SET @sBit062 = 'ERRO NA AUTORIZACAO'
			
		END CATCH

		SELECT	 @sBit003 = @sBit003Aux
				,@sBit004 = @sBit004Aux
				,@sBit005 = @sBit005Aux
				,@sBit041 = @sBit041Aux
				,@sBit042 = @sBit042Aux
		
		IF (@sBit039 = '00')
		BEGIN

			IF (@sBit001 IN ('0200','0210','0400','0410','0430','0420'))
			BEGIN

				EXEC Processadora.dbo.pr_PROC_InsereTransacoesLancamentosVT
					 @sBit001Aux
					,@sNumeroCartao
					,@sBit003
					,@sBit007
					,@sBit011
					,@sBit012
					,@sBit013
					,@sBit041Aux
					,@sBit062
					,@sBit090Aux
					,@sBit125Aux
					,@dValorTransacao
					,@dSaldoAnterior		OUT
					,@iCodTransacaoExterna	OUT
					,@iCodContaCorrente		OUT
					,@iEstabelecimento
					,@iRede
					,@iResposta				OUT
					,@iError				OUT
					,@sErrorMessage			OUT
			END

			/* INI: RETORNAR TICKETS DE TRANSAÇÕES */
			IF (@sBit001 IN ('0200','0210','0400','0410') AND @iResposta = 0)
			BEGIN
					
				IF (@sBit005 = '') 
					SET @sBit005 = @sBit005Aux

				SET @dSaldoDispCartao = dbo.f_RetornarValor(@sBit005)

				EXEC pr_AUT_RetornarTicketTransacao
					 @sBit001
					,@sBit003Aux
					,@sBit004
					,@sBit005
					,@sBit011
					,@sBit038
					,@sBit041
					,@sBit062			OUTPUT
					,@sBit067
					,@sBit127
					,@sCNPJ
					,@sNumeroCartao
					,@sNroDocumento
					,@sLabelProduto
					,@sNomeUsuario
					,@sNomeEstab
					,@sEndereco
					,@sCidade
					,@cEstado
					,@bPagtoContas
					,@dSaldoDispCartao
					,@iRede
					,@iEstabelecimento
					,@iCodTransacaoExterna

			END	/* FIM: RETORNAR TICKETS DE TRANSAÇÕES */

		END
		ELSE
		BEGIN
	
			IF (@iResposta <> 6)
				SET @iResposta = CONVERT(INT, @sBit039) --99
					
			SELECT @sBit062	= REPLACE(@sBit062,'@',' ')
				  ,@sBit048 = ''
			 			
		END
		
	END
	ELSE IF (@iResposta <> 0)
	BEGIN

		IF (@sBit001 IN ('0420','0430') AND @iResposta = 271)
			SET @sBit039 = '00'
		ELSE
		BEGIN
			SELECT @sBit039 = COALESCE(CodPolicard,'99')
				  ,@sBit062 = COALESCE(DescricaoPolicard,Descricao)
			FROM CodigosResposta CER WITH(NOLOCK)
			WHERE Codigo = @iResposta
		END

		IF (@iResposta = 28)
			SET @sBit062 = REPLACE( @sBit062,'@VALOR',  @dValorMinimoRecarga )				

	END

	EXEC pr_AUT_RetornarBitsIso
		 @sBit001 OUT, @sBit002 OUT, @sBit003 OUT, @sBit004 OUT, @sBit005 OUT, @sBit006 OUT, @sBit007 OUT, @sBit008 OUT
		,@sBit009 OUT, @sBit010 OUT, @sBit011 OUT, @sBit012 OUT, @sBit013 OUT, @sBit014 OUT, @sBit015 OUT, @sBit016 OUT
		,@sBit017 OUT, @sBit018 OUT, @sBit019 OUT, @sBit020 OUT, @sBit021 OUT, @sBit022 OUT, @sBit023 OUT, @sBit024 OUT
		,@sBit025 OUT, @sBit026 OUT, @sBit027 OUT, @sBit028 OUT, @sBit029 OUT, @sBit030 OUT, @sBit031 OUT, @sBit032 OUT
		,@sBit033 OUT, @sBit034 OUT, @sBit035 OUT, @sBit036 OUT, @sBit037 OUT, @sBit038 OUT, @sBit039 OUT, @sBit040 OUT
		,@sBit041 OUT, @sBit042 OUT, @sBit043 OUT, @sBit044 OUT, @sBit045 OUT, @sBit046 OUT, @sBit047 OUT, @sBit048 OUT
		,@sBit049 OUT, @sBit050 OUT, @sBit051 OUT, @sBit052 OUT, @sBit053 OUT, @sBit054 OUT, @sBit055 OUT, @sBit056 OUT
		,@sBit057 OUT, @sBit058 OUT, @sBit059 OUT, @sBit060 OUT, @sBit061 OUT, @sBit062 OUT, @sBit063 OUT, @sBit064 OUT
		,@sBit065 OUT, @sBit066 OUT, @sBit067 OUT, @sBit068 OUT, @sBit069 OUT, @sBit070 OUT, @sBit071 OUT, @sBit072 OUT
		,@sBit073 OUT, @sBit074 OUT, @sBit075 OUT, @sBit076 OUT, @sBit077 OUT, @sBit078 OUT, @sBit079 OUT, @sBit080 OUT
		,@sBit081 OUT, @sBit082 OUT, @sBit083 OUT, @sBit084 OUT, @sBit085 OUT, @sBit086 OUT, @sBit087 OUT, @sBit088 OUT
		,@sBit089 OUT, @sBit090 OUT, @sBit091 OUT, @sBit092 OUT, @sBit093 OUT, @sBit094 OUT, @sBit095 OUT, @sBit096 OUT
		,@sBit097 OUT, @sBit098 OUT, @sBit099 OUT, @sBit100 OUT, @sBit101 OUT, @sBit102 OUT, @sBit103 OUT, @sBit104 OUT
		,@sBit105 OUT, @sBit106 OUT, @sBit107 OUT, @sBit108 OUT, @sBit109 OUT, @sBit110 OUT, @sBit111 OUT, @sBit112 OUT
		,@sBit113 OUT, @sBit114 OUT, @sBit115 OUT, @sBit116 OUT, @sBit117 OUT, @sBit118 OUT, @sBit119 OUT, @sBit120 OUT
		,@sBit121 OUT, @sBit122 OUT, @sBit123 OUT, @sBit124 OUT, @sBit125 OUT, @sBit126 OUT, @sBit127 OUT, @sBit128 OUT
		,@iRede, @iResposta

	
	IF @sBit001 = '0100' SET @sBit001 = '0110'
	ELSE IF @sBit001 = '0200' SET @sBit001 = '0210'
	ELSE IF @sBit001 = '0400' SET @sBit001 = '0410'
	ELSE IF @sBit001 = '0420' SET @sBit001 = '0430'
	ELSE IF @sBit001 = '0500' SET @sBit001 = '0510'
	ELSE IF @sBit001 = '0800' SET @sBit001 = '0810'

	/*Transacao 000100: Echo Test  precisa ser verificada*/
	IF (@sBit001 = '0810' AND @sBit003 = '000100')
		SET @sBit039 = '00'
		

	IF (@bProcessaTransacao = 1 OR @sBit003 = '000100')
	BEGIN

		INSERT INTO LogTransacoesVT (
			CodigoReferencia
			,Data_hora
			,BIT001
			,BIT002
			,BIT003
			,BIT004
			,BIT005
			,BIT007
			,BIT011
			,BIT012
			,BIT013
			,BIT014
			,BIT015
			,BIT017
			,BIT022
			,BIT032
			,BIT033
			,BIT035
			,BIT037
			,BIT038
			,BIT039
			,BIT041
			,BIT042
			,BIT047
			,BIT048
			,BIT049
			,BIT052
			,BIT054
			,BIT057
			,BIT061
			,BIT062
			,BIT064
			,BIT066
			,BIT067
			,BIT074
			,BIT086
			,BIT090
			,BIT100
			,BIT118
			,BIT119
			,BIT120
			,BIT121
			,BIT124
			,BIT125
			,BIT126
			,BIT127
			,CodResposta
			)
		VALUES
			(@iCodigoReferencia
			,GETDATE()
			,@sBIT001
			,@sBit002
			,@sBIT003
			,@sBIT004
			,@sBit005
			,@sBIT007
			,@sBIT011
			,@sBIT012
			,@sBIT013
			,@sBIT014
			,@sBIT015
			,@sBIT017
			,@sBIT022
			,@sBIT032
			,@sBIT033
			,@sBIT035
			,@sBIT037
			,@sBIT038
			,@sBIT039
			,@sBIT041
			,@sBIT042
			,@sBIT047
			,@sBIT048
			,@sBIT049
			,@sBIT052
			,@sBIT054
			,@sBIT057
			,@sBIT061
			,@sBIT062
			,@sBIT064
			,@sBIT066
			,@sBIT067
			,@sBIT074
			,@sBIT086
			,@sBIT090
			,@sBIT100
			,@sBIT118
			,@sBIT119
			,@sBIT120
			,@sBIT121
			,@sBIT124
			,@sBIT125
			,@sBIT126
			,@sBIT127
			,@iResposta
			)

	END
	
END
