/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_AUT_CancelaSaqueBco24Horas]
Propósito: Procedure responsável por cancelar saque.
Autor: Cristiano Silva Barbosa- Policard Systems
--------------------------------------------------------------------------
Data criação: 23/07/2015
Mudança: 988
Autor: Cristiano Barbosa
--------------------------------------------------------------------------
Data criação: 19/02/2017
Mudança: 2601

*/

CREATE PROCEDURE [pr_AUT_CancelaSaqueBco24Horas] (
	 @iTrnCodigoSaque			INT
	,@cNumeroCartao				CHAR(16)
	,@dValorSaque				DECIMAL(15,2)
	,@dDataHora_Transacao		DATETIME
	,@iCodigoEstabelecimento	INT
	,@cTerminal					CHAR(8)
	,@iResposta					INT		OUTPUT
	)

AS
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE 
		 @iTrnCodigo_Transacoes			INT
		,@iTpoPrdCodigo_Transacoes		INT
		,@iEstCodigo_Transacoes			INT
		,@iMeiCptCodigo_Transacoes		INT
		,@iCrtUsrCodigo_Transacoes		INT
		,@cDataGMT						VARCHAR(10)
		,@cDataLocal					CHAR(4)
		,@cHoraLocal					CHAR(6)
		,@cNSUTransacaoOriginal    		CHAR(6)
		,@cStatusTransacaoInserida		CHAR
		,@iVinculoTransacao				INT
		,@dValorTarifa					DECIMAL(15,2)
		,@iTpoTrnCodigo_Transacoes		INT
		,@iRdeCodigo_Transacoes			INT
		,@iParcelas_Transacoes			SMALLINT
		,@nTaxaJuros_Transacoes			DECIMAL(6,2)
		,@iLote_Transacoes				INT
		,@nComissao_Transacoes			DECIMAL(5,2)
		,@iPrdCodigo_Transacoes			INT
		,@nValorEstornar_Transacoes		DECIMAL(15,2)
		,@cTipo_TiposTransacoes			CHAR(1)
		,@iCodCliente					INT
		,@bCartaoEmv					BIT
		,@bFallBack						BIT
		,@cProvedor						VARCHAR(40)
		,@cModoEntrada					CHAR(3)
		,@iTpoPrdCodigo					INT
		,@iCntUsrCodigo					INT
		,@cTipo							CHAR(1)
	
	SET @iResposta = 0					

	SELECT	 @iTrnCodigo_Transacoes			= T.TrnCodigo
			,@iEstCodigo_Transacoes			= T.EstCodigo
			,@iTpoTrnCodigo_Transacoes		= T.TpoTrnCodigo
			,@iCrtUsrCodigo_Transacoes		= T.CrtUsrCodigo
			,@iTpoPrdCodigo_Transacoes		= T.TpoPrdCodigo
			,@iMeiCptCodigo_Transacoes		= T.MeiCptCodigo
			,@iRdeCodigo_Transacoes			= T.RdeCodigo
			,@iParcelas_Transacoes			= T.Parcelas
			,@nTaxaJuros_Transacoes			= T.TaxaJuros
			,@iLote_Transacoes				= T.Lote
			,@nComissao_Transacoes			= T.Comissao
			,@iPrdCodigo_Transacoes			= T.PrdCodigo
			,@cTipo_TiposTransacoes			= TT.Tipo
			,@nValorEstornar_Transacoes		= CASE WHEN T.TpoTrnCodigo = 320000 THEN T.Valor /*dbo.fn_PMT(0, (transacoes.parcelas), -(transacoes.valor))*/
											  ELSE T.Valor END
			,@cStatusTransacaoInserida		= 'A'
			,@iVinculoTransacao				= T.VinculoTransacao
			,@bCartaoEmv					= T.CartaoEmv
			,@bFallBack						= T.FallBack
			,@iCodCliente					= T.CodCliente
			,@cProvedor						= T.Provedor
			,@cModoEntrada					= T.ModoEntrada
			,@cDataGMT						= T.DataGMT
			,@cDataLocal					= T.DataLocal
			,@cHoraLocal					= T.HoraLocal
			,@cNSUTransacaoOriginal			= T.NSUOrigem
			,@iTpoPrdCodigo					= C.TpoPrdCodigo
			,@cTipo							= C.Tipo
			,@iCntUsrCodigo					= C.CntUsrCodigo
	FROM Processadora.dbo.Transacoes T WITH(NOLOCK)
	INNER JOIN TiposTransacoes TT WITH(NOLOCK) ON (TT.CodTipoTransacao = T.TpoTrnCodigo)
	INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(HOLDLOCK, ROWLOCK) ON (C.CrtUsrCodigo = T.CrtUsrCodigo)
	WHERE T.TrnCodigo = @iTrnCodigoSaque
		AND T.Valor = @dValorSaque
		AND C.Numero = @cNumeroCartao
		AND T.Status IN ('A','P','E')
		AND TT.Tipo IN ('D','C','P')

	IF (@iVinculoTransacao <> 1)
		SELECT @dValorTarifa = Valor FROM Processadora.dbo.transacoes WITH(NOLOCK) WHERE TrnCodigo = @iVinculoTransacao
	ELSE
		SELECT @dValorTarifa = 0

	IF (@iTrnCodigo_Transacoes IS NOT NULL)
	BEGIN
	
		DECLARE	@iTpoPrdCodigo_TiposProdutosTiposTransacoes		INT
				,@nValorTaxacao_TiposProdutosTiposTransacoes	DECIMAL(15,2)

		SELECT	@iTpoPrdCodigo_TiposProdutosTiposTransacoes	= CodTipoProduto
				,@nValorTaxacao_TiposProdutosTiposTransacoes = CASE WHEN(ValorTaxacao IS NOT NULL AND ValorRefTaxacao IS NOT NULL AND @dValorSaque < ValorRefTaxacao) THEN ValorTaxacao
																	ELSE 0 END
		FROM TiposProdutosTiposTransacoes WITH(NOLOCK)
		WHERE CodTipoProduto = @iTpoPrdCodigo_Transacoes
		  AND TipoTransacao = 'ES'

		IF (@iTpoPrdCodigo_TiposProdutosTiposTransacoes IS NOT NULL)
		BEGIN

			DECLARE @cAutorizacao CHAR(18)

			SET @cAutorizacao = [dbo].[f_GerarAutorizacao]()
					
			/* Estorno da tarifação aplicada a transação */
			IF (@iVinculoTransacao IS NOT NULL AND @dValorTarifa IS NOT NULL)
			BEGIN

				UPDATE	Processadora.dbo.Transacoes
				SET		Status = 'E'
				WHERE	TrnCodigo = @iVinculoTransacao

				EXEC pr_AtualizarCreditoDisponivel
					@iCrtUsrCodigo_Transacoes
					,@iCntUsrCodigo
					,@cTipo
					,@dValorTarifa
					,@iParcelas_Transacoes
					,@iTpoPrdCodigo
					,@iTpoTrnCodigo_Transacoes
					,'C'
					,NULL

			END

			DECLARE	@iTrnCodigo_TransacoesReferencias INT

			SELECT	@iTrnCodigo_TransacoesReferencias = TrnCodigo
			FROM	TransacoesReferencias WITH(NOLOCK)
			WHERE	TipoReferencia = 'T'
				AND trncodigo = @iTrnCodigo_Transacoes

			UPDATE	Processadora.dbo.Transacoes
			SET		Status = 'E'
			WHERE	TrnCodigo = @iTrnCodigo_Transacoes

			DECLARE	@nCreditoParcelamento	DECIMAL(15,2)
					,@nCreditoDisponivel	DECIMAL(15,2)

			IF(@cTipo_TiposTransacoes IN ('C', 'P'))
			BEGIN  

				EXEC pr_AtualizarCreditoDisponivel
					@iCrtUsrCodigo_Transacoes
					,@iCntUsrCodigo
					,@cTipo
					,@nValorEstornar_Transacoes
					,@iParcelas_Transacoes
					,@iTpoPrdCodigo
					,@iTpoTrnCodigo_Transacoes
					,'D'
					,NULL

			END
			ELSE
			BEGIN

				IF (@cTipo_TiposTransacoes IN ('D'))
				BEGIN

					EXEC pr_AtualizarCreditoDisponivel
						@iCrtUsrCodigo_Transacoes
						,@iCntUsrCodigo
						,@cTipo
						,@nValorEstornar_Transacoes
						,@iParcelas_Transacoes
						,@iTpoPrdCodigo
						,@iTpoTrnCodigo_Transacoes
						,'C'
						,NULL

				END
			END

			DECLARE @iScope_IdentityTransacoes1	INT

			INSERT Processadora.dbo.Transacoes(
					EstCodigo
					,TpoTrnCodigo
					,CrtUsrCodigo
					,TpoPrdCodigo
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
					,Autorizacao
					,NsuOrigem
					,Comissao
					,PrdCodigo
					,TipoMensagem
					,Terminal
					,Comprovante_FormGen
					,DataLocal
					,HoraLocal
					,FlagTarifacao
					,CodEstab
					,CodCliente
					,CartaoEmv
					,FallBack
					,Provedor
					,ModoEntrada
					)
			VALUES (@iEstCodigo_Transacoes
					,'210000'
					,@iCrtUsrCodigo_Transacoes
					,@iTpoPrdCodigo_Transacoes
					,@iMeiCptCodigo_Transacoes
					,@iRdeCodigo_Transacoes
					,@nValorEstornar_Transacoes
					,GETDATE()
					,@iParcelas_Transacoes
					,@cDataGMT
					,@nTaxaJuros_Transacoes
					,@cStatusTransacaoInserida
					,@dDataHora_Transacao
					,@dDataHora_Transacao
					,@iLote_Transacoes
					,RIGHT(@cAutorizacao,6)
					,@cAutorizacao
					,@cNSUTransacaoOriginal
					,@nComissao_Transacoes
					,@iPrdCodigo_Transacoes
					,'0400'
					,@cTerminal
					,RIGHT (@cAutorizacao,6)
					,@cDataLocal
					,@cHoraLocal
					,0 -- Indica que não houve tarifacao
					,@iCodigoEstabelecimento
					,@iCodCliente
					,@bCartaoEmv
					,@bFallBack	
					,@cProvedor
					,@cModoEntrada
					) 

			SELECT @iScope_IdentityTransacoes1 = SCOPE_IDENTITY()

			/* Estorno da tarifação aplicada a transação */
			IF (@iVinculoTransacao IS NOT NULL AND @dValorTarifa IS NOT NULL)
			BEGIN

				DECLARE @iScope_IdentityTransacoesTarifa INT

				INSERT Processadora.dbo.Transacoes(
						EstCodigo
						,TpoTrnCodigo
						,CrtUsrCodigo
						,TpoPrdCodigo
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
						,Autorizacao
						,NsuOrigem
						,Comissao
						,PrdCodigo
						,TipoMensagem
						,Terminal
						,Comprovante_FormGen
						,DataLocal
						,HoraLocal
						,VinculoTransacao
						,FlagTarifacao
						,CodEstab
						,CodCliente
						,CartaoEmv
						,FallBack
						,Provedor
						,ModoEntrada
						)
				VALUES (@iEstCodigo_Transacoes
						,'210000'
						,@iCrtUsrCodigo_Transacoes
						,@iTpoPrdCodigo_Transacoes
						,@iMeiCptCodigo_Transacoes
						,@iRdeCodigo_Transacoes
						,@dValorTarifa
						,GETDATE()
						,@iParcelas_Transacoes
						,@cDataGMT
						,@nTaxaJuros_Transacoes
						,@cStatusTransacaoInserida
						,@dDataHora_Transacao
						,@dDataHora_Transacao
						,@iLote_Transacoes
						,RIGHT(@cAutorizacao,6)
						,@cAutorizacao
						,@cNSUTransacaoOriginal
						,@nComissao_Transacoes
						,@iPrdCodigo_Transacoes
						,'0400'
						,@cTerminal
						,NULL
						,@cDataLocal
						,@cHoraLocal
						,@iScope_IdentityTransacoes1
						,1-- Flag indica tarifação
						,@iCodigoEstabelecimento
						,@iCodCliente
						,@bCartaoEmv
						,@bFallBack
						,@cProvedor
						,@cModoEntrada
						)

				SELECT	@iScope_IdentityTransacoesTarifa = SCOPE_IDENTITY()

				UPDATE	Processadora.dbo.Transacoes
				SET		VinculoTransacao = @iScope_IdentityTransacoesTarifa
				WHERE	Trncodigo = @iScope_IdentityTransacoes1
			END
					
			IF (@nValorTaxacao_TiposProdutosTiposTransacoes > 0)
			BEGIN

				DECLARE	@iScope_IdentityTransacoes2	INT

				INSERT Processadora.dbo.Transacaoes(
						EstCodigo
						,TpoTrnCodigo
						,CrtUsrCodigo
						,TpoPrdCodigo
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
						,Autorizacao
						,NsuOrigem
						,Comissao
						,PrdCodigo
						,TipoMensagem
						,Terminal
						,Comprovante_FormGen
						,DataLocal
						,HoraLocal)
				VALUES (@iEstCodigo_Transacoes
						,'5000'
						,@iCrtUsrCodigo_Transacoes
						,@iTpoPrdCodigo_Transacoes
						,@iMeiCptCodigo_Transacoes
						,@iRdeCodigo_Transacoes
						,@nValorEstornar_Transacoes
						,GETDATE()
						,1
						,@cDataGMT
						,0
						,@cStatusTransacaoInserida
						,@dDataHora_Transacao
						,@dDataHora_Transacao
						,@iLote_Transacoes
						,RIGHT(@cAutorizacao,6)
						,@iScope_IdentityTransacoes1 /* 0000000 */
						,@cNSUTransacaoOriginal
						,@nComissao_Transacoes
						,@iPrdCodigo_Transacoes
						,'0400'
						,@cTerminal
						,NULL
						,@cDataLocal
						,@cHoraLocal)

				SELECT @iScope_IdentityTransacoes2 = SCOPE_IDENTITY()

				INSERT TransacoesReferencias(
						TrnCodigo
						,TipoReferencia
						,CodigoTrnOriginal)
				VALUES (@iScope_IdentityTransacoes2
						,'T'
						,@iScope_IdentityTransacoes1)

				EXEC pr_AtualizarCreditoDisponivel
					@iCrtUsrCodigo_Transacoes
					,@iCntUsrCodigo
					,@cTipo
					,@nValorEstornar_Transacoes
					,0
					,@iTpoPrdCodigo
					,5000
					,'D'
					,NULL
			END

			INSERT TransacoesReferencias(
					TrnCodigo
					,TipoReferencia
					,CodigoTrnOriginal)
			VALUES (@iScope_IdentityTransacoes1
					,'E'
					,@iTrnCodigo_Transacoes)

			IF (@iTrnCodigo_TransacoesReferencias IS NOT NULL)
			BEGIN

				DECLARE	@iScope_IdentityTransacoes3	INT

				INSERT Processadora.dbo.Transacoes(
						EstCodigo
						,TpoTrnCodigo
						,CrtUsrCodigo
						,TpoPrdCodigo
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
						,Autorizacao
						,NsuOrigem
						,Comissao
						,PrdCodigo
						,TipoMensagem
						,Terminal
						,Comprovante_FormGen
						,DataLocal
						,HoraLocal)
				VALUES (@iEstCodigo_Transacoes
						,'210000'
						,@iCrtUsrCodigo_Transacoes
						,@iTpoPrdCodigo_Transacoes
						,@iMeiCptCodigo_Transacoes
						,@iRdeCodigo_Transacoes
						,@nValorEstornar_Transacoes
						,GETDATE()
						,1
						,@cDataGMT
						,0
						,@cStatusTransacaoInserida
						,@dDataHora_Transacao
						,@dDataHora_Transacao
						,@iLote_Transacoes
						,RIGHT(@cAutorizacao,6)
						,@iScope_IdentityTransacoes1
						,@cNSUTransacaoOriginal
						,@nComissao_Transacoes
						,@iPrdCodigo_Transacoes
						,'0400'
						,@cTerminal
						,NULL
						,@cDataLocal
						,@cHoraLocal)

				SELECT @iScope_IdentityTransacoes3 = SCOPE_IDENTITY()

				INSERT transacoesreferencias(
						TrnCodigo
						,TipoReferencia
						,CodigoTrnOriginal)
				VALUES (@iScope_IdentityTransacoes3
						,'E'
						,@iTrnCodigo_Transacoes)

				UPDATE	Processadora.dbo.Transacoes
				SET		Status = 'E'
				WHERE	TrnCodigo = @iTrnCodigo_Transacoes

				EXEC pr_atualizarcreditodisponivel
					@iCrtUsrCodigo_Transacoes
					,@iCntUsrCodigo
					,@cTipo
					,@nValorTaxacao_TiposProdutosTiposTransacoes
					,0
					,@iTpoPrdCodigo
					,210000
					,'C'
					,NULL
			END

			DELETE	TransacoesReferencias
			WHERE	TrnCodigo =	@iTrnCodigo_Transacoes
					AND TipoReferencia = 'T'
		END
	END	
	
