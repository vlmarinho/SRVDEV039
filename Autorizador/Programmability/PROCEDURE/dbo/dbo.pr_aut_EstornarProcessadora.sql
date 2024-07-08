/* ..
--------------------------------------------------------------------------
Nome Sistema: Autorização
Objeto: [dbo].[pr_aut_EstornarProcessadora]
Propósito: Procedure responsável por cancelar transações da processadora.
Autor: Cristiano Silva Barbosa- Policard Systems
--------------------------------------------------------------------------
Data Criação: 19/02/2017
Mudança: 2601
--------------------------------------------------------------------------
Data Alteração: 06/06/2017
Chamado: 389762
Responsavel: Cristiano Barbosa- Policard Systems
--------------------------------------------------------------------------
Data Alteração: 28/09/2017
Chamados: 399954  / 3262
Responsavel: Cristiano Barbosa- Policard Systems
--------------------------------------------------------------------------
Data Alteração: 26/04/2018
Chamados: 494467  / 3947
Responsavel: Cristiano Barbosa- Up Brasil
--------------------------------------------------------------------------
Data Alteração: 29/11/2018
Chamados: 581341/4666
Responsavel: João Henrique- Up Brasil
--------------------------------------------------------------------------
Data: 08/09/2022
Autor: Adilson Pereira - Up Brasil
Chamado: 1907778
Descrição: Projeto ABECS para transações SoftwareExpress/FiServ.
-------------------------------------------------------------------------- 	
Data: 14/03/2023
Autor: Adilson Pereira - Up Brasil
Chamado: 1986162
Descrição: Projeto cashback - Integração plataforma Parantez.
-------------------------------------------------------------------------- 
*/

