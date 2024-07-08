
/*
------------------------------------------------------------------------------
Data........: 18/05/2015
Nome Sistema: Autorizador
Objeto......: pr_AUT_ProcessarTransacoes
Propósito...: Procedure responsável por capturar os  dados das transações
			  para validá-los e processar a transação.
--------------------------------------------------------------------------
Data Criacao: 18/11/2015
Mudança.......: 1349-225666
Autor: Luiz Renato
--------------------------------------------------------------------------
Data Criacao: 19/11/2015
Mudança.......: 1349-225666
Autor: Luiz Renato
--------------------------------------------------------------------------
Data Criacao: 14/03/2017
Mudança.......: 363857  / 2667
Autor: Rafael A. M. Borges
--------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[pr_AUT_RelatorioFechamento]
	 @sTerminal			VARCHAR(20)
	,@sData  			VARCHAR(20)
	,@sCNPJ				VARCHAR(20)
	,@sNome				VARCHAR(41)
	,@sEndereco			VARCHAR(41)
	,@sCidade			VARCHAR(30)
	,@cEstado			CHAR(2)
	,@iEstabelecimento	INT
	,@iRede				TINYINT
	,@sTicket			VARCHAR(1000)	OUT
	,@iResposta			INT				OUT
AS
BEGIN
	DECLARE  @iQtdTrnConvenio				INT
			,@iQtdTrnFrota					INT
			,@iQtdTrnProcessadora			INT
			,@iQtdTrnCorrespBancario		INT
			,@iQtdTrnVT						INT
			,@iQtdTrnTotal					INT
			,@iQtdEstornoConvenio			INT
			,@iQtdEstornoFrota				INT
			,@iQtdEstornoProcessadora		INT
			,@iQtdEstornoCorrespBancario	INT
			,@iQtdEstornoVT					INT
			,@iQtdEstornoTotal				INT
			,@dValorConvenio				DECIMAL(15,2)
			,@dValorFrota					DECIMAL(15,2)
			,@dValorProcessadora			DECIMAL(15,2)
			,@dValorCorrespBancario			DECIMAL(15,2)
			,@dValorVT						DECIMAL(15,2)
			,@dValorTotal					DECIMAL(15,2)
			,@dValorEstornoConvenio			DECIMAL(15,2)
			,@dValorEstornoFrota			DECIMAL(15,2)
			,@dValorEstornoProcessadora		DECIMAL(15,2)
			,@dValorEstornoCorrespBancario	DECIMAL(15,2)
			,@dValorEstornoVT				DECIMAL(15,2)
			,@dValorEstornoTotal			DECIMAL(15,2)
			,@dData							DATETIME
			,@sTitulo						VARCHAR(40)
			,@sCabecalho					VARCHAR(500)
			,@sDetalheGenerico				VARCHAR(200)
			,@sDetalheConvenio				VARCHAR(200)
			,@sDetalheFrota					VARCHAR(200)
			,@sDetalheProcessadora			VARCHAR(200)
			,@sDetalheVT					VARCHAR(200)
			,@sDetalheCorBan				VARCHAR(200)
			,@sHora							VARCHAR(10)

	DECLARE @TB_EstabelecimentoTipoProduto TABLE (CodEstabelecimento BIGINT, CodTipoProduto INT)

	SELECT	 @iResposta						= 0
			,@dValorConvenio				= 0
			,@dValorFrota					= 0
			,@dValorProcessadora			= 0
			,@dValorVT						= 0
			,@dValorCorrespBancario			= 0
			,@dValorEstornoTotal			= 0
			,@dValorEstornoConvenio			= 0
			,@dValorEstornoFrota			= 0
			,@dValorEstornoProcessadora		= 0
			,@dValorEstornoVT				= 0
			,@dValorEstornoCorrespBancario	= 0
			,@iQtdTrnTotal					= 0
			,@iQtdTrnConvenio				= 0
			,@iQtdTrnFrota					= 0
			,@iQtdTrnProcessadora			= 0
			,@iQtdTrnVT						= 0
			,@iQtdTrnCorrespBancario		= 0
			,@iQtdEstornoTotal				= 0
			,@iQtdEstornoConvenio			= 0
			,@iQtdEstornoFrota				= 0
			,@iQtdEstornoProcessadora		= 0
			,@iQtdEstornoVT					= 0
			,@iQtdEstornoCorrespBancario	= 0
			,@sDetalheConvenio				= ''
			,@sDetalheFrota					= ''
			,@sDetalheProcessadora			= ''
			,@sDetalheVT					= ''
			,@sDetalheCorBan				= ''
			,@sHora							= LEFT(CONVERT(VARCHAR(10),GETDATE(),108),5)
			,@sTitulo						= '@' + dbo.f_CentralizarMensagem(MsgCabecalho + RIGHT(@sData,2) + '/' + SUBSTRING(@sData,5,2) + '/' + LEFT(@sData,4),'@',42)
			,@sCabecalho					= MsgTicket
			,@sDetalheGenerico				= MsgExtra1
	FROM	TicketsRetorno WITH(NOLOCK)
	WHERE	Codigo = 11

	IF (@iResposta = 0)
	BEGIN
		/* INI: QUANTIDADE E VALORES DE TRANSACAOES CONVENIO E FROTA */
		SET @dData = CONVERT(DATETIME, LEFT(@sData,4) + '-' + SUBSTRING(@sData,5,2) + '-' + RIGHT(@sData,2))

		SELECT	 @dValorConvenio		= COALESCE(SUM(CASE WHEN(LT.Estorno IS NULL AND TE.OpcaoFrota IS NULL) THEN TE.Valor_Operacao ELSE 0 END),0)
				,@iQtdTrnConvenio		= COALESCE(SUM(CASE WHEN(TE.Valor_Operacao > 0 AND TE.OpcaoFrota IS NULL) THEN 1 ELSE 0 END),0)
				,@dValorEstornoConvenio = COALESCE(SUM(CASE WHEN(LT.Estorno IS NOT NULL AND TE.OpcaoFrota IS NULL AND TE2.OpcaoFrota IS NULL) THEN TE.Valor_Operacao ELSE 0 END),0)
				,@iQtdEstornoConvenio	= COALESCE(SUM(CASE WHEN(TE.Valor_Operacao < 0 AND TE.OpcaoFrota IS NULL AND TE2.OpcaoFrota IS NULL) THEN 1 ELSE 0 END),0)
				,@dValorFrota			= COALESCE(SUM(CASE WHEN(LT.Estorno IS NULL AND TE.OpcaoFrota IS NOT NULL) THEN TE.Valor_Operacao ELSE 0 END),0)
				,@iQtdTrnFrota			= COALESCE(SUM(CASE WHEN(TE.Valor_Operacao > 0 AND TE.OpcaoFrota IS NOT NULL) THEN 1 ELSE 0 END),0)
				,@dValorEstornoFrota	= COALESCE(SUM(CASE WHEN(LT.Estorno IS NOT NULL AND TE2.OpcaoFrota IS NOT NULL) THEN TE.Valor_Operacao ELSE 0 END),0)
				,@iQtdEstornoFrota		= COALESCE(SUM(CASE WHEN(TE.Valor_Operacao < 0 AND TE2.OpcaoFrota IS NOT NULL) THEN 1 ELSE 0 END),0)
		FROM	  Policard_603078.dbo.Log_Transacao LT WITH(NOLOCK)
				INNER JOIN   Policard_603078.dbo.Transacao_Eletronica TE WITH(NOLOCK) ON (TE.Autorizacao = LT.Autorizacao AND TE.Terminal = LT.Terminal)
				LEFT JOIN   Policard_603078.dbo.Transacao_Eletronica TE2 WITH(NOLOCK) ON (TE2.Codigo = TE.Estorno)
		WHERE	LT.Id_Rede IN (13,58)
				AND LT.Terminal = @sTerminal
				AND LT.Data_Autorizacao BETWEEN @dData AND DATEADD(DAY,1,@dData)
		/* FIM: QUANTIDADE E VALORES DE TRANSACAOES CONVENIO E FROTA */

		/* INI: QUANTIDADE E VALORES DE TRANSACAOES PROCESSADORA */
		SELECT	 @iQtdTrnProcessadora		= COALESCE(SUM(CASE WHEN(T.TipoMensagem = '0200' AND T.Status <> 'D') THEN 1 ELSE 0 END),0)
				,@iQtdEstornoProcessadora	= COALESCE(SUM(CASE WHEN(T.TipoMensagem = '0400' AND T.Status <> 'D') THEN 1 ELSE 0 END),0)
				,@dValorProcessadora		= COALESCE(SUM(CASE WHEN(T.TipoMensagem = '0200' AND T.Status <> 'D') THEN T.Valor ELSE 0 END),0)
				,@dValorEstornoProcessadora	= COALESCE(SUM(CASE WHEN(T.TipoMensagem = '0400' AND T.Status <> 'D') THEN T.Valor * -1 ELSE 0 END),0)
		FROM	Processadora..TransacoesAutorizadas T WITH(NOLOCK)
		WHERE	T.CodEstabelecimento = @iEstabelecimento
				AND T.Terminal		 = @sTerminal
				AND T.Data BETWEEN @dData AND DATEADD(DAY,1,@dData)
		/* FIM: QUANTIDADE E VALORES DE TRANSACAOES PROCESSADORA */

		/* INI: QUANTIDADE E VALORES DE TRANSACAOES VALE TRANSPORTE */
		IF (@iRede = 21)
			SELECT	 @iQtdTrnVT			= COALESCE(SUM(CASE WHEN(T.TipoMensagem IN('0200','0210') AND C.Estornado <> 'D') THEN 1 ELSE 0 END),0)
					,@iQtdEstornoVT		= COALESCE(SUM(CASE WHEN(T.TipoMensagem IN('0400','0410') AND C.Estornado <> 'D') THEN 1 ELSE 0 END),0)
					,@dValorVT			= COALESCE(SUM(CASE WHEN(T.TipoMensagem IN('0200','0210') AND C.Estornado <> 'D') THEN T.Valor ELSE 0 END),0)
					,@dValorEstornoVT	= COALESCE(SUM(CASE WHEN(T.TipoMensagem IN('0400','0410') AND C.Estornado <> 'D') THEN T.Valor * -1 ELSE 0 END),0)
			FROM Processadora..TransacoesExternas T WITH(NOLOCK)
			INNER JOIN Acquirer..EstabelecimentoContaCorrenteVT C WITH(NOLOCK) ON (C.CodEstabelecimento = T.CodEstabelecimento AND C.CodTransacao = T.Codigo)
			WHERE T.CodEstabelecimento = @iEstabelecimento
			AND T.Terminal = @sTerminal
			AND T.Data BETWEEN @dData AND DATEADD(DAY,1,@dData)
		/* FIM: QUANTIDADE E VALORES DE TRANSACAOES VALE TRANSPORTE */

		SELECT	 @dValorTotal		 = @dValorConvenio + @dValorFrota + @dValorProcessadora + @dValorVT + @dValorCorrespBancario
				,@dValorEstornoTotal = @dValorEstornoConvenio + @dValorEstornoFrota + @dValorEstornoProcessadora + @dValorEstornoVT + @dValorEstornoCorrespBancario
				,@iQtdTrnTotal		 = @iQtdTrnConvenio + @iQtdTrnFrota + @iQtdTrnProcessadora + @iQtdTrnVT + @iQtdTrnCorrespBancario
				,@iQtdEstornoTotal	 = @iQtdEstornoConvenio + @iQtdEstornoFrota + @iQtdEstornoProcessadora + @iQtdEstornoVT + @iQtdEstornoCorrespBancario

		INSERT INTO @TB_EstabelecimentoTipoProduto(CodEstabelecimento, CodTipoProduto)
			SELECT CodigoEstabelecimento, CodigoProduto FROM Acquirer..EstabelecimentoTipoProduto WITH(NOLOCK) WHERE CodigoEstabelecimento = @iEstabelecimento AND CodigoProdutoStatus = 1

		IF (EXISTS(SELECT 1 FROM @TB_EstabelecimentoTipoProduto WHERE CodTipoProduto IN (6,61))) -- CONVENIO E COMBUSTIVEL
		BEGIN
			SET @sDetalheConvenio = @sDetalheGenerico
			SET @sDetalheConvenio = '@ ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
									@sDetalheConvenio,'<PRODUTO>','CONVENIO')
									,'<QTD>',CONVERT(VARCHAR,@iQtdTrnConvenio))
									,'<VALOR>',CONVERT(VARCHAR,@dValorConvenio))
									,'<QTDESTORNO>',CONVERT(VARCHAR,@iQtdEstornoConvenio))
									,'<VALORESTORNO>',CONVERT(VARCHAR,@dValorEstornoConvenio))
		END

		IF (EXISTS(SELECT 1 FROM @TB_EstabelecimentoTipoProduto WHERE CodTipoProduto = 60)) -- FROTA
		BEGIN
			SET @sDetalheFrota = @sDetalheGenerico
			SET @sDetalheFrota = '@ ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
								 @sDetalheFrota,'<PRODUTO>','GESTAO DE FROTA')
								 ,'<QTD>',CONVERT(VARCHAR,@iQtdTrnFrota))
								 ,'<VALOR>',CONVERT(VARCHAR,@dValorFrota))
								 ,'<QTDESTORNO>',CONVERT(VARCHAR,@iQtdEstornoFrota))
								 ,'<VALORESTORNO>',CONVERT(VARCHAR,@dValorEstornoFrota))
		END

		IF (EXISTS(SELECT 1 FROM @TB_EstabelecimentoTipoProduto WHERE CodTipoProduto NOT IN (6,60,61,73))) -- PROCESSADORA
		BEGIN
			SET @sDetalheProcessadora = @sDetalheGenerico
			SET @sDetalheProcessadora = '@ ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
										@sDetalheProcessadora,'<PRODUTO>','PAT, FRETE E OUTROS')
										,'<QTD>',CONVERT(VARCHAR,@iQtdTrnProcessadora))
										,'<VALOR>',CONVERT(VARCHAR,@dValorProcessadora))
										,'<QTDESTORNO>',CONVERT(VARCHAR,@iQtdEstornoProcessadora))
										,'<VALORESTORNO>',CONVERT(VARCHAR,@dValorEstornoProcessadora))
		END

		IF (EXISTS(SELECT 1 FROM @TB_EstabelecimentoTipoProduto WHERE CodTipoProduto = 74)) -- VT
		BEGIN
			SET @sDetalheVT = @sDetalheGenerico
			SET @sDetalheVT = '@ ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
							  @sDetalheVT,'<PRODUTO>','VALE TRANSPORTE')
							  ,'<QTD>',CONVERT(VARCHAR,@iQtdTrnVT))
							  ,'<VALOR>',CONVERT(VARCHAR,@dValorVT))
							  ,'<QTDESTORNO>',CONVERT(VARCHAR,@iQtdEstornoVT))
							  ,'<VALORESTORNO>',CONVERT(VARCHAR,@dValorEstornoVT))
		END

		SET @sCabecalho = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
						  @sCabecalho,'<CNPJ>', @sCNPJ)
						  ,'<NOMEESTAB>', @sNome)
						  ,'<ENDERECO>', @sEndereco)
						  ,'<CIDADE>', @sCidade)
						  ,'<ESTADO>', @cEstado)
						  ,'<CODESTAB>', CONVERT(VARCHAR,@iEstabelecimento))
						  ,'<TERMINAL>', @sTerminal)
						  ,'<DATA>', RIGHT(@sData,2) + '/' + SUBSTRING(@sData,5,2) + '/' + LEFT(@sData,4))
						  ,'<HORA>', @sHora)
						  ,'<QTDTOTAL>', CONVERT(VARCHAR,@iQtdTrnTotal))
						  ,'<VLRTOTAL>', CONVERT(VARCHAR,@dValorTotal))
						  ,'<QTDTOTALESTORNO>', CONVERT(VARCHAR,@iQtdEstornoTotal))
						  ,'<VLRTOTALESTORNO>', CONVERT(VARCHAR,@dValorEstornoTotal))

		SET @sTicket = @sTitulo + @sCabecalho + @sDetalheConvenio + @sDetalheFrota + @sDetalheProcessadora + @sDetalheVT + @sDetalheCorBan + '@'
	END
END




