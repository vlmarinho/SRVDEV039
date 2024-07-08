
/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].pr_AUT_AutorizarTransacoesSonda
Propósito: Retornar respostas de Sonda.
Código de resposta da transação:
00 => Efetuada com sucesso
09 => Em andamento
77 => Pendente de confirmação no PDV
78 => Cancelada							(DESFAZIMENTO)
80 => Não existe no log do TEF da loja	(DESFAZIMENTO)
86 => Desfeita por time-out				(DESFAZIMENTO)
Autor: Cristiano Silva Barbosa - Tecnologia Policard
--------------------------------------------------------------------------
Data: 19/02/2017
Mud/CH.:  2601
--------------------------------------------------------------------------

*/


CREATE PROCEDURE [dbo].[pr_aut_AutorizarTransacoesSonda] (
	 @cNSUMeioCaptura			CHAR(6)		-- Bit011
	,@cHoraLocal				CHAR(6)		-- Bit012 - HHMMSS
	,@cDataLocal				CHAR(4)		-- Bit013 - MMDD
	,@dDataHora_Transacao		DATETIME
	,@cCodigoRespAutorizacao	CHAR(2)		-- Bit039
	,@iCodigoEstabelecimento	INT			-- Bit042
	,@cNSUMeioCapturaTrnOrig	CHAR(6)		-- Bit125
	,@cNSUPolicard				VARCHAR(12)	-- Bit127
	,@iRede						INT = NULL
	)
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE  @cNumeroCartao				VARCHAR(16)
			,@cDadosBit090				VARCHAR(50)
			,@cProdutoResponsavel		VARCHAR(50)
			,@cTipoCartao				CHAR(1)
			,@cTabela					CHAR(1)
			,@cTipoLancamento			CHAR(1)
			,@cTipoMensagem				CHAR(4)
			,@cCodigoProduto			CHAR(11)
			,@cOrigemTransacao			CHAR(1)
			,@cDataHoraGMT				CHAR(10)
			,@iRedeCaptura				INT
			,@cComprovanteResposta		CHAR(6)
			,@iEstabelecimento			INT
			,@iCrtUsrCodigo				INT
			,@iCntUsrCodigo				INT
			,@iQtdParcelas				INT
			,@iTpoPrdCodigo				INT
			,@iTpoTrnCodigo				INT
			,@iResposta					INT
			,@iCodControleSonda			INT
			,@dValorTransacao			DECIMAL(15,2)
			/* Variaveis de controle para Desfazimento do Convenio */
			,@cTerminal					VARCHAR(8)
			,@cAutorizacaoTrnOriginal	VARCHAR(18)
			,@cResponsavel				VARCHAR(50)
			,@cAutorizacao				CHAR(18)
			,@cLote						CHAR(6)
			,@cComprovante				CHAR(6)
			,@cCodProcessamento			CHAR(6)
			,@iCodReferencia			BIGINT
			,@iCodTaxa					BIGINT
			,@iCodTaxaFranquia			BIGINT
			,@iEstornoLncUsuario		BIGINT
			,@iEstornoTrnEletronica		BIGINT
			,@iCliente					INT
			,@iUsuario					INT
			,@iFrqFornecedor			INT
			,@iFornecedor				INT
			,@iAnoFinanciamento			INT
			,@iMesFinanciamento			INT
			,@dDtHrTransacao			DATETIME
			/* Variaveis de controle Banco 24 Horas */
			,@cTipoOperacao				CHAR(1)
			,@sNSUTecban				VARCHAR(6)
			,@sInfoPlanos				VARCHAR(2000)
			,@iCodCartaoUsuario			INT
			,@iFranquiaUsuario			INT
			,@iQtdSonda					INT

	SET @iCodReferencia		= 0
	SET @iCodControleSonda	= 0
	SET @cTipoOperacao = 'A'

	SELECT	@iCodControleSonda = Codigo
			,@cOrigemTransacao = BaseOrigem
			,@iQtdSonda			= QtdSonda
	FROM ControleSonda WITH(NOLOCK)
	WHERE NSU_Policard = @cNSUPolicard
	AND NsuOrigem = @cNSUMeioCapturaTrnOrig
	AND DataInicioSonda BETWEEN CONVERT(VARCHAR(10), GETDATE()-1,120) AND CONVERT(VARCHAR(10), GETDATE() + 1,120)

	
	IF (@cOrigemTransacao = 'P')
	BEGIN
		SELECT	 
			 @dValorTransacao	= T.Valor
			,@iEstabelecimento	= T.EstCodigo
			,@iCrtUsrCodigo		= T.CrtUsrCodigo
			,@iCntUsrCodigo		= CO.CntUsrCodigo
			,@cTipoCartao		= C.Tipo
			,@iQtdParcelas		= T.Parcelas
			,@iTpoPrdCodigo		= T.TpoPrdCodigo
			,@iTpoTrnCodigo		= T.TpoTrnCodigo
			,@cTipoMensagem		= T.TipoMensagem
			,@cNumeroCartao		= C.Numero
			,@cDataHoraGMT		= T.DataGMT
			,@iRedeCaptura		= T.RdeCodigo
			,@cCodProcessamento = T.TpoTrnCodigo
			,@cTerminal			= T.Terminal
		FROM Processadora.dbo.Transacoes T WITH(NOLOCK)
		INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON (T.CrtUsrCodigo = C.CrtUsrCodigo)
		INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
		WHERE T.Status = 'P'
		AND T.TrnCodigo = @cNSUPolicard
	END

	IF (@cOrigemTransacao = 'C')
	BEGIN
		SELECT	@cTabela				= Tabela
				,@iCodReferencia		= Codigo_Referencia
				,@cCodProcessamento		= CodProcessOriginal
				,@dDtHrTransacao		= DataAutorizacao
				,@cTerminal				= Terminal
				,@dValorTransacao		= Valor
				,@cLote					= Lote
				,@cComprovante			= Comprovante_FormGen
				,@cTipoMensagem			= Tipo_Mensagem
				,@cNumeroCartao			= NumeroCartao
				,@cProdutoResponsavel	= ProvedorTef
				,@iRedeCaptura			= Rede
				,@sNSUTecban			= NsuLoja
				,@cHoraLocal			= HoraLocal
				,@cDataLocal			= DataLocal
		FROM	  Policard_603078.dbo.Transacao_RegistroTEF TRT WITH(NOLOCK)
		WHERE	StatusTEF = 'P'
				AND NsuHost = @cNSUPolicard
	END

	SET @cCodigoProduto = LEFT(@cNumeroCartao, 11)
	SET @cTipoLancamento = CASE WHEN(@cTipoMensagem = '0200') THEN 'C'
								WHEN(@cTipoMensagem = '0400') THEN 'D'
						   END

	IF (@cCodigoRespAutorizacao = '00')
	BEGIN
		IF (@cTipoMensagem = '0200')
			EXEC pr_aut_Confirmar_Transacao_Venda @iCodigoEstabelecimento, @cNSUPolicard, @cNumeroCartao, @cOrigemTransacao
		ELSE IF (@cTipoMensagem = '0400')
			EXEC pr_aut_Confirmar_Transacao_Estorno @iCodigoEstabelecimento, @cNSUPolicard, @cNumeroCartao, @cOrigemTransacao

		UPDATE dbo.ControleSonda SET StatusSonda = @cCodigoRespAutorizacao, DataRespSonda = GETDATE() WHERE Codigo = @iCodControleSonda
	END
	ELSE IF (@cCodigoRespAutorizacao IN ('78','80','86') OR (@iRede = 18 AND @cCodigoRespAutorizacao <> '00'))
	BEGIN
		IF (@cOrigemTransacao = 'C')
		BEGIN
			IF (@iRede <> 18)
			BEGIN
				SET @cDadosBit090 = @cTipoMensagem + @cCodProcessamento + @cNSUMeioCaptura + @cDataHoraGMT + @cHoraLocal + @cDataLocal + '000000'

				EXEC   Policard_603078.dbo.pr_aut_desfazer_transacao_convenio
					 @cNumeroCartao				OUTPUT	/* Número do Cartão */
					,@cCodProcessamento			OUTPUT	/* Código de Processamento */
					,@dValorTransacao			OUTPUT	/* Valor da Transação */
					,@cNSUMeioCaptura			OUTPUT	/* NSU do Meio de Captura */
					,@cHoraLocal						/* Hora da Transação (HHMMSS) */
					,@cDataLocal						/* Data da Transação (MMDD) */
					,@iRedeCaptura						/* Código de Identificação da Rede de Captura */
					,@cComprovanteResposta		OUTPUT	/* NSU Policard - Comprovante Formgen */
					,@cTerminal					OUTPUT	/* Identificação do Terminal */
					,@iCodigoEstabelecimento	OUTPUT	/* Código de Identificação do Estabelecimento (Filiação) */
					,@cDadosBit090				OUTPUT	/* Dados da Transação a ser Desfeita */
					,@iResposta					OUTPUT	/* Código de Resposta Interno */
					,@dDataHora_Transacao				/* Data e Hora Corrente (GETDATE) */
					,@cProdutoResponsavel				/* Nome do Responsável pela Rede */
					,@cNSUPolicard						/* NSU HOST POLICARD */
			END
			ELSE
			BEGIN
				SELECT	@iCodCartaoUsuario = C.Codigo
						,@iFranquiaUsuario = C.Franquia
				FROM	  Policard_603078.dbo.Cartao_Usuario C WITH(NOLOCK)
				WHERE	CodigoCartao = @cNumeroCartao

				EXEC pr_AUT_ProcessarSaqueBco24Horas
					@cOrigemTransacao
					,@cTipoOperacao
					,@iCodCartaoUsuario
					,@iFranquiaUsuario
					,@dValorTransacao
					,1
					,@cComprovante
					,@sNSUTecban
					,NULL
					,@cTerminal
					,@iRedeCaptura
					,@cDataLocal
					,@cHoraLocal
					,@sInfoPlanos	OUT
					,@iResposta		OUT
			END

			IF (@iResposta = 0)
				UPDATE dbo.ControleSonda SET StatusSonda = @cCodigoRespAutorizacao, DataRespSonda = GETDATE() WHERE Codigo = @iCodControleSonda
		END
		ELSE IF (@cOrigemTransacao = 'P')
		BEGIN
			SET @cDadosBit090 = @cTipoMensagem + @cCodProcessamento + @cNSUMeioCaptura + @cDataHoraGMT + @cHoraLocal + @cDataLocal + '000000'

			EXEC pr_aut_desfazer_transacao_processadora
				 @cNumeroCartao
				,@cCodProcessamento
				,@dValorTransacao
				,@cNSUMeioCaptura
				,@cHoraLocal
				,@cDataLocal
				,@iRedeCaptura
				,@cComprovanteResposta	OUTPUT
				,@cTerminal
				,@iCodigoEstabelecimento
				,@cDadosBit090
				,''--@cInfPolicard
				,@iResposta				OUTPUT
				,@dDataHora_Transacao
				,@cNSUPolicard

			IF (@iResposta = 0)
				UPDATE dbo.ControleSonda SET StatusSonda = @cCodigoRespAutorizacao, DataRespSonda = GETDATE() WHERE Codigo = @iCodControleSonda
		END
	END
	ELSE IF (@cCodigoRespAutorizacao IN ('09', '77')) /* Forçando nova sonda para transação */
	BEGIN

		IF (@iRedeCaptura IN (2,7))
			UPDATE dbo.ControleSonda SET DataRespSonda = GETDATE(), StatusSonda = @cCodigoRespAutorizacao WHERE Codigo = @iCodControleSonda
		ELSE
			DELETE dbo.ControleSonda WHERE Codigo = @iCodControleSonda -- Nsu_Policard = @cNSUPolicard
	END
END




