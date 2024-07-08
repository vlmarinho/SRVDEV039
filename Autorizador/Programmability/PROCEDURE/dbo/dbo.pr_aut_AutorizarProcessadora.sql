

/*
Criador: Cristiano Silva Barbosa
Data de criação: 18/06/2015
Resumo: Procedure responsável por autorizar transações de venda da processadora.

Histórico de alterações:
--------------------------------------------------------------------------------
Data criação: 19/02/2017
Mudança: 2601
--------------------------------------------------------------------------------
Data: 24/02/2017
Mud/CH.: 359154 / 2627
--------------------------------------------------------------------------
Data Alteracao: 21/03/2017
Autor: Cristiano Barbosa
CH: 365214 - 2676
--------------------------------------------------------------------------
Data Alteracao: 16/05/2017
Autor: Cristiano Barbosa
CH: 383212 - 2839
--------------------------------------------------------------------------
Data: 23/05/2017
Autor: Cristiano Barbosa - Tecnologia Policard
Chamado: 367344 - 2856
--------------------------------------------------------------------------
Data: 28/09/2017
Autor: Cristiano Barbosa - Tecnologia Policard
Chamado: 399954 / 3262
--------------------------------------------------------------------------
Data: 02/02/2018
Autor: Cristiano Barbosa - Tecnologia Policard
Chamado: 474097 / 
--------------------------------------------------------------------------
Data Alteração: 26/04/2018
Chamados: 494467  / 3947
Responsavel: Cristiano Barbosa- Up Brasil
--------------------------------------------------------------------------
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1843805
Descrição: Projeto ABECS para transações NCR/Scope.
-------------------------------------------------------------------------- 	
*/

