/*
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_DesfazerProcessadora]
Propósito: Procedure responsável por desfazer transações eletrônicas.
Autor: Cristiano Silva Barbosa- Policard Systems
--------------------------------------------------------------------------
Data Criação: 19/02/2017
Mudança: 2601
--------------------------------------------------------------------------
Data Alteração: 06/06/2017
Chamado: 389762 / 2926 
Responsavel: Cristiano Barbosa- Policard Systems
--------------------------------------------------------------------------
Data Alteração: 26/04/2018
Chamados: 494467  / 3947
Responsavel: Cristiano Barbosa- Up Brasil
--------------------------------------------------------------------------
Data Alteração: 29/11/2018
Chamados: 581341/4666
Responsavel: João Henrique - Up Brasil
--------------------------------------------------------------------------
Data Alteração: 16/04/2019
Chamados: 
Responsavel: João Henrique - Up Brasil
Descrição: Transações com confirmação de duas vias não estavam sendo desfeitas devido a validação do status da transação.
--------------------------------------------------------------------------
Data Alteração: 18/02/2022
Chamados: 
Responsavel: João Henrique - Up Brasil
Descrição: Inclusao da rede 44 - CardSE
--------------------------------------------------------------------------
Data: 08/11/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1936216
Descrição: Corrige o fluxo de localização de transação original, desconsiderando a tabela TransacoesReferencias,
	que não é mais preenchida nesse modelo de processo.
--------------------------------------------------------------------------
Data: 2024-01-18
Autor: Adilson Pereira - Up Brasil
Chamado: 2096954 
Descrição: Ajuste na tratativa de transações da rede CardSE (44)
--------------------------------------------------------------------------
Data: 23/05/2024
Autor: Adilson Pereira - Up Brasil
Chamado: 2134047
Descrição: Corrige processo de desfazimento de estorno para atualizar a coluna estorno para N.
--------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[pr_aut_DesfazerProcessadora] (
	 @cNumeroCartao				CHAR(16)		OUTPUT	/* BIT02 M  */
	,@cBit003					CHAR(6)			OUTPUT	/* BIT03 ME */
	,@nValor_Transacao			DECIMAL(15,2)	OUTPUT	/* BIT04 ME */
	,@cBit007					CHAR(10)	
 	,@cBit011					CHAR(6)			OUTPUT	/* BIT11 ME */
	,@cBit012					CHAR(6)					/* BIT12 ME */
	,@cBit013					CHAR(4)					/* BIT13 ME */
	,@iRedeNumero				CHAR(3)					/* BIT32 ME */
	,@cBit038					CHAR(6)			OUTPUT	/* BIT38 E  */
	,@cBit041					CHAR(8)					/* BIT41 ME */
	,@iCodigoEstabelecimento	INT						/* BIT42 ME */
	,@bEstabMigrado				BIT
	,@cProvedor					VARCHAR(50)
	,@cBit090					CHAR(99)		OUTPUT	/* BIT90 ME */
	,@cBit105					VARCHAR(1000)	OUTPUT	/* BIT105   */
	,@iResposta					INT				OUTPUT
	,@dDataHora_Transacao		DATETIME
	,@cBit127					VARCHAR(12)		OUTPUT
)
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE 
		 @cCodigoAutorizacaoTransacaoOrig		CHAR(6)
		,@cCodigoMensagem          				CHAR(4)
		,@cNSUTransacaoOriginal    				CHAR(6)
		,@cHoraTrnOriginal         				CHAR(6)
		,@cDataTrnOriginal         				CHAR(4)
		,@iTrnCodigo_TransacoesOriginal			INT
		,@iEstCodigo_TransacoesOriginal			INT
		,@iCrtUsrCodigo_TransacoesOriginal		INT
		,@iTpoPrdCodigo_TransacoesOriginal		INT
		,@iMeiCptCodigo_TransacoesOriginal		INT
		,@iTpoTrnCodigo_TransacoesOriginal		INT
		,@iTrnCodigo_TransacoesEstornada		INT
		,@fValor_TransacoesOriginal				DECIMAL(15,2)
		,@iParcelas_TransacoesOriginal			SMALLINT
		,@cTipo_TiposTransacoesOriginal			CHAR(1)
		,@iVinculoTransacao						INT
		
	SET @iResposta = 0

	IF (LEN(@cBit090) = 26 AND @iRedeNumero NOT IN (13,22,23,24,25,29,31,32,33,34,35)) /* POS Setis, Masters e Sysdata */
	BEGIN
	
		SET @cCodigoMensagem					= SUBSTRING(@cBit090, 1, 4)
		SET @cCodigoAutorizacaoTransacaoOrig	= SUBSTRING(@cBit090, 5, 6)
		SET @cDataTrnOriginal					= SUBSTRING(@cBit090, 11, 4)
		SET @cHoraTrnOriginal					= SUBSTRING(@cBit090, 15, 6)
		SET @cNSUTransacaoOriginal				= SUBSTRING(@cBit090, 21, 6)
				
		SELECT	@iTrnCodigo_TransacoesOriginal		= T.TrnCodigo
				,@iEstCodigo_TransacoesOriginal		= T.EstCodigo
				,@iTpoTrnCodigo_TransacoesOriginal	= T.TpoTrnCodigo
				,@iCrtUsrCodigo_TransacoesOriginal	= T.CrtUsrCodigo
				,@iTpoPrdCodigo_TransacoesOriginal	= T.TpoPrdCodigo
				,@iMeiCptCodigo_TransacoesOriginal	= T.MeiCptCodigo
				,@fValor_TransacoesOriginal			= T.Valor
				,@iParcelas_TransacoesOriginal		= T.Parcelas
				,@iVinculoTransacao					= T.VinculoTransacao
				,@cTipo_TiposTransacoesOriginal		= TT.Tipo
		FROM	Processadora.dbo.Transacoes T WITH(NOLOCK)
		INNER JOIN TiposTransacoes TT WITH(NOLOCK) ON TT.CodTipoTransacao = T.TpoTrnCodigo
		WHERE T.NSUOrigem = CONVERT (VARCHAR,@cNSUTransacaoOriginal)
		AND T.DataLocal = @cDataTrnOriginal
		AND T.HoraLocal = @cHoraTrnOriginal
		AND T.Terminal  = @cBit041
		AND T.CodEstab  = @iCodigoEstabelecimento
		AND T.Status <> 'D' /* VALIDAÇÃO PARA LOCALIZAR SOMENTE QUE NAO FORAM DESFEITAS */
		AND T.Valor		= @nValor_Transacao
		AND CONVERT(VARCHAR(10), DataAutorizacao,120) = CONVERT (VARCHAR(10),GETDATE(),120) /*Desfazer Somente transacoes do dia*/
	END
	ELSE
	BEGIN

		IF (@cProvedor = 'SCOPEPRIVATE')
		BEGIN 

			SET @cCodigoMensagem		= SUBSTRING(@cBit090,1,4)
			SET @cNsuTransacaoOriginal	= SUBSTRING(@cBit090,5,6)
		
		END	
		ELSE IF (@iRedeNumero IN (29,31,44))
		BEGIN
		
			SET @cCodigoMensagem	   = SUBSTRING(@cBit090,1,4)
			SET @cNsuTransacaoOriginal = SUBSTRING(@cBit090,5,6)

		END
		ELSE
		BEGIN

			SET @cCodigoMensagem	   = SUBSTRING(@cBit090,1,4)
			SET @cNsuTransacaoOriginal = SUBSTRING(@cBit090,11,6)

		END
		
		IF (@iRedeNumero NOT IN (29, 31,44))
		BEGIN

			SELECT	
				 @iTrnCodigo_TransacoesOriginal		= T.TrnCodigo
				,@iEstCodigo_TransacoesOriginal		= T.EstCodigo
				,@iTpoTrnCodigo_TransacoesOriginal	= T.TpoTrnCodigo
				,@iCrtUsrCodigo_TransacoesOriginal	= T.CrtUsrCodigo
				,@iTpoPrdCodigo_TransacoesOriginal	= T.TpoPrdCodigo
				,@iMeiCptCodigo_TransacoesOriginal	= T.MeiCptCodigo
				,@fValor_TransacoesOriginal			= T.Valor
				,@iParcelas_TransacoesOriginal		= T.Parcelas
				,@cTipo_TiposTransacoesOriginal		= TT.Tipo
				,@iVinculoTransacao					= T.VinculoTransacao
			FROM Processadora.dbo.Transacoes T WITH(NOLOCK)
			INNER JOIN TiposTransacoes TT WITH(NOLOCK) ON TT.CodTipoTransacao = T.TpoTrnCodigo
			WHERE (T.TrnCodigo = @cBit127 OR T.NSUOrigem = CONVERT (VARCHAR,@cNSUTransacaoOriginal))
			AND T.Terminal = @cBit041
			AND T.CodEstab = @iCodigoEstabelecimento
			AND T.Status = 'P' /* VALIDAÇÃO PARA LOCALIZAR SOMENTE TRANSAÇÕES PENDENTES */
			AND T.Valor = @nValor_Transacao
			AND CONVERT(VARCHAR(10), DataAutorizacao,120) = CONVERT (VARCHAR(10),GETDATE(),120) /* DESFAZER SOMENTE TRANSACOES DO DIA */


		END
		ELSE
		BEGIN

			SELECT	
				 @iTrnCodigo_TransacoesOriginal		= T.TrnCodigo
				,@iEstCodigo_TransacoesOriginal		= T.EstCodigo
				,@iTpoTrnCodigo_TransacoesOriginal	= T.TpoTrnCodigo
				,@iCrtUsrCodigo_TransacoesOriginal	= T.CrtUsrCodigo
				,@iTpoPrdCodigo_TransacoesOriginal	= T.TpoPrdCodigo
				,@iMeiCptCodigo_TransacoesOriginal	= T.MeiCptCodigo
				,@fValor_TransacoesOriginal			= T.Valor
				,@iParcelas_TransacoesOriginal		= T.Parcelas
				,@cTipo_TiposTransacoesOriginal		= TT.Tipo
				,@iVinculoTransacao					= T.VinculoTransacao
			FROM Processadora.dbo.Transacoes T WITH(NOLOCK)
			INNER JOIN TiposTransacoes TT WITH(NOLOCK) ON TT.CodTipoTransacao = T.TpoTrnCodigo
			WHERE (T.TrnCodigo = @cBit127 OR T.NSUOrigem = CONVERT (VARCHAR,@cNSUTransacaoOriginal))
			AND T.Terminal = @cBit041
			AND T.CodEstab = @iCodigoEstabelecimento
			AND T.Status <> 'D' /* VALIDAÇÃO PARA LOCALIZAR TRANSACOES NAO DESFEITAS*/
			AND T.Valor = @nValor_Transacao
			AND CONVERT(VARCHAR(10), DataAutorizacao,120) = CONVERT (VARCHAR(10),GETDATE(),120) /* DESFAZER SOMENTE TRANSACOES DO DIA */
	   
		END

	END

	IF (@cBit105 <> '' /* Desfazimento de Quitação */)
	BEGIN
		
		IF (CONVERT(BIGINT,@cBit105) <> 0)
		BEGIN
		
			DECLARE @iFreteCarta_Frete_Quitacao		INT
					,@nValorQuitacao_Frete_Quitacao DECIMAL(15, 2)
					,@iEntCodigo_Frete_Quitacao		INT
					,@iEntCodigo					INT

			IF ((LTRIM(RTRIM(@cCodigoAutorizacaoTransacaoOrig)) = '' OR @cCodigoAutorizacaoTransacaoOrig = '000000') OR @cNSUTransacaoOriginal IS NOT NULL) /* Desfazimento sem o codigo autorização formgen */
			BEGIN
				SELECT	@iTrnCodigo_TransacoesOriginal		= Q.Codigo
						,@iFreteCarta_Frete_Quitacao		= Q.FreteCarta
						,@nValorQuitacao_Frete_Quitacao		= Q.ValorQuitracao
						,@iEstCodigo_TransacoesOriginal		= Q.Estabelecimento
						,@iMeiCptCodigo_TransacoesOriginal	= Q.MeioCaptura
						,@iCrtUsrCodigo_TransacoesOriginal	= Q.CartaoUsuario
						,@iEntCodigo_Frete_Quitacao			= Q.Entidade
						,@iTpoPrdCodigo_TransacoesOriginal	= Q.TipoProduto
						,@iTpoTrnCodigo_TransacoesOriginal	= Q.TipoTransacao
						,@iTrnCodigo_TransacoesEstornada	= Q.Referencia
						,@iEntCodigo						= Q.CodCliente
				FROM	Processadora.dbo.Frete_Quitacao Q WITH(NOLOCK)
				INNER JOIN Processadora.dbo.Frete_Carta C WITH(NOLOCK) ON (C.PddLncCodigo = Q.FreteCarta)
				WHERE	NSUMeioCaptura	= @cNSUTransacaoOriginal
				
			END
			ELSE
			BEGIN
				SELECT	@iTrnCodigo_TransacoesOriginal		= Q.Codigo
						,@iFreteCarta_Frete_Quitacao		= Q.FreteCarta
						,@nValorQuitacao_Frete_Quitacao		= Q.ValorQuitracao
						,@iEstCodigo_TransacoesOriginal		= Q.Estabelecimento
						,@iMeiCptCodigo_TransacoesOriginal	= Q.MeioCaptura
						,@iCrtUsrCodigo_TransacoesOriginal	= Q.CartaoUsuario
						,@iEntCodigo_Frete_Quitacao			= Q.Entidade
						,@iTpoPrdCodigo_TransacoesOriginal	= Q.TipoProduto
						,@iTrnCodigo_TransacoesEstornada	= Q.Referencia
						,@iEntCodigo						= Q.CodCliente
				FROM	Processadora.dbo.Frete_Quitacao Q WITH(NOLOCK)
				INNER JOIN Processadora.dbo.Frete_Carta C WITH(NOLOCK) ON (C.PddLncCodigo = Q.FreteCarta)
				WHERE	Q.Autorizacao = @cCodigoAutorizacaoTransacaoOrig
			END
		END
		ELSE
			SET @iResposta = 118

	END

		
	IF (@iResposta = 0)
	BEGIN

		IF (@iTrnCodigo_TransacoesOriginal IS NOT NULL)  /* Transacao nao encontrada */
		BEGIN

			IF(@cCodigoMensagem = '0400')
			BEGIN

				DECLARE @iMeiCptCodigo_TransacoesEstornada	INT
						,@dData_TransacoesEstornada			DATETIME
						,@cTipo_TiposTransacoesEstornada	CHAR(1)


				IF (@cBit105 <> '')
				BEGIN
					DECLARE @fQuantidadeChegadaEstornada_Frete_Quitacao			DECIMAL(15,3)
							,@fValorCartaFreteCalculadoEstornada_Frete_Quitacao	DECIMAL(15,2)
							,@fValorPerdaDescontarEstornada_Frete_Quitacao		DECIMAL(15,3)
							,@cOrigemQuitacaoEstornada_Frete_Quitacao			VARCHAR(30)
							--,@iReferenciaOriginal								INT
							

					SELECT	@iMeiCptCodigo_TransacoesEstornada					= Q.MeioCaptura
							,@fQuantidadeChegadaEstornada_Frete_Quitacao		= Q.QuantidadeChegada
							,@dData_TransacoesEstornada							= Q.DataQuitacao
							,@fValorCartaFreteCalculadoEstornada_Frete_Quitacao	= Q.ValorCartaFreteCalculado
							,@fValorPerdaDescontarEstornada_Frete_Quitacao		= Q.ValorPerdaDescontar
							,@cOrigemQuitacaoEstornada_Frete_Quitacao			= Q.OrigemQuitacao
							--,@iReferenciaOriginal								= Q.Referencia
					FROM	Processadora.dbo.Frete_Quitacao Q WITH(NOLOCK)
							INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON C.CrtUsrCodigo = Q.CartaoUsuario
					WHERE	Q.Codigo = @iTrnCodigo_TransacoesEstornada	OR Q.NSUMeioCaptura = @cNSUTransacaoOriginal
					
										
				END
				ELSE
				BEGIN
					SELECT @iTrnCodigo_TransacoesEstornada = t2.TrnCodigo
						,@iMeiCptCodigo_TransacoesEstornada = t2.MeiCptCodigo
						,@dData_TransacoesEstornada = t2.Data
						,@cTipo_TiposTransacoesEstornada = CASE 
							WHEN tt.Tipo = 'D'
								THEN 'C'
							WHEN tt.Tipo IN (
									'C'
									,'P'
									)
								THEN 'D'
							END
					FROM Processadora.dbo.transacoes t WITH (NOLOCK)
						,Processadora.dbo.TiposTransacoes tt WITH (NOLOCK)
						,Processadora.dbo.transacoes t2 WITH (NOLOCK)
					WHERE t.TrnCodigo = @iTrnCodigo_TransacoesOriginal
						AND t.Status = 'P'
						AND t.TrnReferencia = t2.TrnCodigo
						AND t2.TpoTrnCodigo = tt.TpoTrnCodigo
						AND tt.Tipo IN (
							'D'
							,'C'
							,'P'
							);				
				END
			END

			DECLARE  @iNumero_EstabelecimentosTransacaoOriginal		INT
					,@cNome_EstabelecimentosTransacaoOriginal		VARCHAR(50)

			
			IF (@bEstabMigrado = 0)
				SELECT	
						 @iNumero_EstabelecimentosTransacaoOriginal		= Numero
						,@cNome_EstabelecimentosTransacaoOriginal		= Nome
				FROM	Processadora.dbo.Estabelecimentos WITH(NOLOCK)
				WHERE	Numero = @iCodigoEstabelecimento
			ELSE 
				SELECT	
						 @iNumero_EstabelecimentosTransacaoOriginal		= CodigoEstabelecimento
						,@cNome_EstabelecimentosTransacaoOriginal		= Nome
				FROM	Acquirer.dbo.Estabelecimento WITH(NOLOCK)
				WHERE	CodigoEstabelecimento = @iCodigoEstabelecimento

			IF (@iNumero_EstabelecimentosTransacaoOriginal IS NOT NULL)
			BEGIN
				DECLARE @iCrtUsrCodigo_CartoesUsuariosOriginal		INT
						,@iCntUsrCodigo_CartoesUsuariosOriginal		INT
						,@cTipo_CartoesUsuariosOriginal				CHAR(1)

				SELECT	@iCrtUsrCodigo_CartoesUsuariosOriginal		= CrtUsrCodigo
						,@iCntUsrCodigo_CartoesUsuariosOriginal		= CntUsrCodigo
						,@cTipo_CartoesUsuariosOriginal				= Tipo
				FROM	Processadora.dbo.CartoesUsuarios WITH(NOLOCK)
				WHERE	CrtUsrCodigo = @iCrtUsrCodigo_TransacoesOriginal
				
				
				IF(@iCrtUsrCodigo_CartoesUsuariosOriginal IS NOT NULL)
				BEGIN
					DECLARE @iCntUsrCodigo_ContasUsuariosOriginal INT

					SELECT	@iCntUsrCodigo_ContasUsuariosOriginal = CntUsrCodigo
					FROM	Processadora.dbo.ContasUsuarios WITH(NOLOCK)
					WHERE	CntUsrCodigo = @iCntUsrCodigo_CartoesUsuariosOriginal

					IF (@iCntUsrCodigo_ContasUsuariosOriginal IS NOT NULL)
					BEGIN

						SET @cBit038 = @cBit012

						IF (@cBit105 <> '')
						BEGIN
							
							DECLARE @iCodigoLancamentosInternosEntidades	INT
									,@iCodigoLancamentosInternos			INT
									,@nValorEstornoQuitacao					DECIMAL(15,2)
									,@cOrigemQuitacao						CHAR(3)
													
							SET @cOrigemQuitacao = CASE WHEN @iRedeNumero IN (7,8) THEN 'TEF' ELSE 'POS' END
							SET @nValorEstornoQuitacao = @nValorQuitacao_Frete_Quitacao * -1

							IF (@cCodigoMensagem = '0200') /* Desfazimento de quitacao */
							BEGIN
														
								EXEC Processadora.dbo.[pr_FRT_QuitacaoDebitoContaTransportadoraFormGen]
									494
									,@iTpoPrdCodigo_TransacoesOriginal
									,@iEntCodigo_Frete_Quitacao
									,6
									,@nValorEstornoQuitacao
									,@iNumero_EstabelecimentosTransacaoOriginal
									,@dDataHora_Transacao
									,@dDataHora_Transacao
									,@iFreteCarta_Frete_Quitacao
									,@iCodigoLancamentosInternosEntidades	OUTPUT
									,@iResposta								OUTPUT

								IF (@iResposta = 0)
								BEGIN
									EXEC Processadora.dbo.[pr_FRT_QuitacaoCreditoCartaoFormGen]      
										502
										,@nValorEstornoQuitacao
										,@iNumero_EstabelecimentosTransacaoOriginal
										,@dDataHora_Transacao
										,@iFreteCarta_Frete_Quitacao
										,@cNumeroCartao
										,@cTipo_CartoesUsuariosOriginal
										,@iCodigoLancamentosInternos	OUTPUT
										,@iResposta						OUTPUT
								END

								IF (@iResposta = 0)
								BEGIN
									EXEC pr_AtualizarCreditoDisponivel        
										@iCrtUsrCodigo_CartoesUsuariosOriginal
										,@iCntUsrCodigo_CartoesUsuariosOriginal
										,@cTipo_CartoesUsuariosOriginal
										,@nValorQuitacao_Frete_Quitacao
										,1 /* Quantidade de parcelas */     
										,@iTpoPrdCodigo_TransacoesOriginal
										,@iTpoTrnCodigo_TransacoesOriginal
										,'D'
										,NULL

									DECLARE @iFrete_Quitacao_Codigo INT

									UPDATE	Processadora.dbo.Frete_Carta
									SET		IndStatus					= 'L'
											,QuantidadeChegada			= NULL
											,DataQuitacao				= NULL
											,ValorCartaFreteCalculado	= NULL
											,ValorPerdaDescontar		= NULL
											,ValorQuitacao				= NULL
											,EstCodigoQuitacao			= NULL
											,OrigemQuitacao				= NULL
									WHERE	PddLncCodigo = @iFreteCarta_Frete_Quitacao

									INSERT INTO Processadora.dbo.Frete_Quitacao(
											 FreteCarta
											,ValorQuitracao
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
											,Status
											,Operacao
											,Referencia
											,DataGMT
											,DataLocal 
											,HoraLocal
											,CodEstab
											,CodCliente
											,RdeCodigo
											,TipoMensagem
											)
									VALUES (@iFreteCarta_Frete_Quitacao
											,@nValorQuitacao_Frete_Quitacao
											,@cOrigemQuitacao
											,@iEstCodigo_TransacoesOriginal
											,@iMeiCptCodigo_TransacoesOriginal
											,@iCrtUsrCodigo_CartoesUsuariosOriginal
											,@iEntCodigo_Frete_Quitacao
											,@iTpoPrdCodigo_TransacoesOriginal
											,@iTpoTrnCodigo_TransacoesOriginal
											,@cBit011
											,@cBit038
											,GETDATE()
											,'A'
											,'D'
											,@iTrnCodigo_TransacoesOriginal /* Referência */
											,@cBit007
											,@cBit013
											,@cBit012
											,@iCodigoEstabelecimento
											,@iEntCodigo
											,@iRedeNumero
											,'0420'
											)

									SET @iFrete_Quitacao_Codigo = SCOPE_IDENTITY()

									INSERT INTO Processadora.dbo.Frete_Quitacao_Lancamentos
										VALUES (@iFrete_Quitacao_Codigo
												,@iCodigoLancamentosInternosEntidades
												,@iCodigoLancamentosInternos)

									UPDATE Processadora.dbo.Frete_Quitacao SET Status = 'D' WHERE Codigo = @iTrnCodigo_TransacoesOriginal
								END
							END
							ELSE /* Desfazimento de estorno de quitacao */
							BEGIN
							
								EXEC Processadora.dbo.[pr_FRT_QuitacaoDebitoContaTransportadoraFormGen]
									494
									,@iTpoPrdCodigo_TransacoesOriginal
									,@iEntCodigo_Frete_Quitacao
									,6
									,@nValorQuitacao_Frete_Quitacao
									,@iNumero_EstabelecimentosTransacaoOriginal
									,@dDataHora_Transacao
									,@dDataHora_Transacao
									,@iFreteCarta_Frete_Quitacao
									,@iCodigoLancamentosInternosEntidades	OUTPUT
									,@iResposta								OUTPUT

								IF (@iResposta = 0)
								BEGIN
									EXEC Processadora.dbo.[pr_FRT_QuitacaoCreditoCartaoFormGen]      
										502
										,@nValorQuitacao_Frete_Quitacao
										,@iNumero_EstabelecimentosTransacaoOriginal
										,@dDataHora_Transacao
										,@iFreteCarta_Frete_Quitacao
										,@cNumeroCartao
										,@cTipo_CartoesUsuariosOriginal
										,@iCodigoLancamentosInternos	OUTPUT
										,@iResposta						OUTPUT
								END

								IF (@iResposta = 0)
								BEGIN
									EXEC pr_AtualizarCreditoDisponivel
										@iCrtUsrCodigo_CartoesUsuariosOriginal
										,@iCntUsrCodigo_CartoesUsuariosOriginal
										,@cTipo_CartoesUsuariosOriginal
										,@nValorQuitacao_Frete_Quitacao
										,1 /* Quantidade de parcelas */
										,@iTpoPrdCodigo_TransacoesOriginal
										,@iTpoTrnCodigo_TransacoesOriginal
										,'C'
										,NULL

									UPDATE	Processadora.dbo.Frete_Carta
									SET		IndStatus					= 'Q'
											,QuantidadeChegada			= @fQuantidadeChegadaEstornada_Frete_Quitacao
											,DataQuitacao				= @dData_TransacoesEstornada
											,ValorCartaFreteCalculado	= @fValorCartaFreteCalculadoEstornada_Frete_Quitacao
											,ValorPerdaDescontar		= @fValorPerdaDescontarEstornada_Frete_Quitacao
											,ValorQuitacao				= @nValorQuitacao_Frete_Quitacao
											,EstCodigoQuitacao			= @iEstCodigo_TransacoesOriginal
											,OrigemQuitacao				= @cOrigemQuitacaoEstornada_Frete_Quitacao
									WHERE	pddLncCodigo				= @iFreteCarta_Frete_Quitacao

									INSERT INTO Processadora.dbo.Frete_Quitacao(
											FreteCarta
											,ValorQuitracao
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
											,Status
											,Operacao
											,Referencia
											,DataGMT
											,DataLocal 
											,HoraLocal
											,CodEstab
											,CodCliente
											,RdeCodigo
											,TipoMensagem
											)
									VALUES (@iFreteCarta_Frete_Quitacao
											,@nValorQuitacao_Frete_Quitacao
											,@cOrigemQuitacao
											,@iEstCodigo_TransacoesOriginal
											,@iMeiCptCodigo_TransacoesOriginal
											,@iCrtUsrCodigo_CartoesUsuariosOriginal
											,@iEntCodigo_Frete_Quitacao
											,@iTpoPrdCodigo_TransacoesOriginal
											,@iTpoTrnCodigo_TransacoesOriginal
											,@cBit011
											,@cBit038
											,GETDATE()
											,'A'
											,'D'
											,@iTrnCodigo_TransacoesOriginal /* Referência */
											,@cBit007
											,@cBit013
											,@cBit012
											,@iCodigoEstabelecimento
											,@iEntCodigo
											,@iRedeNumero
											,'0420'
											)

									SET @iFrete_Quitacao_Codigo = SCOPE_IDENTITY()

									INSERT INTO Processadora.dbo.Frete_Quitacao_Lancamentos
										VALUES (@iFrete_Quitacao_Codigo
												,@iCodigoLancamentosInternosEntidades
												,@iCodigoLancamentosInternos)
												
									UPDATE Processadora.dbo.Frete_Quitacao SET Status = 'D' WHERE Codigo = @iTrnCodigo_TransacoesOriginal
									UPDATE Processadora.dbo.Frete_Quitacao SET Status = 'P' WHERE Codigo = @iTrnCodigo_TransacoesEstornada

								END
							END
						END
						ELSE
						BEGIN
							/* Desfazimento Venda ou Estorno */
							DECLARE @fValorTemp		DECIMAL(15,2)
									,@fValorTarifa	DECIMAL(15,2)
									,@cTipoTemp		CHAR(1)
									

							IF (@iTpoPrdCodigo_TransacoesOriginal = 59 AND @iTpoTrnCodigo_TransacoesOriginal = '350000')
							BEGIN

								SELECT @fValorTarifa = ISNULL(TPTT.Tarifa,0)
								FROM Processadora.dbo.TiposProdutosTiposTransacoes TPTT WITH(NOLOCK)
								WHERE TPTT.TpoPrdCodigo = @iTpoPrdCodigo_TransacoesOriginal
								AND TPTT.TpoTrnCodigo = @iTpoTrnCodigo_TransacoesOriginal

								SET @fValor_TransacoesOriginal = @fValor_TransacoesOriginal + @fValorTarifa
																
							END					
							

							IF (@iParcelas_TransacoesOriginal > 1)
								SET @fValorTemp = dbo.f_pmt(0, @iParcelas_TransacoesOriginal, @fValor_TransacoesOriginal, 0, 0)
							ELSE
								SET @fValorTemp = @fValor_TransacoesOriginal

							UPDATE	Processadora.dbo.Transacoes
							SET		Status	= 'D'
									,Data	= GETDATE()
							WHERE	TrnCodigo = @iTrnCodigo_TransacoesOriginal
							
							/*DESFAZENDO A TRANSACAO VINCULADA*/
							UPDATE Processadora.dbo.Transacoes
							SET Status = 'D'
							,Data = GETDATE()
							WHERE TrnCodigo = @iVinculoTransacao

							UPDATE	TransacoesRegistro
							SET		StatusTef = 'D'
							WHERE	Trncodigo = @iTrnCodigo_TransacoesOriginal


							IF (@cCodigoMensagem = '0400')
							BEGIN
								
								UPDATE	Processadora.dbo.Transacoes
								SET		Status	= 'A'
										, Estorno = 'N'
										,Data	= GETDATE()
								WHERE	TrnCodigo = @iTrnCodigo_TransacoesEstornada
								
								SET @cTipoTemp = 'C'
								
							END
							ELSE
								SET @cTipoTemp = @cTipo_TiposTransacoesOriginal

							
							IF (@cTipoTemp IN ('C','P'))
							BEGIN
								
								EXEC pr_AtualizarCreditoDisponivel
									 @iCrtUsrCodigo_TransacoesOriginal
									,@iCntUsrCodigo_ContasUsuariosOriginal
									,@cTipo_CartoesUsuariosOriginal
									,@fValorTemp
									,@iParcelas_TransacoesOriginal
									,@iTpoPrdCodigo_TransacoesOriginal
									,@iTpoTrnCodigo_TransacoesOriginal
									,'D'
									,NULL
									,@iTrnCodigo_TransacoesOriginal
									,847
								
							END
							ELSE IF(@cTipoTemp = 'D')
							BEGIN
	
								EXEC pr_AtualizarCreditoDisponivel 
									 @iCrtUsrCodigo_TransacoesOriginal
									,@iCntUsrCodigo_ContasUsuariosOriginal
									,@cTipo_CartoesUsuariosOriginal
									,@fValorTemp
									,@iParcelas_TransacoesOriginal
									,@iTpoPrdCodigo_TransacoesOriginal
									,@iTpoTrnCodigo_TransacoesOriginal
									,'C'
									,NULL
									,@iTrnCodigo_TransacoesOriginal
									,857
										
							END
						END
					END
					ELSE
						SET @iResposta = 272 /* CONTA INEXISTENTE */
				END
				ELSE
					SET @iResposta = 12 /* CARTAO INVALIDO OU INEXISTENTE */
			END
			ELSE
				SET @iResposta = 116 /* ESTABELECIMENTO INVALIDO OU INEXISTENTE */
		END
		ELSE
			SET @iResposta = 270 /* TRANSACAO ORIGINAL NAO ENCONTRADA - NAO AUTORIZADA */
	END

	/* INÍCIO: Carga dados SMS */
	IF (@iResposta = 0)
	BEGIN

		DECLARE @iCrtUsrCodigo		INT
				,@iFranquiaUsuario	INT
				,@dDataTransacao	DATETIME
				,@dSaldo			DECIMAL(15,2)
				,@cBaseOrigem		CHAR(1)

		SET @cBaseOrigem = 'P'

		SELECT	@iCrtUsrCodigo		= T.CrtUsrCodigo
				,@iFranquiaUsuario	= PAE.AgcCodigo
				,@dDataTransacao	= T.DataAutorizacao
				,@dSaldo			= C.CreditoDisponivel
		FROM	Processadora.dbo.Transacoes T WITH(NOLOCK)
		INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = T.CrtUsrCodigo)
		INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
		INNER JOIN Processadora.dbo.Propostas P WITH(NOLOCK) ON (P.PrpCodigo = CO.PrpCodigo)
		INNER JOIN Processadora.dbo.ProdutosAgentesEmissores PAE WITH(NOLOCK) ON (PAE.EntCodigo = P.EntCodigo)
		WHERE	T.TrnCodigo = CONVERT(INT,@cBit127)

		IF EXISTS (SELECT 1 FROM UsuarioPermiteSMS WITH(NOLOCK) WHERE CodCartao = @iCrtUsrCodigo AND Franquia = @iFranquiaUsuario AND Base = @cBaseOrigem)
		BEGIN
			EXEC pr_AUT_CargaInformacoesEnvioSMS
				@iCrtUsrCodigo
				,@iFranquiaUsuario
				,@cBaseOrigem
				,@cNumeroCartao
				,@nValor_Transacao
				,@dSaldo
				,@dDataTransacao
				,'0420'
				,NULL
				,@cNome_EstabelecimentosTransacaoOriginal
		END
	END
	/* FIM: Carga dados SMS */
END