--	/* INÍCIO: Carga dados SMS */
--	IF (@iRedeNumero NOT IN (7,8,14,18,57)) /* 7 TEF Dedicado | 8 TEF Discado | 14 CB Itau | 18 TecBan | 57 POS Phoebus */
--	BEGIN
--		DECLARE @iCrtUsrCodigo		INT
--				,@iFranquiaUsuario	INT
--				,@dDataTransacao	DATETIME
--				,@cBaseOrigem		CHAR(1)
--
--		SET @cBaseOrigem = 'P'
--
--		SELECT	@iCrtUsrCodigo		= T.CrtUsrCodigo
--				,@iFranquiaUsuario	= PAE.AgcCodigo
--				,@dDataTransacao	= T.DataAutorizacao
--		FROM	Transacoes T WITH(NOLOCK)
--				INNER JOIN CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = T.CrtUsrCodigo)
--				INNER JOIN Processadora..ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
--				INNER JOIN Processadora..Propostas P WITH(NOLOCK) ON (P.PrpCodigo = CO.PrpCodigo)
--				INNER JOIN Processadora..ProdutosAgentesEmissores PAE WITH(NOLOCK) ON (PAE.EntCodigo = P.EntCodigo)
--		WHERE	T.TrnCodigo = @iScope_IdentityTransacoes1
--
--		IF EXISTS (SELECT 1 FROM UsuarioPermiteSMS WITH(NOLOCK) WHERE CodCartao = @iCrtUsrCodigo AND Franquia = @iFranquiaUsuario AND Base = @cBaseOrigem)
--		BEGIN
--			EXEC pr_AUT_CargaInformacoesEnvioSMS
--				@iCrtUsrCodigo
--				,@iFranquiaUsuario
--				,@cBaseOrigem
--				,@cNumeroCartao
--				,@nValor_Transacao
--				,@nCreditoDisponivelRetorno
--				,@dDataTransacao
--				,'0400'
--				,NULL
--				,@sNome_Estabelecimento
--		END
--	END
END