CREATE PROCEDURE [dbo].[pr_aut_AutorizarProcessadora](
	 @cBit003					VARCHAR(6)			OUTPUT		/* Código de Processamento */
	,@cBit004					VARCHAR(12)						/* Valor Transacao*/
	,@cBit007					VARCHAR(10)						/* Data e Hora GMT da Transação (MMDDHHMMSS) */
	,@cBit011					VARCHAR(6)						/* Número de Identificação da Transação da Solução de Captura */
	,@cBit012					VARCHAR(6)						/* Hora da Transação (HHMMSS) */
	,@cBit013					VARCHAR(4)						/* Data da Transação (MMDD)*/
	,@cBit014					VARCHAR(1000)		OUTPUT		/* Data Validade do Cartão */
	,@cBit022					CHAR(3)
	,@cBit037					VARCHAR(12)			OUTPUT		/* NSU da Rede de Captura */
	,@cBit038					VARCHAR(6)			OUTPUT		/* Authorization Identification Response */
	,@cBit039					CHAR(2)				OUTPUT		/* Codigo de resposta*/
	,@cBit041					VARCHAR(8)			OUTPUT		/* Identificação do Terminal */
	,@cBit048					VARCHAR(1000)		OUTPUT		/* Informações Adcionais */
	,@cBit052					VARCHAR(16)			OUTPUT		/* Senha Criptografada */
	,@cBit060					VARCHAR(100)		OUTPUT		/* Dados Adicionais de Terminal */
	,@cBit062					VARCHAR(1000)		OUTPUT		/* Ticket transação */
	,@cBit063					VARCHAR(1000)		OUTPUT		/* Ticket transação */
	,@cBit105					VARCHAR(100)		OUTPUT		/* Dados Adicionais Utilizados pela Policard */
	,@cBit123					VARCHAR(100)
	,@cBit047					VARCHAR(1000)		OUTPUT		/* saldo disponível scope */
	,@cBit127					VARCHAR(9)			OUTPUT
	,@cNumeroCartao				VARCHAR(16)			OUTPUT		/* Número do Cartão */
	,@nValor_Transacao			DECIMAL(15,2)		OUTPUT		/* Valor da Transação */
	,@dDataHora_Transacao		DATETIME
	,@iRedeNumero				INT
	,@iMeiCptCodigo				INT
	,@iCodigoEstabelecimento	INT					OUTPUT		/* Código de Identificação do Estabelecimento (Filiação) */
	,@bEstabMigrado				BIT								/* Código de Identificação do Estabelecimento (Filiação) */
	,@bSenhaCapturada			BIT
	,@iResposta					INT					OUTPUT
)
AS
BEGIN
    
	SET NOCOUNT ON;
	
	DECLARE 
		 @cAutorizacao					CHAR(18)
		,@iTrnSysCodigo					INT
		,@iTrnTxSysCodigo				INT
		,@iTipoFinanciamento			INT
		,@iQuantParcelas				INT
		,@nValorParcela					DECIMAL(15,2)
		,@dDataPrimeiraParcela			DATETIME
		/* Cartão */
		,@cStatus_Cartao				CHAR(1)
		,@cTipoCartao					CHAR(1)
		,@iCrtUsrCodigo					INT
		,@iCntUsrCodigo					INT
		,@iTpoPrdCodigo					INT
		,@iLimiteExtraCartao			INT
		,@nCreditoDisponivelCartao		DECIMAL(15,2)
		,@nCreditoParcelamentoCartao	DECIMAL(15,2)
		,@sNomeUsuario					VARCHAR(50)
		,@sLabelProduto					VARCHAR(50)
		/* Conta */
		,@cStatus_Conta					CHAR(1)
		,@iPrpCodigo					INT
		,@nLimiteCreditoConta			DECIMAL(15,2)
		,@nCreditoDisponivelConta		DECIMAL(15,2)
		,@nCreditoDisponivel			DECIMAL(15,2)
		,@nLimiteCredito				DECIMAL(15,2)
		/* Entidades */
		,@cStatus_AgenteEmissor			CHAR(1)
		,@iEntCodigo					INT
		,@iTpoEntCodigo					INT
		,@iaut_ValorLimiteTransacoes	INT
		,@bRestricaoEstabelecimento		BIT
		,@bRetemSaldo					BIT
		/* Tipos Transações */
		,@iTpoTrnCodigo					INT
		,@iPrdCodigo					INT
		,@cProdutoResponsavel			VARCHAR(50)
		/* Tipos Produtos Tipos Transações */
		,@cTipoTransacaoInterno			CHAR(1)
		,@nTaxaJuros					DECIMAL(6,2)
		,@nValorMinimoParcela			DECIMAL(15,2)
		,@nValorMaximoParcela			DECIMAL(15,2)
		,@nValorTaxacao					DECIMAL(15,2)
		,@nPagamentoMinimo				DECIMAL(6,2)
		,@iTransacaoVinculada			INT
		/* Estabelecimento */
		,@iEstCodigo					INT
		,@sEstado_Estabelecimento		CHAR(2)
		,@sCNPJ_Estabelecimento			VARCHAR(18)
		,@sNome_Estabelecimento			VARCHAR(35)
		,@sEndereco_Estabelecimento		VARCHAR(40)
		,@sCidade_Estabelecimento		VARCHAR(40)
		,@dDataRepasse					DATETIME
		,@dDataCalculo					DATETIME
		/* Estabelecimento Tipo Produto */
		,@nTaxaAdministracao			DECIMAL(5,2)
		,@cStatus_EstTpProd				CHAR(1)
		,@iDiaCorte						INT
		,@iFxsRpsCodigo					INT
		,@iDiaRepasse					INT
		/* Transação */
		,@cTipoTransacaoExterno			CHAR(2)
		,@iMinimoParcelas				INT
		,@iMaximoParcelas				INT
		,@iTpoLncCodigo					INT
		,@iTpoLncCodigoTarifa			INT
		--,@iTransacaoTarifacao			INT
		,@bCartaoEmv					BIT
		,@bFallBack						BIT
		,@cIdProvedor					VARCHAR(40)
		/* Controle 3º Via */
		,@cStatusTransacao				CHAR(1)
		/* MeiosCaptura */
		,@iRedeCodigo					INT
		--Valor de Adiantamento Externo
		,@VrFrete_AdiantamentoCC        DECIMAL(15,2)

	/*Buscando codigo da rede*/
	SELECT @iRedeCodigo = CodigoSubRede FROM Acquirer.dbo.SubRede WITH (NOLOCK) WHERE Numero = @iRedeNumero
	
	SET @cIdProvedor = CASE WHEN @iRedeNumero = 58 THEN 'POS WALK'
						WHEN @iRedeNumero = 10 THEN 'CIELO'
						WHEN @iRedeNumero = 29 THEN 'REDECARD'
						WHEN @iRedeNumero = 31 THEN 'STONE'
						WHEN @cBit123 LIKE 'SCOPE%' THEN SUBSTRING(@cBit123,1,12)
				    ELSE @cBit048 END

	/* Controle de 3º Via */
	SET @cStatusTransacao = 'P' --CASE WHEN(CONVERT(INT, @iRdeCodigo) IN (4) AND @cTerminal NOT LIKE 'G0%') THEN 'A' ELSE 'P' END

	IF (@iRedeCodigo IN (8,9))
		EXEC pr_aut_LeInfoAdicionais_VendaParcelada @cBit048, @iTipoFinanciamento OUTPUT, @iQuantParcelas OUTPUT, @dDataPrimeiraParcela OUTPUT

	SET @iResposta = 0
	SET @cAutorizacao = [dbo].[f_GerarAutorizacao]()
	SET @dDataPrimeiraParcela = GETDATE()
	SET @dDataCalculo = @dDataHora_Transacao

	IF (@cBit022 IN ('791','801'))
		SET @bFallBack = 1
	ELSE
		SET @bFallBack = 0

	IF (@cBit003 IN ('000200', '000300' ,'002000' , '003000'))
	BEGIN
		IF LEN(@cBit105) = ''
		BEGIN
			SET @iQuantParcelas = 1
			SET @cTipoTransacaoExterno = 'VV' /* Venda a vista */
		END
		ELSE
		BEGIN
			SET @iQuantParcelas = 1
			SET @cTipoTransacaoExterno = 'QT' /* QUITACAO DE FRETE*/
		END
	END
	ELSE IF @cBit003 = '001000'
	BEGIN
		IF @iQuantParcelas > 1
			SET @cTipoTransacaoExterno = 'VP' /* Venda parcelada sem juros */
		ELSE
		BEGIN
			SET @iQuantParcelas = 1
			SET @cTipoTransacaoExterno = 'VV' /* Venda a vista */
		END
	END
	ELSE IF @cBit003 = '002100'
	BEGIN
		SET @iQuantParcelas = 1
		SET @cTipoTransacaoExterno = 'SQ'
	END
	ELSE
		SET @iResposta = 118 /* TRANSACAO INVÁLIDA - "TRANS.INVALID" */

	/* CARTAO */
	IF (@iResposta = 0)
	BEGIN
		SELECT	@iCrtUsrCodigo					= CU.CrtUsrCodigo
				,@iCntUsrCodigo					= CU.CntUsrCodigo
				,@iTpoPrdCodigo					= CU.TpoPrdCodigo
				,@cTipoCartao					= CU.Tipo
				,@iLimiteExtraCartao			= CU.FlgLimiteExtra
				,@nCreditoDisponivelCartao		= COALESCE(CU.CreditoDisponivel, 0)
				,@nCreditoParcelamentoCartao	= COALESCE(CU.CreditoParcelamento, 0)
				,@iPrdCodigo					= TP.PrdCodigo
				,@sNomeUsuario					= CU.Nome
				,@bCartaoEmv					= COALESCE(CU.Chip,0)
				,@cStatus_Cartao				= CU.Status
				,@sLabelProduto					= LTRIM(RTRIM(UPPER(COALESCE(TP.Descricao,TP.NOME))))
		FROM	Processadora.dbo.CartoesUsuarios CU WITH(HOLDLOCK, ROWLOCK)
		INNER JOIN Processadora.dbo.TiposProdutos TP WITH(NOLOCK) ON (TP.TpoPrdCodigo = CU.TpoPrdCodigo)
		WHERE	CU.Numero = @cNumeroCartao 
		AND FlagTransferido = 0
				
		SET @sLabelProduto = REPLACE(Autorizador.dbo.f_FormatarTexto(@sLabelProduto), 'CARTAO', '')

	END

	IF (@iResposta = 0)
	BEGIN

		/*VERIFICAR ESSE SELECT*/
		SELECT	@iTpoTrnCodigo			= TPTT.CodTipoTransacao
				,@nValorMinimoParcela	= TPTT.ValorMinimoParcela
				,@nValorMaximoParcela	= TPTT.ValorMaximoParcela
				,@nTaxaJuros			= TaxaJuros
				,@nValorTaxacao			= CASE WHEN TPTT.ValorTaxacao IS NOT NULL AND  TPTT.ValorRefTaxacao IS NOT NULL THEN TPTT.ValorTaxacao ELSE 0 END
				,@cTipoTransacaoInterno = CASE TT.Tipo	WHEN 'D' THEN 'D'
														WHEN 'C' THEN 'C'
														WHEN 'P' THEN 'C' END
				,@iTransacaoVinculada	= TransacaoVinculada
		FROM dbo.TiposProdutosTiposTransacoes TPTT WITH(NOLOCK)
		INNER JOIN dbo.TiposTransacoes TT WITH(NOLOCK) ON (TT.CodTipoTransacao = TPTT.CodTipoTransacao)
		WHERE CodTipoProduto = @iTpoPrdCodigo
		AND TipoTransacao = @cTipoTransacaoExterno

		
		
		SELECT  @nPagamentoMinimo = ISNULL(PAGAMENTOMINIMO,0)
			   ,@iTpoLncCodigo = CASE WHEN @iTpoTrnCodigo IN ('100000','350000') AND @iTpoPrdCodigo IN (65,66,67,68) THEN ISNULL(TPTT.TpoLncCodigoTarifa,0)
									ELSE TT.TpoLncCodigo END
			   ,@iTpoLncCodigoTarifa = ISNULL(TPTT.TpoLncCodigoTarifa,0)
		FROM Processadora.dbo.TiposProdutosTiposTransacoes TPTT WITH(NOLOCK)
		INNER JOIN Processadora.dbo.TiposTransacoes TT WITH(NOLOCK) ON (TT.TpoTrnCodigo = TPTT.TpoTrnCodigo)
		WHERE TPTT.TpoPrdCodigo = @iTpoPrdCodigo
		AND TPTT.TpoTrnCodigo = @iTpoTrnCodigo

	END

	IF (@iResposta = 0)
	BEGIN

		IF (@bEstabMigrado = 0)
		BEGIN

			SELECT	 @iEstCodigo				= EstCodigo
					,@sCNPJ_Estabelecimento		= CNPJ
					,@sNome_Estabelecimento		= UPPER(SUBSTRING(LTRIM(RTRIM(Nome)),1,40))
					,@sEndereco_Estabelecimento	= UPPER(LTRIM(RTRIM(Endereco)))
					,@sCidade_Estabelecimento	= UPPER(LTRIM(RTRIM(Cidade)))
					,@sEstado_Estabelecimento	= Estado
			FROM	Processadora.dbo.Estabelecimentos WITH(NOLOCK)
			WHERE	Numero = @iCodigoEstabelecimento -- Parâmetro de entrada referente ao código Policard do estabelecimento.

			SET @sCidade_Estabelecimento = dbo.f_FormatarTexto(@sCidade_Estabelecimento)
			
			SELECT	@nTaxaAdministracao = TaxaAdministracao
					,@cStatus_EstTpProd = Status
					,@iDiaCorte			= DiaCorte
					,@iFxsRpsCodigo	    = FxsRpsCodigo
			FROM Processadora.dbo.EstabelecimentosTiposProdutos  WITH(NOLOCK)
			WHERE EstCodigo = @iEstCodigo
			AND TpoPrdCodigo = @iTpoPrdCodigo
	
			----------------------------------------------------------------------------------------------
			--Nome      : Validar_Vinculo_TipoProduto_Estabelecimento
			--Descrição : Valida existência de vínculo entre o estabelecimento e o produto em questão
			--   Deve ser realizado uma validação de existência de resultados.
			--Cod. resp.: --
			----------------------------------------------------------------------------------------------
			IF (@nTaxaAdministracao IS NULL)
				SET @iResposta = 278 /* PRODUTO INEXISTENTE - TRANSACAO NAO AUTORIZADA */

			----------------------------------------------------------------------------------------------
			--Nome      : Validar_Status_Vinculo_TipoProduto_Estabelecimento
			--Descrição : Valida se o estabelecimento está habilitado habilitado a realizar transações para este produto
			--   Caso o campo "Status" obtido na consulta a entidade EstabelecimentosTiposProdutos seja diferente de 'A'
			--Cod. resp.: --
			----------------------------------------------------------------------------------------------
			IF (@iResposta = 0) AND (@cStatus_EstTpProd <> 'A')
				SET @iResposta = 279 /* PRODUTO INATIVO PARA ESTE ESTABELECIMENTO - TRANSACAO NAO AUTORIZADA */


			IF (@iResposta = 0)
			BEGIN

				IF NOT EXISTS (SELECT 1 FROM Processadora.dbo.EstabelecimentosTiposTransacoes WITH(NOLOCK)
								WHERE EstCodigo	 = @iEstCodigo AND TpoPrdCodigo = @iTpoPrdCodigo AND TpoTrnCodigo = @iTpoTrnCodigo)
				BEGIN

					INSERT INTO Processadora.dbo.EstabelecimentosTiposTransacoes (
							 EstCodigo	
							,TpoPrdCodigo
							,TpoTrnCodigo 
							,MinimoParcelas
							,MaximoParcelas
							)
						VALUES(
							 @iEstCodigo
							,@iTpoPrdCodigo
							,@iTpoTrnCodigo
							,1
							,1
						)
				END 

				SELECT	@iMinimoParcelas = MinimoParcelas
						,@iMaximoParcelas = MaximoParcelas
						,@dDataRepasse = CASE WHEN(TpoTrnCodigo = '350000' AND TpoPrdCodigo = 59) THEN DATEADD(DAY, 2, @dDataCalculo)
											ELSE Processadora.dbo.f_RetornaDataRepasse(@dDataCalculo, @iDiaCorte, @iFxsRpsCodigo, YEAR(@dDataCalculo), MONTH(@dDataCalculo), @iDiaRepasse) 
										END
				FROM Processadora.dbo.EstabelecimentosTiposTransacoes WITH(NOLOCK)
				WHERE EstCodigo	 = @iEstCodigo
				AND TpoPrdCodigo = @iTpoPrdCodigo
				AND TpoTrnCodigo = @iTpoTrnCodigo

				----------------------------------------------------------------------------------------------
				--Nome      : Validar_Vinculo_Estabelecimento_TipoTransacao
				--Descrição : Valida existência de vínculo entre o estabelecimento e o tipo de transação em questão
				--   Deve ser realizado uma validação de existência de resultados.
				--Cod. resp.: --
				----------------------------------------------------------------------------------------------
				IF (@iMinimoParcelas IS NULL) OR (@iMaximoParcelas IS NULL)
					SET @iResposta = 280 /* ESTABELECIMENTO NAO ASSOCIADO A ESTE TIPO DE TRANSACAO - TRANSACAO NAO PERMITIDA */

				----------------------------------------------------------------------------------------------
				--Nome      : Validar_Numero_Parcelas_Permitidas_Estabelecimento
				--Descrição : Caso o campo "MinimoParcelas" for maior do que o número de parcelas obtidos na interpretação do Bit48 ou
				--                 o campo "MaximoParcelas" for menor do que o número de parcelas obtidos na interpretação do Bit48
				--Cod. resp.: --
				----------------------------------------------------------------------------------------------
				IF (@iResposta = 0) AND ((@iQuantParcelas < @iMinimoParcelas  OR @iQuantParcelas > @iMaximoParcelas))
					SET @iResposta = 18 /* QUANTIDADE DE PARCELAS INVALIDA */

			END

		END
		ELSE
		BEGIN
			
			SELECT 
				 @sCNPJ_Estabelecimento		= dbo.f_FormatarCNPJ_CPF(E.Cnpj)
				,@sNome_Estabelecimento		= UPPER(SUBSTRING(LTRIM(RTRIM(E.Nome)),1,40))
				,@sEndereco_Estabelecimento	= UPPER(LTRIM(RTRIM(EE.Logradouro))) + ',' + CONVERT(VARCHAR,EE.NUMERO)
				,@sCidade_Estabelecimento	= UPPER(LTRIM(RTRIM(EE.Cidade)))
				,@sEstado_Estabelecimento	= EE.UF
			FROM Acquirer.dbo.Estabelecimento E WITH (NOLOCK)
			INNER JOIN Acquirer.dbo.EstabelecimentoEndereco EE WITH (NOLOCK) ON E.CodigoEstabelecimento = EE.CodigoEstabelecimento
			WHERE E.CodigoEstabelecimento = @iCodigoEstabelecimento
			AND EE.CodigoTipoEndereco = 1

			SELECT	 @iMinimoParcelas    = etpt.ParcelaMinima
					,@iMaximoParcelas	 = etpt.ParcelaMaxima
					,@nTaxaAdministracao = etp.TaxaAdministracao
					,@cStatus_EstTpProd  = etp.CodigoProdutoStatus
					,@iDiaCorte			 = etp.DiaCorte
					,@iFxsRpsCodigo	     = etp.CodigoFaixaRepasse
					,@dDataRepasse = CASE WHEN(etpt.CodigoTransacao = '350000' AND etp.CodigoProduto = 59) THEN DATEADD(DAY, 2, @dDataCalculo)
											ELSE Acquirer.dbo.f_RetornaDataRepasse(@dDataCalculo, @iFxsRpsCodigo) 
									END
			FROM Acquirer.dbo.EstabelecimentoTipoProduto etp WITH(NOLOCK)
			INNER JOIN Acquirer.dbo.EstabelecimentoTipoProdutoTransacao etpt WITH(NOLOCK) ON etp.CodigoEstabelecimentoTipoProduto = etpt.CodigoEstabelecimentoTipoProduto
			WHERE etp.CodigoEstabelecimento = @iCodigoEstabelecimento
				AND etp.CodigoProduto = @iTpoPrdCodigo
				AND etpt.CodigoTransacao = @iTpoTrnCodigo

			----------------------------------------------------------------------------------------------
			--Nome      : Validar_Vinculo_TipoProduto_Estabelecimento
			--Descrição : Valida existência de vínculo entre o estabelecimento e o produto em questão
			--   Deve ser realizado uma validação de existência de resultados.
			--Cod. resp.: --
			----------------------------------------------------------------------------------------------
			IF (@nTaxaAdministracao IS NULL)
				SET @iResposta = 278 /* PRODUTO INEXISTENTE - TRANSACAO NAO AUTORIZADA */

			----------------------------------------------------------------------------------------------
			--Nome      : Validar_Status_Vinculo_TipoProduto_Estabelecimento
			--Descrição : Valida se o estabelecimento está habilitado habilitado a realizar transações para este produto
			--   Caso o campo "Status" obtido na consulta a entidade EstabelecimentosTiposProdutos seja diferente de 'A'
			--Cod. resp.: --
			----------------------------------------------------------------------------------------------
			IF (@iResposta = 0) AND (@cStatus_EstTpProd <> '1')
				SET @iResposta = 279 /* PRODUTO INATIVO PARA ESTE ESTABELECIMENTO - TRANSACAO NAO AUTORIZADA */

			----------------------------------------------------------------------------------------------
			--Nome      : Validar_Vinculo_Estabelecimento_TipoTransacao
			--Descrição : Valida existência de vínculo entre o estabelecimento e o tipo de transação em questão
			--   Deve ser realizado uma validação de existência de resultados.
			--Cod. resp.: --
			----------------------------------------------------------------------------------------------
			 IF (@iResposta = 0) AND (@iMinimoParcelas IS NULL OR @iMaximoParcelas IS NULL)
				SET @iResposta = 280 /* ESTABELECIMENTO NAO ASSOCIADO A ESTE TIPO DE TRANSACAO - TRANSACAO NAO PERMITIDA */

			----------------------------------------------------------------------------------------------
			--Nome      : Validar_Numero_Parcelas_Permitidas_Estabelecimento
			--Descrição : Caso o campo "MinimoParcelas" for maior do que o número de parcelas obtidos na interpretação do Bit48 ou
			--                 o campo "MaximoParcelas" for menor do que o número de parcelas obtidos na interpretação do Bit48
			--Cod. resp.: --
			----------------------------------------------------------------------------------------------
			IF (@iResposta = 0) AND (@iQuantParcelas < @iMinimoParcelas  OR @iQuantParcelas > @iMaximoParcelas)
				SET @iResposta = 18 /* QUANTIDADE DE PARCELAS INVALIDA */

		END

	END

	----------------------------------------------------------------------------------------------
	--Nome      : Validar_Existencia_Vinculo_EstabelecimentoMeioCapturaWALKPHOEBUS
	--Descrição : Valida existência do vínculo entre o meio de captura e estabelecimento
	--Cod. resp.: --
	----------------------------------------------------------------------------------------------
	--IF (@iResposta = 0 AND @iRedeCodigo = 8)
	--BEGIN
	--	IF NOT EXISTS(SELECT	TOP 1 1
	--					FROM	EstabelecimentosMeiosCaptura EMC (NOLOCK)
	--							JOIN MeiosCaptura MEC (NOLOCK) ON MEC.MeiCptCodigo = EMC.MeiCptCodigo
	--					WHERE	EMC.EstCodigo = @iEstCodigo
	--							AND MEC.Numero = @cBit041)
	--	SET @iResposta = 277
	--END

	----------------------------------------------------------------------------------------------
	--Nome      : Validar se o produto pode efetuar saque
	--Descrição : Somente o produto Polifrete pode efetuar saque na processadora
	--Cod. resp.: 118
	----------------------------------------------------------------------------------------------
	IF (@cBit003 = '002100' AND @iTpoPrdCodigo <> 59)
		SET @iResposta = 118

	/*******************************************************************************
	Alterado por: Elmiro Leandro
	Data: 13/09/2011
	Descrição: Desbloquear cartões PAT no primeiro uso, caso a senha esteja correta (para os
	produtos com senha)
	SA: 447417
	******************************************************************************/
	--IF (@iResposta = 0 AND @iPrdCodigo IN (5,21)) -- Modificado em 11/12/2015 -- 10:00 hs
	IF (@iResposta = 0 AND @cStatus_Cartao = 'B')
		EXEC Processadora.dbo.pr_aut_desbloqueia_Cartao @iCrtUsrCodigo
	/***********************************************************************447417*/

	----------------------------------------------------------------------------------------------
	--Nome      : Validar_TransacaoProduto
	--Descrição : Caso o Bit048 possua dados de venda parcelada e o campo "TpoPrdCodigo" obtido na consulta da tabela cartoesusuario seja diferente de três (AGN).
	--Cod. resp.: --
	----------------------------------------------------------------------------------------------
	IF ((@iResposta = 0) AND (@iQuantParcelas > 1) AND (@iTpoPrdCodigo <> 3)) -- Produto AGN
		SET @iResposta = 287 /* PARCELAMENTO INVALIDO OU NAO PERMITIDO - PARCELAMENTO NAO AUTORIZADO PARA ES*/

	IF (@iResposta = 0) AND (@iQuantParcelas > 1)
		SET @iResposta = 298 /* NUMERO DE PARCELAS EXCEDO O MAXIMO */

	IF (@iResposta = 0)
	BEGIN
		SELECT	 @cStatus_Conta				= CU.Status
				,@iPrpCodigo				= CU.PrpCodigo
				,@nLimiteCreditoConta		= CU.LimiteCredito
				,@nCreditoDisponivelConta	= CU.CreditoDisponivel
		FROM	Processadora.dbo.ContasUsuarios CU /* INI SA: 474430 */ WITH(HOLDLOCK, ROWLOCK) /* FIM SA: 474430 */
		WHERE	CU.CntUsrCodigo = @iCntUsrCodigo

		SELECT	@iEntCodigo = EntCodigo
		FROM	Processadora.dbo.Propostas WITH(NOLOCK)
		WHERE	PrpCodigo = @iPrpCodigo

		SELECT	@iEntCodigo = EntCodigo
				,@iTpoEntCodigo = TpoEntCodigo
				,@iaut_ValorLimiteTransacoes = aut_ValorLimiteTransacoes
				,@bRetemSaldo = ISNULL(ReterSaldo,1)
		FROM	Processadora.dbo.Entidades WITH(NOLOCK)
		WHERE	EntCodigo = @iEntCodigo

		----------------------------------------------------------------------------------------------
		--Nome      : Validar_Existencia_Conta_usuario
		--Descrição : Verifica a existência da conta de um usuário.
		--Cod. resp.: --
		----------------------------------------------------------------------------------------------
		IF ((@iResposta = 0) AND (@nLimiteCreditoConta IS NULL))
			SET @iResposta = 272 /* CONTA INEXISTENTE - TRANSACAO NAO AUTORIZADA */
	END

	----------------------------------------------------------------------------------------------
	--Nome      : Validar_Status_Conta_Usuario
	--Descrição : Caso o campo "Status" obtido na consulta da entidade Conta_usuario seja diferente de 'A'
	--Cod. resp.: --
	----------------------------------------------------------------------------------------------
	IF ((@iResposta = 0) AND (@cStatus_Conta <> 'A'))
		SET @iResposta = 328 /* CONTA BLOQUEADA OU CANCELADA - CONTA CANC / BLOQ */

	--IF (@iResposta = 0)
	--BEGIN
	--	SELECT	@cStatus_AgenteEmissor = Status
	--			,@bRestricaoEstabelecimento = ISNULL(Restricao,0)
	--	FROM Processadora.dbo.TiposProdutosEntidades WITH(NOLOCK)
	--	WHERE TpoEntCodigo = @iTpoEntCodigo		-- Constante 4 que é o código referente ao tipo em questão cadastrado.
	--	AND TpoPrdCodigo = @iTpoPrdCodigo	-- Campo "TpoPrdCodigo" obtido na consulta a entidade cartoesusuarios
	--	AND EntCodigo = @iEntCodigo			-- Campo "EntCodigo" obtido na consulta a entidade Entidades


	--	----------------------------------------------------------------------------------------------
	--	--Nome      : Validar_Status_AgenteEmissor
	--	--Descrição : Caso o campo "Status", obtido na consulta a entidade TiposProdutosEntidades for diferente de 'A'
	--	--Cod. resp.: --
	--	----------------------------------------------------------------------------------------------
	--	IF (@cStatus_AgenteEmissor <> 'A')
	--	BEGIN
	--		IF (@cStatus_AgenteEmissor = 'B')
	--		BEGIN
	--			IF (@bRetemSaldo = 1)
	--				SET @iResposta = 329
	--		END
	--		ELSE
	--			SET @iResposta = 292 /* AGENTE EMISSOR BLOQUEADO OU CANCELADO - TRANSACAO NAO AUTORIZADA */
	--	END
	--END

	IF (@iResposta = 0)
	BEGIN
		----------------------------------------------------------------------------------------------
		--Nome      : Validar_Saldo_Conta_Usuario
		--Descrição :
		--	> Para venda a vista:
		--    * Caso o campo "CreditoDisponivel" obtido na consulta a tabela conta_usuario seja menor do que o Bit004 (valor da transacao)
		--  > Para venda parcelada:
		--    * Caso o campo "CreditoDisponivel" obtido na consulta a tabela conta_usuario seja menor do que o valor da parcela unitário,
		--		obtido através da conclusão do bit048.
		--Cod. resp.: --
		----------------------------------------------------------------------------------------------
		IF (@iResposta = 0)
		BEGIN
			IF (@iQuantParcelas = 1)
			BEGIN
				IF (@nCreditoDisponivelConta < (@nValor_Transacao + @nValorTaxacao))  AND (@cTipoTransacaoExterno <> 'QT')
				BEGIN
					SET @iResposta = 93 /* SALDO INSUFICIENTE NA CONTA USUARIO */
					SET @cBit062 = @nCreditoDisponivelConta
				END
			END
			ELSE IF (@iQuantParcelas > 1)
			BEGIN
				IF (@nCreditoDisponivelConta < (@nValor_Transacao/@iQuantParcelas)) AND (@cTipoTransacaoExterno <> 'QT')
				BEGIN
					SET @iResposta = 93 /* SALDO INSUFICIENTE NA CONTA USUARIO */
					SET @cBit062 = @nCreditoDisponivelConta
				END
			END
		END

		----------------------------------------------------------------------------------------------
		--Nome      : Validar_Vinculo_TipoProduto_TipoTransacao
		--Descrição : Valida existência de vínculo entre o tipo de produto e o tipo de transação.
		--Cod. resp.: --
		----------------------------------------------------------------------------------------------
		IF @iTpoTrnCodigo IS NULL
			SET @iResposta = 275 /* PRODUTO INEXISTENTE - NAO AUTORIZADO */

		----------------------------------------------------------------------------------------------
		--Nome      : Validar_SaldoDisponível
		--Descrição :
		--  > Para transações a vista:
		--    * Caso o campo "CreditoDisponivelCartao" obtido na tabela cartoesusuarios seja menor do que o Bit004 (valor da transação)      
		--  > Para transações parceladas:
		--    * Caso o campo "CreditoParcelamento" obtido na tabela cartoesusuarios seja menor do que o valor da parcela unitário,
		--		obtido através da conclusão do bit048.
		--Cod. resp.: --
		--Não verificar saldo para transação de Quitação de Frete
		----------------------------------------------------------------------------------------------
		IF (@iResposta = 0)
		BEGIN
			IF (@iQuantParcelas = 1)
			BEGIN
				IF (@nCreditoDisponivelCartao < (@nValor_Transacao + COALESCE(@nValorTaxacao, 0))) AND (@cTipoTransacaoExterno <> 'QT')
				BEGIN
					SET @iResposta = 92 /* SALDO INSUFICIENTE */
					SET @cBit062 = @nCreditoDisponivelCartao
				END
			END
			ELSE IF @iQuantParcelas > 1
			BEGIN
				IF (@nCreditoParcelamentoCartao < ((@nValor_Transacao/@iQuantParcelas) + COALESCE(@nValorTaxacao, 0))) AND (@cTipoTransacaoExterno <> 'QT')
				BEGIN
					SET @iResposta = 92 /* SALDO INSUFICIENTE */
					SET @cBit062 = @nCreditoParcelamentoCartao
				END
			END
		END
	END

	----------------------------------------------------------------------------------------------
	--Nome      : Validar_Valor_das_Parcelas
	--Descrição : Aplicar a fórmula PMT de cálculo de aplicação de juros, de acordo com os parâmetros descritos abaixo,
	--			  considerando que o resultado da operação deverá estar entre os campos "ValorMinimoParcela" e
	--			  "ValorMaximoParcela" obtidos na consulta a tabela TiposProdutosTiposTransacoes.
	--Cod. resp.: --
	----------------------------------------------------------------------------------------------
	IF (@iResposta = 0)
	BEGIN
		IF (COALESCE(@iQuantParcelas, 1) = 1) /* @cInfPolicard - Dados adicionais utilizados pelo produto Carta Frete (Bit105) no processo de quitação */
			SET @nValorParcela = @nValor_Transacao /* Quitação Carta Frete */
		ELSE
			SET @nValorParcela = dbo.f_PMT(@nTaxaJuros / 100, @iQuantParcelas, - @nValor_Transacao, 0, 0)

		/*******************************************************************************************
		/ Alterado por: Elmiro Leandro
		/ Data: 02/10/2012
		/ Chamado qualitor: 3750
		/ Descritivo: Desconsiderar limite máximo de transação por produto para os
		/             clientes assinalados ao campo "aut_ValorLimiteTransacoes" da tabela entidades.
		********************************************************************************************/
		IF ((@nValorParcela < @nValorMinimoParcela OR @nValorParcela > @nValorMaximoParcela) AND @iaut_ValorLimiteTransacoes <> 1)
			SET @iResposta =  293 /* VALOR MAIOR QUE PERMITIDO */
	END

	IF (@iResposta = 0)
	BEGIN
		SELECT	
			@nLimiteCredito	= LimiteCredito
		   ,@nCreditoDisponivel = CreditoDisponivel
		FROM Processadora.dbo.LimitesCartoesUsuarios /* INI SA: 474430 */ WITH(HOLDLOCK, ROWLOCK) /* FIM SA: 474430 */
		WHERE CrtUsrCodigo = @iCrtUsrCodigo
		AND TpoTrnCodigo = @iTpoTrnCodigo

		----------------------------------------------------------------------------------------------
		--Nome      : Validar_Limite_CartoesUsuarios
		--Descrição : Caso o campo "LimiteCredito", obtido na consulta a entidade LimitesCartoesUsuarios for menor do que o bit004 (valor da transacao).
		--Cod. resp.: --
		----------------------------------------------------------------------------------------------
		IF (@nLimiteCredito < (@nValor_Transacao + @nValorTaxacao) AND @cTipoTransacaoExterno <> 'QT')
		BEGIN
			SET @iResposta = 94 /* SALDO INSUFICIENTE NA TABELA LIMITESCARTOESUSUARIOS */
			SET @cBit062 = @nLimiteCredito
		END

		----------------------------------------------------------------------------------------------
		--Nome      : Validar_Credito_CartoesUsuarios
		--Descrição : Caso o campo "CreditoDisponivel", obtido na consulta a entidade LimitesCartoesUsuarios for menor do que o bit004 (valor da transacao).
		--Cod. resp.: --
		----------------------------------------------------------------------------------------------
		IF (@iResposta = 0 AND @nCreditoDisponivel < (@nValor_Transacao + @nValorTaxacao) AND @cTipoTransacaoExterno <> 'QT')
		BEGIN
			SET @iResposta = 94 /* SALDO INSUFICIENTE NA TABELA LIMITESCARTOESUSUARIOS */
			SET @cBit062 = @nLimiteCredito
		END
	END

	IF (@iResposta = 0)
	BEGIN
		SELECT	
			 @nLimiteCredito = LimiteCredito
			,@nCreditoDisponivel = CreditoDisponivel
		FROM Processadora.dbo.LimitesContasUsuarios /* INI SA: 474430 */ WITH(HOLDLOCK, ROWLOCK) /* FIM SA: 474430 */
		WHERE CntUsrCodigo = @iCntUsrCodigo
		AND TpoTrnCodigo = @iTpoTrnCodigo

		----------------------------------------------------------------------------------------------
		--Nome      : Validar_Limite_CartoesUsuarios
		--Descrição : Caso o campo "LimiteCredito", obtido na consulta a entidade LimitesContasUsuarios for menor do que o bit004 (valor da transacao).
		--Cod. resp.: --
		----------------------------------------------------------------------------------------------
		IF (@nLimiteCredito < (@nValor_Transacao + @nValorTaxacao) AND @cTipoTransacaoExterno <> 'QT')
		BEGIN
			SET @iResposta = 94 /* SALDO INSUFICIENTE */
			SET @cBit062 = @nLimiteCredito
		END

		----------------------------------------------------------------------------------------------
		--Nome      : Validar_Credito_CartoesUsuarios
		--Descrição : Caso o campo "CreditoDisponivel", obtido na consulta a entidade LimitesContasUsuarios for menor do que o bit004 (valor da transacao).
		--Cod. resp.: --
		----------------------------------------------------------------------------------------------
		IF (@nCreditoDisponivel < (@nValor_Transacao + @nValorTaxacao) AND @cTipoTransacaoExterno <> 'QT')
		BEGIN
			SET @iResposta = 94 /* SALDO INSUFICIENTE */
			SET @cBit062 = @nCreditoDisponivel
		END
	END

	/* Quitação Carta Frete */
	IF ((@iResposta = 0) AND (@cBit105 <> '')) /* @cInfPolicard - Dados adicionais utilizados pelo produto Carta Frete (Bit105) */
	BEGIN

		DECLARE @iNumeroCartaFrete							INT
				,@iNumeroFrete								INT
				,@nQuantidadeChegada						DECIMAL(15,3)
				,@nQuantidadeSaida_Frete_Carta				DECIMAL(15,3)
				,@cIndFormaCalculoPerda_Frete_Carta			CHAR(1)
				,@nPercentualTolerancia_Frete_Carta			DECIMAL(15,2)
				,@nValorMercadoria_Frete_Carta				DECIMAL(15,2)
				,@cIndDescontaTotalPerda_Frete_Carta		CHAR(1)
				,@nValorCartaFrete_Frete_Carta				DECIMAL(15,2)
				,@nValorPorTonelada_Frete_Carta				DECIMAL(15,2)
				,@nValorPedagio_Frete_Carta					DECIMAL(15,2)
				,@nValorOutrosCreditos_Frete_Carta			DECIMAL(15,2)
				,@nValorSestSenat_Frete_Carta				DECIMAL(15,2)
				,@nValorDescontoInss_Frete_Carta			DECIMAL(15,2)
				,@nValorImpostoRenda_Frete_Carta			DECIMAL(15,2)
				,@nValorSeguro_Frete_Carta					DECIMAL(15,2)
				,@nValorOutrosDebitos_Frete_Carta			DECIMAL(15,2)
				,@nTotalAdiantamentos_Frete_Carta			DECIMAL(18,2)
				,@nValorTotalCartaFrete_Frete_Carta			DECIMAL(15,2)
				,@cIndStatus_Frete_Carta					CHAR(1)
				,@iEntCodigo_PedidosLancamentos				INT
				,@cPermiteTransportadoraQuitar				CHAR(1)
		
		SET @iNumeroCartaFrete = CONVERT(INT, SUBSTRING(@cBit105, 1, 25))       
		SET @nQuantidadeChegada = ((CONVERT(DECIMAL(15,3), SUBSTRING(@cBit105, 26, 15)))/100)      
		
		SELECT	 @nQuantidadeSaida_Frete_Carta			= FRC.QuantidadeSaida
				,@cIndFormaCalculoPerda_Frete_Carta		= FRC.IndFormaCalculoPerda
				,@nPercentualTolerancia_Frete_Carta		= FRC.PercentualTolerancia
				,@nValorMercadoria_Frete_Carta			= FRC.ValorMercadoria
				,@cIndDescontaTotalPerda_Frete_Carta	= FRC.IndDescontaTotalPerda
				,@cIndStatus_Frete_Carta				= FRC.IndStatus
				,@nValorCartaFrete_Frete_Carta			= FRC.ValorCartaFrete
				,@nValorPorTonelada_Frete_Carta			= FRC.ValorPorTonelada
				,@nValorPedagio_Frete_Carta				= FRC.ValorPedagio
				,@nValorOutrosCreditos_Frete_Carta		= FRC.ValorOutrosCreditos
				,@nValorSestSenat_Frete_Carta			= FRC.ValorSestSenat
				,@nValorDescontoInss_Frete_Carta		= FRC.ValorDescontoInss
				,@nValorImpostoRenda_Frete_Carta		= FRC.ValorImpostoRenda
				,@nValorSeguro_Frete_Carta				= FRC.ValorSeguro
				,@nValorOutrosDebitos_Frete_Carta		= FRC.ValorOutrosDebitos
				,@nTotalAdiantamentos_Frete_Carta		= COALESCE((SELECT SUM(valor) FROM Processadora.dbo.Frete_Adiantamento (NOLOCK) WHERE pddLncCodigo = FRC.pddLncCodigo),0)
				,@nValorTotalCartaFrete_Frete_Carta		= FRC.ValorTotalCartaFrete
				,@iEntCodigo_PedidosLancamentos			= PEL.EntCodigo
				,@cPermiteTransportadoraQuitar			= PermiteTransportadoraQuitar
				,@iNumeroFrete							= FRC.pddLncCodigo
		FROM Processadora.dbo.Frete_Carta FRC (NOLOCK)       
		INNER JOIN Processadora.dbo.PedidosLancamentos PEL /* INI SA: 474430 */ WITH(HOLDLOCK, ROWLOCK) /* FIM SA: 474430 */ ON (PEL.PddLncCodigo = FRC.pddLncCodigo)
		WHERE PEL.PddLncCodigo = @iNumeroCartaFrete
		
		IF (@iNumeroFrete IS NOT NULL)
		BEGIN
			IF(@nQuantidadeSaida_Frete_Carta IS NOT NULL)
			BEGIN
				IF (@cPermiteTransportadoraQuitar <> 'S' OR @cPermiteTransportadoraQuitar IS NULL)
				BEGIN
					/* Validando a existência do vinculo entre o lançamento e a conta do usuário */
					IF EXISTS (SELECT 1 FROM Processadora.dbo.PedidosLancamentosDetalhes (NOLOCK) WHERE PddLncCodigo = @iNumeroCartaFrete)
					BEGIN
						/* Validando status da carta frete */
						IF(@cIndStatus_Frete_Carta = 'L')
						BEGIN
							IF(@nQuantidadeChegada <= @nQuantidadeSaida_Frete_Carta)
							BEGIN
								DECLARE @nSaldoDisponivel_ProdutosAgentesEmissores	DECIMAL(15,2)
										,@cCalculoQuitacao							NVARCHAR(200)
										,@nValorQuitacao							DECIMAL(15,2)
										,@nValorCartaFreteCalculado					DECIMAL(15,2)
										,@nValorPerdaDescontar						DECIMAL(15,2)
										,@cOrigemQuitacao							CHAR(3)
								
								SET @cOrigemQuitacao =  CASE WHEN @iRedeNumero IN (7,8)	
														THEN 'TEF' ELSE 'POS' END

								SELECT	@nSaldoDisponivel_ProdutosAgentesEmissores = COALESCE(SaldoDisponivel, 0)
								FROM	Processadora.dbo.produtosagentesemissores (NOLOCK)
								WHERE	EntCodigo = @iEntCodigo_PedidosLancamentos
										AND PrdCodigo = @iPrdCodigo

								--Implementando desconto de adiantamentos por conta corrente
								SELECT @VrFrete_AdiantamentoCC = COALESCE(SUM(valor), 0) 
								  FROM processadora.dbo.Frete_AdiantamentoCC WITH(NOLOCK) 
								 WHERE pddLncCodigo = @iNumeroCartaFrete

								SET @nTotalAdiantamentos_Frete_Carta = @nTotalAdiantamentos_Frete_Carta + @VrFrete_AdiantamentoCC
								
								SELECT	@cCalculoQuitacao = dbo.f_FRT_CalcularQuitacao ( @nQuantidadeChegada
																						,@nQuantidadeSaida_Frete_Carta
																						,@cIndFormaCalculoPerda_Frete_Carta
																						,@nPercentualTolerancia_Frete_Carta
																						,@nValorMercadoria_Frete_Carta
																						,@cIndDescontaTotalPerda_Frete_Carta
																						,@nValorCartaFrete_Frete_Carta
																						,@nValorPorTonelada_Frete_Carta
																						,@nValorPedagio_Frete_Carta
																						,@nValorOutrosCreditos_Frete_Carta
																						,@nValorSestSenat_Frete_Carta
																						,@nValorDescontoInss_Frete_Carta
																						,@nValorImpostoRenda_Frete_Carta
																						,@nValorSeguro_Frete_Carta
																						,@nValorOutrosDebitos_Frete_Carta
																						,@nTotalAdiantamentos_Frete_Carta
																						,@nValorTotalCartaFrete_Frete_Carta)
																										
								SET @nValorCartaFreteCalculado = @nValorCartaFrete_Frete_Carta
								SET @nValorQuitacao = CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2), REPLACE(SUBSTRING(@cCalculoQuitacao, 91, 13),',',''))/100)
								SET @nValorQuitacao = @nValorQuitacao - @nValorPedagio_Frete_Carta
								SET @cBit105  = SUBSTRING(@cCalculoQuitacao, 1, (LEN(@cCalculoQuitacao) - 15))								

								IF (@nSaldoDisponivel_ProdutosAgentesEmissores >= @nValorQuitacao)
								BEGIN
									IF(@nValorQuitacao >= 0)
									BEGIN									
										DECLARE @iCodigoLancamentosInternosEntidades	INT
												,@iCodigoLancamentosInternos			INT

										EXEC Processadora.dbo.[pr_FRT_QuitacaoDebitoContaTransportadoraFormGen]
											 494
											,@iTpoPrdCodigo
											,@iEntCodigo_PedidosLancamentos
											,6
											,@nValorQuitacao
											,@iCodigoEstabelecimento
											,@dDataHora_Transacao
											,@dDataHora_Transacao
											,@iNumeroCartaFrete
											,@iCodigoLancamentosInternosEntidades OUTPUT
											,@iResposta OUTPUT


										IF(@iResposta = 0)
										BEGIN
											EXEC Processadora.dbo.[pr_FRT_QuitacaoCreditoCartaoFormGen]
												502
												,@nValorQuitacao
												,@iCodigoEstabelecimento
												,@dDataHora_Transacao
												,@iNumeroCartaFrete
												,@cNumeroCartao
												,@cTipoCartao
												,@iCodigoLancamentosInternos OUTPUT
												,@iResposta OUTPUT
										END
										

										IF(@iResposta = 0)
										BEGIN
											DECLARE @iFrete_Quitacao_Codigo INT

											SET @nValorQuitacao = @nValorQuitacao * -1

											EXEC pr_AtualizarCreditoDisponivel        
												 @iCrtUsrCodigo
												,@iCntUsrCodigo
												,@cTipoCartao
												,@nValorQuitacao
												,@iQuantParcelas
												,@iTpoPrdCodigo
												,@iTpoTrnCodigo
												,@cTipoTransacaoInterno
												,@iLimiteExtraCartao

											SET @nValorQuitacao = @nValorQuitacao * -1

											UPDATE	Processadora.dbo.Frete_Carta
											SET		IndStatus					= 'Q'
													,QuantidadeChegada			= @nQuantidadeChegada
													,DataQuitacao				= @dDataHora_Transacao
													,ValorCartaFreteCalculado	= @nValorCartaFreteCalculado
													,ValorPerdaDescontar		= @nValorPerdaDescontar
													,ValorQuitacao				= @nValorQuitacao
													,EstCodigoQuitacao			= @iCodigoEstabelecimento
													,OrigemQuitacao				= @cOrigemQuitacao
											WHERE	pddLncCodigo = @iNumeroCartaFrete

											SET @cBit038 = RIGHT(@cAutorizacao, 6)

											INSERT	INTO Processadora.dbo.Frete_Quitacao (
													FreteCarta
													,ValorQuitracao
													,QuantidadeChegada
													,DataQuitacao
													,ValorCartaFreteCalculado
													,ValorPerdaDescontar
													,OrigemQuitacao
													,Estabelecimento
													,MeioCaptura
													,CartaoUsuario
													,Entidade
													,TipoProduto
													,TipoTransacao
													,NSUMeioCaptura
													,Autorizacao
													,Data
													,[Status]
													,Operacao
													,Referencia
													,DataGMT
													,DataLocal 
													,HoraLocal
													,CodEstab
													,CodCliente
													,CartaoEmv
													,FallBack
													,ModoEntrada
													,RdeCodigo	
													,TipoMensagem
													)
											VALUES(	 @iNumeroCartaFrete
													,@nValorQuitacao
													,@nQuantidadeChegada
													,@dDataHora_Transacao
													,@nValorCartaFreteCalculado
													,@nValorPerdaDescontar
													,@cOrigemQuitacao
													,@iEstCodigo
													,@iMeiCptCodigo
													,@iCrtUsrCodigo
													,@iEntCodigo_PedidosLancamentos
													,@iTpoPrdCodigo
													,@iTpoTrnCodigo
													,@cBit011
													,@cBit038
													,GETDATE()
													,@cStatusTransacao
													,'Q'
													,NULL /* Referência */
													,@cBit007
													,@cBit013
													,@cBit012
													,@iCodigoEstabelecimento
													,@iEntCodigo
													,@bCartaoEmv
													,@bFallBack 
													,@cBit022
													,@iRedeNumero
													,'0200'
													)

											SET @iFrete_Quitacao_Codigo = SCOPE_IDENTITY()
											
											SET @cBit127 = dbo.f_ZerosEsquerda(@iFrete_Quitacao_Codigo,9)

											INSERT INTO Processadora.dbo.Frete_Quitacao_Lancamentos
											VALUES(	@iFrete_Quitacao_Codigo
													,@iCodigoLancamentosInternosEntidades
													,@iCodigoLancamentosInternos)
										END
									END
								END
								ELSE
									SET @iResposta = 311 /* SALDO TRANSPORTADORA INSULFICIENTE */
							END
							ELSE
								SET @iResposta = 310 /* QUANTIDADE CHEGADA INVALIDA */
						END
						ELSE IF(@cIndStatus_Frete_Carta = 'Q')
							SET @iResposta = 309 /* CARTA FRETE JA QUITADA */
						ELSE
							SET @iResposta = 308 /* CARTA FRETE CANCELADA */
					END
					ELSE
						SET @iResposta = 307 /* CARTA FRETE NAO VINCULADA AO TAC */
				END
				ELSE
					SET @iResposta = 360 /* QUITAÇÃO PERMITIDA SOMENTE NA TRANSPORTADORA */
			END
			ELSE
				SET @iResposta = 306 /* CARTA FRETE QUANTIDADE SAIDA INVALIDA */
		END
		ELSE
			SET @iResposta = 125 /* CARTA FRETE INEXISTENTE */
	END

	IF (@iResposta = 0 AND @cBit105 = '')
	BEGIN

		SET @cBit038 = RIGHT(@cAutorizacao, 6)

		INSERT INTO Processadora.dbo.Transacoes(
				EstCodigo
				,TpoTrnCodigo
				,CrtUsrCodigo
				,TpoPrdCodigo
				,PagamentoMinimo
				,MeiCptCodigo
				,RdeCodigo
				,Valor
				,Data
				,Parcelas
				,DataGMT
				,TaxaJuros
				,Status
				,DataAutorizacao
				,DataSolicitacao
				,Lote
				,Comprovante
				,Comprovante_FormGen
				,Autorizacao
				,NSUOrigem
				,Comissao
				,PrdCodigo
				,TipoMensagem
				,Terminal
				,DataLocal
				,HoraLocal
				,FlagTarifacao
				,VinculoTransacao
				,CodEstab
				,CodCliente
				,CartaoEmv
				,FallBack
				,ModoEntrada
				,Provedor
				,DataRepasse
				,EstabMigrado
				,SenhaCapturada
				)
		VALUES( @iEstCodigo
				,@iTpoTrnCodigo
				,@iCrtUsrCodigo
				,@iTpoPrdCodigo
				,@nPagamentoMinimo
				,@iMeiCptCodigo
				,@iRedeCodigo
				,@nValor_Transacao
				,@dDataHora_Transacao
				,@iQuantParcelas
				,@cBit007
				,0.0
				,@cStatusTransacao
				,@dDataHora_Transacao
				,@dDataHora_Transacao -- Parâmetro de entrada
				,CONVERT(INT,CONVERT(VARCHAR,GETDATE(),12)) -- Lote
				,@cBit038
				,@cBit038
				,@cAutorizacao  -- Utilizar Função gerada anteriormente
				,@cBit011 -- Parâmetro de entrada
				,CASE WHEN @iTpoTrnCodigo = 350000 THEN 0 ELSE @nTaxaAdministracao END -- Campo "TaxaAdministracao" obtido na consulta a entidade EstabelecimentosTiposProdutos
				,@iPrdCodigo
				,'0200'
				,@cBit041
				,@cBit013
				,@cBit012
				,0
				,0
				,@iCodigoEstabelecimento
				,@iEntCodigo
				,@bCartaoEmv
				,@bFallBack 
				,@cBit022
				,@cIdProvedor
				,@dDataRepasse
				,@bEstabMigrado
				,@bSenhaCapturada
				)

		SELECT @iTrnSysCodigo = SCOPE_IDENTITY()
		
		SET @cBit127 = @iTrnSysCodigo
		
		/* Tarifação dinâmica de transações */
		IF (@iTransacaoVinculada IS NOT NULL)
		BEGIN

			EXEC pr_AtualizarCreditoDisponivel
				 @iCrtUsrCodigo			-- Chave da tabela cartoesusuarios
				,@iCntUsrCodigo			-- Chave da tabela contasusuarios
				,@cTipoCartao			-- Chave da tabela tipoCartao
				,@nValorTaxacao			-- campo "ValorTaxacao" obtido na consulta a entidade TiposProdutosTiposTransacoes
				,@iQuantParcelas		-- Quantidade de parcelas a serem aplicadas
				,@iTpoPrdCodigo			-- Tipo Produto
				,@iTransacaoVinculada	-- Neste caso será enviado uma constante que identifica a taxação de transação
				,'D'					-- Variante entre débito e crédito, obtido como parâmetro de entrada, no bit003
				,@iLimiteExtraCartao	-- Flag que sinaliza liberação de crédito extra para cartão da transação, obtido na consulta a entidade cartoesusuarios
				,@iTrnSysCodigo			-- Codigo da tabela de transacoes 
				,@iTpoLncCodigoTarifa	-- Tipo de lancamento

		END

		IF (@iRedeNumero NOT IN (58, 10, 31))
		  SET @cBit037 = CONVERT(VARCHAR, @iTrnSysCodigo)
		
		INSERT INTO TransacoesRegistro(
				 TrnCodigo
				,StatusTef
				,NumeroEstabelecimento
				)
		VALUES	(@iTrnSysCodigo
				,@cStatusTransacao
				,@iCodigoEstabelecimento -- Campo "numero" obtido na consulta da entidade estabelecimentos
				)

		-- Caso o campo "ValorTaxacao" obtido na consulta a entidade TiposProdutosTiposTransacoes possua um valor maior que 0,
		-- deve-se inserir a transação relativa a traxação na tabela transacoes, como descrito abaixo:
		IF (@nValorTaxacao > 0 AND @iTransacaoVinculada IS NULL)
		BEGIN
	
			--A procedure pr_AtualizarCreditoDisponivel, deverá ser utilizada, de acordo com os parâmetros descritos abaixo:
			EXEC pr_AtualizarCreditoDisponivel
					@iCrtUsrCodigo			-- Chave da tabela cartoesusuarios
					,@iCntUsrCodigo			-- Chave da tabela contasusuarios
					,@cTipoCartao			-- Chave da tabela tipoCartao
					,@nValorTaxacao			-- campo "ValorTaxacao" obtido na consulta a entidade TiposProdutosTiposTransacoes
					,@iQuantParcelas		-- Quantidade de parcelas a serem aplicadas
					,@iTpoPrdCodigo			-- Tipo Produto
					,50000					-- Neste caso será enviado uma constante que identifica a taxação de transação
					,'D'					-- Variante entre débito e crédito, obtido como parâmetro de entrada, no bit003
					,@iLimiteExtraCartao	-- Flag que sinaliza liberação de crédito extra para cartão da transação, obtido na consulta a entidade cartoesusuarios
					,@iTrnSysCodigo			-- Codigo da tabela de transacoes 
					,@iTpoLncCodigo			-- Tipo de lancamento

		END

		--O crédito deverá ser atualizado para o valor da transação, utilizando a procedure pr_AtualizarCreditoDisponivel como descrito abaixo:      
		EXEC pr_AtualizarCreditoDisponivel
				 @iCrtUsrCodigo			-- Chave da tabela cartoesusuarios
				,@iCntUsrCodigo			-- Chave da tabela contasusuarios
				,@cTipoCartao			-- Chave da tabela tipoCartao
				,@nValor_Transacao		-- Valor da Transacao
				,@iQuantParcelas		-- Quantidade de parcelas a serem aplicadas
				,@iTpoPrdCodigo			-- Tipo Produto
				,@iTpoTrnCodigo			-- Será obtido através de uma consulta a entidade TiposProdutosTiposTransacoes, com o campo "TpoTrnCodigo"
				,@cTipoTransacaoInterno	-- Variante entre débito e crédito, obtido como parâmetro de entrada, no bit003
				,@iLimiteExtraCartao	-- Flag que sinaliza liberação de crédito extra para cartão da transação, obtido na consulta a entidade cartoesusuarios
				,@iTrnSysCodigo			-- Codigo da tabela de transacoes 
				,@iTpoLncCodigo			-- Tipo de lancamento
	END

	IF(@iResposta = 0 AND @iQuantParcelas > 1 AND @cBit105 = '')
	BEGIN
		EXEC pr_aut_GravaInfoAdicionais_VendaParcelada
				@cBit048 OUTPUT
				,1 -- @iTipoFinanciamento
				,0 -- @nValor_Tarifa
				,0 -- @nValor_Tributos
				,0 -- @nValor_Seguros
				,0 -- @nValor_Terceiros
				,0 -- @nValor_Registros
				,@nValor_Transacao -- @nValor_Emissor
				,@dDataPrimeiraParcela
				,@iQuantParcelas
				,0 -- @nJuros_Mensal
				,0 -- @nJuros_Anual
				,@nValorParcela
	END

	/***********************************************************************
	* Alterado por: Elmiro Leandro
	* Motivo: Todos os produtos da processadora quando transacionados na Cielo,
			  walk ou setis, devem retornar o saldo do produto pós transação.
	* Data: 05/03/2013
	* Chamado: 25903
	************************************************************************/
	SET @nCreditoDisponivelCartao = 0

	SELECT @nCreditoDisponivelCartao = COALESCE(CU.CreditoDisponivel, 0)
	FROM Processadora.dbo.CartoesUsuarios CU WITH(HOLDLOCK, ROWLOCK)
	WHERE CU.Numero = @cNumeroCartao 
	AND FlagTransferido = 0

	EXEC pr_aut_GravaInfoAdicionais_Saldo @cBit048 OUTPUT, @nCreditoDisponivelCartao
	
	/*********************************************************************
	* Alterado por: Elmiro Leandro
	* Motivo: Buscar o formato do ticket a ser utilizado para o retorno da mensagem
	* Data: 15/06/2010
	*********************************************************************/
	/* Transacoes via CRM e AVI deverao retornar o Nome Usuario e Saldo disponivel */
	IF (@iRedeNumero IN (16,17,19))
	BEGIN
		DECLARE @cSaldo VARCHAR(20)
		SET @cSaldo = COALESCE(CONVERT(VARCHAR, CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2),@nCreditoDisponivelCartao))), '')
		SET @cBit062 = @sNomeUsuario + '|' + @cSaldo
	END

	IF(@iResposta = 0 AND @iRedeNumero NOT IN (10,16,17,19,31))/*CIELO, CRM, SIGRA, CAE e STONE*/
	BEGIN
		
		SET @cBit039 = '00'
		
		EXEC [dbo].[pr_AUT_RetornarTicketTransacao]
			 '0200'
			,@cBit003
			,@cBit004			
			,0
			,@cBit011
			,@cBit038			
			,@cBit041			
			,@cBit062			OUTPUT
			,@iQuantParcelas			
			,@cBit127			
			,@sCNPJ_Estabelecimento				
			,@cNumeroCartao		
			,NULL
			,@sLabelProduto		
			,@sNomeUsuario		
			,@sNome_Estabelecimento		
			,@sEndereco_Estabelecimento			
			,@sCidade_Estabelecimento			
			,@sEstado_Estabelecimento			
			,0		
			,@nCreditoDisponivelCartao	
			,@iRedeNumero				
			,@iCodigoEstabelecimento	
			,0	
		
		IF (@iRedeNumero = 7 AND @cBit123 LIKE 'SCOPE%') /*Ticket impresso sem saldo disponivel do usuario*/
		BEGIN
			
			SET @cBit047 = CONVERT(VARCHAR(8000), @nCreditoDisponivelCartao)
			SET @cBit047 = dbo.FN_RemoveNonNumericCharacters(@cBit047)
			SET @cBit047 = '001012' + RIGHT(REPLICATE('0', 12) + @cBit047, 12)

		
			EXEC autorizacao..pr_aut_BuscaMensagemTicket @iTpoPrdCodigo, @iTpoTrnCodigo, @iRedeNumero, @cBit063 OUTPUT
			
			SET @cBit063 = REPLACE(@cBit063, '<NOME_USUARIO>', @sNomeUsuario)
			SET @cBit063 = REPLACE(@cBit063, 'SALDO DISPONIVEL:','')
			SET @cBit063 = REPLACE(@cBit063, '<SALDO_DISPONIVEL>','')
			SET @cBit063 = REPLACE(@cBit063, '<NUMERO_PARCELAS>', CONVERT(VARCHAR, @iQuantParcelas))
			SET @cBit063 = REPLACE(@cBit063, '<CARTAO>', SUBSTRING(@cNumeroCartao,1,6) + '******' + SUBSTRING(@cNumeroCartao,13,4))
			SET @cBit063 = REPLACE(@cBit063, '<CNPJ>', COALESCE(@sCNPJ_Estabelecimento,''))
			SET @cBit063 = REPLACE(@cBit063, '<NOME_ESTABELECIMENTO>', @sNome_Estabelecimento)
			SET @cBit063 = REPLACE(@cBit063, '<ENDERECO>', COALESCE(@sEndereco_Estabelecimento,''))
			SET @cBit063 = REPLACE(@cBit063, '<CIDADE>', COALESCE(@sCidade_Estabelecimento, ''))
			SET @cBit063 = REPLACE(@cBit063, '<ESTADO>', COALESCE(@sEstado_Estabelecimento,''))
			SET @cBit063 = REPLACE(@cBit063, '<NSU_HOST>', CASE WHEN @iRedeNumero IN (10,58) THEN @cBit038 ELSE @cBit127 END)
			SET @cBit063 = REPLACE(@cBit063, '<NSU_LOJA>', COALESCE(@cBit011,''))
			SET @cBit063 = REPLACE(@cBit063, '<CODIGO_ESTABELECIMENTO>',COALESCE(@iCodigoEstabelecimento,''))	-- CONVERT(VARCHAR,CONVERT(BIGINT, @cBit042)))
			SET @cBit063 = REPLACE(@cBit063, '<TERMINAL>', COALESCE(@cBit041, ''))
			SET @cBit063 = REPLACE(@cBit063, '<DATA>',dbo.f_ZerosEsquerda(CONVERT(VARCHAR,DAY(GETDATE())), 2) + '/' + dbo.f_ZerosEsquerda(CONVERT(VARCHAR,MONTH(GETDATE())), 2))
			SET @cBit063 = REPLACE(@cBit063, '<HORA>', SUBSTRING (CONVERT(VARCHAR, GETDATE(), 108 ),1,5))
			SET @cBit063 = REPLACE(@cBit063, '<VALOR>', COALESCE(CONVERT(VARCHAR, CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2),@nValor_Transacao))),''))
		
		END
		
		IF (@iTpoTrnCodigo = '400000') -- Quitação
		BEGIN

			DECLARE @dValor_Carta_Frete		DECIMAL(15,2)
					,@dPedagio				DECIMAL(15,2)
					,@Outros_Creditos		DECIMAL(15,2)
					,@Valor_Adiantamento	DECIMAL(15,2)
					,@cAuxOutrosDescontos	VARCHAR(20)
					,@Valor_Quebra			DECIMAL(15,2)
					,@Valor_Quitacao		DECIMAL(15,2)
					,@dOutros_Descontos		DECIMAL(15,2)

			SET @dValor_Carta_Frete		= @nValorCartaFreteCalculado
			SET	@dPedagio               = @nValorPedagio_Frete_Carta--CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2), REPLACE(SUBSTRING (@cCalculoQuitacao, 16,14),',',''))/100)
			SET	@Outros_Creditos		= @nValorOutrosCreditos_Frete_Carta--CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2), REPLACE(SUBSTRING (@cCalculoQuitacao, 31,15),',',''))/100)
			SET	@Valor_Adiantamento		= @nTotalAdiantamentos_Frete_Carta--CONVERT(DECIMAL(15,2), SUBSTRING (@cCalculoQuitacao,46,12))/100
			SET	@cAuxOutrosDescontos	= '0.00'--POS Não efetua descontos manuais na quitação
			SET @dOutros_Descontos		= @nValorOutrosDebitos_Frete_Carta--CONVERT(DECIMAL(15,2), @cAuxOutrosDescontos)--CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2), REPLACE(SUBSTRING (@cCalculoQuitacao,76,15),',',''))/100)
			SET	@Valor_Quebra			= CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2), REPLACE(SUBSTRING (@cCalculoQuitacao, 76,13),',',''))/100)
			SET	@Valor_Quitacao			= @nValorQuitacao --CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2), REPLACE(SUBSTRING(@cCalculoQuitacao, 91, 13),',',''))/100)
			
			SET @cBit062 = REPLACE(@cBit062, '<VALOR_CARTA_FRETE>', CONVERT(VARCHAR, @dValor_Carta_Frete))
			SET @cBit062 = REPLACE(@cBit062, '<PEDAGIO>', CONVERT(VARCHAR, @dPedagio))
			SET @cBit062 = REPLACE(@cBit062, '<OUTROS_CREDITOS>', CONVERT(VARCHAR, @Outros_Creditos))
			SET @cBit062 = REPLACE(@cBit062, '<VALOR_ADIANTAMENTO>', CONVERT(VARCHAR, @Valor_Adiantamento))
			SET @cBit062 = REPLACE(@cBit062, '<OUTROS_DESCONTOS>', CONVERT(VARCHAR, @dOutros_Descontos))
			SET @cBit062 = REPLACE(@cBit062, '<VALOR_QUEBRA>', @Valor_Quebra)
			SET @cBit062 = REPLACE(@cBit062, '<VALOR_QUITACAO>', CONVERT(VARCHAR, @Valor_Quitacao))
			SET @cBit062 = REPLACE(@cBit062, '<QTDE_CHEGADA>', CONVERT(VARCHAR, CONVERT(DECIMAL(15,2), @nQuantidadeChegada)))
			SET @cBit062 = REPLACE(@cBit062, '<CARTA_FRETE>', @iNumeroCartaFrete)

			SET @cBit105  = ''
		END
	END

	/* INÍCIO: Carga dados SMS */
	IF (@iResposta = 0 AND @iRedeNumero NOT IN (7,8,14,18,22,23,24,57)) /* 7 TEF Dedicado | 8 TEF Discado | 14 CB Itau | 18 TecBan | 57 POS Phoebus */
	BEGIN

		DECLARE @iFranquiaUsuario	INT
				,@dDataTransacao	DATETIME

		SELECT	@iFranquiaUsuario	= PAE.AgcCodigo
				,@dDataTransacao	= T.DataAutorizacao
		FROM Processadora.dbo.Transacoes T WITH(NOLOCK)
		INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = T.CrtUsrCodigo)
		INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
		INNER JOIN Processadora.dbo.Propostas P WITH(NOLOCK) ON (P.PrpCodigo = CO.PrpCodigo)
		INNER JOIN Processadora.dbo.ProdutosAgentesEmissores PAE WITH(NOLOCK) ON (PAE.EntCodigo = P.EntCodigo)
		WHERE T.TrnCodigo = @iTrnSysCodigo

		IF EXISTS (SELECT 1 FROM UsuarioPermiteSMS WITH(NOLOCK) WHERE CodCartao = @iCrtUsrCodigo AND Franquia = @iFranquiaUsuario AND Base = 'P')
		BEGIN
			EXEC pr_AUT_CargaInformacoesEnvioSMS
				@iCrtUsrCodigo
				,@iFranquiaUsuario
				,'P'
				,@cNumeroCartao
				,@nValor_Transacao
				,@nCreditoDisponivelCartao
				,@dDataTransacao
				,'0200'
				,@iQuantParcelas
				,@sNome_Estabelecimento
		END
	END
	/* FIM: Carga dados SMS */

	/* INICIO: Envia Email Gestao de Risco */
	IF (@iResposta = 0 AND (@nValor_Transacao >= 2000 OR @nCreditoDisponivelConta >= 50000 OR @nLimiteCreditoConta >= 50000))
		EXEC Processadora.dbo.pr_aut_EnviaEmail @cNumeroCartao, @nValor_Transacao, @nCreditoDisponivelConta, @nLimiteCreditoConta, @iCodigoEstabelecimento
	
	IF (@iRedeNumero NOT IN (58, 10, 31))
	BEGIN
		SET @cBit037 = ''
		SET @cBit048 = ''
	END
END