CREATE PROCEDURE [dbo].[pr_aut_EstornarProcessadora](
	 @cBit003					CHAR(6)			OUTPUT	/* BIT03  ME */
	,@cBit004					VARCHAR(12)
	,@cBit007					CHAR(10)				/* BIT07  ME */
	,@cBit011					CHAR(6)			OUTPUT	/* BIT11  ME */
	,@cBit012					CHAR(6)					/* BIT12  ME */
	,@cBit013					CHAR(4)					/* BIT13  ME */
	,@cBit037					VARCHAR(12)		OUTPUT	/* BIT37  ME */
	,@cBit038					CHAR(6)			OUTPUT	/* BIT38  E	 */
	,@cBit039					CHAR(2)			OUTPUT	/* BIT39  E	 */
	,@cBit041					CHAR(8)					/* BIT41  ME */
	,@cBit048					VARCHAR(1000)	OUTPUT	/* BIT48	 */
	,@cBit060					VARCHAR(5)				/* BIT60  M	 */
	,@cBit062					VARCHAR(1000)	OUTPUT	/* BIT062 TICKET*/
	,@cBit063					VARCHAR(1000)	OUTPUT	/* BIT063 TICKET*/
	,@cBit090					VARCHAR(99)		OUTPUT	/* BIT90  ME */
	,@cBit105					VARCHAR(1000)	OUTPUT	/* BIT105 	 */
	,@cBit123					VARCHAR(16)
	,@cBit127					VARCHAR(9)		OUTPUT	/* BIT127 	 */
	,@cNumeroCartao				CHAR(16)		OUTPUT	/* BIT02  M	 */
	,@nValor_Transacao			DECIMAL(15,2)	OUTPUT	/* BIT04  ME */
	,@dDataHora_Transacao		DATETIME
	,@iRedeNumero				INT						/* BIT24 OU BIT32  ME */
	,@iCodigoEstabelecimento	INT						/* BIT42  ME */
	,@bEstabMigrado				BIT
	,@iResposta					INT				OUTPUT
	)

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE 
		 @cCodigoAutorizacaoBIT90			CHAR(6)
		,@iTrnCodigo_Transacoes				INT
		,@iTpoPrdCodigo_Transacoes			INT
		,@iEstCodigo_Transacoes				INT
		,@iCodEstabelecimento_Transacoes	INT
		,@iMeiCptCodigo_Transacoes			INT
		,@iCrtUsrCodigo_Transacoes			INT
		,@cNSUTransacaoOriginal    			CHAR(6)
		,@cStatusTransacaoInserida			CHAR
		,@iVinculoTransacao					INT
		,@dValorTarifa						DECIMAL(15,2)
		,@cStatus_Transacao					CHAR(1)
		,@nPagamentoMinimo					DECIMAL(6,2)
		,@cAutorizacao						CHAR(18)
		,@returnCode				INT
		, @returnMessage 			VARCHAR(4000);

	SET @iResposta = 0
	SET @cAutorizacao = [dbo].[f_GerarAutorizacao]()
	SET @cBit038 = RIGHT(@cAutorizacao, 6)
	
	/*POS PHOEBUS NAO ENVIA AS INFORMACOES DA TRANSACAO ORIGINAL NO BIT090*/
	IF (@iRedeNumero = 57)
	BEGIN
		SELECT	@cNSUTransacaoOriginal = NSUOrigem
		FROM	Processadora.dbo.Transacoes WITH (NOLOCK)
		WHERE	TrnCodigo = @cBit037
	END

	IF (@cBit105 <> '') /* Estorno de Quitação */
	BEGIN
		
		IF LEN(@cBit090) = 26 AND (@iRedeNumero NOT IN (13,16,17,32,33,34,35)) /* POS Setis/CRM e AVI será tratado de forma semelhante a TEF */
			SET @cNSUTransacaoOriginal = SUBSTRING(@cBit090, 21,6)
		ELSE
			SET @cNSUTransacaoOriginal = SUBSTRING(@cBit090, 11,6)
		
		
		DECLARE @iFreteCarta_Frete_Quitacao		INT
				,@nValorQuitacao_Frete_Quitacao	DECIMAL(15,2)
				,@iEntCodigo_Frete_Quitacao		INT
				,@iEntCodigo					INT

		SELECT	@iTrnCodigo_Transacoes			= Q.Codigo
				,@iFreteCarta_Frete_Quitacao	= Q.FreteCarta
				,@nValorQuitacao_Frete_Quitacao = Q.ValorQuitracao
				,@iEstCodigo_Transacoes			= Q.Estabelecimento
				,@iMeiCptCodigo_Transacoes		= Q.MeioCaptura
				,@iCrtUsrCodigo_Transacoes		= Q.CartaoUsuario
				,@iEntCodigo_Frete_Quitacao		= Q.Entidade
				,@iTpoPrdCodigo_Transacoes		= Q.TipoProduto
				,@cStatusTransacaoInserida		= 'P'
				,@cStatus_Transacao				= Q.Status
				,@iEntCodigo					= Q.CodCliente
				,@iCodEstabelecimento_Transacoes= Q.CodEstab
		FROM Processadora.dbo.Frete_Quitacao Q WITH(NOLOCK)
		INNER JOIN Processadora.dbo.Frete_Carta C WITH(NOLOCK) ON (C.PddLncCodigo = Q.FreteCarta)
		INNER JOIN Processadora.dbo.CartoesUsuarios CUS WITH(NOLOCK) ON (CUS.CrtUsrCodigo = Q.CartaoUsuario)
		WHERE (Q.Codigo = CONVERT (INT,@cBit127) OR Q.NSUMeioCaptura = @cNSUTransacaoOriginal)
		AND CUS.Numero = @cNumeroCartao
		AND Q.Operacao = 'Q'
					
	END
	ELSE
	BEGIN

		DECLARE @iTpoTrnCodigo_Transacoes		INT
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
				,@cStatusTransacaoInserida		= 'P'
				,@iVinculoTransacao				= T.VinculoTransacao
				,@cStatus_Transacao				= T.Status
				,@bCartaoEmv					= T.CartaoEmv
				,@bFallBack						= T.FallBack
				,@iCodCliente					= T.CodCliente
				,@cProvedor						= T.Provedor
				,@cModoEntrada					= T.ModoEntrada
				,@nPagamentoMinimo				= T.PagamentoMinimo
				,@iCodEstabelecimento_Transacoes = T.CodEstab
		FROM Processadora.dbo.Transacoes T WITH(NOLOCK)
		INNER JOIN dbo.TiposTransacoes TT WITH(NOLOCK) ON (TT.CodTipoTransacao = T.TpoTrnCodigo)
		INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = T.CrtUsrCodigo)
		WHERE t.TrnCodigo = CONVERT(INT, @cBit127)
		AND T.Valor = @nValor_Transacao
		AND C.Numero = @cNumeroCartao
		AND T.Status IN ('A','P','E')
		AND TT.Tipo IN ('D','C','P')

	END
	
	IF (@iTrnCodigo_Transacoes IS NOT NULL) /* TRANSACAO ORIGINAL NAO ENCONTRADA - NAO AUTORIZADA */
	BEGIN

		IF (@cStatus_Transacao <> 'E')/*TRANSACAO JA CANCELADA*/
		BEGIN
					
			DECLARE @iCrtUsrCodigo_CartoesUsuarios			INT
					,@iTpoPrdCodigo_CartoesUsuarios			INT
					,@iCntUsrCodigo_CartoesUsuarios			INT
					,@nCreditoDisponivel_CartoesUsuarios	DECIMAL(15,2)
					,@cTipo_CartoesUsuarios					CHAR(1)
					,@cNome_CartoesUsuarios					VARCHAR(30)
					,@iTpoLncCodigo							INT

			SET @iTpoLncCodigo = 734

			IF (@iVinculoTransacao <> 1)
				SELECT @dValorTarifa = Valor FROM Processadora.dbo.Transacoes WITH(NOLOCK) WHERE TrnCodigo = @iVinculoTransacao
			ELSE
				SELECT @dValorTarifa = 0


			SELECT	@iCrtUsrCodigo_CartoesUsuarios			= C.CrtUsrCodigo
					,@iTpoPrdCodigo_CartoesUsuarios			= C.TpoPrdCodigo
					,@cTipo_CartoesUsuarios					= C.Tipo
					,@iCntUsrCodigo_CartoesUsuarios			= C.CntUsrCodigo
					,@nCreditoDisponivel_CartoesUsuarios	= C.CreditoDisponivel
					,@cNome_CartoesUsuarios					= C.Nome
			FROM	Processadora.dbo.CartoesUsuarios C /* INI SA: 474430 */ WITH(HOLDLOCK, ROWLOCK) /* FIM SA: 474430 */
			WHERE	C.Numero = @cNumeroCartao /* Cartão da transação de estorno */
			AND FlagTransferido = 0

			IF (@iCrtUsrCodigo_CartoesUsuarios IS NOT NULL) /* CARTAO INEXISTENTE */
			BEGIN

				IF(@iCrtUsrCodigo_CartoesUsuarios = @iCrtUsrCodigo_Transacoes) /* CARTAO ESTORNO DIFERENTE */
				BEGIN

					DECLARE  @iCntUsrCodigo_ContasUsuarios			INT
							,@nCreditoDisponivel_ContasUsuarios		DECIMAL(15,2)

					SELECT	@iCntUsrCodigo_ContasUsuarios			= CntUsrCodigo
							,@nCreditoDisponivel_ContasUsuarios		= CreditoDisponivel
					FROM	Processadora.dbo.ContasUsuarios WITH(HOLDLOCK, ROWLOCK)
					WHERE	CntUsrCodigo = @iCntUsrCodigo_CartoesUsuarios

					IF (@iCntUsrCodigo_ContasUsuarios IS NOT NULL)
					BEGIN

						DECLARE 
							 @iNumero_Estabelecimento			INT
							,@sCNPJ_Estabelecimento				VARCHAR(18)
							,@sNome_Estabelecimento				VARCHAR(40)
							,@sEndereco_Estabelecimento			VARCHAR(40)
							,@sCidade_Estabelecimento			VARCHAR(40)
							,@sEstado_Estabelecimento			CHAR(2)
						
						IF (@bEstabMigrado = 0)
						BEGIN

							SELECT	 @iNumero_Estabelecimento		= Numero
									,@sCNPJ_Estabelecimento			= CNPJ
									,@sNome_Estabelecimento			= RTRIM(LTRIM(Nome))
									,@sEndereco_Estabelecimento		= RTRIM(LTRIM(Endereco))
									,@sCidade_Estabelecimento		= RTRIM(LTRIM(Cidade))
									,@sEstado_Estabelecimento		= Estado
							FROM	Processadora.dbo.Estabelecimentos WITH(NOLOCK)
							WHERE	Numero = @iCodigoEstabelecimento /* Estabelecimento da transação de estorno */
						
						END
						ELSE 
						BEGIN
							
							SELECT 
								 @sCNPJ_Estabelecimento		= dbo.f_FormatarCNPJ_CPF(E.Cnpj)
								,@sNome_Estabelecimento		= LTRIM(RTRIM(E.Nome))
								,@sEndereco_Estabelecimento	= LTRIM(RTRIM(EE.Logradouro))
								,@sCidade_Estabelecimento	= LTRIM(RTRIM(EE.Cidade))
								,@sEstado_Estabelecimento	= EE.UF
							FROM Acquirer.dbo.Estabelecimento E WITH (NOLOCK)
							INNER JOIN Acquirer.dbo.EstabelecimentoEndereco EE WITH (NOLOCK) ON E.CodigoEstabelecimento = EE.CodigoEstabelecimento
							WHERE E.CodigoEstabelecimento = @iCodigoEstabelecimento
							AND EE.CodigoTipoEndereco = 1

						END 

						IF (@iCodigoEstabelecimento IS NOT NULL)
						BEGIN

							IF(@iCodigoEstabelecimento = @iCodEstabelecimento_Transacoes) /* ESTABELECIMENTO ESTORNO DIFERENTE */
							BEGIN

								DECLARE	
									 @iTpoPrdCodigo_TiposProdutosTiposTransacoes	INT
									,@iTpoTrnCodigo_TiposProdutosTiposTransacoes	INT
									,@nValorTaxacao_TiposProdutosTiposTransacoes	DECIMAL(15,2)

								SELECT @iTpoPrdCodigo_TiposProdutosTiposTransacoes	= CodTipoProduto
									  ,@iTpoTrnCodigo_TiposProdutosTiposTransacoes	= CodTipoTransacao
									  ,@nValorTaxacao_TiposProdutosTiposTransacoes	= CASE WHEN(ValorTaxacao IS NOT NULL AND ValorRefTaxacao IS NOT NULL AND @nValor_Transacao < ValorRefTaxacao) THEN ValorTaxacao
																							  ELSE 0 END
								FROM TiposProdutosTiposTransacoes WITH(NOLOCK)
								WHERE CodTipoProduto = @iTpoPrdCodigo_Transacoes
								AND TipoTransacao = 'ES'


								IF (@iTpoPrdCodigo_TiposProdutosTiposTransacoes IS NOT NULL)
								BEGIN

									IF (@cBit105 <> '') /* Estorno de Quitacao */
									BEGIN
																				
										IF(@nCreditoDisponivel_ContasUsuarios >= @nValorQuitacao_Frete_Quitacao AND @nCreditoDisponivel_CartoesUsuarios >= @nValorQuitacao_Frete_Quitacao)
										BEGIN

											DECLARE	
												@iCodigoLancamentosInternosEntidades	INT
												,@iCodigoLancamentosInternos			INT
												,@nValorEstornoQuitacao					DECIMAL(15,2)
												,@cOrigemQuitacao						CHAR(3)
													
											SET @cOrigemQuitacao = CASE WHEN @iRedeNumero IN (7,8) THEN 'TEF' ELSE 'POS' END

											SET @nValorEstornoQuitacao = @nValorQuitacao_Frete_Quitacao * -1

											EXEC Processadora..[pr_FRT_QuitacaoDebitoContaTransportadoraFormGen]
												 494
												,@iTpoPrdCodigo_Transacoes
												,@iEntCodigo_Frete_Quitacao
												,6
												,@nValorEstornoQuitacao
												,@iNumero_Estabelecimento
												,@dDataHora_Transacao
												,@dDataHora_Transacao
												,@iFreteCarta_Frete_Quitacao
												,@iCodigoLancamentosInternosEntidades	OUTPUT
												,@iResposta								OUTPUT

											IF (@iResposta = 0)
											BEGIN
												EXEC Processadora..[pr_FRT_QuitacaoCreditoCartaoFormGen]
													512 /* Lancamento de Estorno de Quitacao */
													,@nValorQuitacao_Frete_Quitacao
													,@iNumero_Estabelecimento
													,@dDataHora_Transacao
													,@iFreteCarta_Frete_Quitacao
													,@cNumeroCartao
													,@cTipo_CartoesUsuarios
													,@iCodigoLancamentosInternos	OUTPUT
													,@iResposta						OUTPUT
											END

											IF (@iResposta = 0)
											BEGIN

												EXEC pr_AtualizarCreditoDisponivel        
													 @iCrtUsrCodigo_CartoesUsuarios
													,@iCntUsrCodigo_CartoesUsuarios
													,@cTipo_CartoesUsuarios
													,@nValorQuitacao_Frete_Quitacao
													,1 /* Quantidade de parcelas */
													,@iTpoPrdCodigo_Transacoes
													,@iTpoTrnCodigo_TiposProdutosTiposTransacoes
													,'D'
													,NULL
													,@iTrnCodigo_Transacoes
													,@iTpoLncCodigo
					

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
												WHERE	PddLncCodigo				= @iFreteCarta_Frete_Quitacao

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
														,@iEstCodigo_Transacoes
														,@iMeiCptCodigo_Transacoes
														,@iCrtUsrCodigo_CartoesUsuarios
														,@iEntCodigo_Frete_Quitacao
														,@iTpoPrdCodigo_Transacoes
														,@iTpoTrnCodigo_TiposProdutosTiposTransacoes
														,@cBit011
														,@cBit038
														,GETDATE()
														,@cStatusTransacaoInserida
														,'E'
														,@iTrnCodigo_Transacoes
														,@cBit007
														,@cBit013
														,@cBit012
														,@iCodigoEstabelecimento
														,@iEntCodigo
														,@iRedeNumero
														,'0400'
														)

												SET @iFrete_Quitacao_Codigo = SCOPE_IDENTITY()
												
												SET @cBit127 = dbo.f_ZerosEsquerda(@iFrete_Quitacao_Codigo,9)

												INSERT INTO Processadora.dbo.Frete_Quitacao_Lancamentos
												VALUES (@iFrete_Quitacao_Codigo
														,@iCodigoLancamentosInternosEntidades
														,@iCodigoLancamentosInternos)

												UPDATE Processadora.dbo.Frete_Quitacao 
												SET Status = 'E' 
												WHERE Codigo = @iTrnCodigo_Transacoes

											END
										END
										ELSE
											SET @iResposta = 343 /* SALDO CONTA/CARTAO MENOR QUE VALOR QUITACAO */
									END
									ELSE /* Estorno de Venda */
									BEGIN

										DECLARE	@fCreditoParcelamento				DECIMAL(15,2)
												,@fCreditoDisponivel				DECIMAL(15,2)
												,@iScope_IdentityTransacoes			INT
												,@nCreditoParcelamento				DECIMAL(15,2)
												,@nCreditoDisponivel				DECIMAL(15,2)


										IF(@cTipo_TiposTransacoes IN ('C', 'P'))
										BEGIN  

											EXEC pr_AtualizarCreditoDisponivel
												@iCrtUsrCodigo_Transacoes
												,@iCntUsrCodigo_CartoesUsuarios
												,@cTipo_CartoesUsuarios
												,@nValorEstornar_Transacoes
												,@iParcelas_Transacoes
												,@iTpoPrdCodigo_CartoesUsuarios
												,@iTpoTrnCodigo_Transacoes
												,'D'
												,NULL
												,@iTrnCodigo_Transacoes
												,@iTpoLncCodigo
					

										END
										ELSE IF (@cTipo_TiposTransacoes ='D')
										BEGIN

											EXEC pr_AtualizarCreditoDisponivel
												@iCrtUsrCodigo_Transacoes
												,@iCntUsrCodigo_CartoesUsuarios
												,@cTipo_CartoesUsuarios
												,@nValorEstornar_Transacoes
												,@iParcelas_Transacoes
												,@iTpoPrdCodigo_CartoesUsuarios
												,@iTpoTrnCodigo_Transacoes
												,'C'
												,NULL
												,@iTrnCodigo_Transacoes
												,@iTpoLncCodigo
					
										END

										INSERT INTO Processadora.dbo.Transacoes(
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
												,PagamentoMinimo
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
												,EstabMigrado
												,TrnReferencia
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
												,@cBit007
												,@nTaxaJuros_Transacoes
												,@cStatusTransacaoInserida
												,@dDataHora_Transacao
												,@dDataHora_Transacao
												,@iLote_Transacoes
												,@cBit038
												,@cAutorizacao
												,@cBit011
												,@nComissao_Transacoes
												,@iPrdCodigo_Transacoes
												,'0400'
												,@cBit041
												,@nPagamentoMinimo
												,@cBit038
												,@cBit013
												,@cBit012
												,0 -- Indica que não houve tarifacao
												,@iCodigoEstabelecimento
												,@iCodCliente
												,@bCartaoEmv
												,@bFallBack	
												,@cProvedor
												,@cModoEntrada
												,@bEstabMigrado
												,@iTrnCodigo_Transacoes
												) 

										SELECT @iScope_IdentityTransacoes = SCOPE_IDENTITY()

										UPDATE	Processadora.dbo.Transacoes
										SET		Status = 'E'
												,Estorno = 'S'
												,TrnReferencia = @iScope_IdentityTransacoes
										WHERE	TrnCodigo = @iTrnCodigo_Transacoes

										--Altera transação Parantez para estornar o cashback gerado, se houver
										EXEC Autorizador.dbo.PR_Aut_ParantezTransaction @iCodigoEstabelecimento
											,@iTrnCodigo_Transacoes
											,'P'
											,@cNumeroCartao
											,1
											,@returnCode OUTPUT
											,@returnMessage OUTPUT;
										
										
										SET @cBit127 = @iScope_IdentityTransacoes
										
										/* Estorno da tarifação aplicada a transação */
										IF (@iVinculoTransacao IS NOT NULL AND @dValorTarifa IS NOT NULL)
										BEGIN

											UPDATE	Processadora.dbo.transacoes
											SET	Status = 'E'
												,Estorno = 'S'
											WHERE TrnCodigo = @iVinculoTransacao

											EXEC pr_AtualizarCreditoDisponivel
												@iCrtUsrCodigo_Transacoes
												,@iCntUsrCodigo_CartoesUsuarios
												,@cTipo_CartoesUsuarios
												,@dValorTarifa
												,@iParcelas_Transacoes
												,@iTpoPrdCodigo_CartoesUsuarios
												,@iTpoTrnCodigo_Transacoes
												,'C'
												,NULL
												,@iTrnCodigo_Transacoes
												,@iTpoLncCodigo
					

										END
										
										IF (@nValorTaxacao_TiposProdutosTiposTransacoes > 0)
										BEGIN

											EXEC pr_AtualizarCreditoDisponivel
												@iCrtUsrCodigo_Transacoes
												,@iCntUsrCodigo_CartoesUsuarios
												,@cTipo_CartoesUsuarios
												,@nValorEstornar_Transacoes
												,0
												,@iTpoPrdCodigo_CartoesUsuarios
												,5000
												,'C'
												,NULL
												,@iTrnCodigo_Transacoes
												,@iTpoLncCodigo
					
										END

										SET @iResposta = 0

									END
								END
								ELSE
									SET @iResposta = 275 /* PRODUTO INEXISTENTE */
							END
							ELSE
								SET @iResposta =  343 /* ESTABELECIMENTO ESTORNO DIFERENTE */
						END
						ELSE
							SET @iResposta = 116 /* ESTABELECIMENTO INVALIDO OU INEXISTENTE */
					END
					ELSE
						SET @iResposta = 272 /* CONTA INEXISTENTE */
				END
				ELSE
					SET @iResposta =  342 /* CARTAO ESTORNO DIFERENTE */
			END
			ELSE
				SET @iResposta = 12 /* CARTAO INEXISTENTE */
		END
		ELSE
			SET @iResposta = 74 /* TRANSACAO JA CANCELADA*/
	END
	ELSE
		SET @iResposta = 271 /* TRANSACAO ORIGINAL NAO ENCONTRADA - NAO AUTORIZADA */

	IF (@iResposta = 0)
	BEGIN

		DECLARE	@nCreditoDisponivelRetorno DECIMAL(15,2)
		
		SET @cBit039 = '00'

		SELECT	@nCreditoDisponivelRetorno = COALESCE(C.CreditoDisponivel,0)
		FROM	Processadora.dbo.CartoesUsuarios C /* INI SA: 474430 */ WITH(HOLDLOCK, ROWLOCK) /* FIM SA: 474430 */
		WHERE	C.Numero = @cNumeroCartao
		
		IF @iRedeNumero IN (10,31,58)
			EXEC pr_aut_GravaInfoAdicionais_Saldo @cBit048 OUTPUT, @nCreditoDisponivelRetorno
		ELSE
			SET @cBit048 = ''
			
		/***********************************************************************************
		* Alterado por: Elmiro Leandro													   *
		* Motivo: Buscar o formato do ticket a ser utilizado para o retorno da mensagem    *
		* Data: 15/06/2010																   *
		***********************************************************************************/
		IF (@iRedeNumero IN (16,17))
		BEGIN

			DECLARE @sSaldo VARCHAR(15)

			SET @sSaldo = COALESCE(CONVERT(VARCHAR, CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2),@nCreditoDisponivelRetorno))),'')
			SET @cBit062 = @cNome_CartoesUsuarios + '|' + @sSaldo
			
			DECLARE	
				 @cResult		VARCHAR(1000)
				,@cMsgDisplay	VARCHAR(1000)
				,@cResposta		CHAR(3)
			SELECT 
				@cBit039			= codigo_policard, 
				@cMsgDisplay		= COALESCE(descricao, descricao_policard),
				@cResult			= descricao_policard
			FROM 
				aut_CodigosResposta WITH(NOLOCK)
			WHERE 
				codigo = @iResposta
		
			SET @cResposta = CONVERT(VARCHAR,@iResposta)
			SET @cBit062 = @cBit062 + '|' + @cResposta + '|' + @cMsgDisplay + '|' + @cResult + '|'
			
		END
		ELSE
		BEGIN

			IF (@iRedeNumero NOT IN (10,31))
			BEGIN

				DECLARE @sLabelProduto varchar(100)

				SELECT @sLabelProduto = LTRIM(RTRIM(UPPER(COALESCE(TP.Descricao,TP.NOME))))
				FROM Processadora.dbo.TiposProdutos TP WITH(NOLOCK)
				WHERE TpoPrdCodigo = @iTpoPrdCodigo_Transacoes
				
				EXEC [dbo].[pr_AUT_RetornarTicketTransacao]
					 '0400'
					,@cBit003
					,@cBit004			
					,0
					,@cBit011
					,@cBit038			
					,@cBit041			
					,@cBit062			OUTPUT
					,1			
					,@cBit127			
					,@sCNPJ_Estabelecimento				
					,@cNumeroCartao		
					,NULL
					,@sLabelProduto		
					,@cNome_CartoesUsuarios		
					,@sNome_Estabelecimento		
					,@sEndereco_Estabelecimento			
					,@sCidade_Estabelecimento			
					,@sEstado_Estabelecimento			
					,0		
					,@nCreditoDisponivelRetorno	
					,@iRedeNumero
					,@iCodigoEstabelecimento	
					,0	
					
--				EXEC pr_aut_BuscaMensagemTicket @iTpoPrdCodigo_CartoesUsuarios, 210000, @iRedeNumero, @cBit063 OUT						
			
				--SET @cBit090 = ''
			
				--SET @cBit062 = REPLACE(@cBit062, '<NOME_USUARIO>', @cNome_CartoesUsuarios)
				--SET @cBit062 = REPLACE(@cBit062, '<SALDO_DISPONIVEL>', COALESCE(CONVERT(VARCHAR, CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2),@nCreditoDisponivelRetorno))),''))
				--SET @cBit062 = REPLACE(@cBit062, '<CARTAO>', SUBSTRING(@cNumeroCartao,1,6) + '******' + SUBSTRING(@cNumeroCartao,13,4))
				--SET @cBit062 = REPLACE(@cBit062, '<CNPJ>', COALESCE(@sCNPJ_Estabelecimento,''))
				--SET @cBit062 = REPLACE(@cBit062, '<NOME_ESTABELECIMENTO>', @sNome_Estabelecimento)
				--SET @cBit062 = REPLACE(@cBit062, '<ENDERECO>', COALESCE(@sEndereco_Estabelecimento,''))
				--SET @cBit062 = REPLACE(@cBit062, '<CIDADE>', COALESCE(@sCidade_Estabelecimento, ''))
				--SET @cBit062 = REPLACE(@cBit062, '<ESTADO>', COALESCE(@sEstado_Estabelecimento,''))
				--SET @cBit062 = REPLACE(@cBit062, '<NSU_HOST>', COALESCE(@cBit038,''))
				--SET @cBit062 = REPLACE(@cBit062, '<NSU_LOJA>', COALESCE(@cBit011,''))
				--SET @cBit062 = REPLACE(@cBit062, '<CODIGO_ESTABELECIMENTO>',COALESCE(@iCodigoEstabelecimento,''))	-- CONVERT(VARCHAR,CONVERT(BIGINT, @cBit042)))
				--SET @cBit062 = REPLACE(@cBit062, '<TERMINAL>', COALESCE(@cBit041, ''))
				--SET @cBit062 = REPLACE(@cBit062, '<DATA>',dbo.f_ZerosEsquerda(CONVERT(VARCHAR,DAY(GETDATE())), 2) + '/' + dbo.f_ZerosEsquerda(CONVERT(VARCHAR,MONTH(GETDATE())), 2))
				--SET @cBit062 = REPLACE(@cBit062, '<HORA>', SUBSTRING (CONVERT(VARCHAR, GETDATE(), 108 ),1,5))
				--SET @cBit062 = REPLACE(@cBit062, '<VALOR>', COALESCE(CONVERT(VARCHAR, CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2),@nValor_Transacao))),''))
			
			
				IF (@iRedeNumero = 7 AND @cBit123 LIKE 'SCOPE%') /*Ticket impresso sem saldo disponivel do usuario*/
				BEGIN
					EXEC Autorizacao.dbo.pr_aut_BuscaMensagemTicket @iTpoPrdCodigo_CartoesUsuarios, 210000, @iRedeNumero, @cBit063 OUT	
				
					SET @cBit063 = REPLACE(@cBit063, '<NOME_USUARIO>', @cNome_CartoesUsuarios)
					SET @cBit063 = REPLACE(@cBit063, 'SALDO DISPONIVEL:','')
					SET @cBit063 = REPLACE(@cBit063, '<SALDO_DISPONIVEL>','')
					SET @cBit063 = REPLACE(@cBit063, '<CARTAO>', SUBSTRING(@cNumeroCartao,1,6) + '******' + SUBSTRING(@cNumeroCartao,13,4))
					SET @cBit063 = REPLACE(@cBit063, '<CNPJ>', COALESCE(@sCNPJ_Estabelecimento,''))
					SET @cBit063 = REPLACE(@cBit063, '<NOME_ESTABELECIMENTO>', @sNome_Estabelecimento)
					SET @cBit063 = REPLACE(@cBit063, '<ENDERECO>', COALESCE(@sEndereco_Estabelecimento,''))
					SET @cBit063 = REPLACE(@cBit063, '<CIDADE>', COALESCE(@sCidade_Estabelecimento, ''))
					SET @cBit063 = REPLACE(@cBit063, '<ESTADO>', COALESCE(@sEstado_Estabelecimento,''))
					SET @cBit063 = REPLACE(@cBit063, '<NSU_HOST>', COALESCE(@cBit038,''))
					SET @cBit063 = REPLACE(@cBit063, '<NSU_LOJA>', COALESCE(@cBit011,''))
					SET @cBit063 = REPLACE(@cBit063, '<CODIGO_ESTABELECIMENTO>',COALESCE(@iCodigoEstabelecimento,''))
					SET @cBit063 = REPLACE(@cBit063, '<TERMINAL>', COALESCE(@cBit041, ''))
					SET @cBit063 = REPLACE(@cBit063, '<DATA>',dbo.f_ZerosEsquerda(CONVERT(VARCHAR,DAY(GETDATE())), 2) + '/' + dbo.f_ZerosEsquerda(CONVERT(VARCHAR,MONTH(GETDATE())), 2))
					SET @cBit063 = REPLACE(@cBit063, '<HORA>', SUBSTRING (CONVERT(VARCHAR, GETDATE(), 108 ),1,5))
					SET @cBit063 = REPLACE(@cBit063, '<VALOR>', COALESCE(CONVERT(VARCHAR, CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2),@nValor_Transacao))),''))

				END
			END

		END
		/***********************************************************************************/

		/* INÍCIO: Carga dados SMS */
		IF (@iRedeNumero NOT IN (7,8,14,18,57)) /* 7 TEF Dedicado | 8 TEF Discado | 14 CB Itau | 18 TecBan | 57 POS Phoebus */
		BEGIN

			DECLARE @iCrtUsrCodigo		INT
					,@iFranquiaUsuario	INT
					,@dDataTransacao	DATETIME
					,@cBaseOrigem		CHAR(1)

			SET @cBaseOrigem = 'P'
			
			IF EXISTS (SELECT 1 FROM Autorizacao.dbo.UsuarioPermiteSMS WITH(NOLOCK) WHERE CodCartao = @iCrtUsrCodigo_Transacoes and TpoPrdCodigo = @iTpoPrdCodigo_Transacoes AND Base = @cBaseOrigem)
			BEGIN

				SELECT	@iCrtUsrCodigo		= T.CrtUsrCodigo
						,@iFranquiaUsuario	= PAE.AgcCodigo
						,@dDataTransacao	= T.DataAutorizacao
				FROM	Processadora.dbo.Transacoes T WITH(NOLOCK)
				INNER JOIN Processadora.dbo.CartoesUsuarios C WITH(NOLOCK) ON (C.CrtUsrCodigo = T.CrtUsrCodigo)
				INNER JOIN Processadora.dbo.ContasUsuarios CO WITH(NOLOCK) ON (CO.CntUsrCodigo = C.CntUsrCodigo)
				INNER JOIN Processadora.dbo.Propostas P WITH(NOLOCK) ON (P.PrpCodigo = CO.PrpCodigo)
				INNER JOIN Processadora.dbo.ProdutosAgentesEmissores PAE WITH(NOLOCK) ON (PAE.EntCodigo = P.EntCodigo)
				WHERE	T.TrnCodigo = @iScope_IdentityTransacoes


				EXEC pr_AUT_CargaInformacoesEnvioSMS
					 @iCrtUsrCodigo
					,@iFranquiaUsuario
					,@cBaseOrigem
					,@cNumeroCartao
					,@nValor_Transacao
					,@nCreditoDisponivelRetorno
					,@dDataTransacao
					,'0400'
					,NULL
					,@sNome_Estabelecimento
			END
		END
		/* FIM: Carga dados SMS */
	END
END

